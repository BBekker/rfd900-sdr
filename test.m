close all; clear;

[x, Fs] = readfile('IQ_2short.wav');
t = linspace(0,length(x)/Fs, length(x))';

%offset = -250000;
offset = -150000;
channelspacing = 200000;


s = exp(-1i * pi * 2 * offset * t);
x = x .* s;

%mySpectrogram(x,Fs,1028,0);

spectrogram(x,1024)
figure

[b,a] = butter(4,2*channelspacing / Fs);
x_f = filter(b,a,x);

x_r = resample(x_f, 4*channelspacing, Fs);

Fs2 = Fs /( Fs / (4*channelspacing))


%mySpectrogram(x_r,Fs2,8,0);

peak1 = fdesign.peak('N,F0,Q',2,channelspacing/Fs2,100);
p1 = design(peak1,'SystemObject',true);

peak2 = fdesign.peak('N,F0,Q',2,-1*channelspacing/Fs2,100); 
p2 = design(peak2,'SystemObject',true);

x1 = p1(x_r);
x2 = p2(x_r);

t2 = linspace(0,length(x1)/Fs2, length(x1));


x3 = resample(x_r, Fs, 4*channelspacing);
%plot(linspace(0,1,length(x3)),real(x3), linspace(0,1,length(x3)), imag(x3));
%plot(linspace(0,1,length(x3)),atan2(imag(x3),real(x3)));
%plot(t2,x_r)

[u,i,o] = spectrogram(x_r,2);
%mySpectrogram(x_r,Fs2, 3,0);

%mySpectrogram(x2,Fs2, 258,0);

y = abs(sum(u(1:120,:))) - abs(sum(u(135:256,:)));
y_0 = [y 0];
y_1 = [0 y];

period = Fs2 / 128e3;
crossings = sign(y_0) ~= sign(y_1) | y_0 == 0;
positions = find(crossings);

res = []
for i = 1:length(positions)-1
    length = positions(i+1) - positions(i);
    bits = round(length / period,0);
    res = [res ones(1,bits)*y(floor(mean(positions([i, i+1]))))>0];
end
    

plot(t2,y_0./2)
ylim([-10, 10]);

%res = y(mod(t2(1:end-1).*128e3+0.4,1) <= 0.15) > 0;
%figure;
%plot(t,real(x_f),t,imag(x_f))


