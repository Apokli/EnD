load("Data.mat");

ens = A .* A * (s.' * s);       % energy of signals
ens_n = s.' * s;                % energy without A
std_n = sqrt(sigmaw2 * ens_n);  % standard deviation (without A)

%% task 1 : known A and s
Pfa = [1e-1, 1e-2, 1e-3, 1e-4, 1e-5];                   % 5 Pfa scenarios
pred1 = zeros(length(Pfa), size(x, 1), size(A, 2));     % predictions under every case (5 * 10000 * 30)
threshs = norminv(1 - Pfa, 0, 1) * std_n;                  % threshold does not depend on A

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
plot_pd(pd, SNRs, labels, "Actual Pd when known A and s", "SNR");

% theoretical prediction rate

pd_theory = zeros(size(pd));                            % probability of prediction (5 * 30)
for i = 1 : size(pd_theory, 1)
    for j = 1 : size(pd_theory, 2)
        pd_theory(i, j) = 1 - normcdf(norminv(1 - Pfa(i), 0, 1) - sqrt(ens(j) / sigmaw2), 0, 1);    % using energy with A
    end
end
plot_pd(pd_theory, SNRs, labels, "Theoretical Pd when known A and s", "SNR")

%% task 3 : unknown A and known s
% generate new datas with new As.
A2 = -2.8 : 0.2 : 3;          % assume A can also be negative
ens2 = A2 .* A2 * (s.' * s);       % energy of signals
x2 = zeros(size(x));        % generate new datas
for i = 1 : length(A2)
    for j = 1 : length(s)
        for k = 1 : length(mask)
            x2(k, j, i) = x(k, j, i) + mask(k) * (A2(i) - A(i)) * s(j);
        end
    end
end

% first try the original predictor

% Prediction
pred2_1 = zeros(size(pred1));
for i = 1 : length(Pfa)
    for j = 1 : size(A2, 2)
        detector = squeeze(x2(:, :, j)) * s;
        pred2_1(i, :, j) = double(detector > threshs(i));
    end
end

% Calculate Pds
pd2_1 = zeros(size(pd));             % probability of prediction (5 * 30)
for i = 1 : size(pd2_1, 1)
    for j = 1 : size(pd2_1, 2)
        pd2_1(i, j) = sum(pred2_1(i, mask == 1, j)) / sum(mask);     % predicted positives / real positives
    end
end
plot_pd(pd2_1, A2, labels, "Actual Pd using original detector when A is unknown", "A");    % plotted against A (not SNR)

pd_theory2_1 = zeros(size(pd));                            % probability of prediction (5 * 30)
for i = 1 : size(pd_theory2_1, 1)
    for j = 1 : size(pd_theory2_1, 2)
        if A2(j) > 0
            pd_theory2_1(i, j) = 1 - normcdf(norminv(1 - Pfa(i), 0, 1) - sqrt(ens2(j) / sigmaw2), 0, 1);    % different cases based on the sign of A
        else
            pd_theory2_1(i, j) = 1 - normcdf(norminv(1 - Pfa(i), 0, 1) + sqrt(ens2(j) / sigmaw2), 0, 1);
        end
    end
end
plot_pd(pd_theory2_1, A2, labels, "Theoretical Pd using original detector when A is unknown", "A")

% then try the absolute value detector
pred2_2 = zeros(size(pred1));
threshs2 = norminv(1 - Pfa / 2, 0, 1) * std_n;

% Prediction
for i = 1 : length(Pfa)
    for j = 1 : size(A2, 2)
        detector = abs(squeeze(x2(:, :, j)) * s);             % Using the absolute value
        pred2_2(i, :, j) = double(detector > threshs2(i)); 
    end
end

% Calculate Pds
pd2_2 = zeros(size(pd));             
for i = 1 : size(pd2_2, 1)
    for j = 1 : size(pd2_2, 2)
        pd2_2(i, j) = sum(pred2_2(i, mask == 1, j)) / sum(mask);
    end
end
plot_pd(pd2_2, A2, labels, "Actual Pd using the absolute value detector when A is unknown", "A");    % plotted against A (not SNR)

pd_theory2_2 = zeros(size(pd));                            % probability of prediction (5 * 30)
for i = 1 : size(pd_theory2_2, 1)
    for j = 1 : size(pd_theory2_2, 2)
        pd_theory2_2(i, j) = (1 - normcdf(norminv(1 - Pfa(i) / 2, 0, 1) - sqrt(ens2(j) / sigmaw2), 0, 1))+ ...
                             (1 - normcdf(norminv(1 - Pfa(i) / 2, 0, 1) + sqrt(ens2(j) / sigmaw2), 0, 1));
    end
end
plot_pd(pd_theory2_2, A2, labels, "Theoretical Pd using absolute value detector when A is unknown", "A")

