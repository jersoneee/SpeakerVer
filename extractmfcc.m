function [] = extractmfcc(datapath,duration,key);

disp(strcat('Extracting MFCCs for:',num2str(duration),' seconds')); 
fs = 16000;
durpath = strcat(num2str(duration),'seconds');

cd ..;
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
        if key == 0
            mfccvec=[mfccvec,[coeffs']];
        elseif key == 1
            mfccvec=[mfccvec,[coeffs';delta']];
        else
            mfccvec=[mfccvec,[coeffs';delta';deltaDelta']];
        end
    end
    a = regexp(files(i).name,'\d+_','match');
    save(strcat(a{1}(1:end-1),'mfcc.mat'),'mfccvec');
end

cd ..;
cd ..;
cd('SpeakerVer');
disp(strcat('Complete.')); 

end