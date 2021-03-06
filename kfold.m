function [] = kfold(duration,folds,samplesperspk);

disp('Performing Cross-Validation sets.');
durpath = strcat(num2str(duration),'seconds');
cd ..;
cd ('mfccextracts');

cd (durpath);


files = dir('**\*.mat');
filepath = strings(numel(files),1);
for i=1:numel(files)
    filepath(i) = strcat(files(i).folder,'\',files(i).name);
end

cd ..;
cd ..;
cd('SpeakerVer');
if exist('experiment') ~= 7
    mkdir('experiment');
end
cd('experiment');
    


for i=1:folds

    if exist(strcat('k',int2str(i))) ~= 7
        mkdir(strcat('k',int2str(i)));
    end

    cd(strcat('k',int2str(i)));
    
    if exist('dev') ~= 7
        mkdir('dev');
    end
    if exist('test') ~= 7
        mkdir('test');
    end
    

    for k=1:numel(filepath)
        load(filepath(k));
        a = size(mfccvec);
        mfccvec = reshape(mfccvec,a(1)*folds,[]);
        mfccsamp = mat2cell(mfccvec,a(1)*ones(1,folds));
        cd('test');
        temp = mfccsamp{i};
        a = size(temp);
        sample= mat2cell(temp,a(1),(a(2)/(samplesperspk/folds))*ones(1,samplesperspk/folds));
        b = regexp(files(k).name,'\d+','match');
        save(strcat(b{1},'.mat'),'sample');
        cd ..;

        cd('dev');
        temp=0;
        sample = [];
        for l = [i+1:folds,1:folds]
            sample = [sample,mfccsamp{l}];
            temp = temp+1;
            if temp ==4
                break
            end
        end
        b = regexp(files(k).name,'\d+','match');
        save(strcat(b{1},'.mat'),'sample');
        cd ..;
        
    end
    cd ..;
end
cd ..;

disp('Complete.');
end