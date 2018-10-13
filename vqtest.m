function bigD = vqtest(centroids,words);

epsilon = 0.0001;
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
            b = regexp(files(i).name,'\d+','match');
            sample{k} = [sample{k}' str2double(b{1})*ones(a(2),1)];
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
        speakerid = files(m).name(1:end-4);
        for i=1:numel(observations)
            for l = 0:log2(words)
                if l==0
                    [idx,C2] = kmeans(observations{i}(:,1:end-1),2^l,'MaxIter',1000);   
                else
                    [idx,C2] = kmeans(observations{i}(:,1:end-1),2^l,'MaxIter',1000,'Start',[C3]);
                end
                C3 = [C2+epsilon; C2-epsilon];
            end
            %[idx,C2] = kmeans(observations{i}(:,1:end-1),words,'Replicates',5,'MaxIter',1000);
            %opts = statset('Display','final');
            %[idx,C2] = kmeans(observations{i}(:,1:end-1),words,'Replicates',5,'Options',opts,'MaxIter',1000);
    
            a = size(C);
            d = 0;
            for k=1:a(1)
                d = d + norm(C(k,:)-C2(k,:));
            end
            distance(i,1) = d/a(1);
            %distance(i,1) = d;
            distance(i,2) = observations{i}(end);
        end

        a = size(distance);
        distance = [str2num(speakerid)*ones(a(1),1) distance];
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