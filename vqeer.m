function [EER,threshold] = vqeer(distance,dur,words)


disp('Calculating EER.');

a = size(distance);

threshold = [min(distance(:,2)) :0.1:max(distance(:,2))];

for i=1:numel(threshold)
    for k = 1:a(1)
        if distance(k,2) <= threshold(i)
            distance(k,4) = distance(k,1);
        else
            distance(k,4) = 0;
        end
    end
    if i==1
        FAR = nnz(distance(:,4)>0 & distance(:,3) ~= distance(:,4))/a(1);
        FRR = nnz(distance(:,4)==0 & distance(:,1) ~= distance(:,3))/a(1);
    else
        FAR = [FAR nnz(distance(:,4)>0 & distance(:,3) ~= distance(:,4))/a(1)];
        FRR = [FRR nnz(distance(:,4)==0 & distance(:,1) ~= distance(:,3))/a(1)];        
    end
    

end
    [X,idx] = min(abs(FAR-FRR));
    EER = FAR(idx);
    errorplot = figure;
    plot(threshold,FAR)
    title(strcat('Error Rate Plot: ',num2str(dur),' seconds, ', num2str(words),' words'))
    xlabel('Threshold') 
    ylabel('Error Rate') 
    hold on
    plot(threshold,FRR)
    legend({'FRR','FAR'},'Location','southwest')
    hold off
    threshold = threshold(idx);
    cd ..;
    if exist('Graphs') ~= 7
    mkdir('Graphs');
    end
    cd('Graphs');
    saveas(errorplot,strcat(num2str(dur),' seconds, ', num2str(words),' words.jpg'));
    cd ..;
    cd('SpeakerVer');
    close(errorplot);
end