function save_fig_pdf_eps(fig_name)
savepdf([fig_name '.pdf']);
savefig([fig_name '.fig']);
saveas(gcf,fig_name,'epsc');
end