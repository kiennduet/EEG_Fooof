close all;

EEG = pop_loadset('D:\1_Course\6_Course_1_2023\1_EEG_Data\EEG_Data_2\intact_cognition\p2259.set');
range = 755:2500;
data = EEG.data(18, range);

h = figure; h.Color = [1,1,1]; set(h,'position',[1000,300,800,800]);
subplot(2,1,1);
plot(EEG.times(range), data , 'LineWidth', 1.0 , 'Color', hex2rgb('#04a97e')); grid on; grid minor;
title('Time Domain', 'FontSize', 15);
xlabel('Time[ms]', 'FontSize', 15);
ylabel('Amplitude[\muV]', 'FontSize', 15);

nfft = 512; window = hamming(nfft); overlap = 0;
[pxxs,freqs] = pwelch(data', window, overlap, nfft, EEG.srate);

subplot(2,1,2);
plot(freqs(1:140), 10*log10(pxxs(1:140)),'LineWidth',1.2, 'Color', hex2rgb('#04a97e')); grid on; grid minor;
title('Frequency Domain', 'FontSize', 15);
xlabel('Frequency[Hz]', 'FontSize', 15);
ylabel('log(Power)', 'FontSize', 15);