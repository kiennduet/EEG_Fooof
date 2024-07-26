

function slopePlot(osI, expI, osD, expD, freqs, titleFig)
    g = '#04a97e';
    r = '#ef476f';
    o = '#d99c0e';
    
    intactColor = hex2rgb(g);
    degreColor = hex2rgb(o);    

    slopeI = -(mean(expI)).*(log10(freqs)) + mean(osI);
%     slopeD = -(mean(expD)).*(log10(freqs)) + mean(osI);
    slopeD = -(mean(expD)).*(log10(freqs)) + mean(osD);
    disp(['MeanExpI ', num2str(mean(expI))]);
    disp(['MeanExpD ', num2str(mean(expD))]);
    disp('  ')
    
    grid on;
    plot(log10(freqs(41:83)), slopeI(41:83), '-', 'LineWidth' , 2, 'Color', intactColor); 
    hold on;
    plot(log10(freqs(41:83)), slopeD(41:83), '--', 'LineWidth' , 2, 'Color', degreColor);
    title(titleFig,'FontSize', 12);
  
end
