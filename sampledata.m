function [] = sampledata(duration,files,filepath,samplesperspk)
    % Sample the data in the filepath, and save according to the duration. Assume every speaker has 2 audio
    % streams to sample from, as specified by the DSP FSC. 
   



cd('dataextracts');

%Make a folder that corresponds to the duration
durpath = strcat(num2str(duration),'seconds');
if exist(durpath) ~= 7
    mkdir(durpath);
end

cd(durpath);

%Sample the 2 audio files and extract the first 25 samples from each strem,
%then save in a matrix
for i=1:2:length(filepath)
    [y,Fs] = audioread(filepath(i));
    speaker = y(1:Fs*duration*samplesperspk/2);
    speakerA = reshape(speaker,[duration*Fs,samplesperspk/2]);
    [y,Fs] = audioread(filepath(i+1));
    speaker = y(1:Fs*duration*samplesperspk/2);
    speakerB = reshape(speaker,[duration*Fs,samplesperspk/2]);
    speaker = [speakerA,speakerB];
    save(strcat(files(i).name(1:end-5),'.mat'),'speaker');
end

%Go back to parent
cd ..;
cd ..;
end