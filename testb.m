
C1 = centroids{1,1}(:,1:3);
C2 = centroids{2,1}(:,1:3);
C3 = centroids{3,1}(:,1:3);
C4 = centroids{4,1}(:,1:3);
C5 = centroids{5,1}(:,1:3);

scatter3(C1(:,1), C1(:,2), C1(:,3),'*')
hold on
scatter3(C2(:,1), C2(:,2), C2(:,3))
scatter3(C3(:,1), C3(:,2), C3(:,3))
scatter3(C4(:,1), C4(:,2), C4(:,3))
scatter3(C5(:,1), C5(:,2), C5(:,3))
X = [C1 C2 C3 C4 C5];
varNames = {'First'; 'sec'; 'Thrds'; 'F'; 'Fif'};
figure
gplotmatrix(X,[],[],['c' 'b' 'm' 'g' 'r'],[],[],false);
text([.08 .24 .43 .66 .83], repmat(-.1,1,5), varNames, 'FontSize',8);
text(repmat(-.12,1,5), [.86 .62 .41 .25 .02], varNames, 'FontSize',8, 'Rotation',90);

