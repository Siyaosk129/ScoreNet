function bar_with_error(Mean,Median,Q1,Q3,Color)
% This funciton is plotting categorical grouped bar charts with error bar
% overlayed on the bar charts.
% Args:
%     Mean: array of mean values to specify the height of bar chart
%     Median: array of median values to specify the center of error bar
%     Q1: array of Q1's to specify the length below the median of error bar
%     Q3: array of Q3's to specify the length above the median of error bar
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
        set(bb(ii,jj),'FaceAlpha',0.5);
    else
        bb(ii,jj).DisplayName = losses{jj-1};
    end
    errorbar(C(ii)+c(jj),Median(jj,ii),...
        Median(jj,ii)-Q1(jj,ii),Q3(jj,ii)-Median(jj,ii),'ok');
    end
end
ylim([0 100]);
set_def_fig;
set(axes1,'Xlim',[1.7 dd*n+1.3]);
set(axes1,'XTick',(2.5:dd:dd*n+2),'XTickLabel',...
    classifier);
legend(bb(1,1:6),'Location','northoutside','Orientation','horizontal');
end