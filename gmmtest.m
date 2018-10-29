function posterior = gmmtest(gmm)


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
        p=[];
        G = gmm{m,fold};
        b = regexp(files(m).name,'\d+','match');
        speakerid = b{1};
        for i=1:numel(observations)
            
            p(i,1) = sum(log(pdf(G,observations{i}(:,1:end-1))));
            p(i,2) = observations{i}(end);

        end
        
        a = size(p);
        p = [str2num(speakerid)*ones(a(1),1) p];
        if m==1
            posterior = p;
        else
            posterior = [posterior;p];
        end
    end
    
    if fold == 1
        bigP = posterior;
    else
        bigP = [bigP; posterior];
    end
    cd ..;
    cd ..;
end
cd ..;



disp('Testing Complete.');

    
end

