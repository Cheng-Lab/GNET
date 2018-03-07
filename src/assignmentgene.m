function [Assign]=assignmentgene(data,regulators,Depth)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
assignmatrixall=[];
assignmatrixtop3=[];
num=unique(data(:,2));
 Assign={};
 for i=1:size(num,1)
     datamodule=data(find(data(:,2)==num(i)),:);
     datamodule=[[1:size(data,2)];datamodule];
 %     [scoremoduleall,scoremoduletop3]=treeTraining3Score(datamodule,regulators,Depth)
 %     assignmatrixall=scoremoduleall;
 %     assignmatrixtop3=scoremoduletop3;
     [tree,treegene,treeMV,group_struct]=treeTraining3(datamodule,regulators,Depth);
     Assign{i}=group_struct;
 end;
 %save Assign Assign;

% v6=[];
% left=[];
% right=[];
% row={};
% for num=1:size(matrix,2) %暂时不考虑叶子结点重复出现同一个转录因子的情况
%     if (matrix(5,num)==matrix(5,num+1) & ~isnan(matrix(5,num)))
%         row=[row;num];
%         v6=matrix(6,find(matrix(5,:)==matrix(5,num)));
%         if(matrix(6,num)==v6[1,1])
%             left=[left;matrix(5,num) matrix(7,num)];
%         elseif(matrix(6,num)!=v6[1,1] & ~isnan(matrix(6,num)))
%             right=[right;matrix(5,num) matrix(7,num)];
%         end;
%     elseif ()
%     end;
            


% number=unique(tree(5,~isnan(tree(5,:))));
% 
% for j=1:size(number,2)
%     matrix(7,find(matrix(5,:)==number(1,j)));
%     if (number(1,j)>0)
% for i=2:size(data,1)
%     gene=data(i,3:end);
%     scrdataup=sum(sum(-(geneup-meandataup).^2/(2*vardataup^2)-log(vardataup)));
%     scrdatanonup=sum(sum(-(genenonup-meandatanonup).^2/(2*vardatanonup^2)-log(vardatanonup)));
%     scoreupall=scrdataup+scrdatanonup;
% end


