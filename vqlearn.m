function centroids = vqlearn(words);


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
        %[idx,C] = kmeans(sample,words,'Replicates',5,'Options',opts,'MaxIter',1000);
        [idx,C] = kmeans(sample,words,'Replicates',5,'MaxIter',1000);
        centroids{k,i} = C;
    end
    cd ..;
    cd ..;
end
cd ..;

disp('Learning Complete.');
end