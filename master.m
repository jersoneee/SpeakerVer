%BLOCK 1: DATA EXTRACTION

key = 0; %Only male 
%key = 1; %Only female 
%key = 2; %Both 
extractdata('data',key);

%MAKE NOISY DATA

for i = 10:-2:2
    for k = 24:6:48
        noisify(k,i)
    end
end


%MAKE IMPOSTOR DATA

for i = 10:-2:2
    for k = -5:2.5:5
        impostor(k,i)
    end
end


%Start Experimentation: Vary datapath according to experiment (e.g.
%Standard, with noise, or impostors)

%BLOCK 2: Extract MFCC Coefficients
key = 0; %Only coefficients 
%key = 1; %With delta 
%key = 2; %With delta-delta 

for i = 10:-2:2
    extractmfcc('dataextracts',i,key)
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