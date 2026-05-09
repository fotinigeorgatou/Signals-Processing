Ts = 1;
omega = linspace(0.001, pi/5, 1000);
N = 1024;

D_ideal = 1j * omega / Ts; 

H_symmetric = (1 - exp(-1j * 2 * omega)) / (2 * Ts);
h_symmetric = [-1/2  0  1/2];
H_backward = (1 - exp(-1j * omega)) / Ts;
h_backward = [1 -1];

n=(0:99);
x=cos(pi*n/5);
figure();
plot(x);
title('x=cos(pi*n/5)');

y_symmetric = filter(h_symmetric, 1, x);
figure;
plot(y_symmetric);
title('Y symmetric');
y_backward = filter(h_backward, 1, x);
figure;
plot(y_backward);
title('Y Backward');



figure();
plot(y_symmetric);
title('Y Symmetric');

figure();
plot(y_backward);
title('Y Backward');

% 1. Μέθοδος Ορθογωνίου (Left Riemann Sum)
b_rect = [0, Ts];    % [0, T_s]
a_rect = [1, -1];    % [1, -1]

 % 2. Μέθοδος Τραπεζίου (Trapezoidal Rule)
 b_trap = (Ts/2) * [1, 1];  % [T_s/2, T_s/2]
 a_trap = [1, -1];          % [1, -1]

[H_rect, w] = freqz(b_rect, a_rect, N, 'half');
[H_trap, w] = freqz(b_trap, a_trap, N, 'half');

y_rect=filter(b_rect, a_rect,x);
figure;
plot(y_rect);
title('Y rectangle');

y_trap=filter(b_trap, a_trap,x);
figure;
plot(y_trap);
title('Y trapezio');


% Υπολογισμός απόλυτων τιμών (πλάτη)
mag_ideal = abs(D_ideal);
mag_backward = abs(H_backward);
mag_symmetric = abs(H_symmetric);

% Υπολογισμός σχετικού σφάλματος πλάτους
error_backward_mag = abs(mag_backward - mag_ideal) ./ mag_ideal;
error_symmetric_mag = abs(mag_symmetric - mag_ideal) ./ mag_ideal;

% Υπολογισμός σχετικού σφάλματος μιγαδικής απόκρισης
error_backward_complex = abs(H_backward - D_ideal) ./ abs(D_ideal);
error_symmetric_complex = abs(H_symmetric - D_ideal) ./ abs(D_ideal);

%% Γραφική Παράσταση 1: Σχετικό Σφάλμα Πλάτους
figure('Position', [100, 100, 1200, 800]);

semilogy(omega, error_backward_mag, 'b-', 'LineWidth', 2); hold on;
semilogy(omega, error_symmetric_mag, 'r--', 'LineWidth', 2);
xlabel('Συχνότητα ω (rad)', 'FontSize', 12);
ylabel('Σχετικό Σφάλμα Πλάτους', 'FontSize', 12);
title('Σύγκριση Σχετικού Σφάλματος Πλάτους', 'FontSize', 14);
legend('Διαφοριστής Προς τα Πίσω', 'Συμμετρικός Διαφοριστής', 'Location', 'northwest');
grid on;
xlim([0, pi/5]);
xticks([0, pi/5]);
xticklabels({'0', 'π/5'});

%% Εμφάνιση Τιμών Σε Συγκεκριμένες Συχνότητες
fprintf('Σύγκριση Σχετικού Σφάλματος Πλάτους:\n');
fprintf('ω (rad)\t\tΠρος τα Πίσω\tΣυμμετρικός\n');
fprintf('---------------------------------------------\n');
test_freqs = [0.1, 0.3, 0.6];
for i = 1:length(test_freqs)
    w = test_freqs(i);
    idx = find(omega >= w, 1);
    if ~isempty(idx)
        fprintf('%.1f\t\t%.4f\t\t%.4f\n', w, error_backward_mag(idx), error_symmetric_mag(idx));
    end
end







