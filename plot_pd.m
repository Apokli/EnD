function [] = plot_pd(pd, SNRs, labels, name, x_label, legend_place)    
    figure('Name', name);
    plot(SNRs, pd);
    xlabel(x_label);
    ylabel("Probability of Detection");
    legend(labels, 'Location', legend_place);
    title(name);
    saveas(gcf,name,'png');
end

