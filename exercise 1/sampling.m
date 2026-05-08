load("/Users/despoinis/Library/CloudStorage/OneDrive-UniversityofPatras/3rd grade/Signal processing lab/exercise 1/dtmf_signal.mat","fs",'signal');


t=(0:length(signal)-1)/fs;
%plot(t,signal);
%title("DTMF signal");

frame_len=round(0.04*fs);
numFrames = floor(length(signal)/frame_len);


energy = zeros(1,numFrames);
for k = 1:numFrames
    idx = (k-1)*frame_len + (1:frame_len);
    energy(k) = mean(signal(idx).^2);  
end

timeFrames = ((0:numFrames-1)*frame_len + frame_len/2)/fs;
%subplot(2,1,1); plot(t, signal); title('signal');
%subplot(2,1,2); plot(timeFrames, energy); title('energy');
%xlabel('t');

     
nmask= islocalmin(energy); %briskv ta topika elaxista sthn energy poy einai oi siopes kai antistrefv to mask
mask=~nmask

d = diff([0 mask 0]);
starts = find(d == 1);  
ends   = find(d == -1)-1;  

starts_samples = starts * frame_len + 1;
ends_samples   = ends * frame_len;

freqs=zeros(15,2);
for i = 1:length(starts_samples)
    tone = signal(starts_samples(i):ends_samples(i));
    L=length(tone);
    f=(0:L-1)*(fs/L);
    %figure;
    %plot((0:length(tone)-1)/fs, tone);
     num=abs(fft(tone));
     figure;
     plot(f(1:L/2),num(1:L/2));
    % xlabel("frequency");
    % ylabel("FFT");
    [pks,locs]=findpeaks(num(1:L/2), 'SortStr','descend');
    f1=f(locs(1));
    f2=f(locs(2));
    freqs(i,1:2)=[f1,f2]

end





