function [yhat,candidate,score,out_gate,idx_on,idx_off] = forward_compute(Z,model,n_sam_rec)
% This funciton is for forward calculation of the ScoreNet. This function
% also uses the function 'find_onoff' to find the first and last indices of
% each seizure candidate group.
% Args:
%     Z: restructured matrix of inputs
%     model: structure variable of model parameters containing
%     a1,a2,a3,a4,b1,b2,b3,b4
%     n_sam_rec: array of record lengths
% We use the lengths of the records (n_sam_rec) to split Z corresponding to
% each EEG record since Z contains stacked predictions of epoch-based 
% prediction of many records. If a single EEG record is used for the 
% computation, n_sam_rec is the record length.
% Returns:
%     yhat: array of model final outputs in equation (7)
%     candidate: array of seizure candidates in equation (4)
%     score: array of scores in equation (5)
%     out_gate: array of output gates of seizure candidate groups in
%     equation (6)
%     idx_on: array of first indices of seizure candidate groups
%     idx_off: array of last indices of seizure candidate groups

% Extract model parameters
a1 = model.a1; a2 = model.a2; a3 = model.a3; a4 = model.a4;
b1 = model.b1; b2 = model.b2; b3 = model.b3; b4 = model.b4;

% Calculate seizure candidate
candidate = sigmoid(a1'*Z+b1);

% Calculate score
score = tanh(a2'*Z+b2); 

% Grouping
idx_on = [];
idx_off = [];
idx_start = 0;
for i = 1:length(n_sam_rec) % Iterate through each record
    
    % Find onset and offset of each seizure candidate group
    [idx_sei_on,idx_sei_off] = find_onoff(find(candidate(idx_start+1:idx_start+n_sam_rec(i))>=0.5)); % Seizure Group
    [idx_nor_on,idx_nor_off] = find_onoff(find(candidate(idx_start+1:idx_start+n_sam_rec(i))<0.5)); % Normal group
    idx_on = [idx_on idx_start+[idx_sei_on idx_nor_on]];
    idx_off = [idx_off idx_start+[idx_sei_off idx_nor_off]];
    idx_start = idx_start+n_sam_rec(i);
end
idx_on = sort(idx_on);
idx_off = sort(idx_off);
out_gate = zeros(1,length(idx_on));
for i=1:length(idx_on) % Iterate through each group
    
    % Calculate output gate of each seizure candidate group
    out_gate(i) = sigmoid(a3*sum(score(idx_on(i):idx_off(i)))/(idx_off(i)-idx_on(i)+1)+b3);% Output gate of each group
    
    % Calculate final output
    yhat(idx_on(i):idx_off(i)) = sigmoid(a4*candidate(idx_on(i):idx_off(i))*out_gate(i)+b4); % Compute yhat
end
end