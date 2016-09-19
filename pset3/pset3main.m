function pset3main

LMS_File = load('LMSResponse.mat');
CIE_File = load('CIEMatch.mat');
T_File = load('CIE2RGB.mat');

%Problem 1a(i)
RGBMatch = T_File.T*CIE_File.CIEMatch;
%Problem 1a(ii)
P_RGB = pinv(RGBMatch);
%Problem 1a(iii)
P_XYZ = pinv(CIE_File.CIEMatch);
%Problem 1b
LMS_File.LMSResponse(isnan(LMS_File.LMSResponse)) = 0;
P_LMSR = pinv(LMS_File.LMSResponse);

%RBG extract from matrices
r1 = RGBMatch(1,:);
g1 = RGBMatch(2,:);
b1 = RGBMatch(3,:);

r2 = CIE_File.CIEMatch(1,:);
g2 = CIE_File.CIEMatch(2,:);
b2 = CIE_File.CIEMatch(3,:);

r3 = P_RGB(:,1);
g3 = P_RGB(:,2);
b3 = P_RGB(:,3);

r4 = P_XYZ(:,1);
g4 = P_XYZ(:,2);
b4 = P_XYZ(:,3);

r5 = P_LMSR(:,1);
g5 = P_LMSR(:,2);
b5 = P_LMSR(:,3);

%Wavelength range
x = 360:5:730;

figure
plot(x,r1, 'r'); hold on;
plot(x,g1, 'g'); hold on;
plot(x,b1, 'b'); hold on;
xlabel('x: wavelength (nm)');
ylabel('y: value');
title('\fontsize{16}Color matching functions RGB');

figure
plot(x,r2, 'r'); hold on;
plot(x,g2, 'g'); hold on;
plot(x,b2, 'b'); hold on;
xlabel('x: wavelength (nm)');
ylabel('y: value');
title('\fontsize{16}Color matching functions CIE');

figure
plot(x,r3, 'r'); hold on;
plot(x,g3, 'g'); hold on;
plot(x,b3, 'b'); hold on;
xlabel('x: wavelength (nm)');
ylabel('y: value');
title('\fontsize{16}Primaries to RGB');

figure
plot(x,r4, 'r'); hold on;
plot(x,g4, 'g'); hold on;
plot(x,b4, 'b'); hold on;
xlabel('x: wavelength (nm)');
ylabel('y: value');
title('\fontsize{16}Primaries to XYZ');

figure
plot(x,r5, 'r'); hold on;
plot(x,g5, 'g'); hold on;
plot(x,b5, 'b'); hold on;
xlabel('x: wavelength (nm)');
ylabel('y: value');
title('\fontsize{16}Primaries to LMSR');
