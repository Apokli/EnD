load("Data.mat");

ens = A .* A * (s.' * s);   % energy of signals

%% task 1 : known A and s
lambda = 1;
Pfa = [1e-1, 1e-2, 1e-3, 1e-4, 1e-5];
pred1 = zeros(length(Pfa), size(x, 1), size(A, 2));

for i = 1 : length(Pfa)
    for j = 1 : size(A, 2)
        detector = A(j) * squeeze(x(:, :, j)) * s;
    %     thresh = sigmaw2 * log(lambda) + 0.5 * A(i) ^ 2 * s.' * s;
        thresh = -norminv(Pfa(i), 0, 1) * sqrt(sigmaw2 * ens(j));
        pred1(i, :, j) = double(detector > thresh);
    end
end

%% task 2 : plot Pd versus SNR
SNRs = 10 * log10(ens / sigmaw2);
pd = pred_rate(mask, pred1);
labels = ["Pfa = 1e-1", "Pfa = 1e-2", "Pfa = 1e-3", "Pfa = 1e-4", "Pfa = 1e-5"];
plot_pd(pd, SNRs, labels, "actual Pd when known A and s");

%% task 3 : unknown A and known s