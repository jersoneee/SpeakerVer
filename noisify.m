function [] = noisify(SNR,duration)
    % Makes noisy copies of the extracted files, with pecified
    % signal-to-noise ratio (in dB), and duration of the signal. Noise is Additive White Gaussian Noise.
    % Makes a new directory, noisyextracts to save from.

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

if exist('noisyextracts') ~= 7
    mkdir('noisyextracts');
end
cd('noisyextracts');

if exist(durpath) ~=7
    mkdir(durpath);
end
cd (durpath);

if exist(strcat(int2str(SNR),'dB')) ~= 7
    mkdir(strcat(int2str(SNR),'dB'));
end
cd(strcat(int2str(SNR),'dB'));

for i=1:numel(filepath)
    load(filepath(i));
    speaker = awgn(speaker,48);
    save(strcat(files(i).name(1:end-5),'-',int2str(SNR),'dB.mat'),'speaker');
end

cd ..;
cd ..;
cd ..;

cd('SpeakerVer');

end