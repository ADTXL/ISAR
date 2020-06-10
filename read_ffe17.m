%%% 这段代码是从网上找的，读取feko2017的ffe文件。
%%%%如果是feko7.0的ffe注意更改一下读取文件行数的起始位置
%%% 输出的结果分别是theta方向的电场Et,以及phi方向电场Ep

function  read_ffe17(pol,num_sam)
% Description: read  the *.ffe  file of Feko situ. 7.
% Input parameters:
%          num_sam - the number samples in frequency, elevation, and
%          azimuth:  [Ne,Na,Nf]              频率 高度 方位角采样点数
%          pol_type - polarized type,{'H','V'} 极化类型
% Created: Yong-Chen, Li.
% Date: May 20, 2015.

[FileName,PathName]   = uigetfile('*.ffe', 'Select the FEKO data file to open'); %选择文件
fid = fopen([PathName,FileName], 'r');  %fopen()是个将数据按指定格式读入到matlab中的函数
FileName = strtok(FileName,'.');    %函数用于自左向右提取字符串中某字符或字符串，提取的依据是给定的delimiter(.)

    pol = 'V'%('--- Incident polarization {H, V}: ');
%     num_sam = [1,4186,128]%('--- Num. samples of [Elev.,Azim.,Freq.]: ');
    num_sam = [1,150,150]%('--- Num. samples of [Elev.,Azim.,Freq.]: ');

Ne = num_sam(1);          % Number of elevation samples
Na = num_sam(2);          % Number of azimuth samples
Nf = num_sam(3);          % Number of frequency samples

fname = strtok(FileName,'.');

N = Ne*Na*Nf;
data = zeros(N,9);
j = 1;
%fgets:从文件中读取行，保留换行符 (换行符和回车符)
%sscanf:按一定的格式从字符串中读取出字符
%
for i = 1:N
    while j <=  6 + 12*i
        schar = fgets(fid);
        if j == 6 + 12*i
            data(i,:) = sscanf(schar,'%f',[1,9]);
        end
        j = j+1;
    end
    %     j = j+1;
end

%%% feko7.0的ffe用这个
% for i = 1:N
%     while j <=  6 + 10*i
%         schar = fgets(fid);
%         if j == 6 + 10*i
%             data(i,:) = sscanf(schar,'%f',[1,9]);
%         end
%         j = j+1;
%     end
%     %     j = j+1;
% end




% reshape:B = reshape(A,m,n),返回一个m*n的矩阵B， B中元素是按列从A中得到的。
% 如果A中元素个数没有m*n个， 则会引发错误
% 
if Ne == 1
    E_theta_r = reshape(data(:,3),Na,Nf);           % Real component
    E_theta_i = reshape(data(:,4),Na,Nf);           % Imaginary component
    E_phi_r = reshape(data(:,5),Na,Nf);             % Real component
    E_phi_i = reshape(data(:,6),Na,Nf);             % Imaginary component
else
    E_theta_r = reshape(data(:,3),Ne,Na,Nf);         % Real component
    E_theta_i = reshape(data(:,4),Ne,Na,Nf);         % Imaginary component
    E_phi_r = reshape(data(:,5),Ne,Na,Nf);           % Real component
    E_phi_i = reshape(data(:,6),Ne,Na,Nf);           % Imaginary component
end
E_theta = E_theta_r + 1i*E_theta_i;
E_phi = E_phi_r + 1i*E_phi_i;
if pol == 'H'
    %     phdata = struct(...
    %         'VH',E_theta,...
    %         'HH',E_phi);
    Et = E_theta;
    Ep = E_phi;
    save(fname,'Et','Ep')
else
%         phdata = struct(...
%             'VV',E_theta,...
%             'HV',E_phi);
    Et = E_theta;
    Ep = E_phi;
%     save(['E:\TanXiaolong\ISAR\ISAR_Classification\readdata\F15\',fname],'Et','Ep')
    save(fname,'Et','Ep')
end
% save(fname,'phdata')

fclose(fid);
