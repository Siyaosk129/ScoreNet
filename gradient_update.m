function dx = gradient_update(Z_train,dyhat,yhat,out_gate_train,cand_train,score_train,idx_on_train,idx_off_train,model)
% This function is for calculating the gradients w.r.t. each parameters.
% Args:
%     Z_train: restructured matrix of training inputs
%     dyhat: array of gradients of loss w.r.t. yhat
%     yhat: array of model final outputs in equation (7) from training data
%     cand_train: array of seizure candidates in equation (4) from training
%     data
%     score_train: array of scores in equation (5) from training data
%     out_gate_train: array of output gates of seizure candidate groups in
%     equation (6) from training data
%     idx_on_train: array of first indices of seizure candidate groups from
%     training data
%     idx_off_train: array of last indices of seizure candidate groups from
%     training data
%     model: structure variable of model parameters containing
%     a1,a2,a3,a4,b1,b2,b3,b4
%     n_sam_rec: array of record lengths
% Returns:
%     dx: gradients of loss function w.r.t. model parameters

% Exctract model parameters
a4 = model.a4; a3 = model.a3; w = model.w;
da1 = zeros(w,1); da2 = zeros(w,1); da3 = 0; da4 = 0;
db1 = 0; db2 = 0; db3 = 0; db4 = 0;

% Pre-calculate d Loss
yprime = yhat.*(1-yhat);

% d score/d b2
sprime = 1-score_train.^2; 

% d candidate/d b3
cprime = cand_train.*(1-cand_train); 
for i=1:length(idx_on_train) %iterate through each candidate group
    gr_on = idx_on_train(i);
    gr_off = idx_off_train(i);
    % Calculate d Loss/db4
    db4 = db4+dyhat(gr_on:gr_off)*yprime(gr_on:gr_off)'; 
    
    da4_demo = out_gate_train(i)*dyhat(gr_on:gr_off)*(cand_train(gr_on:gr_off).*yprime(gr_on:gr_off))'; % Repetitive term to be substituted
    
    % Calculate d Loss/da4
    da4 = da4+da4_demo; 
    db3_demo = a4*(1-out_gate_train(i))*da4_demo;
    
    % Calculate d Loss/db3
    db3 = db3 + db3_demo; % Repetitive term to be substituted
    
    % Calculate d Loss/da3
    da3 = da3+db3_demo*sum(score_train(gr_on:gr_off))/(gr_off-gr_on+1); 
    
    % Calculate d Loss/d b2
    db2 = db2+a3*db3_demo*sum(sprime(gr_on:gr_off))/(gr_off-gr_on+1); 
    
    % Calculate d Loss/d a2
    da2 = da2+a3*db3_demo*Z_train(:,gr_on:gr_off)*sprime(gr_on:gr_off)'/(gr_off-gr_on+1); 
    
    % Calculate d Loss/d b1
    db1 = db1+a4*out_gate_train(i)*dyhat(gr_on:gr_off)*(yprime(gr_on:gr_off).*cprime(gr_on:gr_off))'; 
    
    % Calculate d Loss/d a1
    da1 = da1+a4*out_gate_train(i)*Z_train(:,gr_on:gr_off)*(dyhat(gr_on:gr_off).*yprime(gr_on:gr_off).*cprime(gr_on:gr_off))'; 
end

% Gather gradient of each model parameter for further optimization
dx = [da1;da2;da3;da4;db1;db2;db3;db4];
end