

input_param = input('Type kind of input (1 - Offset, 2 - Exp): ');

apD = [];
apI = [];

for i = 1:19
curI  = Intact_Out(i).All_Aperiodic(:,input_param);
apI = [apI; curI];

curD  = Decre_Out(i).All_Aperiodic(:,input_param);
apD = [apD; curD];

end;

apA = [apI' , apD'];

% cognition
g1 = [zeros(1,551) , ones(1,551)]; 
%____________________________________________
%channel
g2 = [];
for j = 1:19
    n = size(Intact_Out(i).All_Aperiodic(:,input_param), 1);
    if j == 1
        g2(1 : n) = j ;
        temp = n ;
    else
        g2(temp+1 : temp+n ) = j;
        temp = temp+n ;
    end
end

g2 = [g2, g2];

pValue2 = anovan(apA, {g1,g2}, 'model' , 'interaction')


% Sample data for two groups (Group A and Group B)
groupD_data = apD;
groupI_data = apI;

% Combine the data into a single cell array for violinplot function
combined_data = {groupD_data, groupI_data};

% Create a raincloud plot
if input_param == 1
    tLable = 'Exponent';
else
    tLable = 'Offset';
end

figure;
raincloud = violin(combined_data, 'ShowData', false,'xlabel', {'Decreased Group','Intact Group'});
title(tLable);

