function [windows2d]=win2d(m,n)
%m=101;n=128;
window1=window(@blackmanharris,m);
window2=window(@blackmanharris,n);
mat1=ones(1,n);
winmat1=window1*mat1;
mat2=ones(m,1);
winmat2=mat2*(window2');
windows2d=winmat1.*winmat2;
