function [] = plot_pd(pd, SNRs, labels, name, x_label)    
    figure('Name', name);
    plot(SNRs, pd);
    xlabel(x_label);
    ylabel("Accuracy");
    legend(labels);
    title(name);
end

