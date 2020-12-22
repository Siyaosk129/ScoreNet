function lat_revised = lat_process(gdr,lat)
% This function is for substituting 0 for NaN in latencies when GDR is 0.
% Args:
%     gdr: array of good detection rates
%     lat: array of mean latencies
% Returns:
%     lat_revised: array of revised mean latencies

nonan = ~isnan(gdr);
lat_revised = lat;
lat_revised(nonan & isnan(lat_revised)) = 0;
end