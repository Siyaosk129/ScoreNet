% This script is to visualize training and test losses, and outputs of the 
% ScoreNet compared to the inputs. The outputs include both seizure
% probabilities and seizure predictions. This script uses 'set_def_fig' and
% 'save_fig_pdf_eps' to set default parameters for figure and to save
% figure in different formats.

% Cost during training
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,1,1);plot(loss_train(1:iter));title('Training loss');
xticklabels({});
xlim([1 iter]);
set_def_fig;
ax = gca;
pos = get(gca, 'Position');
pos(1) = 0.059;
set(gca, 'Position', pos)
subplot(2,1,2);plot(loss_test(1:iter));title('Testing loss');
set_def_fig;
ax = gca;
pos = get(gca, 'Position');
pos(1) = 0.059;
set(gca, 'Position', pos)
xlim([1 iter]);
xlabel('Iteration');
save_fig_pdf_eps([fig_dir 'loss-' file{1}(12:end-4) '_' loss_name]);

% Seizure probability of training data
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(4,1,1);stem(y_train);title('Training data');ylabel('Label');
ylim([0 1]);
xlim([1 N]);
xticklabels({});
set_def_fig;
subplot(4,1,2);stem(y_bf);ylabel('Input');
ylim([0 1]);
xlim([1 N]);
xticklabels({});
set_def_fig;
subplot(4,1,3);stem(cand_train);ylabel('Candidate');
ylim([0 1]);
xlim([1 N]);
xticklabels({});
set_def_fig;
subplot(4,1,4);stem(yhat);ylabel('Output');
ylim([0 1]);
xlim([1 N]);
set_def_fig;
xlabel('Epochs');
save_fig_pdf_eps([fig_dir 'train_prob_onoff-' file{1}(12:end-4) '_' loss_name]);

% Seizure probability of test data
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(4,1,1);stem(y_test);title('Test data');ylabel('Label');
xticklabels({});
ylim([0 1]);
xlim([1 n_test]);
set_def_fig;
subplot(4,1,2);stem(z_test_nonan);ylabel('Input');
xticklabels({});
ylim([0 1]);
xlim([1 n_test]);
set_def_fig;
subplot(4,1,3);stem(cand_test);ylabel('Candidate');
xticklabels({});
ylim([0 1]);
xlim([1 n_test]);
set_def_fig;
subplot(4,1,4);stem(yhat_test);ylabel('Output');
ylim([0 1]);
xlim([1 n_test]);
set_def_fig;
xlabel('Epochs');
save_fig_pdf_eps([fig_dir 'test_prob_onoff-' file{1}(12:end-4) '_' loss_name]);

% Seizure predictions of training data
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(4,1,1);stem(y_train);title('Training data (thres)');ylabel('Label');
ylim([0 1]);
xlim([1 N]);
xticklabels({});
set_def_fig;
subplot(4,1,2);stem(ybar_train_old);ylabel('Input');
ylim([0 1]);
xlim([1 N]);
xticklabels({});
set_def_fig;
subplot(4,1,3);stem(candbar_train);ylabel('Candidate');
ylim([0 1]);
xlim([1 N]);
xticklabels({});
set_def_fig;
subplot(4,1,4);stem(ybar_train);ylabel('Output');
ylim([0 1]);
xlim([1 N]);
set_def_fig;
xlabel('Epochs');
save_fig_pdf_eps([fig_dir 'train_class_onoff-' file{1}(12:end-4) '_' loss_name]);

% Seizure predictions of test data
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(4,1,1);stem(y_test);title('Test data (thres)');ylabel('Label');
xticklabels({});
ylim([0 1]);
xlim([1 n_test]);
set_def_fig;
subplot(4,1,2);stem(ybar_test_old);ylabel('Input');
xticklabels({});
ylim([0 1]);
xlim([1 n_test]);
set_def_fig;
subplot(4,1,3);stem(candbar_test);ylabel('Candidate');
xticklabels({});
ylim([0 1]);
xlim([1 n_test]);
set_def_fig;
subplot(4,1,4);stem(ybar_test);ylabel('Output');
ylim([0 1]);
xlim([1 n_test]);
set_def_fig;
xlabel('Epochs');
save_fig_pdf_eps([fig_dir 'test_class_onoff-' file{1}(12:end-4) '_' loss_name]);

close all;