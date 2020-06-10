%%% ��δ����Ǵ������ҵģ���ȡfeko2017��ffe�ļ���
%%%%�����feko7.0��ffeע�����һ�¶�ȡ�ļ���������ʼλ��
%%% ����Ľ���ֱ���theta����ĵ糡Et,�Լ�phi����糡Ep

function  read_ffe17(pol,num_sam)
% Description: read  the *.ffe  file of Feko situ. 7.
% Input parameters:
%          num_sam - the number samples in frequency, elevation, and
%          azimuth:  [Ne,Na,Nf]              Ƶ�� �߶� ��λ�ǲ�������
%          pol_type - polarized type,{'H','V'} ��������
% Created: Yong-Chen, Li.
% Date: May 20, 2015.

[FileName,PathName]   = uigetfile('*.ffe', 'Select the FEKO data file to open'); %ѡ���ļ�
fid = fopen([PathName,FileName], 'r');  %fopen()�Ǹ������ݰ�ָ����ʽ���뵽matlab�еĺ���
FileName = strtok(FileName,'.');    %������������������ȡ�ַ�����ĳ�ַ����ַ�������ȡ�������Ǹ�����delimiter(.)

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
%fgets:���ļ��ж�ȡ�У��������з� (���з��ͻس���)
%sscanf:��һ���ĸ�ʽ���ַ����ж�ȡ���ַ�
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

%%% feko7.0��ffe�����
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




% reshape:B = reshape(A,m,n),����һ��m*n�ľ���B�� B��Ԫ���ǰ��д�A�еõ��ġ�
% ���A��Ԫ�ظ���û��m*n���� �����������
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
