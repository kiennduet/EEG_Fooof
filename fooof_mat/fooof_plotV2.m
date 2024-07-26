% fooof_plot() - Plot a FOOOF model.
%
% Usage:
%   >> fooof_plot(fooof_results)
%
% Inputs:
%   fooof_results   = struct of fooof results
%                       Note: must contain FOOOF model, not just results
%   log_freqs       = boolean, whether to log frequency axis
%                       Note: this argument is optional, defaults to false
%

function fooof_plotV2(fooof_results, visible, varargin)

    %% Data Checking

    if ~isfield(fooof_results, 'freqs')
       error('FOOOF results struct does not contain model output.')
    end
    
    if isempty(find(strcmp(varargin,'plotMode')))==0
        pePlot = varargin{find(strcmp(varargin,'plotMode'))+1};
        apePlot= varargin{find(strcmp(varargin,'plotMode'))+2};
    else
        pePlot = 'on';
        apePlot = 'on';
    end
    

    %% Set Up

%     if exist('log_freqs', 'var') && log_freqs
%         plt_freqs = log10(fooof_results.freqs);
%     else
%         plt_freqs = fooof_results.freqs;
%     end
    plt_freqs = fooof_results.freqs;
    
    % Plot settings
    lw = 2.5;
 

    %% Create the plots

%     h = figure('visible', visible); h.Color = [1,1,1]; 
    hold on;

    
    oriColor = hex2rgb('#168bc7');
    peColor  = hex2rgb('#ff684a');
    apeColor = hex2rgb('#c7168b');
    
%     oriColor = hex2rgb('#534293');
%     peColor  = hex2rgb('#eb5951');
%     apeColor = hex2rgb('#05BBaa');

    % Plot the original data
    data = plot(plt_freqs, fooof_results.power_spectrum, 'Color', oriColor, 'LineWidth', lw);
    
    % Plot the full model fit
    if strcmp(pePlot, 'on') && strcmp(apePlot, 'on')
        model = plot(plt_freqs, fooof_results.fooofed_spectrum, '-.', 'Color', peColor, 'LineWidth', lw);
        ap_fit = plot(plt_freqs, fooof_results.ap_fit,  '--', 'Color', apeColor, 'LineWidth', lw);
        legendLabel = {'Original Spectrum', 'Periodic Fit', 'Aperiodic Fit'};
    end
    
    if strcmp(pePlot, 'on') && strcmp(apePlot, 'off')
        model = plot(plt_freqs, fooof_results.fooofed_spectrum, 'Color', peColor, 'LineWidth', lw);
        legendLabel = {'Original Spectrum', 'Periodic Fit'};
    end
    
    % Plot the aperiodic fit
    if strcmp(pePlot, 'off') && strcmp(apePlot, 'on')
        ap_fit = plot(plt_freqs, fooof_results.ap_fit, '--', 'Color', apeColor, 'LineWidth', lw);
        legendLabel = {'Original Spectrum', 'Aperiodic Fit'};
    end
    
    
    
    %% Plot Settings

    % Set alpha value for model - in a wonky way, because Matlab
    %   Note: the '4' is magical and mysterious. No idea.
    model.Color(4) = 0.9;

    grid on; box on; grid minor;
    
    legend(legendLabel, 'FontSize', 9.5);
    
    %text(fooof_results.peak_params(1,1), 0, sprintf('\\leftarrow Dominant Frequency'));
    
%     xlabel('Frequency')
%     ylabel('log(Power)')
    hold off

end