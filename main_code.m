% This is a main file based on the paper
% P. Boonyakitanont, A. Lek-uthai, and J. Songsiri, "ScoreNet: A neural network-based post-processing model
% for identifying epileptic seizure onset and offset in EEGs"
% 
% Develooper: Poomipat Boonyakitanont
% Date: Dececber 21, 2020.
% 
% This file contains 4 sections as follows.
% 
% Section 1: EXPERIMENTAL SETUP
% This section specifies details of experimental setup including cases of 
% patients, losses, and parameter initialization. Note that this setup is 
% based on a conjugate gradient agorithm for optimizing the ScoreNet.
% 
% Section 2: DATA PREPARATION
% In this section, input data (z) are reconstructed for
% training and evaluating ScoreNet, where the input data are saved in table format.
% In the imported table, the test inputs (z_test) are in the column
% corresponding to the test record name (the first column of the file
% prediction_chb23_06.csv for example), and the training inputs (z_train)
% are in the other columns. The trainging data from each column are 
% concatenated and reshape from z_train = [z_1,z_2,...,z_N] into Z_train =
% [vec(z)_1;vec(z)_2;...;vec(z)_N] (in equation (1)). For the label (y), 
% the seizure onsets and offsets are specified by the time points (columns 
% B to G for seizure onsets and columns H to M for seizure offsets), so we 
% create the label containing 0 or 1 corresponding to the annotated time. 
% In addition, since lengths of EEGs are different, we remove NaN contained
% in the table before training the ScoreNet.
% 
% Section 3: TRAINING AND TESTING PROCESS
% We provide codes for training and evaluating the ScoreNet in this 
% section.
% There are 4 scripts required in this section:
% 1. forward_compute.m for predicting final outputs (yhat).
% 2. loss_grad.m for computing the loss and the gradients w.r.t predictions
% (yhat).
% 3. gradient_update.m for calculating the gradient of the loss function 
% w.r.t the model parameters.
% 4. conj_grad.m for updating the model using a conjugate gradient 
% algorithm. Note that another optimization algorithm can be used by 
% changing this function.
% 
% Section 4: EVALUATION AND VISUALIZATION
% In this section, we give codes of evaluation and visualization of 
% predictions of seizure onset and offset. This section includes the 
% processes of
% 1. Thresholding outcomes (seizure probabilities) into binary values 
% (normal/seizure)
% 2. Evaluating seizure onset and offset using the function 'onoff_eval'
% 3. Visualizing both seizure probabilities and decision making 
% (normal/seizure) by the script 'visualization'
% 4. Saving results into csv files (for easy inspection) and mat files 
% (for further analysis) using the script 'save_results'
% 
% Note: these codes work properly by MATLAB R2018a

clc;clear;close all;

%% ========================= EXPERIMENTAL SETUP (USER SPECIFIED) =============================== %%
% Specify main directory 
main_dir = 'C:\Users\pingp\OneDrive\forgithub\';

% Select cases (for example {'chb23'} or {'chb01','chb02','chb03'})
patients = {'chb23'};

% Select epoch-based classifier (used for specifying directory only)
class_model_name = 'random-forest';

% Select loss function
% 'ent': entropy
% 'softdl': soft-dice loss
% 'sqdl': square-dice loss
% 'logdl': log-dice loss
loss_name = 'logdl';

%% -------------- EXPERIMENTAL SETUP (AUTOMATIC) --------------%%
% ---------------------- Import epoch-based classification data ------------------------- %

for p =1:length(patients) % Loop through each case of patients
    patient = patients{p};
    
    % Set directory
    fig_dir = [main_dir class_model_name '_fig\' patient '\'];
    result_dir = [main_dir class_model_name '_result\' patient '\'];
    predict_dir = [main_dir class_model_name '_result\' patient '\prediction\'];
    label_dir = [main_dir '\chb-mit_onsetoffset_label\annot_' patient '.csv'];
    files_struc = dir(predict_dir);
    files = {files_struc(3:end).name}';
    
    for te_record = 1:length(files) % Loop through each fold of LOOCV
        
        % Import data
        file = files(te_record);
        table_data = importdata([predict_dir file{1}]);
        predict = table_data.data(1:end,2:end)';
        table_label = importdata(label_dir);
        result = struct();
        fprintf('Start post processing: case %2s \n',file{1}(12:end-4));
        fprintf('Data pre-processing \n');
        
% ---------------------------------- Parameter Setup -------------------------------------- %
        
        % Set decay rate of EL-index
        r = 0.9;
        
        % Set size of a1 and a2
        w = 2*6+1;
        
        % Initialize model parameters
        a1 = ones(w,1);
        a2 = ones(w,1);
        a3 = 3;
        a4 = 3;
        b1 = -1;
        b2 = -2;
        b3 = 0;
        b4 = -1;
        model = struct(); model.w = w;
        
        % Set maximum iteration
        n_iter = 2500;
        
        % Allocate arrays of training and test losses
        loss_train = zeros(1,n_iter);
        loss_test = zeros(1,n_iter);
        
        % Allocate memories of parameters for optimization algorithm
        x = [a1;a2;a3;a4;b1;b2;b3;b4];
        x = [x zeros(size(x,1),n_iter-1)];
        dx = zeros(size(x));
        s = zeros(size(x));
        beta = zeros(1,size(x,2));
        
%% ================================== DATA PREPARATION ================================ %%
        % Pull epoch-based predictions and labels of test record
        z_test_raw = predict(te_record,:); 
        y_test_raw = table_label(te_record,2:end);
        
        % Prepare training data
        z_train = predict; 
        z_train(te_record,:) = [];
        y_train_raw = table_label(:,2:end);
        y_train_raw(te_record,:) = []; % Remove test label
        [n_rec,n_sam] = size(z_train);
        n_sam_rec = zeros(1,n_rec);
        Z_train = [];
        n_test = table_label(te_record,1);
        y_train = zeros(1,sum(table_label(:,1))-n_test);
        
        % Construct seizure probabilities of test data from epoch-based classifier
        y_bf = []; % bf = before post-processing
        
        for i=1:n_rec % Reconstruct Z_train and y_train
            z_train_nonan = z_train(i,~isnan(z_train(i,:))); % Remove NaN from the array
            train_onset = y_train_raw(i,1:6);
            train_offset = y_train_raw(i,7:end);
            train_onset = train_onset(~isnan(train_onset));
            train_offset = train_offset(~isnan(train_offset));
            y_bf = [y_bf z_train(i,:)];
            for j=1:length(train_onset)
                y_train(sum(n_sam_rec)+train_onset(j):sum(n_sam_rec)+train_offset(j)) =1;
            end
            A = toeplitz([z_train_nonan zeros(1,(w-1)/2)]);
            A = triu(A);
            n_sam_rec(i) = size(A,2)-(w-1)/2;
            Z_train = [Z_train, A(1:w,(w-1)/2+1:end)];
        end
        y_bf = y_bf(~isnan(y_bf));
        
        % Reconstruct Z_test and y_test
        z_test_nonan = z_test_raw(~isnan(z_test_raw));
        A = toeplitz([z_test_nonan zeros(1,(w-1)/2)]);
        A = triu(A);
        Z_test = A(1:w,(w-1)/2+1:end);
        N = sum(n_sam_rec);
        y_test = zeros(1,n_test);
        test_onset = y_test_raw(1:6); % At most 6 seizure events
        test_offset = y_test_raw(7:end);
        test_onset = test_onset(~isnan(test_onset));
        test_offset = test_offset(~isnan(test_offset));
        for i=1:length(test_onset)
            y_test(test_onset(i):test_offset(i))=1;
        end
        % Reserve memory for step size and gradient
        lambda = zeros(1,n_iter); 
        gradx = zeros(size(x));
        
        fprintf('Begin optimization \n');
        
%% ============================ TRAINING AND TESTING PROCESS ============================= %%
        for iter =1:n_iter
            
% --------------------------------- Forward calculation --------------------------------- %
            model.a1 = a1; model.a2 = a2; model.a3 = a3; model.a4 = a4;
            model.b1 = b1; model.b2 = b2; model.b3 = b3; model.b4 = b4;
            if mod(iter,20) == 0
                fprintf('Iteration %i. ',iter);
            end
            % Forward compute for training and test data
            [yhat,cand_train,score_train,out_gate_train,idx_on_train,idx_off_train] = forward_compute(Z_train,model,n_sam_rec);
            [yhat_test,cand_test,score_test,out_gate_test,idx_on_test,idx_off_test] = forward_compute(Z_test,model,n_test);
            
            % Compute losses for training and test data
            [loss_train(iter), dyhat] = loss_grad(yhat,y_train,loss_name);
            [loss_test(iter), ~] = loss_grad(yhat_test,y_test,loss_name);
            
            % Display training and test loss
            if mod(iter,20) == 0
                fprintf('Training loss: %0.6f. \t Test loss: %0.6f \n',loss_train(iter),loss_test(iter));
            end
            
% ------------------------------- Backward calculation ----------------------------------- %
            % Calculate gradient
            gradx(:,iter) = gradient_update(Z_train,dyhat,yhat,out_gate_train,...
                cand_train,score_train,idx_on_train,idx_off_train,model);
            
            % Conjugate gradient
            if mod(iter,size(x,1)) == 1 % reset direction
                s(:,iter) = -gradx(:,iter);
            end
            [x(:,iter+1),lambda(:,iter),beta(iter),s(:,iter+1),FLAG]= conj_grad(Z_train,...
                x(:,iter),y_train,loss_train(iter),gradx(:,iter),s(:,iter),n_sam_rec,w,loss_name);
            
            % Check continue training
            if ~FLAG 
                break;
            end
            
            % Update model parameters
            a1 = x(1:w,iter+1);
            a2 = x(w+1:2*w,iter+1);
            a3 = x(2*w+1,iter+1);
            a4 = x(2*w+2,iter+1);
            b1 = x(2*w+3,iter+1);
            b2 = x(2*w+4,iter+1);
            b3 = x(2*w+5,iter+1);
            b4 = x(2*w+6,iter+1);
        end
        
%% ========================== EVALUATION AND VISUALIZATION =========================== %%
% ---------------------------------- Thresholding ------------------------------------ %
        % Allocate memories of thresholded output
        ybar_test = zeros(1,n_test);
        ybar_test_bf = zeros(1,n_test);
        ybar_train = zeros(1,N);
        ybar_train_bf = zeros(1,N);
        candbar_train = zeros(1,N);
        candbar_test = zeros(1,n_test);
        
        % Before post procesisng
        ybar_train_bf(y_bf >=0.5) = 1;
        ybar_test_bf(z_test_nonan>=0.5) = 1;
        [met_tr_epo_bf,met_tr_eve_bf,met_tr_time_bf] = onoff_eval(y_train,ybar_train_bf,n_sam_rec,r);
        [met_te_epo_bf,met_te_eve_bf,met_te_time_bf] = onoff_eval(y_test,ybar_test_bf,n_test,r);
        
        % After post-processing
        ybar_test(yhat_test>=0.5) = 1;
        ybar_train(yhat>=0.5) = 1;
        [met_tr_epo,met_tr_eve,met_tr_time] = onoff_eval(y_train,ybar_train,n_sam_rec,r);
        [met_te_epo,met_te_eve,met_te_time] = onoff_eval(y_test,ybar_test,n_test,r);
        candbar_train(cand_train>=0.5) = 1;
        candbar_test(cand_test>=0.5) = 1;
        
% ----------------------------------- Visualization -------------------------------------- %
        
        visualization;
        
% ----------------------------------- Save results --------------------------------------- %
        
        save_results;
        
    end
end
