function [tfnet]=draw(DataSy,assign,regulatorid,regulatorname)
tfnet=[];
[sDataSy]=regulaorderbycon(assign);
[m]=smallcodes(sDataSy,DataSy);
res=getLevelOfReg(assign);
tfnet=picmodule(sDataSy,m,assign,regulatorid,regulatorname,res,DataSy)