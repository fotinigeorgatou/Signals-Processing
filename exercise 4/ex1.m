data = load('noisy_dataset.mat');
noisy_images = double(data.noisy_images)/255 * ...
              (data.max_val - data.min_val) + data.min_val;
[height, width, total_samples] = size(noisy_images);

% Μέγεθος κάθε ομάδας (batch) - χρησιμοποιούμε 16 δείγματα ανά ομάδα
batch_size = 16;
% Υπολογισμός συνολικού αριθμού ομάδων
num_batches = total_samples / batch_size;
% Σημεία ελέγχου όπου θα αποθηκεύσουμε τη μέση τιμή
% 1/256, 1/16 και 100% του συνόλου των ομάδων
checkpoints = [1/256, 1/16, 1] .* num_batches;
% Κελί για αποθήκευση μέσων τιμών σε κάθε σημείο ελέγχου
means_at_checkpoints = cell(size(checkpoints));

noisy_batches = reshape(noisy_images, height, width, batch_size, []);

% Υπολογισμός μέσης τιμής κάθε ομάδας
batch_means = squeeze(mean(noisy_batches, 3));

running_mean = zeros(height, width);

% Αναδρομικός υπολογισμός μέσης τιμής - δείχνει πώς συγκλίνει η μέση τιμή
for batch_index = 1:size(batch_means, 3)
    % Αναδρομικός τύπος: new_mean = old_mean + (new_sample - old_mean)/k
    % Αυτός ο τύπος υπολογίζει αποτελεσματικά τη νέα μέση τιμή
    running_mean = running_mean + (batch_means(:, :, batch_index) - running_mean) / batch_index;
    
    % Ελέγχουμε αν αυτή η ομάδα είναι ένα από τα σημεία ελέγχου
    checkpoint_index = find(checkpoints == batch_index, 1);
    
    % Αποθήκευση της τρέχουσας μέσης τιμής αν βρήκαμε σημείο ελέγχου
    if ~isempty(checkpoint_index)
        means_at_checkpoints{checkpoint_index} = running_mean;
    end
end

pic=means_at_checkpoints{2};
pic=im2double(pic);
[height, width] = size(pic);
imshow(pic);
Noise=0.5*rand(size(pic));
noisy_pic= pic+Noise;
figure;
imshow(noisy_pic);

%% Law of Large Numbers
running_mean = zeros(height, width);

% Αναδρομικός υπολογισμός μέσης τιμής - δείχνει πώς συγκλίνει η μέση τιμή
for batch_index = 1:size(batch_means, 3)
    % Αναδρομικός τύπος: new_mean = old_mean + (new_sample - old_mean)/k
    % Αυτός ο τύπος υπολογίζει αποτελεσματικά τη νέα μέση τιμή
    running_mean = running_mean + (batch_means(:, :, batch_index) - running_mean) / batch_index;
    
    % Ελέγχουμε αν αυτή η ομάδα είναι ένα από τα σημεία ελέγχου
    checkpoint_index = find(checkpoints == batch_index, 1);
    
    % Αποθήκευση της τρέχουσας μέσης τιμής αν βρήκαμε σημείο ελέγχου
    if ~isempty(checkpoint_index)
        means_at_checkpoints{checkpoint_index} = running_mean;
    end
end

figure;
imshow(running_mean);
title('Law of Large Numbers');
%%  Ανάλυση στατιστικών θορύβου
clean_estimate = means_at_checkpoints{end};

% Υπολογισμός θορύβου ως διαφορά κάθε εικόνας από τη μέση τιμή
noise = noisy_pic - repmat(clean_estimate, [1, 1, total_samples]);

% Στατιστικά του θορύβου
noise_mean = mean(noise(:));
noise_std = std(noise(:));

% Ιστόγραμμα κατανομής θορύβου
figure;
histogram(noise(:), 100, 'Normalization', 'pdf');
title('Noise Distribution');
xlabel('Noise Value');
ylabel('Probability Density');


%% Central Limit Theorem — Correct Demonstration

pixels_per_image = height * width;
num_samples = 5000;   

noise_stack = noise_std * randn(height, width, num_samples);

noise_mean = mean(noise_stack(:));
noise_std  = std(noise_stack(:));

noise_sum_per_image = squeeze(sum(sum(noise_stack,1),2));

standardized_sums = (noise_sum_per_image - noise_mean * pixels_per_image) ...
                    / (noise_std * sqrt(pixels_per_image));

% Plot CLT result
figure;
histogram(standardized_sums, 100, 'Normalization', 'pdf');
title('Central Limit Theorem: Distribution of Normalized Sample Sums');
xlabel('Standardized Value');
ylabel('Probability Density');
grid on;

% Προσθήκη της θεωρητικής κανονικής κατανομής N(0,1) για σύγκριση
hold on;
x_values = linspace(-4, 4, 100);
normal_pdf = normpdf(x_values, 0, 1);
plot(x_values, normal_pdf, 'r-', 'LineWidth', 2);
legend('Standardized Sums', 'Normal Distribution N(0,1)');
hold off;

% Στατιστικά των τυποποιημένων αθροισμάτων
clt_mean = mean(standardized_sums);
clt_std = std(standardized_sums);

fprintf('=== CENTRAL LIMIT THEOREM STATISTICS ===\n');
fprintf('Mean of standardized sums (should be near 0): %.4f\n', clt_mean);
fprintf('Std of standardized sums (should be near 1): %.4f\n', clt_std);
fprintf('\nThe CLT predicts that these should approach 0 and 1 respectively.\n');


