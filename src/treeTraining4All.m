function [Assign,reAssignClassall]=treeTraining4All(kmeandata,regulators,Depth)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%kmeandatatop3=kmeandata;
for i=1:30
    [Assign]=assignmentgene(kmeandata,regulators,Depth);
    [reAssignClassall,reAssignClasstop3]=Assignment(kmeandata,regulators,Assign);
    kmeandata=sortrows(kmeandata);
    reAssignClassall=sortrows(reAssignClassall);
        if sum(find(reAssignClassall(:,2)-reAssignClassall(:,3)))==0
        break
    end
    kmeandata(:,2)=reAssignClassall(:,3);
    i
%     [Assigntop3]=assignmentgene(kmeandatatop3,regulators,Depth);
%     [reAssignClassall,reAssignClasstop3]=Assignment(kmeandatatop3,regulators,Assigntop3);
%     kmeandatatop3=sortrows(kmeandatatop3);
%     reAssignClasstop3=sortrows(reAssignClasstop3);
%     kmeandatatop3(:,2)=reAssignClasstop3(:,3);
end
% save reAssignClassall reAssignClassall;
% save reAssignClasstop3 reAssignClasstop3;

