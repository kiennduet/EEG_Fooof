

function disPlot(osI, expI, osD, expD, titleFig)
%   hex2rgb('#2a5f5f')); %c35c7d e99854
    g = '#04a97e';
    r = '#ef476f';
    o = '#d99c0e';

    intactColor = hex2rgb(g);
    degreColor = hex2rgb(o); 
    transparancyLevel = 1;
    markerSize = 30;
    edgeWidth = 0.05;
    grid on;
    scatter1 = scatter(osI, expI,'MarkerFaceColor',intactColor,...
                       'LineWidth', edgeWidth, 'Marker', 'o', 'SizeData', markerSize);
    scatter1.MarkerFaceAlpha = transparancyLevel;
    hold on;
    scatter2 = scatter(osD, expD,'MarkerFaceColor',degreColor,...
                       'LineWidth', edgeWidth, 'Marker', 'o', 'SizeData', markerSize); 
    scatter2.MarkerFaceAlpha = transparancyLevel;
    title(titleFig,'FontSize', 12);
    
end