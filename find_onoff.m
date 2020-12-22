function [idx_on,idx_off] = find_onoff(idx)
% This function is for finding first and last indices of seiuzre candidate
% groups.
% Args:
%     idx: array of indices indicating that seizure candidate are higher 
%     than 0.5 
% Returns:
%     idx_on: array of first indices of seizure candidate groups
%     idx_off: array of last indices of seizure candidate groups

if isempty(idx)
    idx_on = [];
    idx_off = [];
else
    diff_ind = diff(idx) > 1;
    idx_diff = find(diff_ind);
    idx_off = [idx(idx_diff) idx(end)];
    idx_on = [idx(1) idx(idx_diff+1)];
end
end