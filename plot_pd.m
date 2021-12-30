function [] = plot_pd(pd, SNRs, labels, name)    
    figure('Name', name);
    plot(SNRs, pd);
    xlabel("SNR");
    ylabel("Accuracy");
    legend(labels);
    title(name);
end

