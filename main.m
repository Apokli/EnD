load("Data.mat");

ens = A .* A * (s.' * s);       % energy of signals
ens_n = s.' * s;                % energy without A
std_n = sqrt(sigmaw2 * ens_n);  % standard deviation (without A)

%% task 1 : known A and s
Pfa = [1e-1, 1e-2, 1e-3, 1e-4, 1e-5];                   % 5 Pfa scenarios
pred1 = zeros(length(Pfa), size(x, 1), size(A, 2));     % predictions under every case (5 * 10000 * 30)
threshs = -norminv(Pfa, 0, 1) * std_n;                  % threshold does not depend on A

for i = 1 : length(Pfa)
    for j = 1 : size(A, 2)
        detector = squeeze(x(:, :, j)) * s;             % kick A out of detector
        pred1(i, :, j) = double(detector > threshs(i)); % predicts
    end
end

%% task 2 : plot Pd versus SNR
SNRs = 10 * log10(ens / sigmaw2);                       % calculate SNRs
labels = ["Pfa = 1e-1", "Pfa = 1e-2", "Pfa = 1e-3", "Pfa = 1e-4", "Pfa = 1e-5"];    % used afterwards in legends

% actual prediction rate
pd = zeros(size(pred1, 1), size(pred1, 3));             % probability of prediction (5 * 30)
for i = 1 : size(pd, 1)
    for j = 1 : size(pd, 2)
        pd(i, j) = sum(pred1(i, mask == 1, j)) / sum(mask);     % predicted positives / real positives
    end
end
plot_pd(pd, SNRs, labels, "actual Pd when known A and s");

% theoretical prediction rate

pd_theory = zeros(size(pd));                            % probability of prediction (5 * 30)
for i = 1 : size(pd_theory, 1)
    for j = 1 : size(pd_theory, 2)
        pd_theory(i, j) = 1 - normcdf(norminv(1 - Pfa(i), 0, 1) - sqrt(ens(j) / sigmaw2), 0, 1);
    end
end
plot_pd(pd_theory, SNRs, labels, "theoretical Pd when known A and s")

%% task 3 : unknown A and known s
% solution 1: assume A = 1
pred2_1 = zeros(length(Pfa), size(x, 1), size(A, 2));
