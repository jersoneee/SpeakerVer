function [] = normalizemfcc(duration);

disp(strcat('Normalizing ',num2str(duration),' seconds.'));
fs = 16000;
durpath = strcat(num2str(duration),'seconds');
cd ..;
cd('mfccunnorm');
cd(durpath);


files = dir('**\*.mat');
filepath = strings(numel(files),1);
for i=1:numel(files)
    filepath(i) = strcat(files(i).folder,'\',files(i).name);
end
cd ..;
cd ..;
if exist('mfccextracts') ~= 7
    mkdir('mfccextracts');
end
cd ('mfccextracts');

if exist(durpath) ~=7
    mkdir(durpath);
end
cd (durpath);


for i=1:numel(files)
    load(filepath(i));
    a = size(mfccvec);
    if i==1
        meann = mean(mfccvec');
        standev = std(mfccvec');
    end
    %disp(strcat('Normalizing ',files(i).name(1:3),'mfcc.mat'));
    mfccvec = (mfccvec - meann'*ones(1,a(2)))./(standev'*ones(1,a(2)));
        
    save(strcat(files(i).name(1:3),'mfcc.mat'),'mfccvec');
end

cd ..;
cd ..;
cd('SpeakerVer');
disp('Complete.');
end
