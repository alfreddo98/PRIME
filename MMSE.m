% Example MMSE. We choose a 3 tap equalizer
%
  close all; clear; format compact;
%
  fs = 8;   Ts = 1/fs;
  f2 = 0.5;  f3 = 1.8;
  N  = 64;
  t  = 0:Ts:(N-1)*Ts;   
  s  = cos(2*pi*f2*t) + cos(2*pi*f3*t);
  y  = 0.5*cos(2*pi*f2*t) + 1.5*cos(2*pi*f3*t);
%
% Building of vectors yn and sn
  yn = fliplr(y);   sn = fliplr(s);
%
% Matrix Ry: 3x3 
  Ry0  = mean(yn.*yn);
  yn_1 = yn(2:N); 
  yn_2 = yn(3:N);  
  Ry1  = mean(yn(1:N-1).*yn_1);
  Ry2  = mean(yn(1:N-2).*yn_2);
%  
  Ry = [Ry0 Ry1 Ry2; Ry1 Ry0 Ry1; Ry2 Ry1 Ry0]
%
% Matrix Rsy: 3x1 
  Rsy0 = mean(sn.*yn);
  Rsy1 = mean(sn(1:N-1).*yn_1);
  Rsy2 = mean(sn(1:N-2).*yn_2);
%
  Rsy = [Rsy0 Rsy1 Rsy2]'
  Ryinv=inv(Ry);
  W=Ryinv*Rsy;
  yeq=conv(y,W);
    Y=fft(y,64)/64;
    Y=abs(Y);
    Y=Y(1:end/2+1)
    S=fft(s,64)/64;
    S=abs(S);
    S=S(1:end/2+1)
    Yeq=fft(yeq)/64;
    Yeq=abs(Yeq);
    Yeq=Yeq(1:end/2)
    f=0:fs/64:fs/2;
    figure
    subplot(3,1,1)
    plot(f,S);
    subplot(3,1,2)
    plot(f,Y);
    subplot(3,1,3)
    plot(f,Yeq);