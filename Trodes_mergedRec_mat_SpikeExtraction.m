%%Trodes spike-LFP extraction - batch processing of files in folder
%% Batch processing of SpikeGadgetsData, Plotting (1. Hypoxia Per-Event Histograms (HypPEH))
%%
% reads all the trodes files from one folder, saves variables to another folder.
clc;                                                                       % Clear the command window.
workspace;                                                                 % Make sure the workspace panel is showing.
format compact;
inputFolder = uigetdir(pwd);                                               % Open a pop up window to choose the input folder; Defines path to input folder
addpath(genpath(inputFolder))                                              % adds the input folder with all subfolders to the matlab path
cd(inputFolder);                                                           % changes directory(path) to inputFolder
[inputFolderPath, inputFolderName, inputFolderExtension] = fileparts([inputFolder]);                                                      
if isfolder([inputFolderName '_merged.spikes'])                            % checks if there is any folder/file with .spike extension - Ideally, at this point, such file doesn't exist in the .rec folder unless Spikes were extracted using Trodes software GUI. 
    spikesFilePattern = dir([inputFolder '\*merged.spikes']);               % Creates a variable(spikeFilePattern) that lists files and folders in the current folder; check 'dir' function details
    cd([inputFolder '\' spikesFilePattern.name]);                          % changes the current directory to the name defined by variables/characters inside the sqaure bracket
    datFilePattern = dir('*.dat');                                          % Creates a variable(datFilePattern) that lists name and properties of all dat-files in folder.
    numFiles = length(datFilePattern);                                      % Creates a variable(numFiles) that stores the total number of files in the folder 
    matData = cell(size(datFilePattern));                                   % Creates a variable(matData) that has empty cell array of size of teh variable 'datFilePattern'
    %spikeTimes = cell(size(datFilePattern));                                % Creates a variable(spikeTimes) that has empty cell array of size of teh variable 'datFilePattern'
    matFolder = mkdir([inputFolderName '_merged.spikes.mat']);                         % Creates a new fodler whose name is a combination of strings defined by variable 'recFilename' ending with'.spikes.mat'
    %[matFolder, matFileName, extension] = fileparts([recFileName '.spikes.mat']); %Separating the parts of the filename into three variables: folder path(matFolder), matFileName(filename without extention), and extension(extension-,.mat in this case)
    addpath(genpath(inputFolder))                                           % adds the input folder with all subfolders to the matlab path in clusing any new folder created since addpath last time
    for k = 1:numFiles                                                     % defines the k number of iterations to execute the 'for' loop                           
       cd([inputFolder '\' spikesFilePattern.name]); 
       baseFileName = datFilePattern(k).name;                              % defines the baseFileName as the k'th entry in the 'name' field of the variable 'datFilePattern'
       fulldatFileName = fullfile(inputFolder, spikesFilePattern.name, baseFileName); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fulldatFileName'
       [datFolder, datFileName, extension] = fileparts(fulldatFileName);   % Separating the parts of the filename into three variables: folder path(datFolder), datFileName(filename without extention), and extension(extension-,.dat in this case)
       fullmatFilePath = fullfile([inputFolder '\' inputFolderName '.spikes.mat' '\' datFileName,'.mat']); % Concatenates and saves the full path of the 'baseFileName' name as variable 'fullmatFilePath'
       fprintf(1, 'Now reading file #%d of %d: %s to %s\n', ...            % Prints a message showing the k'th entry out of total(numFiles) being read; %d in the formatSpec input prints each value in the vector, baseFileName, as a signed integer. \n is a control character that starts a new line; %s in the formatSpec input indicates that the values of the variables 'baseFileName' and 'fullmatFilePath', should be printed as text.
           k,numFiles , baseFileName, fullmatFilePath);
       matData = readTrodesExtractedDataFile(fulldatFileName);             % Creates a variable matData and stores all the fields created by the function (Trodes)
       cd([spikesFilePattern.name '.mat'])                                            % changes current direcoru to the .mat folder created earlier in the same folder
       save([datFileName '.mat'], 'matData')                               % saves the matData.mat variable with defined name
    end
else
    recFilePattern = dir([inputFolder, '\*merged.rec']);                       % to read and execute fllowing commands on merged file (*merged.rec) after wireless recording extracttion from SD card using trodes' datalogger GUI.
    [folder, recFileName, extension] = fileparts(recFilePattern.name);         % Separating the parts of the filename into three variables: folder path(Folder), recFileName(filename without extention), and extension(extension-,.rec in this case)
    extractSpikeBinaryFiles(recFileName);                                      % Runs the spike extraction function on the .rec file (Trodes), creates a folder with .spikes extension in current directory and saves tetrodewise spike data in the new folder
    addpath(genpath(inputFolder))                                              % adds the input folder with all subfolders to the matlab path in clusing any new folder created since addpath last time
    spikesFilePattern = dir([inputFolder '\*merged.spikes']);
    cd([inputFolder '\' spikesFilePattern.name]);
    datFilePattern = dir('*.dat'); % lists all dat-files in folder.
    %[datFolder, datFileName, extension] = fileparts(fulldatFileName);
    %datFiles = datFilePattern.name;
    numFiles = length(datFilePattern);
    matData = cell(size(datFilePattern));
    spikeTimes = cell(size(datFilePattern));
    matFolder = mkdir([recFileName '.spikes.mat']);
    [matFolder, matFileName, extension] = fileparts([recFileName '.spikes.mat']);
    addpath(genpath(inputFolder))
            % Read the files.
    for k = 1:numFiles
        cd([inputFolder '\' spikesFilePattern.name]);
        % Get the base file name.
        baseFileName = datFilePattern(k).name;
        fulldatFileName = fullfile(inputFolder, matFileName, baseFileName);
        [datFolder, datFileName, extension] = fileparts(fulldatFileName);
        fullmatFilePath = fullfile([inputFolder '\' recFileName '.spikes.mat' '\' datFileName,'.mat']);
        fprintf(1, 'Now reading file #%d of %d: %s to %s\n', ...
           k,numFiles , baseFileName, fullmatFilePath);
        matData = readTrodesExtractedDataFile(fulldatFileName);
        cd([matFileName '.mat'])
        save([datFileName '.mat'], 'matData')
    end
end

%                                         %     readTrodesExtractedDataFile(fulldatFileName);
%                                         %     save(matData.fields(1)
%                                         %     dataName = fieldnames(matData);
%                                         %     tetrodes{baseFilename} = matData.(dataName{1});
%                                         %     tsLog = strcmp({tetrodes{baseFileName}.fields.name}, 'time');
%                                         %     spikeTimes{baseFileName} = double(tetrodes{baseFileName}.fields(tsLog).data) - double(tetrodes{1}.timestamp_at_creation); % Assuming "timestamp_at_creation" here reflects the file creation time or recording start time... use this if events need to be relative to that timepoint
% end