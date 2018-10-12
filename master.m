%This series of codes describe the Speaker Verification System. They are
%arranged according to their block sequence, with their corresponding
%function calls.

%BLOCK 1: DATA EXTRACTION: Extract the data from a specified folder into
%usable segments, then save as .mat files into another folder (no feature extraction yet). Use keys
%accordingly to specify to only extract male, female, or both.

key = 0; %Only male 
%key = 1; %Only female 
%key = 2; %Both 
extractdata('data',key);

%MAKE NOISY DATA: From the extracted data, introduce Additive White
%Gaussian Noise to the segments.
% i: specifies the duration
% k: specifies the Signal-to-Noise Ratio (SNR)

for i = 10:-2:2
    for k = 24:6:48
        noisify(k,i)
    end
end


%MAKE IMPOSTOR DATA: From the extracted data, change the pitch of the
%samples to controllably emulate as impostors for the system.
% i: specifies the duration
% k: specifies the pitch change. Negative values mean lower voice, while
% positive values translate into higher voice.

for i = 10:-2:2
    for k = -5:2.5:5
        impostor(k,i)
    end
end


%Start Experimentation: Specify the datapath where the experiment will be
%conducted (e.g. 'dataextracts', 'fakeextracts', or 'noisyextracts')
datapath = 'dataextracts';

%BLOCK 2: Extract MFCC Coefficients: Extract MFCC coefficients from the
%specified datapath. Provides an option to extract only the main
%coefficients, or add the first and/or second derivatives.
% i: specifies the duration

key = 0; %Only coefficients 
%key = 1; %With delta 
%key = 2; %With delta-delta 

for i = 10:-2:2
    extractmfcc(datapath,i,key)
end

for i = 10:-2:2
    normalizemfcc(i)
end
    
    
%Perform Cross-Validation Scheme
    folds = 5;
    samplesperspk = 50;
    durmax = 10;
    
%BLOCK 3: Model    
%%%%For 2sec only 
    z=2;
    kfold(z,folds,samplesperspk);
    for i = 1:4
        words = 2^i*8;
        %words =64;
        t = cputime;
        centroids = vqlearnb(words);
        distance = vqtest(centroids,words);
        [EER(z/2,i),threshold] = vqeer(distance,z,words);
        e = cputime - t;
        elap(z/2,i) = e;
        disp(strcat('Words: ',num2str(words),' EER = ',num2str(EER(z/2,i)),'| Time Elapsed: ',num2str(e),' seconds'));
    end
    rmdir('experiment','s');
    EER(z/2,5) = NaN;
    
    
    
for z = 4:2:durmax    
    kfold(z,folds,samplesperspk);
%BLOCK 3: Model
    for i = 1:5
        words = 2^i*8;
        %words =64;
        t = cputime;
        centroids = vqlearnb(words);
        distance = vqtest(centroids,words);
        [EER(z/2,i),threshold] = vqeer(distance,z,words);
        e = cputime - t;
        elap(z/2,i) = e;
        disp(strcat('Words: ',num2str(words),' EER = ',num2str(EER(z/2,i)),'| Time Elapsed: ',num2str(e),' seconds'));
    end
    rmdir('experiment','s');
end