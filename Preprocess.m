
files = dir('data\**\*.wav');
filepath = strings(numel(files),1);
for i=1:numel(files)
    filepath(i) = strcat(files(i).folder,'\',files(i).name);
end

if exist('dataprepro') ~= 7
   mkdir('dataprepro');
end
cd('dataprepro');

outpath = strrep(filepath,'data','dataprepro');

for k=1:numel(files)
disp(strcat("Processing: ",files(k).name));
                  
[speech,Fs] = audioread(filepath(k));

% Initialize VAD parameters
VAD_cst_param = vadInitCstParams;
clear vadG729, 
% Run for 10 seconds

disp("Running VAD...");
for i=1:length(speech)/80
  % Retrieve 10 ms of speech data from the audio recorder
  %speech = audioSource();
  % Call the VAD algorithm
  decision(i) = vadG729(speech(80*i-79:i*80), VAD_cst_param);
  % Plot speech frame and decision: 1 for speech, 0 for silence
end

expand = ones(1,80);
D = kron(decision,expand);


disp("Smoothing...");
windd= 0.2;
for i=windd*Fs+1:length(D)-windd*Fs
    if D(i) == 0 && D(i-windd*Fs) == 0
       D(i-windd*Fs:i) = 0;
    end
end

windd= 0.5;
for i=windd*Fs+1:length(D)-windd*Fs
    if D(i) == 0 && D(i-windd*Fs) == 0
       D(i-windd*Fs:i) = 0;
    end
end


disp("Applying...");

for i = 1:length(D)
    if D(i) == 0
        speech(i) = 0;
    end
end
speech = speech(speech ~=0);

clear decision;
clear D;

C = strsplit(outpath(k),'\');
c = find(contains(C,'dataprepro'));
for i = c+1:numel(C)-1
    if exist(C{i}) ~= 7
        mkdir(C{i});
    end
    cd(C{i});
end
audiowrite(files(k).name,speech,Fs)
while c<i
    cd ..;
    i = i-1;
end

end

cd ..;
