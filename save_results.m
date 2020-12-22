% This script is to save all results (predictions and metrics) in mat file,
% and evalutation metrics are saved in the csv file. Note that 'bf', 'tr', 
% and 'te' stand for 'before post process', 'train', and 'test', 
% respectively. 

% --------------------------- To mat file ----------------------
result.x = x(:,1:iter); result.gradx = gradx(:,1:iter); result.lambda = lambda(1:iter);
result.cand_train = cand_train;result.score_train = score_train; result.out_gate_train = out_gate_train;
result.cand_test = cand_test; result.score_test = score_test; result.out_gate_test = out_gate_test;
result.loss_train = loss_train(1:iter); result.loss_test = loss_test(1:iter);
result.Z_train = Z_train; result.Z_test = Z_test;
result.yhat_train = yhat; result.yhat_test = yhat_test;
resutl.y_train = y_train;result.y_test = y_test;
result.idx_on_train = idx_on_train;result.idx_off_train = idx_off_train;
result.idx_on_test = idx_on_test;result.idx_off_test = idx_off_test;
result.n_sam_rec = n_sam_rec;

result.met_tr_epo = met_tr_epo; result.met_te_epo = met_te_epo;
result.met_tr_eve = met_tr_eve; result.met_te_eve = met_te_eve;
result.met_tr_time = met_tr_time; result.met_te_time = met_te_time;

result.met_tr_epo_bf = met_tr_epo_bf; result.met_te_epo_bf = met_te_epo_bf;
result.met_tr_eve_bf = met_tr_eve_bf; result.met_te_eve_bf = met_te_eve_bf;
result.met_tr_time_bf = met_tr_time_bf; result.met_te_time_bf = met_te_time_bf;
save([result_dir 'result-onoff-' file{1}(12:end-4) '_' loss_name '.mat'],'-struct','result');

% ---------------------- To csv file -----------------------
% After Post processing
acc_train = met_tr_epo.acc; acc_test = met_te_epo.acc;
f1_train = met_tr_epo.f1; f1_test = met_te_epo.f1;
sen_train = met_tr_epo.sen; sen_test = met_te_epo.sen;
spe_train = met_tr_epo.spe; spe_test = met_te_epo.spe;
tn_train = sum(met_tr_epo.conf_mat(:,1),'omitnan'); tn_test = met_te_epo.conf_mat(1);
fn_train = sum(met_tr_epo.conf_mat(:,2),'omitnan'); fn_test = met_te_epo.conf_mat(2);
fp_train = sum(met_tr_epo.conf_mat(:,3),'omitnan'); fp_test = met_te_epo.conf_mat(3);
tp_train = sum(met_tr_epo.conf_mat(:,4),'omitnan'); tp_test = met_te_epo.conf_mat(4);

gdr_train = mean(met_tr_eve.gdr,'omitnan'); gdr_test = met_te_eve.gdr;
fpr_train = mean(met_tr_eve.fpr,'omitnan'); fpr_test = met_te_eve.fpr;
fph_train = mean(met_tr_eve.fph,'omitnan'); fph_test = met_te_eve.fph;

onlat_train = mean(met_tr_time.avg_onlat,'omitnan'); onlat_test = mean(met_te_time.avg_onlat,'omitnan');
ab_onlat_train = mean(met_tr_time.avg_abs_onlat,'omitnan'); ab_onlat_test = mean(met_te_time.avg_abs_onlat,'omitnan');
eff_onlat_train = mean(met_tr_time.avg_eff_onlat,'omitnan'); eff_onlat_test = mean(met_te_time.avg_eff_onlat,'omitnan');
offlat_train = mean(met_tr_time.avg_offlat,'omitnan'); offlat_test = mean(met_te_time.avg_offlat,'omitnan');
ab_offlat_train = mean(met_tr_time.avg_abs_offlat,'omitnan');ab_offlat_test = mean(met_te_time.avg_abs_offlat,'omitnan');
eff_offlat_train = mean(met_tr_time.avg_eff_offlat,'omitnan'); eff_offlat_test = mean(met_te_time.avg_eff_offlat,'omitnan');

% Before post processing
acc_train_bf = met_tr_epo_bf.acc; acc_test_bf = met_te_epo_bf.acc;
f1_train_bf = met_tr_epo_bf.f1; f1_test_bf = met_te_epo_bf.f1;
sen_train_bf = met_tr_epo_bf.sen; sen_test_bf = met_te_epo_bf.sen;
spe_train_bf = met_tr_epo_bf.spe; spe_test_bf = met_te_epo_bf.spe;
tn_train_bf = sum(met_tr_epo_bf.conf_mat(:,1),'omitnan'); tn_test_bf = met_te_epo_bf.conf_mat(1);
fn_train_bf = sum(met_tr_epo_bf.conf_mat(:,2),'omitnan'); fn_test_bf = met_te_epo_bf.conf_mat(2);
fp_train_bf = sum(met_tr_epo_bf.conf_mat(:,3),'omitnan'); fp_test_bf = met_te_epo_bf.conf_mat(3);
tp_train_bf = sum(met_tr_epo_bf.conf_mat(:,4),'omitnan'); tp_test_bf = met_te_epo_bf.conf_mat(4);

gdr_train_bf = mean(met_tr_eve_bf.gdr,'omitnan'); gdr_test_bf = met_te_eve_bf.gdr;
fpr_train_bf = mean(met_tr_eve_bf.fpr,'omitnan'); fpr_test_bf = met_te_eve_bf.fpr;
fph_train_bf = mean(met_tr_eve_bf.fph,'omitnan'); fph_test_bf = met_te_eve_bf.fph;

onlat_train_bf = mean(met_tr_time_bf.avg_onlat,'omitnan'); onlat_test_bf = mean(met_te_time_bf.avg_onlat,'omitnan');
ab_onlat_train_bf = mean(met_tr_time_bf.avg_abs_onlat,'omitnan'); ab_onlat_test_bf = mean(met_te_time_bf.avg_abs_onlat,'omitnan');
eff_onlat_train_bf = mean(met_tr_time_bf.avg_eff_onlat,'omitnan'); eff_onlat_test_bf = mean(met_te_time_bf.avg_eff_onlat,'omitnan');
offlat_train_bf = mean(met_tr_time_bf.avg_offlat,'omitnan'); offlat_test_bf = mean(met_te_time_bf.avg_offlat,'omitnan');
ab_offlat_train_bf = mean(met_tr_time_bf.avg_abs_offlat,'omitnan');ab_offlat_test_bf = mean(met_te_time_bf.avg_abs_offlat,'omitnan');
eff_offlat_train_bf = mean(met_tr_time_bf.avg_eff_offlat,'omitnan'); eff_offlat_test_bf = mean(met_te_time_bf.avg_eff_offlat,'omitnan');

type = {'tr_before';'tr_after';'te_before';'te_after'};
varnames = {'Type';'tn';'fn';'fp';'tp';'acc';'sen';'spe';'f1';'gdr';'fpr';...
    'fph';'onlat';'ab_onlat';'eff_onlat';'offlat';'ab_offlat';'eff_offlat'};
T = table(type,...
            [tn_train_bf;tn_train;tn_test_bf;tn_test],...
            [fn_train_bf;fn_train;fn_test_bf;fn_test],...
            [fp_train_bf;fp_train;fp_test_bf;fp_test],...
            [tp_train_bf;tp_train;tp_test_bf;tp_test],...
            [acc_train_bf;acc_train;acc_test_bf;acc_test],...
            [sen_train_bf;sen_train;sen_test_bf;sen_test],...
            [spe_train_bf;spe_train;spe_test_bf;spe_test],...
            [f1_train_bf;f1_train;f1_test_bf;f1_test],...
            [gdr_train_bf;gdr_train;gdr_test_bf;gdr_test],...
            [fpr_train_bf;fpr_train;fpr_test_bf;fpr_test],...
            [fph_train_bf;fph_train;fph_test_bf;fph_test],...
            [onlat_train_bf;onlat_train;onlat_test_bf;onlat_test],...
            [ab_onlat_train_bf;ab_onlat_train;ab_onlat_test_bf;ab_onlat_test],...
            [eff_onlat_train_bf;eff_onlat_train;eff_onlat_test_bf;eff_onlat_test],...
            [offlat_train_bf;offlat_train;offlat_test_bf;offlat_test],...
            [ab_offlat_train_bf;ab_offlat_train;ab_offlat_test_bf;ab_offlat_test],...
            [eff_offlat_train_bf;eff_offlat_train;eff_offlat_test_bf;eff_offlat_test],...
            'VariableNames',varnames);
writetable(T,[result_dir 'result-onoff-' file{1}(12:end-4) '_' loss_name '.csv']);