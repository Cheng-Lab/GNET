function [tfnetwork]=picmodule(s,m,assign,regulatorid,regulatorname,res,DataSy)
load ourcolormap;
colormap(ourcolormap);
tfnetwork=[];
% max_value=10;
%min_value=-10;
%colormapeditor
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
num=size(assign,2);
datalabel=[];
num_conditions=size(DataSy,2)-1;
squarelength=25;
width=num_conditions*squarelength;
bar_height=10;
lengthoftext=90;
for i=1:num
msubnum=size(m.regulatorexpress{1,i},1);    
subnum=size(assign{1,i},2);
f=[];
condition=[];

data=[];
    x_ticks=[];
    group_gap_poses=[];
    temp=0;
for j=1:subnum
    data=assign{1,i}(1,j).data;
    f=[f,data(2:end,3:end)];
    regulator=assign{1,i}(1,j).regulator;
    condition=[condition assign{1,i}(1,j).conditions];
    x_ticks=[x_ticks,assign{i}(j).data(1,3:end)];
    temp=temp+size(assign{i}(j).data,2)-2;
    group_gap_poses=[group_gap_poses,temp];
end
    group_gap_poses_start=[1,group_gap_poses+1];     
datalabel=[datalabel;data(2:end,1:2)];
%h=image(f,'CDataMapping','scale');
%F=round((f-min_value)/(max_value-min_value)*63+1);
%h=image(F,'CDataMapping','direct');

% min_v=min(min(DataSy(:,2:end)));
% max_v=max(max(DataSy(:,2:end)));
D=DataSy(:,2:end);
 min_v=quantile(D(:),0.05);
 max_v=quantile(D(:),0.95);

h=image([1+squarelength/2,1+squarelength*(size(f,2)-0.5)],[500,900],f,'cDataMapping','scale');
caxis([min_v,max_v]);
hold on;

for k=1:(msubnum-1)
%     a=m.regulatorexpress{1,i}(k+1,find(m.regulatorexpress{1,i}(k+1,:)~=0));
%     star=find(m.regulatorexpress{1,i}(k+1,:)~=0); 
%     star=star-1;
%     gap_pos=[find(ismember(star,group_gap_poses)),length(star)+1];
%     for ni=1:length(gap_pos)-1
%         star_t{ni}=star(gap_pos(ni):gap_pos(ni+1)-1);
%         a_t{ni}=a(gap_pos(ni):gap_pos(ni+1)-1);
%     end
%     
%     hh=s.regu2{1,i}(find(s.regu2{1,i}(:,1)==a(1,1)),2);
%     if size(hh,1)>1
%         i
%     end
%m.regulatorexpress{1,i}(k+1,2:end);
    nz=1;
    for ni=1:size(res(i).R,1)
        exp_t=[];
        for nj=res(i).T(ni,1):res(i).T(ni,2)
            exp_t=[exp_t,assign{i}(nj).data(1,3:end)-1];
        end
        exp_t=DataSy(DataSy(:,1)==res(i).R(ni),exp_t);
        
        high=150*(res(i).T(ni,3)-0.5);
        move_h=(-1)^nz*35;
        high=high+move_h;
        x_start=squarelength*(group_gap_poses_start(res(i).T(ni,1))-0.5);
        x_stop=squarelength*(group_gap_poses(res(i).T(ni,2))-0.5);
        image([x_start,x_stop],[high,(high+bar_height)],exp_t,'cDataMapping','scale');
        axis([0,width,0,1000]);
        caxis([min_v,max_v]);
        
        text(x_start+(x_stop-x_start-lengthoftext)/2,high-35,regulatorname{regulatorid==res(i).R(ni)});%num2str(a(1,1))
        
        tfnetwork=[tfnetwork;i res(i).R(ni)];
        
        nz=nz+1;

        axis off;
        colorbar;
    end
    
    for ni=1:length(x_ticks)
        text((ni-0.75)*squarelength,950,int2str(x_ticks(ni)));
    end

end;
%H=getimage(h);
%IMWRITE(H,['pic',num2str(i),'.jpeg'],'jpeg');
saveas(gcf, ['pic',num2str(i),'.jpeg'], 'jpeg');
hold off;
end;