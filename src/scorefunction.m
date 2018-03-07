function [meanvar,regulascore]=scorefunction(data,regulator)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
meanvar=[];
regulascore=[];
regulascoreup=[];
regulascoredown=[];
cluID=unique(data(:,2));
conup=find(regulator(1,:)==1);
dataup=data(:,conup);
connonup=find(regulator(1,:)<1);
datanonup=data(:,connonup);
condown=find(regulator(1,:)==-1);
connondown1=find(regulator(1,:)==0);
connondown2=find(regulator(1,:)==1);
connondown=[connondown1 connondown2];
datadown=data(:,condown);
datanondown=data(:,connondown);
% save dataup dataup;
% save datanonup datanonup;
% save datadown datadown;
% save datanondown datanondown;
        meandataup=mean(dataup(:));
        vardataup=std(dataup(:));
        meandatanonup=mean(datanonup(:));
        vardatanonup=std(datanonup(:));
        scrdataup=sum(sum(-(dataup-meandataup).^2/(2*vardataup^2)-log(vardataup)));
        scrdatanonup=sum(sum(-(datanonup-meandatanonup).^2/(2*vardatanonup^2)-log(vardatanonup)));
        scoreupall=scrdataup+scrdatanonup;
        regulascoreup=[regulator(1,1) regulator(1,2) cluID scoreupall];
        %regulascoreup=sortrows(regulascoreup,4);
        
        meandatadown=mean(datadown(:));
        vardatadown=std(datadown(:));
        meandatanondown=mean(datanondown(:));
        vardatanondown=std(datanondown(:));
        scrdatadown=sum(sum(-(datadown-meandatadown).^2/(2*vardatadown^2)-log(vardatadown)));
        scrdatanondown=sum(sum(-(datanondown-meandatanondown).^2/(2*vardatanondown^2)-log(vardatanondown)));
        scoredownall=scrdatadown+scrdatanondown;
        regulascoredown=[regulator(1,1) regulator(1,2) cluID scoredownall];
        %regulascoredown=sortrows(regulascoredown,4);
        meanvar=[meandataup,vardataup,meandatanonup,vardatanonup,meandatadown,vardatadown,meandatanondown,vardatanondown];
         if (size(conup,2)*size(connonup,2)==0)
             regulascoreup=[regulator(1,1) regulator(1,2) cluID -Inf];
         end;
         if  (size(condown,2)*size(connondown,2)==0)
             regulascoredown=[regulator(1,1) regulator(1,2) cluID -Inf];
         end;
            
        if (regulascoreup(1,4)>regulascoredown(1,4))
            regulascore=[regulascoreup 1];
        else%if regulascoreup(1,4)<regulascoredown(1,4)
            regulascore=[regulascoredown -1];
        end;


