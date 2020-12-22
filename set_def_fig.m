function set_def_fig
ax = gca;
pos = get(gca, 'Position');
% pos(1) = 0.08;
pos(1) = 0.095;
% pos(2) = 0.1;
pos(2) = 0.08;
% pos(3) = 0.89;
pos(3) = 0.90;
% pos(4) = 0.85;
pos(4) = 0.87;
set(gca, 'Position', pos)
% ax.FontSize = 21;
ax.FontSize = 30;