
close all;
load('adEEG');

labelChannels = {'Fp1','Fp2','F7','F3','Fz','F4','F8','T3','C3',...
                'Cz','C4','T4','T5','P3','Pz','P4','T6','O1','O2'};
            
% Import EEG data
EEG = adEEG(1);
nbchan = 1:19;
% Plot Mode Settings
plotPSD = 'off'; 
psdRange = 1:140;
plotFitChannel = 'on';

pxxs = EEG.PSD; freqs = EEG.Freqs;

h = figure('visible', plotPSD);
h.Color = [1, 1, 1];
set(h,'position',[1000,400,800,600]);



 
plot(freqs(psdRange), 10*log10(pxxs(nbchan,psdRange)),'LineWidth',1.2);
title('Welch Power Spectra Density Estimate', 'FontSize', 18);
xlabel('Frequency[Hz]', 'FontSize', 15);
ylabel('log(Power)', 'FontSize', 15);
legend(labelChannels, 'Location', 'NorthEast', 'FontSize', 13 );
grid on; grid minor;

% FOOOF settings
peSettings = struct(...
                'peak_width_limits', [0.05, 20], ... 
                'max_n_peaks', 1, ... 
                'min_peak_height', 0.01, ...
                'peak_threshold', -5, ...
                'aperiodic_mode', 'fixed', ...
                'verbose', false); 
apeSettings = struct(...
                'peak_width_limits', [0.05, 20], ... 
                'max_n_peaks', Inf, ... 
                'min_peak_height', 0.05, ...
                'peak_threshold', -10, ...
                'aperiodic_mode', 'fixed', ...
                'verbose', false);    

h1 = figure; h1.Color = [1,1,1]; set(h1,'position',[1000,300,800,320]);
%%% Run FOOOF
Result = [];
for i = 18
    curR0 = fooof(freqs, pxxs(i,:), [0.5, 40], peSettings, true);
    hs(4) = subplot(1,2,1);
    fooof_plotV2(curR0, plotFitChannel, 'plotMode', 'on', 'on');
%     title('Periodic & Aperiodic Fitting: 0.5-40 Hz ', 'FontSize', 12);    
    
    curR1 = fooof(freqs, pxxs(i,:), [4, 16], peSettings, true);
    hs(1) = subplot(1,2,2);
    fooof_plotV2(curR1, plotFitChannel, 'plotMode', 'on', 'on');
%     title('Periodic Fitting: 4-16 Hz ', 'FontSize', 12);
     
%     curR2 = fooof(freqs, pxxs(i,:), [20, 40], apeSettings, true);
%     hs(2) = subplot(2,2,3);
%     fooof_plotV2(curR2, plotFitChannel, 'plotMode', 'off', 'on');
%     title('Aperiodic Fitting: 20-40 Hz' ,'FontSize', 12); 
%    
%     curR3 = fooof(freqs, pxxs(i,:), [0.5, 40], apeSettings, true);
%     hs(3) = subplot(2,2,4);
%     fooof_plotV2(curR3, plotFitChannel, 'plotMode', 'off', 'on');
%     title('Aperiodic Fitting: 0.5-40 Hz' , 'FontSize', 12); 
end

% text('Parent',hs(4), 'HorizontalAlignment','left','FontWeight','normal','FontSize',12,...
%     'String',['CF   = ', num2str(curR0.peak_params(1,1), '%.2f') ,...
%     sprintf('\n'),'PW  = ',num2str(curR0.peak_params(1,2), '%.2f'), ...
%     sprintf('\n'),'BW  = ', num2str(curR0.peak_params(1,3), '%.2f'),...
%     sprintf('\n'),'OS   = ', num2str(curR0.aperiodic_params(1,1), '%.2f'),...
%     sprintf('\n'),'EXP = ', num2str(curR0.aperiodic_params(1,2), '%.2f')],...
%     'Position',[26 -0.1 0]);
% 
% text('Parent',hs(1), 'HorizontalAlignment','left','FontWeight','normal','FontSize',12,...
%     'String',['CF  = ', num2str(curR1.peak_params(1,1), '%.2f') ,...
%     sprintf('\n'),'PW = ',num2str(curR1.peak_params(1,2), '%.2f'), ...
%     sprintf('\n'),'BW = ', num2str(curR1.peak_params(1,3), '%.2f')],...
%     'Position',[12 0.5 0]);

h2 = figure; h2.Color = [1,1,1]; set(h2,'position',[1000,300,800,320]);
%%% Run FOOOF
Result = [];
for i = 18
     
    curR2 = fooof(freqs, pxxs(i,:), [20, 40], apeSettings, true);
    hs(2) = subplot(1,2,1);
    fooof_plotV2(curR2, plotFitChannel, 'plotMode', 'off', 'on');
%     title('Aperiodic Fitting: 20-40 Hz' ,'FontSize', 12); 
   
    curR3 = fooof(freqs, pxxs(i,:), [0.5, 40], apeSettings, true);
    hs(3) = subplot(1,2,2);
    fooof_plotV2(curR3, plotFitChannel, 'plotMode', 'off', 'on');
%     title('Aperiodic Fitting: 0.5-40 Hz' , 'FontSize', 12); 
end

% text('Parent',hs(3), 'HorizontalAlignment','left','FontWeight','normal','FontSize',12,...
%     'String',['OS   = ', num2str(curR2.aperiodic_params(1,1), '%.2f') ,...
%     sprintf('\n'),'EXP = ',num2str(curR2.aperiodic_params(1,2), '%.2f')], ...
%     'Position',[-26 0.3 0]);
% 
% text('Parent',hs(3), 'HorizontalAlignment','left','FontWeight','normal','FontSize',12,...
%     'String',['OS   = ', num2str(curR3.aperiodic_params(1,1), '%.2f') ,...
%     sprintf('\n'),'EXP = ',num2str(curR3.aperiodic_params(1,2), '%.2f')], ...
%     'Position',[26 0.3 0]);

% for i = [1 3]; ylabel(hs(i), 'log(Power)','FontSize', 15); end
% for i = [2 3]; xlabel(hs(i), 'Frequency[Hz]' ,'FontSize', 15); end

for i = [1 2 3 4]; xlabel(hs(i), 'Frequency[Hz]' ,'FontSize', 15); ylabel(hs(i), 'log(Power)','FontSize', 15); end


text('Parent',hs(2), 'HorizontalAlignment','center','FontWeight','bold','FontSize',18,...
    'String',['Channel O1'],...
    'Position',[0.06 0.849 0.03]);

% print(h1,'C:\Users\Admin\Pictures\EUSIPCO\pefit.png','-dpng','-r300'); 
% print(h2,'C:\Users\Admin\Pictures\EUSIPCO\apefit.png','-dpng','-r300'); 

