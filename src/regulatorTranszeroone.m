function [regulators6ex]=regulatorTranszeroone(data)
regulators6ex=[];
for i=1:size(data,1)
    me=mean(data(i,3:4));%time zeros columns
    %me=mean(data(i,3:8));%DMSO columns
    va=sqrt((data(i,3)-me)^2+(data(i,4)-me)^2);
    %va=sqrt((data(i,3)-me)^2+(data(i,4)-me)^2+(data(i,5)-me)^2+(data(i,6)-me)^2+(data(i,7)-me)^2+(data(i,8)-me)^2);
    pma=[];
    for j=3:size(data,2)
    P=NORMCDF(data(i,j),me,va);
    if (P>0.9)
        re=1;
    end;
    if (P<0.1)
        re=-1;
    end;  
    if (P>=0.1 & P<=0.9)
        re=0;
    end;   
    pma=[pma re];
    end;
    regulators6ex=[regulators6ex;data(i,1:2) pma];
end;
