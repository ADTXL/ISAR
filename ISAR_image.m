function Isar_image
global Xx Yy Aimg
% c=300;
[fname,pname] = uigetfile('*','Open ISAR 2d data');
if ischar(pname)
  filename=strcat(pname,fname);
end

% current_filename=fname;
%%%%%%% 变量定义
freqstart = 10;
freqstop = 11;
phi_span = 5.43;
theta = 70;
c=300;
load(filename,'-mat')
%load('FResults-F15.mat')


freq = (freqstart+freqstop)/2; % 中心频率 GHz
BW = (freqstop-freqstart)*1000; % 带宽 MHz
lamda=0.3/freq;
span_phi = abs(phi_span); % 角度范围

[m,n]=size(Et);
rcs=4*pi*(Et+Ep);
%rcs=4*pi*(Et);
Nfreq=n;
Nphi=m;

window=win2d(m,n);
rcs=rcs.*window;
rcst=ifft2(rcs);
Arcst=abs(rcst);
[m,n]=size(Arcst);

% Aimg=zeros(m,n);
% Aimg=fftshift(circshift(Arcst,[1,1150])); % ddg
% Aimg=fftshift(circshift(Arcst,[240,1]));% carrier_russia
Aimg=fftshift(Arcst);
Aimg=10*log10(Aimg);

t=1:n;
t=t/BW;
x=c.*t/2;
x=x-max(x)/2;
x=x/cos((90-theta)*pi/180); %地面投影
yy=1:m;

crossjl=(yy-1)*lamda/(2*sin(span_phi*pi/180)); %横向分辨率,单基地
% crossjl=(yy-1)*lamda/(2*sin(span_phi*pi/360)); %横向分辨率,双基地
maxcr=max(crossjl);
y=crossjl-maxcr/2;
y=y/cos((90-theta)*pi/180); %地面投影

[Xx,Yy]=meshgrid(x,y);

% h_fig = figure('Name','Post ISAR',...
%        'NumberTitle','off','renderer','Painters', ...
%        'Position',[150 100 1050 600]);
% axes('position',[.08  .1  .76  .85]);

colormap(jet)
pcolor(Xx,Yy,Aimg);
% pcolor(Aimg);
shading interp

set(gca,'Title',text( 'FontSize',16,'Color','k','string','ISAR 2D-Image'))
ylabel('Cross Range (m)','FontSize',16,'Color','b');
xlabel('Range (m)','FontSize',16,'Color','b');

cmax=max(max(Aimg));
%cmax=0;
cmin=cmax-35;
caxis([cmin cmax])
colorbar
axis equal








