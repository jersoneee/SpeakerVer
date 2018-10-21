%This series of codes describe the Speaker Verification System. They are
%arranged according to their block sequence, with their corresponding
%function calls.

%BLOCK 1: DATA EXTRACTION: Extract the data from a specified folder into
%usable segments, then save as .mat files into another folder (no feature extraction yet). Use keys
%accordingly to specify to only extract male, female, or both.
for keyA = 0:2 
    
    extractdata('dataprepro',keyA);


    datapath = 'dataextracts';

%BLOCK 2: Extract MFCC Coefficients: Extract MFCC coefficients from the
%specified datapath. Provides an option to extract only the main
%coefficients, or add the first and/or second derivatives.
% i: specifies the duration

    for keyB = 0:2
    
        if exist('../mfccunnorm') == 7
                rmdir('../mfccunnorm','s');
        end
    
        for i = 10:-2:2
            extractmfcc(datapath,i,keyB)
        end

%BLOCK 2.5: Normalize MFCC Coefficients. For distance-based metrics (like VQ),
%normalization will help in improving classification. Subtracts every coefficients with its overall mean,
%and divides by the population's standard deviation.
% i: specifies the duration

        if exist('../mfccextracts') == 7
           rmdir('../mfccextracts','s');
        end
        
        for i = 10:-2:2
            normalizemfcc(i)
        end


%BLOCK 3- MODEL: Makes voice models of the samples and compares them
%against each other. EER is then determined and displayed.

%BLOCK 3.1 - Perform Cross-Validation Scheme: 

        folds = 5;
        samplesperspk = 50;
        durmax = 10;
    
        for z = 2:2:durmax    
            if exist('experiment') ==7
               rmdir('experiment','s');
            end
            kfold(z,folds,samplesperspk);
            for i = 1:5
                if i==5 && z==2
                    EER(z/2,5) = NaN;
                    break;
                end
                words = 2^i*8;
                t = cputime;
                centroids = vqlearnb(words);
                distance = vqtest(centroids,words);
                [EER(z/2,i),threshold] = vqeer(distance,z,words);
                e = cputime - t;
                elap(z/2,i) = e;
                disp(strcat('Words: ',num2str(words),' EER = ',num2str(EER(z/2,i)),'| Time Elapsed: ',num2str(e),' seconds'));
            end
        end

        if keyA == 0
            Astring = 'Male';
        elseif keyA == 1
            Astring = 'Female';
        elseif keyA == 2
            Astring = 'Both';
        end

        if keyB == 0
            Bstring = 'MFCC';
        elseif keyB == 1
            Bstring = 'Delta';
        elseif keyB == 2
            Bstring = 'DeltaDelta';
        end
        
        if exist('../Results') ~= 7
            mkdir('../Results');
        end
        cd ('../Results');
        
        if exist(Astring) ~= 7
            mkdir(Astring);
        end
        cd (Astring)
        if exist(Bstring) ~= 7
            mkdir(Bstring);
        end
        cd ('../../SpeakerVer');
        
        
        save(strcat('../Results/',Astring,'/',Bstring,'/EER.mat'),'EER');
        save(strcat('../Results/',Astring,'/',Bstring,'/elap.mat'),'elap');
    end
end