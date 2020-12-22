% This script is for visualing performance metrics from the paper
% P. Boonyakitanont, A. Lek-uthai, and J. Songsiri, "ScoreNet: A neural network-based post-processing model
% for identifying epileptic seizure onset and offset in EEGs".
%     Required file: performance-scorenet.mat containing all performance
% metrices in structure variables. In each structure file, there are six
% fields corresponding to each scheme of ScoreNet where fields ended with
% 'ent','soft','sq','log','ori', and 'class' are for 'entropy', 'soft-dice
% loss', 'squared-dice loss', 'log-dice loss', 'no ScoreNet' and
% 'counting-based method', respectively. Each row presents the performance
% metric obtained from each record, and each column shows the metrics when 
% epoch-based seizure classifier (i.e. CNN, logistic regression, SVM, 
% decision tree, and random forest from the first to the last columns) is
% applied. 
% This file also includes mean, median, Q1, Q3, and standard deviation of 
% each performance metric where each row indicates schemes of ScoreNet
% (i.e., 'no ScoreNet', 'entropy', 'soft-dice loss', 'squared-dice loss', 
% 'log-dice loss', and 'counting-based method' from the first to the last
% rows) and each column shows the metrics from the applied epoch-based 
% seizure classifier (i.e. CNN, logistic regression, SVM, decision tree, 
% and random forest from the first to the last columns)
%     Required main functions: plot_scatter2, bar_with_error, 
%     and categorical_bar

clear;clc;close all;

%% ScoreNet visualization
load('performance-scorenet.mat');
size = 15;
plot_scatter2(gdr_collection,abonlat_collection,abofflat_collection,...
    effonlat_collection,effofflat_collection,size,'d');
set_def_fig;
xlabel('Mean absolute latency (s)');
ylabel('EL-index');
xlabel('Mean absolute latency');
ytickformat('%.1f')
title('EL-index vs Mean absolute latency');
% save_fig_pdf_eps('elindex_ablatency2');

Color = [0.3010 0.7450 0.9330;0.4660 0.6740 0.1880;0.8500 0.3250 0.0980;...
    0 0.4470 0.7410;0.7 0.1840 0.7;0.9290 0.6940 0.1250];

bar_with_error(Mean_f1,Median_f1,Q1_f1,Q3_f1,Color);
ylabel('F1');
% save_fig_pdf_eps('f1_scorenet');

categorical_bar(Mean_fph,Color);
ylabel('FPR/h'); ylim([0 5.5]);
% save_fig_pdf_eps('fph_scorenet');

categorical_bar(Mean_gdr,Color);
ylabel('GDR'); ylim([60 100]);
% save_fig_pdf_eps('gdr_scorenet');

bar_with_error(Mean_effonlat,Median_effonlat,Q1_effonlat,Q3_effonlat,Color);
ylabel('EL-index'); ylim([0 1]);
% save_fig_pdf_eps('elonlat_scorenet');

bar_with_error(Mean_effofflat,Median_effofflat,Q1_effofflat,Q3_effofflat,Color);
ylabel('EL-index'); ylim([0 1]);
% save_fig_pdf_eps('elofflat_scorenet');
% close all;
