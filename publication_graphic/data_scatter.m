function [x,y,sz] = data_scatter(X,Y)
% This funciton is preparing data for the scatter plot in the manuscript.
% Args:
%     X: array of x-axis data
%     Y: array of y-axis data
% Returns:
%     x: array of x coordinates
%     y: array of y coordinates
%     sz: array of point sizes
x = [];
y = [];
sz = [];
n = size(X,1);
for ii =1:n
    if ~isnan(X(ii)) && ~isnan(Y(ii))
        if ismember(X(ii),x) && ismember(Y(ii),y)
            idx_x = find(x==X(ii));
            idx_y = find(y==Y(ii));
            row = intersect(idx_x,idx_y);
            if length(row) >1
                disp('Error. Duplicate index');
            else
                sz(row) = sz(row)+1;
            end
        else
            x = [x;X(ii)];
            y = [y;Y(ii)];
            sz = [sz;1];
        end
    elseif (~isnan(X(ii)) && isnan(Y(ii))) || (isnan(X(ii)) && ~isnan(Y(ii)))
        disp('Error. Please check size incompatibility');
    end
end
end