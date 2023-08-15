function [x1, y1, x2, y2, x, y, LE1, LE2, TE1, TE2, xl, yl, xt, yt] = meri_lines(Q, H, nr, N)
    [~, R2e, Bo, ~, Ymi, Rli, Roe, Li, Le, ~, ~, Yme, ~] = meridoinaldim(Q, H, nr, N);
Q=100
H =554
nr=0.5
N=80
    n = 50;
    x1 = nan(1, n);
    x2 = nan(1, n);
    y1 = nan(1, n);
    y2 = nan(1, n);
    p = Li / 4;
    q = p / n;
    b = 0;

    for i = 1:n
        x1(1, i) = b;
        y1(1, i) = Ymi * curve(x1, Li);
        b = b + q;
    end

    x1 = -x1;
    y1 = -y1;
    x_trans = Le + Bo;
    y_trans = Roe;
    for i = 1:n
        x1(1, i) = x1(1, i) + x_trans;
        y1(1, i) = y1(1, i) + y_trans;
    end

    figure(1)
    plot(y1, x1, 'g')
    hold on
    grid on

    p = Le;
    q = p / n;
    b = 0;
    for i = 1:n
        x2(1, i) = b;
        y2(1, i) = Yme * curve(x2, Le);
        b = b + q;
    end

    x2 = -x2;
    y2 = -y2;
    x_tran = Le;
    y_tran = Roe;
    for i = 1:n
        x2(1, i) = x2(1, i) + x_tran;
        y2(1, i) = y2(1, i) + y_tran;
    end

    plot(y2, x2, 'b')

    % Meridional view with streamline
    x = nan(N, n);
    y = nan(N, n);
    for i = 1:N
        x(i, :) = x1 + (x2 - x1) * i / (N + 1);
        y(i, :) = y1 + (y2 - y1) * i / (N + 1);
    end
    for i = 1:N
        plot(y(i, :), x(i, :), 'r')
    end
    title('Meridional plane');

    % Rest of your code...

    hold off
end

function y = curve(x, L)
    % Define your curve function here, e.g., y = x.^2 / L;
    y = x.^2 / L;
end
