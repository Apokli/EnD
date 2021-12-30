function [] = plot_acc(acc, SNRs, name)    
    figure('Name', name);
    plot(SNRs, acc);
    xlabel("SNR");
    ylabel("Accuracy");
    title(name);
end

