function categorical_bar(Mean,Color)
% This funciton is plotting categorical grouped bar charts without error
% bar.
% Args:
%     Mean: array of mean values to specify the height of bar chart
%     Color: array of color codes
[m,n] = size(Mean);
classifier = {'CNN','Logistic regression','SVM','Decision tree','Random forest'};
losses = {'entropy','softdl','sqdl','logdl','counting'};
figH = figure;
axes1 = axes;
hold on
dd = 2;
C = 1:dd:dd*n;
c = 1+(0:0.2:0.2*n);
for ii =1:n
    for jj=1:m
    bb(ii,jj) = bar(C(ii)+c(jj),Mean(jj,ii),0.2,'FaceColor','flat');
    bb(ii,jj).CData = Color(jj,:);
    if jj==1
        bb(ii,jj).DisplayName = 'classification';
    else
        bb(ii,jj).DisplayName = losses{jj-1};
    end
    end
end
ylim([0 100]);
set_def_fig;
set(axes1,'Xlim',[1.7 dd*n+1.3]);
set(axes1,'XTick',(2.5:dd:dd*n+2),'XTickLabel',...
    classifier);
legend(bb(1,1:6),'Location','northoutside','Orientation','horizontal');
end
