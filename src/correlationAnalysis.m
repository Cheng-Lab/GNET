function [corrscore]=correlationAnalysis(assign)
corrscore=[];
for i=1:size(assign,2)
        data=[];
    for j=1:size(assign{1,i},2)
        data=[data assign{1,i}(1,j).data(2:end,3:end)];
    end;
    b=corr(data');
    u=b-eye(size(data',2));
    s=triu(u);
    M=sum(sum(s))*2/size(data',2)/(size(data',2)-1);
    corrscore=[corrscore;i M];
end;