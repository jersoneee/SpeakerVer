function bigD = vqtestb(centroids,words);


disp('Testing...');
cd ('experiment');


all_files = dir;
all_dir = all_files([all_files(:).isdir]);
num_dir = numel(all_dir)-2;

for fold=1:num_dir
    cd(strcat('k',num2str(fold)));
    cd('test');
    files = dir('**\*.mat');
    filepath = strings(numel(files),1);
    for i=1:numel(files)
        filepath(i) = strcat(files(i).folder,'\',files(i).name);
    end


    for i=1:numel(filepath)
      load(filepath(i));
        for k = 1:numel(sample)
            a = size(sample{k});
            sample{k} = [sample{k}' str2double(files(i).name(1:3))*ones(a(2),1)];
        end
        if i==1
        observations=sample;
        else
            for k = 1:numel(sample)
                observations{end+1} = sample{k};
            end
        end
    end
    
    for m=1:numel(filepath)
        distance = 0;
        C = centroids{m,fold};
        speakerid = str2num(files(m).name(1:end-4));
        for i=1:numel(observations)

                [idx,C2] = kmeans(observations{i}(:,1:end-1),words,'Replicates',5,'MaxIter',1000);
            %opts = statset('Display','final');
            %[idx,C2] = kmeans(observations{i}(:,1:end-1),words,'Replicates',5,'Options',opts,'MaxIter',1000);
            %a = size(C);

                distance(1,i) = norm(C-C2);
                distance(2,i) = observations{i}(end);
        end
        distance = distance';
        a = size(distance);
        distance = [speakerid*ones(a(1),1) distance];
        if m==1
            Distance = distance;
        else
            Distance = [Distance;distance];
        end
    end
    
    if fold == 1
        bigD = Distance;
    else
        bigD = [bigD; Distance];
    end
    cd ..;
    cd ..;
end
cd ..;



disp('Testing Complete.');
end