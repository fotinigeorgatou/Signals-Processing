%% 3.1
% K = 1000;  
% n = -200:200;            
% N = length(n);
% 
% w_n = rand(1, K);
% w_n2 = rand(1, K);
% 
% mean_w=mean(w_n);
% w_n=w_n-mean_w;
% 
% [Rw,lags] = xcorr(w_n, 'coeff');
% figure;
% plot(lags,Rw); %sto lags=0 einai 1
% 
% % cross-corelation
% mean2=mean(w_n2);
% 
% w_n2=w_n2-mean2;
% 
% Rxy= xcorr(w_n,w_n2, 'coeff');

%% 3.2
% K = 10; 
% n = -200:200; 
% N = length(n);  
% load("/Users/despoinis/Library/CloudStorage/OneDrive-UniversityofPatras/3rd grade/Signal processing lab/exercise 4/Κώδικες & Αρχεία/chirp.mat");
% s=y(1:N);
% 
% 
% v = zeros(1, K);
% w = randn(1, K);
% 
% for n = 2:K
%    v(n) = a * v(n-1) + w(n);
% end
% %% Οπτικοποίηση 1: Ορισμένες πραγματοποιήσεις της διαδικασίας
% figure;
% plot( v);     % Παρουσίαση μόνο των πρώτων 10 πραγματοποιήσεων
% title(sprintf('10 από τις K = %d Πραγματοποιήσεις της Στοχαστικής Διαδικασίας v(n)', K));
% xlabel('Χρόνος n');
% ylabel('Τιμή x(n)');
% grid on;
% legend('Πραγματοποίηση 1', 'Πραγματοποίηση 2', 'Πραγματοποίηση 3', ...
%        'Πραγματοποίηση 4', 'Πραγματοποίηση 5', 'Πραγματοποίηση 6', ...
%        'Πραγματοποίηση 7', 'Πραγματοποίηση 8', 'Πραγματοποίηση 9', ...
%        'Πραγματοποίηση 10', 'Location', 'best');
% 
% figure;
% plot( w);     % Παρουσίαση μόνο των πρώτων 10 πραγματοποιήσεων
% title(sprintf('10 από τις K = %d Λευκού θορύβου', K));
% grid on;
% legend('Πραγματοποίηση 1', 'Πραγματοποίηση 2', 'Πραγματοποίηση 3', ...
%        'Πραγματοποίηση 4', 'Πραγματοποίηση 5', 'Πραγματοποίηση 6', ...
%        'Πραγματοποίηση 7', 'Πραγματοποίηση 8', 'Πραγματοποίηση 9', ...
%        'Πραγματοποίηση 10', 'Location', 'best');
% 
% figure;
% plot( s);     % Παρουσίαση μόνο των πρώτων 10 πραγματοποιήσεων
% title('chirp.mat');
% grid on;

%% 3.3

load("/Users/despoinis/Library/CloudStorage/OneDrive-UniversityofPatras/3rd grade/Signal processing lab/exercise 4/Κώδικες & Αρχεία/chirp.mat");

N = 7;          % Μήκος φίλτρου
alpha = 0.6;   % Παράμετρος AR(1) για χρωματισμό θορύβου
N_samples = 1000; % Αριθμός δειγμάτων


s = y(1:N_samples); 
w_n = randn(N_samples, 1); 

v = filter(1, [1 -alpha], w_n);

Rvv_full = xcorr(v,'biased');
rvw_full = xcorr(v,w_n,'biased');

mid = length(Rvv_full)/2 + 0.5;

Rvv = zeros(N,N);
rvw = zeros(N,1);

for i = 1:N
    for j = 1:N
        Rvv(i,j) = Rvv_full(mid + i - j);
    end
    rvw(i) = rvw_full(mid + i - 1);
end


h = Rvv \ rvw;

w_hat = filter(h',1,v);
figure;
plot(w_hat);
title('Wiener filter');
MSE = mean((w_n - w_hat).^2);



disp('Wiener coefficients:');
disp(h);
disp(['MSE = ', num2str(MSE)]);
