%%Trodes spike-LFP extraction - batch processing of files in folder
%% Batch processing of SpikeGadgetsData, Plotting (LFP/Spikes Hypoxia Per-Event Histograms (HypPEH))
%% Reads all the trodes files from one folder, saves variables to another folder.
clc;                                                                       % Clear the command window.
workspace;                                                                 % Make sure the workspace panel is showing.
format compact;
inputFolderrec = uigetdir(pwd);                                               % Opens a pop up window to choose the input folder; Defines path to input folder
addpath(genpath(inputFolderrec))                                              % adds the input folder with all subfolders to the matlab path
cd(inputFolderrec);                                                           % changes directory(path) to inputFolder
[inputFolderPathrec, inputFolderNamerec, inputFolderExtensionrec] = fileparts([inputFolderrec]);                                                      
if isfolder([inputFolderNamerec '.LFP'])                                      % checks if there is any folder/file with .spike extension - Ideally, at this point, such file doesn't exist in the .rec folder unless Spikes were extracted using Trodes software GUI. 
    LFPFilePattern = dir([inputFolderrec '\*.LFP']);
    cd([inputFolderrec '\' LFPFilePattern.name]);                          % changes the current directory to the name defined by variables/characters inside the sqaure bracket
    datFilePatternLFP = dir('*.dat');                                         % Creates a variable(datFilePattern) that lists name and properties of all dat-files in folder.
    numFilesLFP = length(datFilePatternLFP);                                     % Creates a variable(numFiles) that stores the total number of files in the folder 
    matDataLFP = cell(size(datFilePatternLFP));                                  % Creates a variable(matData) that has empty cell array of size of teh variable 'datFilePattern'
    matFolderLFP = mkdir([inputFolderNamerec '.LFP.mat']);             % Creates a new fodler whose name is a combination of strings defined by variable 'recFilename' ending with'.spikes.mat'
    %[matFolderLFP, matFileNameLFP, extensionLFP] = fileparts([recFileName '.LFP.mat']); %Separating the parts of the filename into three variables: folder path(matFolder), matFileName(filename without extention), and extension(extension-,.mat in this case)
    addpath(genpath(inputFolderrec))                                          % adds the input folder with all subfolders to the matlab path in clusing any new folder created since addpath last time
    for kLFP = 1:numFilesLFP                                                     % defines the k number of iterations to execute the 'for' loop                           
       cd([inputFolderrec '\' LFPFilePattern.name]); 
       baseFileNameLFP = datFilePatternLFP(kLFP).name;                              % defines the baseFileName as the k'th entry in the 'name' field of the variable 'datFilePattern'
       fulldatFileNameLFP = fullfile(inputFolderrec, LFPFilePattern.name, baseFileNameLFP); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fulldatFileName'
       [datFolderLFP, datFileNameLFP, extensionLFP] = fileparts(fulldatFileNameLFP);   % Separating the parts of the filename into three variables: folder path(datFolder), datFileName(filename without extention), and extension(extension-,.dat in this case)
       fullmatFilePathLFP = fullfile([inputFolderrec '\' inputFolderNamerec '.LFP.mat' '\' datFileNameLFP,'.mat']); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fullmatFilePath'
       fprintf(1, 'Now reading file #%d of %d: %s to %s\n', ...            % Prints a message showing the k'th entry out of total(numFiles) being read; %d in the formatSpec input prints each value in the vector, baseFileName, as a signed integer. \n is a control character that starts a new line; %s in the formatSpec input indicates that the values of the variables 'baseFileName' and 'fullmatFilePath', should be printed as text.
           kLFP,numFilesLFP , baseFileNameLFP, fullmatFilePathLFP);
       matDataLFP = readTrodesExtractedDataFile(fulldatFileNameLFP);             % Creates a variable matData and stores all the fields created by the function (Trodes)
       
       cd([LFPFilePattern.name '.mat'])                                            % changes current direcoru to the .mat folder created earlier in the same folder
       save([datFileNameLFP '.mat'], 'matDataLFP')                               % saves the matData.mat variable with defined name
    end
else
    recFilePattern = dir([inputFolderrec, '\*.rec']);                       % to read and execute fllowing commands on merged file (*merged.rec) after wireless recording extracttion from SD card using trodes' datalogger GUI.
    [folder, recFileName, extensionrec] = fileparts(recFilePattern.name);         % Separating the parts of the filename into three variables: folder path(Folder), recFileName(filename without extention), and extension(extension-,.rec in this case)
    extractLFPBinaryFiles(recFileName);                                      % Runs the spike extraction function on the .rec file (Trodes), creates a folder with .spikes extension in current directory and saves tetrodewise spike data in the new folder
    addpath(genpath(inputFolderrec))                                              % adds the input folder with all subfolders to the matlab path in clusing any new folder created since addpath last time
    cd(inputFolderrec); 
    LFPFilePattern = dir([inputFolderrec '\*.LFP']);
    cd([inputFolderrec '\' LFPFilePattern.name]);                          % changes the current directory to the name defined by variables/characters inside the sqaure bracket
    datFilePatternLFP = dir('*.dat');                                         % Creates a variable(datFilePattern) that lists name and properties of all dat-files in folder.
    numFilesLFP = length(datFilePatternLFP);                                     % Creates a variable(numFiles) that stores the total number of files in the folder 
    matDataLFP = cell(size(datFilePatternLFP));                                  % Creates a variable(matData) that has empty cell array of size of teh variable 'datFilePattern'
    matFolderLFP = mkdir([inputFolderNamerec '.LFP.mat']);             % Creates a new fodler whose name is a combination of strings defined by variable 'recFilename' ending with'.spikes.mat'
    %[matFolderLFP, matFileNameLFP, extensionLFP] = fileparts([recFileName '.LFP.mat']); %Separating the parts of the filename into three variables: folder path(matFolder), matFileName(filename without extention), and extension(extension-,.mat in this case)
    addpath(genpath(inputFolderrec))                                          % adds the input folder with all subfolders to the matlab path in clusing any new folder created since addpath last time
    for kLFP = 1:numFilesLFP                                                     % defines the k number of iterations to execute the 'for' loop                           
       cd([inputFolderrec '\' LFPFilePattern.name]); 
       baseFileNameLFP = datFilePatternLFP(kLFP).name;                              % defines the baseFileName as the k'th entry in the 'name' field of the variable 'datFilePattern'
       fulldatFileNameLFP = fullfile(inputFolderrec, LFPFilePattern.name, baseFileNameLFP); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fulldatFileName'
       [datFolderLFP, datFileNameLFP, extensionLFP] = fileparts(fulldatFileNameLFP);   % Separating the parts of the filename into three variables: folder path(datFolder), datFileName(filename without extention), and extension(extension-,.dat in this case)
       fullmatFilePathLFP = fullfile([inputFolderrec '\' inputFolderNamerec '.LFP.mat' '\' datFileNameLFP,'.mat']); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fullmatFilePath'
       fprintf(1, 'Now reading file #%d of %d: %s to %s\n', ...            % Prints a message showing the k'th entry out of total(numFiles) being read; %d in the formatSpec input prints each value in the vector, baseFileName, as a signed integer. \n is a control character that starts a new line; %s in the formatSpec input indicates that the values of the variables 'baseFileName' and 'fullmatFilePath', should be printed as text.
           kLFP,numFilesLFP , baseFileNameLFP, fullmatFilePathLFP);
       matDataLFP = readTrodesExtractedDataFile(fulldatFileNameLFP);             % Creates a variable matData and stores all the fields created by the function (Trodes)
       
       cd([LFPFilePattern.name '.mat'])                                            % changes current direcoru to the .mat folder created earlier in the same folder
       save([datFileNameLFP '.mat'], 'matDataLFP')                               % saves the matData.mat variable with defined name
    end
end

% cd(inputFolderrec);                                                           % changes directory(path) to inputFolder            
% if isfolder([inputFolderNamerec '.spikes'])
%     spikesFilePattern = dir([inputFolderrec '\*.spikes']);                    % Creates a variable(spikeFilePattern) that lists files and folders in the current folder; check 'dir' function details
%     cd([inputFolderrec '\' spikesFilePattern.name]);                          % changes the current directory to the name defined by variables/characters inside the sqaure bracket
%     datFilePatternSpikes = dir('*spikes_*.dat');                                         % Creates a variable(datFilePattern) that lists name and properties of all dat-files in folder.
%     numFilesSpikes = length(datFilePatternSpikes);                                     % Creates a variable(numFiles) that stores the total number of files in the folder 
%     matDataSpikes = cell(size(datFilePatternSpikes));                                  % Creates a variable(matData) that has empty cell array of size of teh variable 'datFilePattern'
%     spikeTimes = cell(size(datFilePatternSpikes));                              % Creates a variable(spikeTimes) that has empty cell array of size of teh variable 'datFilePattern'
%     matFolderSpikes = mkdir([inputFolderNamerec '.spikes.mat']);             % Creates a new fodler whose name is a combination of strings defined by variable 'recFilename' ending with'.spikes.mat'
%     %[matFolderSpikes, matFileNameSpikes, extensionSpikes] = fileparts([recFileName '.spikes.mat']); %Separating the parts of the filename into three variables: folder path(matFolder), matFileName(filename without extention), and extension(extension-,.mat in this case)
%     addpath(genpath(inputFolderrec))                                          % adds the input folder with all subfolders to the matlab path in clusing any new folder created since addpath last time
%     for kSpikes = 1:numFilesSpikes                                                     % defines the k number of iterations to execute the 'for' loop                           
%        cd([inputFolderrec '\' spikesFilePattern.name]); 
%        baseFileNameSpikes = datFilePatternSpikes(kSpikes).name;                              % defines the baseFileName as the k'th entry in the 'name' field of the variable 'datFilePattern'
%        fulldatFileNameSpikes = fullfile(inputFolderrec, spikesFilePattern.name, baseFileNameSpikes); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fulldatFileName'
%        [datFolderSpikes, datFileNameSpikes, extensionSpikes] = fileparts(fulldatFileNameSpikes);   % Separating the parts of the filename into three variables: folder path(datFolder), datFileName(filename without extention), and extension(extension-,.dat in this case)
%        fullmatFilePathSpikes = fullfile([inputFolderrec '\' inputFolderNamerec '.spikes.mat' '\' datFileNameSpikes,'.mat']); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fullmatFilePath'
%        fprintf(1, 'Now reading file #%d of %d: %s to %s\n', ...            % Prints a message showing the k'th entry out of total(numFiles) being read; %d in the formatSpec input prints each value in the vector, baseFileName, as a signed integer. \n is a control character that starts a new line; %s in the formatSpec input indicates that the values of the variables 'baseFileName' and 'fullmatFilePath', should be printed as text.
%            kSpikes,numFilesSpikes , baseFileNameSpikes, fullmatFilePathSpikes);
%        matDataSpikes = readTrodesExtractedDataFile(fulldatFileNameSpikes);             % Creates a variable matData and stores all the fields created by the function (Trodes)
%        cd([spikesFilePattern.name '.mat'])                                            % changes current direcoru to the .mat folder created earlier in the same folder
%        save([datFileNameSpikes '.mat'], 'matDataSpikes')                               % saves the matData.mat variable with defined name
%     end
% else
%     recFilePattern = dir([inputFolderrec, '\*.rec']);                       % to read and execute fllowing commands on merged file (*merged.rec) after wireless recording extracttion from SD card using trodes' datalogger GUI.
%     [folder, recFileName, extensionrec] = fileparts(recFilePattern.name);         % Separating the parts of the filename into three variables: folder path(Folder), recFileName(filename without extention), and extension(extension-,.rec in this case)
%     extractSpikeBinaryFiles(recFileName);                                      % Runs the spike extraction function on the .rec file (Trodes), creates a folder with .spikes extension in current directory and saves tetrodewise spike data in the new folder
%     addpath(genpath(inputFolderrec))                                              % adds the input folder with all subfolders to the matlab path in clusing any new folder created since addpath last time
%     cd(inputFolderrec);
%     spikesFilePattern = dir([inputFolderrec '\*.spikes']);                    % Creates a variable(spikeFilePattern) that lists files and folders in the current folder; check 'dir' function details
%     cd([inputFolderrec '\' spikesFilePattern.name]);                          % changes the current directory to the name defined by variables/characters inside the sqaure bracket
%     datFilePatternSpikes = dir('*spikes_*.dat');                                         % Creates a variable(datFilePattern) that lists name and properties of all dat-files in folder.
%     numFilesSpikes = length(datFilePatternSpikes);                                     % Creates a variable(numFiles) that stores the total number of files in the folder 
%     matDataSpikes = cell(size(datFilePatternSpikes));                                  % Creates a variable(matData) that has empty cell array of size of teh variable 'datFilePattern'
%     spikeTimes = cell(size(datFilePatternSpikes));                              % Creates a variable(spikeTimes) that has empty cell array of size of teh variable 'datFilePattern'
%     matFolderSpikes = mkdir([inputFolderNamerec '.spikes.mat']);             % Creates a new fodler whose name is a combination of strings defined by variable 'recFilename' ending with'.spikes.mat'
%     %[matFolderSpikes, matFileNameSpikes, extensionSpikes] = fileparts([recFileName '.spikes.mat']); %Separating the parts of the filename into three variables: folder path(matFolder), matFileName(filename without extention), and extension(extension-,.mat in this case)
%     addpath(genpath(inputFolderrec))                                          % adds the input folder with all subfolders to the matlab path in clusing any new folder created since addpath last time
%     for kSpikes = 1:numFilesSpikes                                                     % defines the k number of iterations to execute the 'for' loop                           
%        cd([inputFolderrec '\' spikesFilePattern.name]); 
%        baseFileNameSpikes = datFilePatternSpikes(kSpikes).name;                              % defines the baseFileName as the k'th entry in the 'name' field of the variable 'datFilePattern'
%        fulldatFileNameSpikes = fullfile(inputFolderrec, spikesFilePattern.name, baseFileNameSpikes); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fulldatFileName'
%        [datFolderSpikes, datFileNameSpikes, extensionSpikes] = fileparts(fulldatFileNameSpikes);   % Separating the parts of the filename into three variables: folder path(datFolder), datFileName(filename without extention), and extension(extension-,.dat in this case)
%        fullmatFilePathSpikes = fullfile([inputFolderrec '\' inputFolderNamerec '.spikes.mat' '\' datFileNameSpikes,'.mat']); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fullmatFilePath'
%        fprintf(1, 'Now reading file #%d of %d: %s to %s\n', ...            % Prints a message showing the k'th entry out of total(numFiles) being read; %d in the formatSpec input prints each value in the vector, baseFileName, as a signed integer. \n is a control character that starts a new line; %s in the formatSpec input indicates that the values of the variables 'baseFileName' and 'fullmatFilePath', should be printed as text.
%            kSpikes,numFilesSpikes , baseFileNameSpikes, fullmatFilePathSpikes);
%        matDataSpikes = readTrodesExtractedDataFile(fulldatFileNameSpikes);             % Creates a variable matData and stores all the fields created by the function (Trodes)
%        cd([spikesFilePattern.name '.mat'])                                            % changes current direcoru to the .mat folder created earlier in the same folder
%        save([datFileNameSpikes '.mat'], 'matDataSpikes')                               % saves the matData.mat variable with defined name
%     end
% end

cd(inputFolderrec);                                                           % changes directory(path) to inputFolder            
if isfolder([inputFolderNamerec '.DIO'])
    DIOFilePattern = dir([inputFolderrec '\*.dio']);                    % Creates a variable(spikeFilePattern) that lists files and folders in the current folder; check 'dir' function details
    cd([inputFolderrec '\' DIOFilePattern.name]);                          % changes the current directory to the name defined by variables/characters inside the sqaure bracket
    datFilePatternDIO = dir('*.dio*.dat');                                         % Creates a variable(datFilePattern) that lists name and properties of all dat-files in folder.
    numFilesDIO = length(datFilePatternDIO);                                     % Creates a variable(numFiles) that stores the total number of files in the folder 
    matDataDIO = cell(size(datFilePatternDIO));                                  % Creates a variable(matData) that has empty cell array of size of teh variable 'datFilePattern'
    DIOTimes = cell(size(datFilePatternDIO));                              % Creates a variable(spikeTimes) that has empty cell array of size of teh variable 'datFilePattern'
    matFolderDIO = mkdir([inputFolderNamerec '.DIO.mat']);             % Creates a new fodler whose name is a combination of strings defined by variable 'recFilename' ending with'.spikes.mat'
    %[matFolderSpikes, matFileNameSpikes, extensionSpikes] = fileparts([recFileName '.spikes.mat']); %Separating the parts of the filename into three variables: folder path(matFolder), matFileName(filename without extention), and extension(extension-,.mat in this case)
    addpath(genpath(inputFolderrec))                                          % adds the input folder with all subfolders to the matlab path in clusing any new folder created since addpath last time
    for kDIO = 1:numFilesDIO                                                     % defines the k number of iterations to execute the 'for' loop                           
       cd([inputFolderrec '\' DIOFilePattern.name]); 
       baseFileNameDIO = datFilePatternDIO(kDIO).name;                              % defines the baseFileName as the k'th entry in the 'name' field of the variable 'datFilePattern'
       fulldatFileNameDIO = fullfile(inputFolderrec, DIOFilePattern.name, baseFileNameDIO); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fulldatFileName'
       [datFolderDIO, datFileNameDIO, extensionDIO] = fileparts(fulldatFileNameDIO);   % Separating the parts of the filename into three variables: folder path(datFolder), datFileName(filename without extention), and extension(extension-,.dat in this case)
       fullmatFilePathDIO = fullfile([inputFolderrec '\' inputFolderNamerec '.DIO.mat' '\' datFileNameDIO,'.mat']); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fullmatFilePath'
       fprintf(1, 'Now reading file #%d of %d: %s to %s\n', ...            % Prints a message showing the k'th entry out of total(numFiles) being read; %d in the formatSpec input prints each value in the vector, baseFileName, as a signed integer. \n is a control character that starts a new line; %s in the formatSpec input indicates that the values of the variables 'baseFileName' and 'fullmatFilePath', should be printed as text.
           kDIO,numFilesDIO , baseFileNameDIO, fullmatFilePathDIO);
       matDataDIO = readTrodesExtractedDataFile(fulldatFileNameDIO);             % Creates a variable matData and stores all the fields created by the function (Trodes)
       cd([DIOFilePattern.name '.mat'])                                            % changes current direcoru to the .mat folder created earlier in the same folder
       save([datFileNameDIO '.mat'], 'matDataDIO')                               % saves the matData.mat variable with defined name
    end
else
    recFilePattern = dir([inputFolderrec, '\*.rec']);                       % to read and execute fllowing commands on merged file (*merged.rec) after wireless recording extracttion from SD card using trodes' datalogger GUI.
    [folder, recFileName, extensionrec] = fileparts(recFilePattern.name);         % Separating the parts of the filename into three variables: folder path(Folder), recFileName(filename without extention), and extension(extension-,.rec in this case)
    extractDioBinaryFiles(recFileName);                                      % Runs the spike extraction function on the .rec file (Trodes), creates a folder with .spikes extension in current directory and saves tetrodewise spike data in the new folder
    addpath(genpath(inputFolderrec))                                              % adds the input folder with all subfolders to the matlab path in clusing any new folder created since addpath last time
    cd(inputFolderrec);
    DIOFilePattern = dir([inputFolderrec '\*.dio']);                    % Creates a variable(spikeFilePattern) that lists files and folders in the current folder; check 'dir' function details
    cd([inputFolderrec '\' DIOFilePattern.name]);                          % changes the current directory to the name defined by variables/characters inside the sqaure bracket
    datFilePatternDIO = dir('*.dio*.dat');                                         % Creates a variable(datFilePattern) that lists name and properties of all dat-files in folder.
    numFilesDIO = length(datFilePatternDIO);                                     % Creates a variable(numFiles) that stores the total number of files in the folder 
    matDataDIO = cell(size(datFilePatternDIO));                                  % Creates a variable(matData) that has empty cell array of size of teh variable 'datFilePattern'
    DIOTimes = cell(size(datFilePatternDIO));                              % Creates a variable(spikeTimes) that has empty cell array of size of teh variable 'datFilePattern'
    matFolderDIO = mkdir([inputFolderNamerec '.DIO.mat']);             % Creates a new fodler whose name is a combination of strings defined by variable 'recFilename' ending with'.spikes.mat'
    %[matFolderSpikes, matFileNameSpikes, extensionSpikes] = fileparts([recFileName '.spikes.mat']); %Separating the parts of the filename into three variables: folder path(matFolder), matFileName(filename without extention), and extension(extension-,.mat in this case)
    addpath(genpath(inputFolderrec))                                          % adds the input folder with all subfolders to the matlab path in clusing any new folder created since addpath last time
    for kDIO = 1:numFilesDIO                                                     % defines the k number of iterations to execute the 'for' loop                           
       cd([inputFolderrec '\' DIOFilePattern.name]); 
       baseFileNameDIO = datFilePatternDIO(kDIO).name;                              % defines the baseFileName as the k'th entry in the 'name' field of the variable 'datFilePattern'
       fulldatFileNameDIO = fullfile(inputFolderrec, DIOFilePattern.name, baseFileNameDIO); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fulldatFileName'
       [datFolderDIO, datFileNameDIO, extensionDIO] = fileparts(fulldatFileNameDIO);   % Separating the parts of the filename into three variables: folder path(datFolder), datFileName(filename without extention), and extension(extension-,.dat in this case)
       fullmatFilePathDIO = fullfile([inputFolderrec '\' inputFolderNamerec '.DIO.mat' '\' datFileNameDIO,'.mat']); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fullmatFilePath'
       fprintf(1, 'Now reading file #%d of %d: %s to %s\n', ...            % Prints a message showing the k'th entry out of total(numFiles) being read; %d in the formatSpec input prints each value in the vector, baseFileName, as a signed integer. \n is a control character that starts a new line; %s in the formatSpec input indicates that the values of the variables 'baseFileName' and 'fullmatFilePath', should be printed as text.
           kDIO,numFilesDIO , baseFileNameDIO, fullmatFilePathDIO);
       matDataDIO = readTrodesExtractedDataFile(fulldatFileNameDIO);             % Creates a variable matData and stores all the fields created by the function (Trodes)
       cd([DIOFilePattern.name '.mat'])                                            % changes current direcoru to the .mat folder created earlier in the same folder
       save([datFileNameDIO '.mat'], 'matDataDIO')                               % saves the matData.mat variable with defined name
       addpath(genpath(inputFolderrec))
    end
end


%% Plotting LFP around Beep-Buzz sound stimulus (0.5sec)
addpath(genpath(inputFolderrec)) 
cd([inputFolderrec '\' LFPFilePattern.name '\' LFPFilePattern.name '.mat']);            % change directory to the folder with '*LFP*.mat files for all tetrodes
matFilePatternLFPTimestamps = load([inputFolderNamerec '.timestamps.mat']);             % creates the variable on LHS and loads the timestamps.mat file common for all the tetrodes
LFPTimestamps = double(matFilePatternLFPTimestamps.matDataLFP.fields.data(:,1));        % creates a variable on LHS to store and access the value of timestamps
cd([inputFolderrec '\' DIOFilePattern.name '\' DIOFilePattern.name '.mat']);            % change directory to the folder containing digital input (dio) files (environmental stimuli from MCU)
matFilePatternDIO_Din6_Buzz = load([inputFolderNamerec '.dio_Controller_Din6.mat']);    % creates the variable on LHS and loads the .mat file for channel 6 from MCU(Beep for this task)
BuzzDIOTimeStamps = matFilePatternDIO_Din6_Buzz.matDataDIO.fields(1).data;              % creates a variable on LHS to store and access the value of Ch6(Beep) timestamps
BuzzDIOState = matFilePatternDIO_Din6_Buzz.matDataDIO.fields(2).data;                   % creates a variable on LHS to store and access the value of down(0) or up(1) state corresponding to Ch6 timestamps
BuzzDIOTimestampsUPstate = double(BuzzDIOTimeStamps(BuzzDIOState==1));                  % creates a variable on LHS to select and store all the even rows of Ch6(Beep) timestamps with UP(1) state 
matFilePatternDIO_Din5_Beep = load([inputFolderNamerec '.dio_Controller_Din5.mat']);    % creates the variable on LHS and loads the .mat file for channel 5 from MCU(Buzz for this task)
BeepDIOTimeStamps = matFilePatternDIO_Din5_Beep.matDataDIO.fields(1).data;              % creates a variable on LHS to store and access the value of Ch5(Buzz) timestamps
BeepDIOState = matFilePatternDIO_Din5_Beep.matDataDIO.fields(2).data;                   % creates a variable on LHS to store and access the value of down(0) or up(1) state corresponding to Ch5 timestamps
%BeepDIOTimestampsUPstate = double(BeepDIOTimeStamps(2:2:end));                         % creates a variable on LHS to select and store all the even rows of Ch5(Buzz) timestamps with UP(1) state
BeepDIOTimestampsUPstate = double(BeepDIOTimeStamps(BeepDIOState==1));
cd([inputFolderrec '\' LFPFilePattern.name '\' LFPFilePattern.name '.mat']);            % change directory to the folder with '*LFP*.mat files for all tetrodes
numFilesLFPVolt = length(dir('*LFP*.mat'));                                             % creates a variable on LHS to store the number of '*LFP*.mat' files in the folder
LFPdataFileList = (dir(fullfile([inputFolderNamerec '*LFP*.mat'])));                    % creates a variable on LHS to store all the names of individual tetrode LFP .mat files in the field 'name' 
LFPdataFileListNames = [{LFPdataFileList.name}];                                        %#ok<NBRAK> % creates a variable on LHS to store all the names of individual tetrode LFP .mat files in different columns of first row (row vector) 
plotTimestampsBeforeSound = 4500;
plotTimestampsAfterSound = 10500;
tempBuzzLFPVoltWindow = nan((plotTimestampsBeforeSound+plotTimestampsAfterSound+1),1);
tempBeepLFPVoltWindow = nan((plotTimestampsBeforeSound+plotTimestampsAfterSound+1),1);
tetrodeDataLFP_Buzz = nan(length(BuzzDIOTimestampsUPstate), length((tempBuzzLFPVoltWindow)'), length(numFilesLFPVolt));
tetrodeDataLFP_Beep = nan(length(BeepDIOTimestampsUPstate), length((tempBeepLFPVoltWindow)'), length(numFilesLFPVolt));
plotFolderBuzzLFP = mkdir([inputFolderNamerec 'Buzz-LFP-Plots']);
plotFolderBeepLFP = mkdir([inputFolderNamerec 'Beep-LFP-Plots']);
addpath(genpath(inputFolderrec)) 
for kLFPdataFiles = 1:numFilesLFPVolt
    cd([inputFolderrec '\' LFPFilePattern.name '\' LFPFilePattern.name '.mat']);
    temptetrodeDataLFP = load(LFPdataFileListNames{1, kLFPdataFiles});  
    temptetrodeLFPVolt = temptetrodeDataLFP.matDataLFP.fields.data(:,1);
    AllTrial_BuzzLFPWindow = nan(length(BuzzDIOTimestampsUPstate), length(tempBuzzLFPVoltWindow));
    for kBuzzTrials  = 3:length(BuzzDIOTimestampsUPstate)-2
        tempBuzzDIOTimestampsUPstate = double(BuzzDIOTimestampsUPstate(kBuzzTrials,1));
        tempBuzzLFPTimestampsDiffIdx = find((LFPTimestamps - tempBuzzDIOTimestampsUPstate)>=0,1,'first');
        tempBuzzLFPVoltWindow = temptetrodeLFPVolt((tempBuzzLFPTimestampsDiffIdx - plotTimestampsBeforeSound):(tempBuzzLFPTimestampsDiffIdx + plotTimestampsAfterSound));
        AllTrial_BuzzLFPWindow(kBuzzTrials,:) = (tempBuzzLFPVoltWindow)';
    end
    tetrodeDataLFP_Buzz(:, :, kLFPdataFiles) = AllTrial_BuzzLFPWindow;
    BuzzFig = figure;
%     h = plot(-0.1:1/30000:0.25,tetrodeDataLFP_Buzz(:,:,kLFPdataFiles), 'k');
%     for hh = 1:length(h)
%         h(hh).Color = ([h(hh).Color, 0.1]);      
%     end
%     hold on;
%     plot(-0.1:1/30000:0.25,nanmedian(tetrodeDataLFP_Buzz(:,:,kLFPdataFiles)), 'w', 'linewidth', 2);
    plot(-3:1/1500:7,nanmedian(tetrodeDataLFP_Buzz(:,:,kLFPdataFiles)), 'k', 'linewidth', 2);
    set(gca, 'xlim', [-3 7]);
    set(gca, 'ylim', [-750 750]);
    title(['Buzz' '-' LFPdataFileListNames{1, kLFPdataFiles}]);
    xlabel('Time(sec)');
    ylabel('EP(microV)');
    xHS = xline(0,'--r',{'Buzz','Onset'});
    xHS.LineWidth = 2;
    cd([inputFolderrec '\' LFPFilePattern.name '\' LFPFilePattern.name '.mat' '\' inputFolderNamerec 'Buzz-LFP-Plots']);
    savefig(gcf, [LFPdataFileListNames{1, kLFPdataFiles} '-Buzz.fig']); 
    saveas(gcf, [LFPdataFileListNames{1, kLFPdataFiles} '-Buzz.tif'], 'tiffn');
end
Buzz_Plot_Folder = fullfile([inputFolderrec '\' LFPFilePattern.name '\' LFPFilePattern.name '.mat' '\' inputFolderNamerec 'Buzz-LFP-Plots']);
Buzz_imds = imageDatastore(Buzz_Plot_Folder,'FileExtensions',{'.tif'});
Buzz_Out = imtile(Buzz_imds);
imshow(Buzz_Out);
title(['Buzz-' inputFolderNamerec '-LFP-Plots']);
saveas(gcf, [LFPdataFileListNames{1, kLFPdataFiles} 'combined-Buzz'], 'tiffn');
for kLFPdataFiles = 1:numFilesLFPVolt
    cd([inputFolderrec '\' LFPFilePattern.name '\' LFPFilePattern.name '.mat']);
    temptetrodeDataLFP = load(LFPdataFileListNames{1, kLFPdataFiles});  
    temptetrodeLFPVolt = temptetrodeDataLFP.matDataLFP.fields.data(:,1);
    AllTrial_BeepLFPWindow = nan(length(BeepDIOTimestampsUPstate), length(tempBeepLFPVoltWindow));
    for kBeepTrials  = 3:length(BeepDIOTimestampsUPstate)-2
        tempBeepDIOTimestampsUPstate = double(BeepDIOTimestampsUPstate(kBeepTrials,1));
        tempBeepLFPTimestampsDiffIdx = find((LFPTimestamps - tempBeepDIOTimestampsUPstate)>=0,1,'first');
        tempBeepLFPVoltWindow = temptetrodeLFPVolt((tempBeepLFPTimestampsDiffIdx - plotTimestampsBeforeSound):(tempBeepLFPTimestampsDiffIdx + plotTimestampsAfterSound));
        AllTrial_BeepLFPWindow(kBeepTrials,:) = (tempBeepLFPVoltWindow)';
    end
    tetrodeDataLFP_Beep(:, :, kLFPdataFiles) = AllTrial_BeepLFPWindow;
    figure;
%     h = plot(-0.1:1/30000:0.25,tetrodeDataLFP_Beep(:,:,kLFPdataFiles), 'k');
%     for hh = 1:length(h)
%         h(hh).Color = ([h(hh).Color, 0.1]);      
%     end
%     hold on;
%     plot(-0.1:1/30000:0.25,nanmedian(tetrodeDataLFP_Beep(:,:,kLFPdataFiles)), 'w', 'linewidth', 2);
    plot(-3:1/1500:7,nanmedian(tetrodeDataLFP_Beep(:,:,kLFPdataFiles)), 'k', 'linewidth', 2);
    set(gca, 'xlim', [-3 7]);
    set(gca, 'ylim', [-750 750]);
    title(['Beep' '-' LFPdataFileListNames{1, kLFPdataFiles}]);
    xlabel('Time(sec)');
    ylabel('EP(microV)');
    xHS = xline(0,'--r',{'Beep','Onset'});
    xHS.LineWidth = 2;
    cd([inputFolderrec '\' LFPFilePattern.name '\' LFPFilePattern.name '.mat' '\' inputFolderNamerec 'Beep-LFP-Plots']);
    savefig(gcf, [LFPdataFileListNames{1, kLFPdataFiles} '-Beep.fig']);
    saveas(gcf, [LFPdataFileListNames{1, kLFPdataFiles} '-Beep.tif'], 'tiffn');
end
Beep_Plot_Folder = fullfile([inputFolderrec '\' LFPFilePattern.name '\' LFPFilePattern.name '.mat' '\' inputFolderNamerec 'Beep-LFP-Plots']);
Beep_imds = imageDatastore(Beep_Plot_Folder,'FileExtensions',{'.tif'});
Beep_Out = imtile(Beep_imds);
imshow(Beep_Out);
title(['Beep-' inputFolderNamerec '-LFP-Plots']);
saveas(gcf, [LFPdataFileListNames{1, kLFPdataFiles} 'combined-Beep'], 'tiffn');

% 
% for EPplots = 1:size(tetrodeDataLFP,3);
%     figure;
%     plot(-0.1:1/30000:0.25,tetrodeDataLFP(:,:,EPplots));
%     set(gca, 'xlim', [-0.1 0.25]);
%     set(gca, 'ylim', [-15000 15000]);
% end

% for FigureTitle = 1:length(LFPdataFileListNames);
%             








% 
%         tetrodeData(:, :, BeepTrials) = tempDataBeepLFP;
%         %popVData(:, BeepTrials) = sum(tempDataBeepLFP, 2);
%         meanpopVData = mean(popVData,2);
%         STDpopVData = std(popVData,1,2);
%         SEpopVData = STDpopVData/sqrt(length(meanpopVData));
%         SEpositive = meanpopVData+SEpopVData;
%         SEnegative = meanpopVData-SEpopVData;
%     end
% end



% for LFPdataFiles = 1:numFilesLFPVolt
%     temptetrodeDataLFP = load(LFPdataFileListNames{1, LFPdataFiles});  
%     temptetrodeLFPVol = temptetrodeDataLFP.matDataLFP.fields.data(:,1);
%     timebins = -1:0.05:1;
%     binningvector = timebins * temptetrodeDataLFP.matDataLFP.clockrate;
%     tetrodeData = nan(length(binningvector) - 1, length(numFilesLFPVolt), length(BeepDIOTimestampsUPstate));
%     popVData = nan(length(binningvector) - 1, length(BeepDIOTimestampsUPstate));
%     for BeepTrials  = 1:length(BeepDIOTimestampsUPstate)
%          
%         tempDataBeepLFP = nan(size(tetrodeData, 1), size(tetrodeData, 2));
%         for n = 1:length(numFilesLFPVolt)
%             relativeLFPtimes =(LFPTimestamps - BeepDIOTimestampsUPstate(BeepTrials));
%             tempDataBeepLFP = (histcounts(relativeLFPtimes - binningvector))';
%         end
%         tetrodeData(:, :, BeepTrials) = tempDataBeepLFP;
%         popVData(:, BeepTrials) = sum(tempDataBeepLFP, 2);
%         meanpopVData = mean(popVData,2);
%         STDpopVData = std(popVData,1,2);
%         SEpopVData = STDpopVData/sqrt(length(meanpopVData));
%         SEpositive = meanpopVData+SEpopVData;
%         SEnegative = meanpopVData-SEpopVData;
%     end
% end




% filePattern = fullfile(HypSn5_20210802_134241_merged.spikes, '*.*'); % All files.
% filePattern = fullfile(inputFolder, '*.dat'); % dat-files.
% datFiles = dir(filePattern);
% numFiles = length(datFiles);
% matData = cell(size(datFiles));
% spikeTimes = cell(size(datFiles));
% Read the files.
% for k = 1:numFiles
%     dataName = fieldnames(matData);
%     tetrodes{baseFilename} = matData.(dataName{1});
%     tsLog = strcmp({tetrodes{baseFileName}.fields.name}, 'time');
%     spikeTimes{baseFileName} = double(tetrodes{baseFileName}.fields(tsLog).data) - double(tetrodes{1}.timestamp_at_creation); % Assuming "timestamp_at_creation" here reflects the file creation time or recording start time... use this if events need to be relative to that timepoint
% end
% cd('D:\SpikeGadgets_Recordings\OpenField_Sn10-BefHyp_HypoxiaSn2_OpenField_Sn11-AftHyp_20210710_151030.rec\OpenField_Sn10-BefHyp_HypoxiaSn2_OpenField_Sn11-AftHyp_20210710_151030_merged.spikes');                                      %   Change to match the directory where the files are stored on the computer
% dataFiles = [{'OFSn10_HypSn2_OFSn11_TT2_Spikes.mat'}, {'OFSn10_HypSn2_OFSn11_TT18_Spikes.mat'}...
%    {'OFSn10_HypSn2_OFSn11_TT22_Spikes.mat'}];
%     {'OFSn10_HypSn2_OFSn11_TT13_Spikes.mat'},{'OFSn10_HypSn2_OFSn11_TT19_Spikes.mat'},{'OFSn10_HypSn2_OFSn11_TT20_Spikes.mat'},...{'OFSn10_HypSn2_OFSn11_TT9_Spikes.mat'},...{'OFSn10_HypSn2_OFSn11_TT1_Spikes.mat'},{'OFSn10_HypSn2_OFSn11_TT11_Spikes.mat'},{'OFSn10_HypSn2_OFSn11_TT12_Spikes.mat'},...
%     {'OFSn10_HypSn2_OFSn11_TT7_Spikes.mat'}{'OFSn10_HypSn2_OFSn11_TT21_Spikes.mat'},{'OFSn10_HypSn2_OFSn11_TT32_Spikes.mat'}];                 %   Add in additional file names here. Adding them in manually is probably going to be the easiest way to do things right now. Add in new filenames by placing them within {''} with a comma separating each one within the []
% numTetrodes = length(dataFiles);
% tetrodes = cell(1,length(dataFiles));                                       %   A place to store the tetrode data from the files (may not be necessary)
% spikeTimes = cell(1,length(dataFiles));                                     %   A place to store the spike times for each tetrode
% for file = 1:length(dataFiles)                                                      
%    tempData = load(dataFiles{file});                                       %   Load the data file
%    dataName = fieldnames(tempData);                                        %   This is here because the example file I was given had a unique variable name. I'm assuming each file will have their own unique variable name and it will be the only variable stored in the file. This section will need to be reworked if that assumption is not accurate in the future
%    tetrodes{file} = tempData.(dataName{1});
%    tsLog = strcmp({tetrodes{file}.fields.name}, 'time');                   %   May not be necessary if the structure Trodes outputs is always a 1x5 with the first index being the timestamps
%     spikeTimes{file} = double(tetrodes{file}.fields(tsLog).data);           %   Conversion to double is necessary for math to work here. Specifically, because the spike times are in UNSIGNED integers, you can't have any negative values, which is necessary for the alignment calculation
%     spikeTimes{file} = double(tetrodes{file}.fields(tsLog).data) - double(tetrodes{1}.timestamp_at_creation); % Assuming "timestamp_at_creation" here reflects the file creation time or recording start time... use this if events need to be relative to that timepoint
%    spikeTimes{file} = double(tetrodes{file}.fields(tsLog).data) - double(tetrodes{1}.timestamp_at_creation); % Assuming "timestamp_at_creation" here reflects the file creation time or recording start time... use this if events need to be relative to that timepoint
% end
% 
% hyp = [49967176, 62160547, 72293301, 86375135, 98554147, 110663587, 122535221, 134453848,...
%   146590409, 158451878, 170505734,182559590,194613446,206667302,218721158,230775014,...
%   242828870,254882726,266936582,278990438,291044294,303098150,315152006,327205862,...
%   339259718,347261621,359016684,370888318,382806945,394943506,406997362,418868996];
% hyp = [49967176, 62160547, 72293301, 86375135, 98554147, 110663587, 122535221, 134453848];
% hyp = [146590409, 158451878, 170505734,182559590,194613446,206667302,218721158,230775014];
% hyp = [242828870,254882726,266936582,278990438,291044294,303098150,315152006,327205862];
% hyp = [339259718,347261621,359016684,370888318,382806945,394943506,406997362,418868996];
% extrapTime = mean(diff(hyp));
% lastReal = hyp(end);
% for n = 1:8
%    hyp(end+1) = hyp(end)+(extrapTime);
% end
% timeBins = -300:0.5:100;
% binningVector = timeBins * tetrodes{baseFileName}.clockrate;
% tetrodeData = nan(length(binningVector)-1, length(datFiles), length(hyp));
% popVData = nan(length(binningVector)-1, length(hyp));
% for h = 1:length(hyp)
%     tempData = nan(size(tetrodeData, 1), size(tetrodeData, 2));
%     for n = 1:numTetrodes
%         relativeSpikeTimes = spikeTimes{n} - hyp(h);
%         tempData(:, n) = histcounts(relativeSpikeTimes, binningVector);
%     end
%     tetrodeData(:, :, h) = tempData;
%     popVData(:, h) = sum(tempData, 2);
%     meanpopVData = mean(popVData,2);
%     STDpopVData = std(popVData,1,2);
%     SEpopVData = STDpopVData/sqrt(length(meanpopVData));
%     SEpositive = meanpopVData+SEpopVData;
%     SEnegative = meanpopVData-SEpopVData;
% end
% figure; 
% plot(timeBins(1:end-1)+mode(diff(timeBins))/2, popVData);
% hold on;
% plot(timeBins(1:end-1)+mode(diff(timeBins))/2, meanpopVData, 'k','LineWidth',3);
% hold on;
% plot(timeBins(1:end-1)+mode(diff(timeBins))/2, SEpositive, 'c','LineWidth',1);
% hold on;
% plot(timeBins(1:end-1)+mode(diff(timeBins))/2, SEnegative, 'c','LineWidth',1);
% axis tight;
% xlabel('Time(sec)');
% ylabel('SpikeCounts(0.5s bin)');
% xHS = xline(0,'--r',{'Hypoxia','Start'});
% xHS.LineWidth = 2;
% xHE = xline(90,'--r',{'Hypoxia','End'});
% xHE.LineWidth = 2;
% xNS = xline(-300,'--g',{'Normoxia','Start'});
% xNS.LineWidth = 2;
% xNE = xline(-210,'--g',{'Normoxia','End'});
% xNE.LineWidth = 2;
% xRS = xline(-200,'--m',{'Rampdown','Started'});
% xRS.LineWidth = 2;
% xRE = xline(-20,'--m',{'Rampdown','Ending'});
% xRE.LineWidth = 2;

