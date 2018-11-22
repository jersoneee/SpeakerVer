duration = 4;
words = 32;
fs=16000;
epsilon = 0.0001;

cd('../dataextracts');
files = dir('**\*.mat');
filepath = strings(numel(files),1);
filepath = strcat(files(1).folder,'\',files(1).name);
load(filepath);

temp = speaker;
speaker = temp(:,1);
save('1.mat','speaker');
speaker = temp(:,2);
save('2.mat','speaker');


load('1.mat');
[mfccvec,delta,deltaDelta] = mfcc(speaker,fs,'LogEnergy','Ignore','NumCoeffs',12);
a = size(mfccvec);
meann = mean(mfccvec');
standev = std(mfccvec');

mfccvec = (mfccvec - meann'*ones(1,a(2)))./(standev'*ones(1,a(2)));

sample = mfccvec;
for l = 0:log2(words)
    if l==0
        [idx,C] = kmeans(sample,2^l,'Replicates',1,'MaxIter',1000);
    else
        [idx,C] = kmeans(sample,2^l,'Replicates',1,'MaxIter',1000,'Start',[C2]);
    end
    C2 = [C+epsilon; C-epsilon];
end

load('2.mat');
[mfccvec,delta,deltaDelta] = mfcc(speaker,fs,'LogEnergy','Ignore','NumCoeffs',12);
a = size(mfccvec);
meann = mean(mfccvec');
standev = std(mfccvec');

mfccvec = (mfccvec - meann'*ones(1,a(2)))./(standev'*ones(1,a(2)));

sample = mfccvec;
for l = 0:log2(words)
    if l==0
        [idx,Ctest] = kmeans(sample,2^l,'Replicates',1,'MaxIter',1000);
    else
        [idx,Ctest] = kmeans(sample,2^l,'Replicates',1,'MaxIter',1000,'Start',[C2]);
    end
    C2 = [Ctest+epsilon; Ctest-epsilon];
end

a = size(C);
d = 0;
for k=1:a(1)
    d = d + norm(C(k,:)-Ctest(k,:));
end
distance = d/a(1);

threshold = 3.5180;