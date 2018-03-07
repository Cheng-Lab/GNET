function [datalabel] =modulepicture(assign)
load ourcolormap;
colormap(ourcolormap);
% max_value=10;
%min_value=-10;
colormapeditor
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
num=size(assign,2);
datalabel=[];
for i=1:num
subnum=size(assign{1,i},2);
f=[];
condition=[];

data=[];
regulator=[];
for j=1:subnum
    data=assign{1,i}(1,j).data;
    f=[f,data(2:end,3:end)];
    regulator=assign{1,i}(1,j).regulator;
    condition=[condition assign{1,i}(1,j).conditions];
end
datalabel=[datalabel;data(2:end,1:2)];
%h=image(f,'CDataMapping','scale');
%F=round((f-min_value)/(max_value-min_value)*63+1);
%h=image(F,'CDataMapping','direct');
h=image(f,'cDataMapping','scale');
caxis([-10,10]);
H=getimage(h);

IMWRITE(H,['pic',num2str(i),'.jpeg'],'jpeg');
saveas(gcf, ['pic',num2str(i),'.fig'], 'fig')
end;