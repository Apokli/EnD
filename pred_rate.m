function pr = pred_rate(real, pred)
    pr = zeros(size(pred, 1), size(pred, 3));
    for i = 1 : size(pred, 1)
        for j = 1 : size(pred, 3)
            pr(i, j) = sum(pred(i, real == 1, j)) / sum(real);
        end
    end
end

