import socket #to get host machine identity
import os # for joining paths and filenames sensibly
import scipy.misc #for image function
import numpy as np #number functions
import pandas as pd #dataframes
import glob #file functions

'''need to install SR research eyelink tools for EDF2ASC conversion to work'''


''' --------- set up parameters for analysis ------ '''

'''
#test which machine we are on and set working directory
if 'tom' in socket.gethostname():
    os.chdir('/home/tom/Dropbox/university/expts/microsaccades')
else:
    print("I don't know where I am! ")
    print("Maybe the script will run anyway...")
'''


from pygazeanalyser.edfreader import read_edf #from https://github.com/esdalmaijer/PyGazeAnalyser/
    

DATADIR='DATA'



''' ---- define functions ------ '''





''' ---- convert raw data ---- '''


#convert to asc first

#get all EDF files in folders in DATA folder
edf_files=glob.glob(os.path.join(DATADIR,'**','*.edf'),recursive=True)

#for each EDF file in turn, make it an asc file, then a txt file with the right character encoding
for filename in edf_files:
    filestem=filename.split(sep='.')[0]
    if not os.path.exists(filestem+'.asc'):
        print("Converting " + filename + " to asc")
        os.system('edf2asc ' + filename) #makes asc    - for some reason only works on my laptop
        os.system('iconv -f ISO-8859-1 -t UTF-8//TRANSLIT ' + filestem + '.asc -o ' + filestem + '.txt') #convert character encoding
    else:
        print(filename.split(sep='.')[0]+'.asc already exists')




''' ---- analysis individual participants ---- '''

#get names of all converted files
filenames=glob.glob(os.path.join(DATADIR,'**','*.txt'),recursive=True)


#cribbing from https://github.com/esdalmaijer/PyGazeAnalyser
# DATA FILES
SEP = '\t' # value separator
EDFSTART = "START" # EDF file trial start message
EDFSTOP = "END" # EDF file trial end message
TRIALORDER = [EDFSTART, 'targetpresented','targetremoved', EDFSTOP]
INVALCODE = 0.0 # value coding invalid data


for fp in filenames:

    '''    find trial range
        get data for trialrange
    '''

    #1: get expt structure (ie trial start and end points) from Edwins EDFREADER
    edfdata = read_edf(fp, EDFSTART, stop=EDFSTOP, missing=INVALCODE, debug=False)
    # key https://github.com/esdalmaijer/PyGazeAnalyser/blob/master/pygazeanalyser/edfreader.py
    
    n=len(edfdata) #how many trials do we have (should be 60)

    ''' edfdata[0].keys() #tells us what data is stored for each trial '''
    
    ######################################################
    ###### THIS IS A TERRIBLE HACK, DON'T DO THIS ########    
    ######################################################
    
    #2: now use trial info to extract only raw data to single file
    
    command="grep '^\<[0-9]\{6,9\}\>' " # a regexp that recognises lines which begin with a 6-9 digit number
    os.system(command + fp + ' > '+ fp[:-3] + 'dat') #puts only matching lines in a .dat file


    #3: now use pandas to read that data 
    df=pd.read_csv(fp[:-3] + 'dat',sep='\t',header=None)
    df.columns=['trackertime','x1','y1','size1','x2','y2','size2','dots'] #label columns
    
    ######################################################
    ###### I told you it was a terrible hack #############
    ######################################################
    

    #now we have trial start and stop times, and a dataframe of all raw data by tracker times
    
    #for each trial
    for trial_n in range(n):
        starttt=edfdata[trial_n]['trackertime'].min() #start time
        finisht=edfdata[trial_n]['trackertime'].max() #end time
        mask=(df['trackertime']>starttt) & (df['trackertime']<finisht) #identify that data
        df[mask][['x1','y1','x2','y2']].to_csv(fp[:-4]+'_trial'+str(trial_n)+'.csv',index=False) #save it to a CSV file
        

'''
now we have by trial raw data which we can process in R using the microsaccade toolbox
'''

#taking from
#https://stackoverflow.com/questions/3503879/assign-output-of-os-system-to-a-variable-and-prevent-it-from-being-displayed-on

#get all trial data files in folders in DATA folder
trial_files=glob.glob(os.path.join(DATADIR,'**','*.csv'),recursive=True)

df = pd.DataFrame(index=trial_files,columns=['N'])

#loop through all trial files
for trialfile in trial_files:
    cmd = 'Rscript count_microsaccades.R ' + trialfile #call R to get number of microsaccades
    try:
        output = os.popen(cmd).read() # get output of R script on that trial data
        Nms = int(output.split("\"")[1]) #strip other stuff, so we just get number of (micro)saccades
    except:
        Nms = np.NaN #if it doesn't work just record NaN
        continue
    df.ix[trialfile]=Nms #store output
    
df.to_csv('microsaccades.csv')



trialfile= 'DATA/0618post/0618post_trial3.csv'
cmd = 'Rscript count_microsaccades.R ' + trialfile #call R to get number of microsaccades
output = os.popen(cmd).read() # get output of R script on that trial data
Nms = int(output.split("\"")[1]) #strip other stuff, so we just get number of (micro)saccades

df=pd.read_csv(trialfile)
