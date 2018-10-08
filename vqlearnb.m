function centroids = vqlearnb(words);

epsilon = 0.0001;

disp('Learning ...');

fs = 16000;
cd('experiment');

all_files = dir;
all_dir = all_files([all_files(:).isdir]);
num_dir = numel(all_dir)-2;

for i=1:num_dir
    cd(strcat('k',num2str(i)));
    cd('dev');
    files = dir('**\*.mat');
    for k=1:numel(files)
        load(files(k).name);
        sample = sample';
        %opts = statset('Display','final');
        %[idx,Ccontrol] = kmeans(sample,words,'Replicates',5,'Options',opts,'MaxIter',1000);
        for l = 0:log2(words)
            if l==0
                [idx,C] = kmeans(sample,2^l,'Replicates',1,'MaxIter',1000);   
            else
                [idx,C] = kmeans(sample,2^l,'Replicates',1,'MaxIter',1000,'Start',[C2]);
            end
            C2 = [C+epsilon; C-epsilon];
        end
        centroids{k,i} = C;
    end
    cd ..;
    cd ..;
end
cd ..;

disp('Learning Complete.');
end