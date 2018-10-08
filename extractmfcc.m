function [] = extractmfcc(datapath,duration);

fs = 16000;
durpath = strcat(num2str(duration),'seconds');


cd(datapath);
cd(durpath);

files = dir('**\*.mat');
filepath = strings(numel(files),1);
for i=1:numel(files)
    filepath(i) = strcat(files(i).folder,'\',files(i).name);
end

cd ..;
cd ..;


if exist('mfccunnorm') ~= 7
    mkdir('mfccunnorm');
end
cd ('mfccunnorm');

if exist(durpath) ~=7
    mkdir(durpath);
end
cd (durpath);

for i=1:numel(files)
    load(filepath(i));
    mfccvec=[];
    for k=1:size(speaker,2)
        [coeffs,delta,deltaDelta] = mfcc(speaker(:,k),fs,'LogEnergy','Ignore','NumCoeffs',12);
        mfccvec=[mfccvec,[coeffs';delta';deltaDelta']];
    end
    save(strcat(files(i).name(1:3),'mfcc.mat'),'mfccvec');
end

cd ..;
cd ..;
end