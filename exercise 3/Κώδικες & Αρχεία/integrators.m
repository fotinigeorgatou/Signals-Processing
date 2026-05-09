% Απόκριση Συχνότητας Ολοκληρωτών με χρήση freqz - ΔΙΟΡΘΩΜΕΝΟ
clear; close all; clc;

%% Παράμετροι
Ts = 1;  % Περίοδος δειγματοληψίας
N = 1024; % Αριθμός σημείων για τον υπολογισμό

%% Συντελεστές Ολοκληρωτών

% 1. Μέθοδος Ορθογωνίου (Left Riemann Sum)
b_rect = [0, Ts];    % [0, T_s]
a_rect = [1, -1];    % [1, -1]

 % 2. Μέθοδος Τραπεζίου (Trapezoidal Rule)
 b_trap = (Ts/2) * [1, 1];  % [T_s/2, T_s/2]
 a_trap = [1, -1];          % [1, -1]

%% Υπολογισμός Απόκρισης Συχνότητας με freqz (0 έως π ΜΟΝΟ)
% Χρήση 'half' για αυτόματη λήψη 0 έως π
[H_rect, w] = freqz(b_rect, a_rect, N, 'half');
[H_trap, w] = freqz(b_trap, a_trap, N, 'half');

% Ιδανικός Ολοκληρωτής (για σύγκριση)
H_ideal = 1./(1j * w * Ts);

%% Γραφικές Παραστάσεις
figure('Position', [100, 100, 1200, 800]);

% 1. Απόκριση Πλάτους (Λογαριθμική Κλίμακα)
subplot(2,2,1);
semilogx(w, 20*log10(abs(H_ideal)), 'g-', 'LineWidth', 3); hold on;
semilogx(w, 20*log10(abs(H_rect)), 'b-', 'LineWidth', 2);
semilogx(w, 20*log10(abs(H_trap)), 'r--', 'LineWidth', 2);
xlabel('Συχνότητα ω (rad/δείγμα)');
ylabel('|H(ω)| (dB)');
title('Απόκριση Πλάτους (dB)');
legend('Ιδανικός','Ορθογώνιο', 'Τραπέζιο', 'Location', 'southwest');
grid on;

% 2. Απόκριση Φάσης (Μοίρες)
subplot(2,2,2);
phase_ideal = angle(H_ideal) * 180/pi;
phase_rect = angle(H_rect) * 180/pi;
 phase_trap = angle(H_trap) * 180/pi;

plot(w, phase_ideal, 'g-', 'LineWidth', 3); hold on;
plot(w, phase_rect, 'b-', 'LineWidth', 2);
plot(w, phase_trap, 'r--', 'LineWidth', 2);
xlabel('Συχνότητα ω (rad/δείγμα)');
ylabel('∠H(ω) (μοίρες)');
title('Απόκριση Φάσης');
legend('Ιδανικός (-90°)', 'Ορθογώνιο', 'Τραπέζιο (-90°)', 'Location', 'southeast');
grid on;
xlim([0, pi]);
xticks([0, pi/4, pi/2, 3*pi/4, pi]);
xticklabels({'0', 'π/4', 'π/2', '3π/4', 'π'});

% 3. Σχετικό Σφάλμα Πλάτους (0 έως π)
subplot(2,2,3);
error_rect = abs(abs(H_rect) - abs(H_ideal)) ./ abs(H_ideal);
error_trap = abs(abs(H_trap) - abs(H_ideal)) ./ abs(H_ideal);

semilogx(w, error_rect, 'b-', 'LineWidth', 2); hold on;
semilogx(w, error_trap, 'r--', 'LineWidth', 2);
xlabel('Συχνότητα ω (rad/δείγμα)');
ylabel('Σχετικό Σφάλμα Πλάτους');
title('Σχετικό Σφάλμα Πλάτους (0 έως π)');
legend('Ορθογώνιο', 'Τραπέζιο', 'Location', 'northwest');
grid on;

% 4. Σφάλμα Φάσης (0 έως π)
subplot(2,2,4);
phase_error_rect = abs(phase_rect - phase_ideal);
phase_error_trap = abs(phase_trap - phase_ideal);

plot(w, phase_error_rect, 'b-', 'LineWidth', 2); hold on;
plot(w, phase_error_trap, 'r--', 'LineWidth', 2);
xlabel('Συχνότητα ω (rad/δείγμα)');
ylabel('Απόλυτο Σφάλμα Φάσης (μοίρες)');
title('Σφάλμα Φάσης (0 έως π)');
legend('Ορθογώνιο', 'Τραπέζιο', 'Location', 'northeast');
grid on;
xlim([0, pi]);
xticks([0, pi/4, pi/2, 3*pi/4, pi]);
xticklabels({'0', 'π/4', 'π/2', '3π/4', 'π'});


%% Πίνακας Σύγκρισης με freqz
fprintf('=== ΠΙΝΑΚΑΣ ΣΥΓΚΡΙΣΗΣ ΜΕ FREQZ (0 έως π) ===\n\n');
fprintf('Συχνότητα\tΙδανικός\tΟρθογώνιο\tΤραπέζιο\tΣφάλμα Ορθ.\tΣφάλμα Τραπ.\n');
fprintf('(rad)\t\t|H(ω)|\t\t|H(ω)|\t\t|H(ω)|\t\t%%\t\t%%\n');
fprintf('--------------------------------------------------------------------------------\n');

test_freqs = [0.01, 0.1, 0.5, 1.0, 2.0, 3.0];
for i = 1:length(test_freqs)
    w_test = test_freqs(i);
    idx = find(w >= w_test, 1);

    if ~isempty(idx) && w_test <= pi
        mag_ideal = abs(H_ideal(idx));
        mag_rect = abs(H_rect(idx));
        mag_trap = abs(H_trap(idx));

        error_rect_pct = 100 * abs(mag_rect - mag_ideal) / mag_ideal;
        error_trap_pct = 100 * abs(mag_trap - mag_ideal) / mag_ideal;

        fprintf('%.2f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.2f\t\t%.2f\n', ...
                w_test, mag_ideal, mag_rect, mag_trap, error_rect_pct, error_trap_pct);
    end
end

%% Επαλήθευση Συχνοτήτων
fprintf('\n=== ΕΠΑΛΗΘΕΥΣΗ ΣΥΧΝΟΤΗΤΩΝ ===\n');
fprintf('Εύρος συχνοτήτων w: %.4f έως %.4f rad\n', min(w), max(w));
fprintf('Π should be: %.4f rad\n', pi);
fprintf('Αριθμός σημείων: %d\n', length(w));

% Έλεγχος ορθότητας σε συγκεκριμένες συχνότητες
test_points = [0, pi/4, pi/2, 3*pi/4, pi];
fprintf('\nΈλεγχος σε διάφορες συχνότητες:\n');
for i = 1:length(test_points)
    w_test = test_points(i);
    idx = find(w >= w_test, 1);
    if ~isempty(idx)
        fprintf('ω = %.4f rad: |H_rect| = %.6f, |H_trap| = %.6f\n', ...
                w_test, abs(H_rect(idx)), abs(H_trap(idx)));
    end
end