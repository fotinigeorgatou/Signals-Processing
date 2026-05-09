K = 1000;                % 1000 διαφορετικές πραγματοποιήσεις

n = -200:200;            
N = length(n);           

% Δημιουργία στοχαστικής διαδικασίας
A = randn(K, 1);         

deterministic_portion = (exp(-n/50) .* (n >= 0));
x = A .* deterministic_portion;  % Διαστάσεις: K × 401
%% Μέση υλοποίηση της στοχαστικής διαδικασίας
mean_x=mean(x);

figure;
plot(n, mean_x);
grid on;
xlabel('n');
ylabel('m_x(n)');
title('Μέση υλοποίηση της στοχαστικής διαδικασίας');

%% LLN
M = 1000;      
n0 = 30;         

x_n0 = A .* exp(-n0/50);

% Running ensemble average (LLN)
running_mean = cumsum(x_n0) ./ (1:M)';

% Plot
figure;
plot(running_mean);
title('Running time average of ensemble mean');

%% πυκνότητας του φάσματος ισχύος 

w= linspace(-pi,pi,2048);
a = exp(-1/50);

% Power Spectral Density
Ph_xx = 1 ./ abs(1 - a*exp(-1j*w)).^2;

figure;
semilogy(w, Ph_xx);
ylabel('\Phi_{xx}(e^{j\omega})');
title('Power Spectral Density of x(n)');
grid on;

%% διαδικασία υπολογισμού / δοκιμής της εργοδικότητας 1ης τάξης 

figure;
plot(running_mean,'LineWidth',1.5);
grid on;
xlabel('n');
ylabel('Time average');
title('Time Average of One Realization');
yline(0,'r--','Ensemble mean');