keyB = 0;
folds = 5;
samplesperspk = 50;
duration = 4;
words =  32;
Bstring = 'MFCC';

for keyA = 0:1 
    
    extractdata('dataprepro',keyA);
    
    
    for i = 1:11
        SNR = -15+(5*i);
        disp(strcat('Setting up for SNR-',int2str(SNR),'dB'));

        if exist('../noisyextracts') == 7
            rmdir('../noisyextracts','s');
        end    
        noisify(SNR,duration)
        
        datapath = 'noisyextracts';

%BLOCK 2: Extract MFCC Coefficients: Extract MFCC coefficients from the
%specified datapath. Prov   ides an option to extract only the main
%coefficients, or add the first and/or second derivatives.
% i: specifies the duration

        if exist('../mfccunnorm') == 7
            rmdir('../mfccunnorm','s');
        end
        extractmfcc(datapath,duration,keyB)
    
%BLOCK 2.5: Normalize MFCC Coefficients. For distance-based metrics (like VQ),
%normalization will help in improving classification. Subtracts every coefficients with its overall mean,
%and divides by the population's standard deviation.
% i: specifies the duration

        if exist('../mfccextracts') == 7
            rmdir('../mfccextracts','s');
        end
        normalizemfcc(duration)


        if keyA == 0
            Astring = 'Male';
        elseif keyA == 1
            Astring = 'Female';
        end

        
%BLOCK 3- MODEL: Makes voice models of the samples and compares them
%against each other. EER is then determined and displayed.

%BLOCK 3.1 - Perform Cross-Validation Scheme: 

        if exist('experiment') ==7
            rmdir('experiment','s');
        end
        kfold(duration,folds,samplesperspk);
        t = cputime;
        centroids = vqlearnb(words);
        distance = vqtest(centroids,words);
        [EER{i,keyA+1},avg(i,keyA+1),threshold] = vqeer(distance,duration,words);
        e = cputime - t;
        elap(i,keyA+1) = e;
        disp(strcat(Astring,Bstring,num2str(duration),'seconds',num2str(words),'words | SNR: ',num2str(SNR),' Average EER = ',num2str(avg(i,keyA+1)),'| Time Elapsed: ',num2str(e),' seconds'));

    end
end


            
        if exist('../VQResultsNoise') ~= 7
            mkdir('../VQResultsNoise');
        end
        
        save(strcat('../VQResultsNoise/avg.mat'),'avg');        
        save(strcat('../VQResultsNoise/EER.mat'),'EER');
        save(strcat('../VQResultsNoise/elap.mat'),'elap');

    
        
        
for keyA = 0:1 
    
    extractdata('dataprepro',keyA);
    
    
    for i = 1:11
        pitch = -12 +(2*i);
        disp(strcat('Setting up for pitchchange:',int2str(pitch),''));

        if exist('../fakeextracts') == 7
            rmdir('../fakeextracts','s');
        end    
        impostor(pitch,duration)
        
        datapath = 'fakeextracts';

%BLOCK 2: Extract MFCC Coefficients: Extract MFCC coefficients from the
%specified datapath. Provides an option to extract only the main
%coefficients, or add the first and/or second derivatives.
% i: specifies the duration

        if exist('../mfccunnorm') == 7
            rmdir('../mfccunnorm','s');
        end
        extractmfcc(datapath,duration,keyB)
    
%BLOCK 2.5: Normalize MFCC Coefficients. For distance-based metrics (like VQ),
%normalization will help in improving classification. Subtracts every coefficients with its overall mean,
%and divides by the population's standard deviation.
% i: specifies the duration

        if exist('../mfccextracts') == 7
            rmdir('../mfccextracts','s');
        end
        normalizemfcc(duration)


        if keyA == 0
            Astring = 'Male';
        elseif keyA == 1
            Astring = 'Female';
        end

        
%BLOCK 3- MODEL: Makes voice models of the samples and compares them
%against each other. EER is then determined and displayed.

%BLOCK 3.1 - Perform Cross-Validation Scheme: 

        if exist('experiment') ==7
            rmdir('experiment','s');
        end
        kfold(duration,folds,samplesperspk);
        t = cputime;
        centroids = vqlearnb(words);
        distance = vqtest(centroids,words);
        [EER{i,keyA+1},avg(i,keyA+1),threshold] = vqeer(distance,duration,words);
        e = cputime - t;
        elap(i,keyA+1) = e;
        disp(strcat(Astring,Bstring,num2str(duration),'seconds',num2str(words),'words | Pitch Change: ',num2str(pitch),' Average EER = ',num2str(avg(i,keyA+1)),'| Time Elapsed: ',num2str(e),' seconds'));

    end
end

        if exist('../VQResultsFake') ~= 7
            mkdir('../VQResultsFake');
        end
        
        save(strcat('../VQResultsFake/avg.mat'),'avg');        
        save(strcat('../VQResultsFake/EER.mat'),'EER');
        save(strcat('../VQResultsFake/elap.mat'),'elap');

