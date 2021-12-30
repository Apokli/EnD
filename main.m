load("Data.mat");

ens = A .* A * (s.' * s);   % energy of signals

%% task 1 : known A and s
Pfa = [1e-1, 1e-2, 1e-3, 1e-4, 1e-5];                   % 5 Pfa scenarios
pred1 = zeros(length(Pfa), size(x, 1), size(A, 2));     % predictions under every case (5 * 10000 * 30)

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
labels = ["Pfa = 1e-1", "Pfa = 1e-2", "Pfa = 1e-3", "Pfa = 1e-4", "Pfa = 1e-5"];

% actual prediction rate
pd = zeros(size(pred1, 1), size(pred1, 3));
for i = 1 : size(pd, 1)
    for j = 1 : size(pd, 2)
        pd(i, j) = sum(pred1(i, mask == 1, j)) / sum(mask);
    end
end
plot_pd(pd, SNRs, labels, "actual Pd when known A and s");

% theoretical prediction rate

pd_theory = zeros(size(pd));
for i = 1 : size(pd_theory, 1)
    for j = 1 : size(pd_theory, 2)
        tmp = -norminv(Pfa(i), 0, 1) - sqrt(ens(j) / sigmaw2);
        tmp2 = normcdf(-norminv(Pfa(i), 0, 1) - sqrt(ens(j) / sigmaw2), 0, 1);
        pd_theory(i, j) = 1 - normcdf(-norminv(Pfa(i), 0, 1) - sqrt(ens(j) / sigmaw2), 0, 1);
    end
end
plot_pd(pd_theory, SNRs, labels, "theoretical Pd when known A and s")

%% task 3 : unknown A and known s