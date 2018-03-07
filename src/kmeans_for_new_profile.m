function new_profile=kmeans_for_new_profile(de_profile,ep)
new_profile=de_profile;
len=size(new_profile,2)-2;
for i=1:size(de_profile,1)
    % Freq=getFreqFromVector(de_profile(i,3:end));
    % labels=Freq(Freq(:,2)~=0,:);
%     k=size(labels,1);
%     if k==3
%         i
%     end
labels=[-1;0;1];
k=3;
    gene_ep=ep(ep(:,1)==de_profile(i,1),3:end);
    idgene=kmeans(gene_ep,k,'EmptyAction', 'singleton');
    for j=1:k
        gj=gene_ep(idgene==j);
        w(j,1)=j;
        w(j,2)=mean(gj);
    end
    w=sortrows(w,2);
    s=zeros(1,len);
    for j=1:k
        s(idgene==w(j,1))=labels(j);
    end
    new_profile(i,3:end)=s;
end
        
        
    