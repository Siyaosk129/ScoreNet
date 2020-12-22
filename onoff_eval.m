function [epoch_metrics,event_metrics,time_metrics] = onoff_eval(label,predict,siglen,r)
% This funciton is for evaluation of the seizure onset and offset detection.
% This function also uses the function 'find_onoff' to find the first and 
% last indices of each seizure candidate group.
% Args:
%     label: array of label (y) containing 0 and 1
%     predict: array of decision making containing 0 and 1
%     siglen: array of signal lengths.
%     r: decay rate of EL-index
% Returns:
%     epoch_metrics: structure variable of epoch-based metrics
%     event_metrics: structure variable of event-based metrics
%     time_metrics: structure variable of time-based metrics

% Pre-allocate memories
sig_start= 1; sig_end = 0;
n_sig = length(siglen);

% Confusion matrix
conf_mat = zeros(length(siglen),4); 
gdr = NaN(n_sig,1); fpr = zeros(n_sig,1);

% Onset and offset latencies of each record assumed to be less 20 latencies
on_lat = NaN(length(siglen),20); 
off_lat = NaN(length(siglen),20);
avg_onlat = NaN(length(siglen),1);
avg_offlat = NaN(length(siglen),1);
avg_abs_onlat = NaN(length(siglen),1);
avg_abs_offlat = NaN(length(siglen),1);
avg_eff_onlat = NaN(length(siglen),1);
avg_eff_offlat = NaN(length(siglen),1);

for i=1:length(siglen) % Iterate through signals
    sig_end = sig_end+siglen(i);
    [idx_on_lab,idx_off_lab] = find_onoff(find(label(sig_start:sig_end)==1));
    [idx_on_pred,idx_off_pred] = find_onoff(find(predict(sig_start:sig_end)==1));
    n_sei = length(idx_on_lab);
    n_pred = length(idx_on_pred);
    
    % Check overlap of actual and detected seizure
    pred_conf =zeros(1,n_pred); 
    
    % Check overlap of actual and detected seizure
    lab_conf = zeros(1,n_sei); 
    
    % Epoch-based metrics
    conf_mat_sq = confusionmat(label(sig_start:sig_end),predict(sig_start:sig_end)); % epoch-based confusion matrix
    if size(conf_mat_sq,1) == 2
        conf_mat(i,:) = conf_mat_sq(:)';
    else
        conf_mat(i,1) = conf_mat_sq;
    end

    % Calculate event and time-based metrics    
    for j=1:n_sei % Iterate through actual seizure activities
        if n_pred ~= 0
            sub_onlat = [];
            sub_offlat = [];
        for k=1:n_pred % Iteratre through detected seizure activities
            
            % Check overlap of actual and predicted seizure event
            if idx_on_lab(j) <= idx_off_pred(k) && idx_off_lab(j) >= idx_on_pred(k)
                
                % Collect onset and offset latencies
                sub_onlat = [sub_onlat idx_on_pred(k)-idx_on_lab(j)];
                sub_offlat = [sub_offlat idx_off_pred(k)-idx_off_lab(j)];
                
                % Check co-existence of detected and actual seizure
                pred_conf(k) = 1;
                lab_conf(j) = 1;
            end
        end
        % Select the first index for seizure onset and last index for
        % seizure offset
        if lab_conf(j) == 1 
            on_lat(i,j) = sub_onlat(1);
            off_lat(i,j) = sub_offlat(end);
        end
        end
    end
    
    % Summarize performance metrics
    if n_sei > 0
        gdr(i) = sum(lab_conf)/n_sei*100;
        avg_onlat(i) = mean(on_lat(i,:),'omitnan');
        avg_offlat(i) = mean(off_lat(i,:),'omitnan');
        avg_abs_onlat(i) = mean(abs(on_lat(i,:)),'omitnan');
        avg_abs_offlat(i) = mean(abs(off_lat(i,:)),'omitnan');
        avg_eff_onlat(i) = sum(r.^(abs(on_lat(i,:))),'omitnan')/n_sei;
        avg_eff_offlat(i) = sum(r.^(abs(off_lat(i,:))),'omitnan')/n_sei;
    end
    fpr(i) = n_pred-sum(pred_conf);
    sig_start= sig_end+1; % Evaluate next record
end
    % Collect epoch-based metrics
    epoch_metrics.conf_mat = conf_mat;
    epoch_metrics.sen = sum(conf_mat(:,4))/sum(sum(conf_mat(:,[2 4])))*100;
    epoch_metrics.spe = sum(conf_mat(:,1))/sum(sum(conf_mat(:,[1 3])))*100;
    epoch_metrics.acc = sum(sum(conf_mat(:,[1 4])))/sum(sum(conf_mat))*100;
    epoch_metrics.f1 = 2*sum(conf_mat(:,4))/sum(2*conf_mat(:,4)+conf_mat(:,3)+conf_mat(:,2))*100;
    
    % Collect event-based metrics
    event_metrics.gdr = gdr;
    event_metrics.fpr = fpr;
    event_metrics.fph = fpr./siglen'*3600;
    event_metrics.n_seizure = n_sei;
    
    % Collect time-based metrics
    time_metrics.onlat = on_lat;
    time_metrics.offlat = off_lat;
    time_metrics.avg_onlat = avg_onlat;
    time_metrics.avg_offlat = avg_offlat;
    time_metrics.avg_abs_onlat = avg_abs_onlat;
    time_metrics.avg_abs_offlat = avg_abs_offlat;
    time_metrics.avg_eff_onlat = avg_eff_onlat;
    time_metrics.avg_eff_offlat = avg_eff_offlat;
end