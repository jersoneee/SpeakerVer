function [] = impostor(pitchchange, duration)
    % Makes noisy copies of the extracted files, with pecified
    % signal-to-noise ratio (in dB), and duration of the signal. Noise is Additive White Gaussian Noise.
    % Makes a new directory, noisyextracts to save from.
fs = 16000;
cd ..;
cd('dataextracts');
durpath = strcat(num2str(duration),'seconds');
cd(durpath);
files = dir('**\*.mat');
filepath = strings(numel(files),1);
for i=1:numel(files)
    filepath(i) = strcat(files(i).folder,'\',files(i).name);
end

cd ..;
cd ..;

if exist('fakeextracts') ~= 7
    mkdir('fakeextracts');
end
cd('fakeextracts');

if exist(durpath) ~=7
    mkdir(durpath);
end
cd (durpath);


if exist(num2str(pitchchange)) ~= 7
    mkdir(num2str(pitchchange));
end
cd(num2str(pitchchange));


for i=1:numel(filepath)
    load(filepath(i));
    a = size(speaker);
    for k = 1:a(2)
        speaker(:,k) = shiftPitch(speaker(:,k),pitchchange,0.3,fs);
        %audiowrite(strcat(files(i).name(1:3),' (',num2str(SNR),').wav'),speaker(:,k),fs);
    end
    save(strcat(files(i).name(1:3),'(',num2str(pitchchange),').mat'),'speaker');
end

cd ..;
cd ..;
cd ..;

cd('SpeakerVer');
end