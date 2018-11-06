function [EER,avg,threshold] = gmmeer(posterior,dur,mixtures)


disp('Calculating EER.');


samplesperspk = 50;
a = size(posterior);


for l=0:(a(1)/samplesperspk)-1
    threshold = [min(posterior(l*samplesperspk+1:(l+1)*samplesperspk,2)) :0.05:max(posterior(l*samplesperspk+1:(l+1)*samplesperspk,2))];

    for i=1:numel(threshold)
        for k = l*samplesperspk+1:(l+1)*samplesperspk
            if posterior(k,2) >= threshold(i)
                posterior(k,4) = posterior(k,1);
            else
                posterior(k,4) = 0;
            end
        end
        if i==1
            FAR = nnz(posterior(:,4)>0 & posterior(:,3) ~= posterior(:,4))/a(1);
            FRR = nnz(posterior(:,4)==0 & posterior(:,1) ~= posterior(:,3))/a(1);
        else
            FAR = [FAR nnz(posterior(:,4)>0 & posterior(:,3) ~= posterior(:,4))/a(1)];
            FRR = [FRR nnz(posterior(:,4)==0 & posterior(:,1) ~= posterior(:,3))/a(1)];        
        end
    end
    [X,idx] = min(abs(FAR-FRR));
    EER(l+1,1) = posterior(l*samplesperspk+1,1);
    EER(l+1,2) = FAR(idx);
end
   
a = unique( EER(:,1) ) ;
b = accumarray( EER(:,1), EER(:,2), [], @mean ) ;
EER = [a, b(a)]
avg = mean(EER(:,2))

%     [X,idx] = min(abs(FAR-FRR));
%     EER = FAR(idx);
%     errorplot = figure;
%     plot(threshold,FAR)
%     title(strcat('Error Rate Plot: ',num2str(dur),' seconds, ', num2str(mixtures),' mixtures'))
%     xlabel('Threshold') 
%     ylabel('Error Rate') 
%     hold on
%     plot(threshold,FRR)
%     legend({'FRR','FAR'},'Location','southwest')
%     hold off
%     threshold = threshold(idx);
%     cd ..;
%     if exist('Graphs') ~= 7
%     mkdir('Graphs');
%     end
%     cd('Graphs');
%     saveas(errorplot,strcat(num2str(dur),' seconds, ', num2str(mixtures),' mixtures.jpg'));
%     cd ..;
%     cd('SpeakerVer');
%     close(errorplot);
end