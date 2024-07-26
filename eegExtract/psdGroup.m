

function psdG = psdGroup(allEEG)
    numPatient = size(allEEG, 2);
    psdG = [];
    for i = 1:numPatient
        
        curPatient = allEEG(i);
        
        if isfield(curPatient , 'cognition') == 0
            patientCog  = 'NA';
        else
            patientCog  = curPatient.cognition;
        end
            
        patientName = strrep(curPatient.filename, '.set', '');
        eegData = curPatient.data(1:19,:)';
        nChannel = size(eegData, 2);
        
        %% Goldmann Reference
        refChannel = 10; % Cz
        commonChannels = setdiff(1:19, refChannel);
        averageCommonChannels = mean(eegData(:, commonChannels), 2);

        refData = zeros(size(eegData));
        for i = 1:19
            refData(:, i) = eegData(:, i) - averageCommonChannels;
        end
        
        %% Caculate Power Spectra Density
        nfft = 512; window = hamming(nfft); overlap = 0;
        [pxxs,freqs] = pwelch(refData, window, overlap, nfft, curPatient.srate);
        freqs = freqs'; pxxs = pxxs';
        
        %% Output
        curpStruct = struct('patientName', patientName, 'cognition', patientCog,...
                            'Freqs', freqs, 'PSD', pxxs);
        
        psdG = [psdG, curpStruct];
        
    end
end