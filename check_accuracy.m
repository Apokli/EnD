function acc = check_accuracy(real, pred)
    acc = zeros(size(pred, 1), size(pred, 3));
    for i = 1 : size(pred, 1)
        for j = 1 : size(pred, 3)
            acc(i, j) = sum(double(pred(i, :, j).' == real)) / length(real);
        end
    end
end

