function [tree,treecondition,treeMV,group_struct]=treeTraining3(theGroup,regulators,deepDepth)
if nargin<3
    deepDepth=5;
end
if deepDepth<0
    tree=[];
    return;
end

groupIDs=theGroup(1:end,1:2);
groupData=theGroup(2:end,3:end);%--
regulatorIDs=regulators(:,1:2);%****
regulatorData=regulators(:,3:end);
cols=size(groupData,2);
%tree=NaN(deepDepth,2^(deepDepth-1));
treeMV=[];
tree=NaN(deepDepth,cols);
mingroup=2;

if cols<mingroup

    treecondition=theGroup(1,3:end);
    %group_struct
    group_struct.conditions=treecondition;
    group_struct.data=theGroup;
    group_struct.regulator=[];
    group_struct.regulated_way={'leaf_node'};
    group_struct.mean=mean(groupData(:));
    group_struct.std=std(groupData(:));
    %end group_struct
    return
end
if deepDepth==0

    treecondition=theGroup(1,3:end);
    %group_struct
    group_struct.conditions=treecondition;
    group_struct.data=theGroup;
    group_struct.regulator=[];
    group_struct.regulated_way={'leaf_node'};
    group_struct.mean=mean(groupData(:));
    group_struct.std=std(groupData(:));
    %end group_struct
    return
end
[regulatorID,up_or_down,score]=choosedregulator(theGroup(2:end,:),regulators);
tree(1,:)=regulatorID*up_or_down;
%group_struct
thisRegulator=regulatorID*up_or_down;
%end group_struct
load MV;
treeMV=[treeMV;MV];
%tree(1,1)=regulatorID*up_or_down;
%tree(1,2:end)=0;

if(up_or_down>0)
    rightNodeIDs=find(regulatorData((regulatorIDs(:,1)==regulatorID),:)>0);
    leftNodeIDs=find(regulatorData((regulatorIDs(:,1)==regulatorID),:)<=0);
    right_str='up_regulate';
    left_str='not_up_regulate';
else
    rightNodeIDs=find(regulatorData((regulatorIDs(:,1)==regulatorID),:)>=0);
    leftNodeIDs=find(regulatorData((regulatorIDs(:,1)==regulatorID),:)<0);
    right_str='not_down_regulate';
    left_str='down_regulate';
end
%regulatorData((regulatorIDs(:,1)==regulatorID),:)=[];
%regulatorIDs((regulatorIDs(:,1)==regulatorID),:)=[];

rightData=theGroup(:,rightNodeIDs+2);%--
leftData=theGroup(:,leftNodeIDs+2);%--
rightRegulators=regulatorData(:,rightNodeIDs);
leftRegulators=regulatorData(:,leftNodeIDs);
[tree_right,treecondition_right,MV,group_struct_right]=treeTraining3([groupIDs,rightData],[regulatorIDs,rightRegulators],deepDepth-1);
treeMV=[treeMV;MV];
[tree_left,treecondition_left,MV,group_struct_left]=treeTraining3([groupIDs,leftData],[regulatorIDs,leftRegulators],deepDepth-1);
treeMV=[treeMV;MV];
tree(2:end,:)=[tree_left,tree_right];
treecondition=[treecondition_left treecondition_right];
%group_struct
for i=1:length(group_struct_left)
    group_struct_left(i).regulator=[thisRegulator,group_struct_left(i).regulator];
    group_struct_left(i).regulated_way=[left_str,group_struct_left(i).regulated_way];
    
end
for i=1:length(group_struct_right)
    group_struct_right(i).regulator=[thisRegulator,group_struct_right(i).regulator];
    group_struct_right(i).regulated_way=[right_str,group_struct_right(i).regulated_way];
end
group_struct=[group_struct_left,group_struct_right];
%end group_struct
    
