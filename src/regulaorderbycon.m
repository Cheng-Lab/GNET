function [structure]=regulaorderbycon(assign)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
num=size(assign,2);

for i=1:num
    subnum=size(assign{1,i},2);
    regulatormatrix=[];
    condition=[];
    regu=[];
    regu2=[];
      for l=1:subnum
        condition=[condition assign{1,i}(1,l).conditions];
        regu=[regu assign{1,i}(1,l).regulator];
        gu2=[assign{1,i}(1,l).regulator' (1:size(assign{1,i}(1,l).regulator,2))'];
        regu2=[regu2;gu2];
      end; 
      regu=unique(abs(regu'));
      regu2=unique(abs(regu2),'rows');
      structure.regu2{i}=regu2;
      regulatormatrix=zeros(size(regu,1),size(condition,2));
      regulatormatrix=[regu regulatormatrix];
      regulatormatrix=[0 condition;regulatormatrix];
      b=[];
    for j=1:subnum
        subnumofregulator=size(assign{1,i}(1,j).regulator,2);
        subregulatorcon=[];
        
        condition=assign{1,i}(1,j).conditions;
        regu=abs(assign{1,i}(1,j).regulator);
%         for k=1:subnumofregulator
%             subregulatorcon=assign{1,i}(1,j).regulator(k);
%         end;
            for k=1:size(condition,2)
                column=find(regulatormatrix(1,:)==condition(k));
                for u=1:size(regu,2)
                    row=find(regulatormatrix(:,1)==regu(u));
                    regulatormatrix(row,column)=1;
                end;
            end;
%              a=size(regulatormatrix,2);
%              b=sum(regulatormatrix(2:end,2:end)');
%              regulatormatrix=[regulatormatrix [100;b']];
%              regulatormatrix=sortrows(regulatormatrix,-(a+1));
             
    end;
    structure.regulatormatrix{i}=regulatormatrix;
    
end

