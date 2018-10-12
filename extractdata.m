%Loads sound files from the folder 'x' and extracts 2, 4, 6, 8, and 10s
%snippets of the file, and puts them on 5 different folders. Specific to
%the Filipino Speech Corpus (FSC) formatting.

function [] = extractdata(datapath,key)
%x = 'data'
clc;
workspace;

cd(datapath);

if key ==0
    cd('Male');
elseif key==1
    cd('Female');
end


%Find all relevant files in the data folder
files = dir('**\*.wav');
filepath = strings(numel(files),1);
for i=1:numel(files)
    filepath(i) = strcat(files(i).folder,'\',files(i).name);
end


%Define samples per speaker = 50
samplesperspk = 50;

% Go back to parent folder
cd ..;
cd ..; 
cd ..;
%Make a sperate folder t put extracted data

if exist('dataextracts') ==7
   rmdir('dataextracts','s');
end
    mkdir('dataextracts');

if exist('mfccunnorm') ==7
   rmdir('mfccunnorm','s');
end

if exist('mfccextracts') ==7
   rmdir('mfccextracts','s');
end

if exist('noisyextracts') ==7
   rmdir('noisyextracts','s');
end

if exist('fakeextracts') ==7
   rmdir('fakeextracts','s');
end



cd('SpeakerVer');

%Extract the first 25 samples from each file, then put in appropriate
%folders
disp('Extracting data for 10s');
sampledata(10,files,filepath,samplesperspk);

disp('Extracting data for 8s');
sampledata(8,files,filepath,samplesperspk);

disp('Extracting data for 6s');
sampledata(6,files,filepath,samplesperspk);

disp('Extracting data for 4s');
sampledata(4,files,filepath,samplesperspk);

disp('Extracting data for 2s');
sampledata(2,files,filepath,samplesperspk);

disp('Extraction Complete');
end
