# microsaccades
Hacky scripts for calculating microsaccade rate during simple fixation task done on SR Research Eyelink (using head-stablised binocular tracking)


## Shoulders of Giants

Uses scripts from other people:

### SR Research dataviewer files
Specifically EDF2ASC.exe which you can download from here
https://www.sr-support.com/forum/downloads/data-analysis/4557-eyelink-data-viewer

### PyGaze - the open-source toolbox for eye tracking

https://github.com/esdalmaijer/PyGazeAnalyser/
Dalmaijer, E.S., Mathôt, S., & Van der Stigchel, S. (2013). PyGaze: an open-source, cross-platform toolbox for minimal-effort programming of eye tracking experiments. Behaviour Research Methods. doi:10.3758/s13428-013-0422-2

(Doesn't seem to be set up for binocular data in EDF files, but we are still truly gradeful)


### Microsaccade Toolbox 0.9
Authors: Ralf Engbert, Petra Sinn, Konstantin Mergenthaler, Hans Trukenbrod
Affiliation: Universität Potsdam, Germany
Date: March 12, 2015
Folder: MS_Toolbox_R
Download from http://read.psych.uni-potsdam.de/index.php?option=com_content&view=article&id=140:engbert-et-al-2015-microsaccade-toolbox-for-r&catid=26:publications&Itemid=34


## Process flow

- Record head stablised binocular eyetracking data at 50Hz during a simple fixation task with 60 trials (a "run")
- Raw data in form of EDF file for each run into folder DATA in a named subfolder. 
- Run grabdat.py in Python 3. This will
	- Identify all the runs for which we have EDF files
	- Convert EDF to ASC using EDF2ASC 
	- Use PyGaze to identify trial structure 
	- save raw data in seperate .CSV file for each trial
	- run count_microsaccades.R (which use MS_toolbox) to count the microsaccades
	- save output in microsaccades.csv
	
- procdat.py does some initial analysis of the processed data


## Run me

It works on my machine, but you'll certainly need to install various dependendies etc. The best thing is probably try this at the command line

<code>python3 grabdat.py</code>

And see what happens

![good luck](explosion.gif)

