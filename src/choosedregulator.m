function [regulatorID,up_or_down,score]=choosedregulator(data,regulators)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
reg=[];
MV=[];
for i=1:size(regulators,1);
    [meanvar,regulascore]=scorefunction(data,regulators(i,:));
    reg=[reg;regulascore meanvar];
    
end;
    reg=sortrows(reg,4);
    regulatorID=reg(end,1);
    up_or_down=reg(end,5);
    score=reg(end,4);
    MV=[regulatorID reg(end,6:end)];
    save MV MV;



