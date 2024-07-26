
function allEEG = createEEGGroup(filename,filepath)
    allEEG = [];
    numPatient = size(filename,1);
    
    for n = 1:numPatient
        
        curName = filename(n,1);
        curPatient = pop_loadset(curName, filepath);
        allEEG = [allEEG, curPatient];

    end 
end