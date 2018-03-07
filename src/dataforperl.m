function [moduledata]=dataforperl(Assigndata14con7level2)

moduledata=[];
for i=1:size(Assigndata14con7level2,2)
    i
moduledata=[moduledata;Assigndata14con7level2{1,i}(1,1).data(2:end,1:2)];
end;