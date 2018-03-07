function [m]=smallcodes(s,DataSy)
for i=1:size(s.regulatormatrix,2)
    for j=1:size(s.regulatormatrix{i},1)
        for k=1:size(s.regulatormatrix{1},2)
            if(s.regulatormatrix{i}(j,k)==1)
                n=s.regulatormatrix{i}(1,k);
                s.regulatormatrix{i}(j,k)=DataSy(DataSy(:,1)==s.regulatormatrix{i}(j,1),n-1);
            end;
        end;
    end;
    m.regulatorexpress{i}=s.regulatormatrix{i};
end;
            
