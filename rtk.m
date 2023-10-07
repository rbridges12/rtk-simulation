%% run single simulation
n = 1000;
sigma_i = 0.5;
d = 2;

p_l = normrnd(0, sigma_i, 2, n);
p_r = normrnd(0, sigma_i, 2, n) + [d; 0];

v = p_r - p_l;
v = v ./ vecnorm(v);
signs = sign(v(2,:));
theta = acos(v(1,:)) * 180 / pi .* signs;
u_theta = mean(theta)
sigma_theta = std(theta)

%% plot single simulation
figure
subplot(2,1,1)
hold on
th = 0:pi/50:2*pi;
xunit = sigma_i * cos(th);
yunit = sigma_i * sin(th);
scatter(p_l(1,:), p_l(2,:))
scatter(p_r(1,:), p_r(2,:))
plot([0, d], [0, 0], '.-', xunit, yunit, xunit + d, yunit, 'LineWidth', 3')
legend('left samples', 'right samples')

subplot(2,1,2)
hold on
histogram(theta, 50, 'Normalization', 'pdf')
xs = linspace(-120, 120, 100);
plot(xs, normpdf(xs, u_theta, sigma_theta), 'LineWidth', 3')
legend('histogram', 'gaussian fit')
xlabel('$\theta$ (degrees)', 'Interpreter', 'latex')
ylabel('probability density', 'Interpreter', 'latex')

%% run multiple simulations
n = 1000;
sigma_is = [0.005, 0.01, 0.05, 0.1];
ds = 0.5:0.1:1.5;
sigma_thetas = zeros(length(sigma_is), length(ds));
for i = 1:length(sigma_is)
    sigma_i = sigma_is(i);
    for j = 1:length(ds)
        d = ds(j);
        [u_theta, sigma_theta] = simulate(sigma_i, d, n);
        sigma_thetas(i,j) = sigma_theta;
    end
end

%% plot multiple simulations
figure
hold on
for i = 1:length(sigma_is)
    plot(ds, sigma_thetas(i,:), 'LineWidth', 3')
end
legend('$\sigma_i = 0.5$cm', '$\sigma_i = 1$cm', '$\sigma_i = 5$cm', '$\sigma_i = 10$cm', 'Interpreter', 'latex')
title('Standard Deviation of Heading Error vs. Baseline Distance and Position Error', 'Interpreter', 'latex')
xlabel('baseline distance $d$ (m)', 'Interpreter', 'latex')
ylabel('$\sigma_\theta$ (degrees)', 'Interpreter', 'latex')
grid on

function [u_theta, sigma_theta] = simulate(sigma_i, d, n)
    p_l = normrnd(0, sigma_i, 2, n);
    p_r = normrnd(0, sigma_i, 2, n) + [d; 0];

    v = p_r - p_l;
    v = v ./ vecnorm(v);
    signs = sign(v(2,:));
    theta = acos(v(1,:)) * 180 / pi .* signs;
    u_theta = mean(theta);
    sigma_theta = std(theta);
end