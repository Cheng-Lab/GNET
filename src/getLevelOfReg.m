function res=getLevelOfReg(Assign)
num=length(Assign);

for i=1:num
    R=[];
    T=[];
    struct_i=Assign{i};
    n=length(struct_i);
    for j=1:n
        m(j)=length(struct_i(j).regulator);
    end

    m=max(m);
    w=1;
    R(1)=abs(struct_i(1).regulator(1));
    T(w,1)=1;
    T(w,2)=n;
    T(w,3)=1;
    
        
    for j=2:m
        empty=0;
        for k=1:n
            if length(struct_i(k).regulator)<j
                continue
            else
                R=[R;abs(struct_i(k).regulator(j))];
                w=w+1;
                T(w,1)=k;
                T(w,3)=j;
                last_r=R(end);
                last_w=struct_i(k).regulated_way{j-1};
                break;
            end
        end
        for k=T(w,1)+1:n
            if length(struct_i(k).regulator)<j
                if ~empty
                    T(w,2)=k-1;                    
                    empty=1;
                end
                continue
            elseif (abs(struct_i(k).regulator(j))~=last_r)|(~strcmp(struct_i(k).regulated_way{j-1},last_w))
                R=[R;abs(struct_i(k).regulator(j))];
                if ~empty 
                    T(w,2)=k-1;
                else
                    empty=0;
                end
                w=w+1;
                T(w,1)=k;
                T(w,3)=j;
                last_r=R(end);
                last_w=struct_i(k).regulated_way{j-1};
            end               
        end
        if ~empty
            T(w,2)=n;
        end
    end
    res(i).R=R;
    res(i).T=T;
    
end

    