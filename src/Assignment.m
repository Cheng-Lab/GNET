function [reAssignClassall,reAssignClasstop3]=Assignment(kmeandata,regulators,Assign)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
num=unique(kmeandata(:,2));
moduleall=[];
moduletop3=[];
for nummod=1:size(num,1)
    %data=kmeandata(find(kmeandata(:,2)==nummod),:);
    group_struct=Assign{nummod};
scoremoduleall=[];
scoremoduletop3=[];
for i=1:size(kmeandata,1)
    geneID=kmeandata(i,1);
    scoreall=0;
    scoretop3=[];
    for j=1:size(group_struct,2)
        %gene=group_struct(j).data(find(group_struct(j).data(:,1)==geneID),3:end);
        gene=kmeandata(find(kmeandata(:,1)==geneID),group_struct(j).conditions);
        scrdata=sum(sum(-(gene-group_struct(j).mean).^2/(2*group_struct(j).std^2)-log(group_struct(j).std)));
        scoreall=scoreall+scrdata;
        scoretop3=[scoretop3;scrdata];
    end;
    n=size(scoretop3,1);
    scoretop3=sort(scoretop3);
    scoremoduleall=[scoremoduleall;kmeandata(i,1:2) scoreall];
    scoremoduletop3=[scoremoduletop3;kmeandata(i,1:2) sum(scoretop3(n-2:n,:))];
end;
    moduleall=[moduleall scoremoduleall(:,3)];
    moduletop3=[moduletop3 scoremoduletop3(:,3)];
end;
    moduleall=[kmeandata(:,1:2) moduleall];
    moduletop3=[kmeandata(:,1:2) moduletop3];
    reAssignClassall=[];
    reAssignClasstop3=[];
    for ii=1:size(kmeandata,1)
        reAssignClassall=[reAssignClassall;moduleall(ii,1:2) find(moduleall(ii,:)==max(moduleall(ii,3:end)))-2 moduleall(ii,3:end)];
        reAssignClasstop3=[reAssignClasstop3;moduletop3(ii,1:2) find(moduletop3(ii,:)==max(moduletop3(ii,3:end)))-2 moduletop3(ii,3:end)];
    end;
    

    
