function plot_scatter2(gdr_collection,latency_on,latency_off,EL_on,EL_off,size,style)
% This funciton is a scatter plot of EL-index, GDR, and mean absolute 
% latency.
% Args:
%     gdr_collection: structure variable of GDR from all detection cases
%     latency_on: array of mean absolute latencies of seizure onsets 
%     detection from all cases
%     latency_on: array of mean absolute latencies of seizure offset
%     detection from all cases
%     EL_on: array of EL-indices of seizure onset detection from all cases
%     EL_off: array of EL-indices of seizure offset detection from all
%     cases
%     size: mutiplication of marker in log-scale
%     style: style of the marker
% 
% Required function: lat_process and data_scatter

% Collect GDR
gdr_ent = gdr_collection.metric_ent; gdr_soft = gdr_collection.metric_soft;
gdr_sq = gdr_collection.metric_sq; gdr_log = gdr_collection.metric_log;
gdr = [gdr_ent;gdr_soft;gdr_sq;gdr_log];
unique_gdr = unique(gdr);
unique_gdr = unique_gdr(~isnan(unique_gdr));

% Collect mean absolute latencies
onlat_ent = lat_process(gdr_ent,latency_on.metric_ent);
onlat_soft = lat_process(gdr_soft,latency_on.metric_soft);
onlat_sq = lat_process(gdr_sq,latency_on.metric_sq);
onlat_log = lat_process(gdr_log,latency_on.metric_log);
onlat = [onlat_ent;onlat_soft;onlat_sq;onlat_log];

offlat_ent = lat_process(gdr_ent,latency_off.metric_ent);
offlat_soft = lat_process(gdr_soft,latency_off.metric_soft);
offlat_sq = lat_process(gdr_sq,latency_off.metric_sq);
offlat_log = lat_process(gdr_log,latency_off.metric_log);
offlat = [offlat_ent;offlat_soft;offlat_sq;offlat_log];
latency = [onlat;offlat];

% Collect EL-indices
el_onlat = [EL_on.metric_ent;EL_on.metric_soft;EL_on.metric_sq;EL_on.metric_log];

el_offlat = [EL_off.metric_ent;EL_off.metric_soft;EL_off.metric_sq;EL_off.metric_log];

el_index = [el_onlat;el_offlat];

gdr = [gdr;gdr];
Color = [0.902 0.569 0.220;0.918 0.263 0.209; 0.761 0.482 0.627;...
    0.455 0.106 0.278; 0.259 0.522 0.957; 0.043 0.325 0.580;...
    0.576 0.769 0.490; 0.220 0.463 0.114; 1 0 1];

for ii=length(unique_gdr):-1:1 % Loop through GDR cases
    focused_gdr = unique_gdr(ii);
    idx_focused_gdr = find(gdr == focused_gdr);
    [x,y,sz] = data_scatter(latency(idx_focused_gdr),el_index(idx_focused_gdr));
    ss(ii) = scatter(x,y,(log(sz)+1)*size,style,'MarkerFaceColor',Color(ii,:),...
        'MarkerEdgeColor',Color(ii,:));
    ss(ii).DisplayName = [num2str(round(focused_gdr)) '% GDR'];
    hold on;
end

for jj=length(unique_gdr):-1:1 % Plot exponential bounds
    focused_gdr = unique_gdr(jj);
    x_line = 0:0.5:max(latency);
    plot(x_line,focused_gdr/100*(0.9.^x_line),'--','Color',Color(jj,:));
    
end
legend(ss);
end