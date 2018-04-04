function res = signaltobits(x,Fs, noisefloor)

x = x(abs(x) > noisefloor*2);
[u,i,o] = spectrogram(x,2);
y = abs(sum(u(1:128,:))) - abs(sum(u(129:256,:)));
y_0 = [y 0];
y_1 = [0 y];

period = Fs / 128e3;
crossings = sign(y_0) ~= sign(y_1) | y_0 == 0;
positions = find(crossings);

res = [];
for i = 1:length(positions)-1
    len = positions(i+1) - positions(i);
    bits = round(len / period,0);
    res = [res ones(1,bits)*y(floor(mean(positions([i, i+1]))))>0];
end

end