function bytes = decodepacket(x,Fs)
%DECODEPACKET Decode single packet IQ into bytes
%   Detailed explanation goes here
    

t = linspace(0,length(x)/Fs, length(x))';

%offset = -250000;
offset = meanfreq(x,Fs);
channelspacing = 200000;

%%Tune signal

s = exp(-1i * pi * 2 * offset * t);
x = x .* s;

%spectrogram(x,1024)
%%LPF and resample

[b,a] = butter(4,2*channelspacing / Fs);
x_f = filter(b,a,x);
x_r = resample(x_f, 4*channelspacing, Fs);


Fs2 = Fs /( Fs / (4*channelspacing))

t2 = linspace(0,length(x_r)/Fs2, length(x_r))';
%% get bits

res = signaltobits(x_r,Fs2, 0.001);

%% Find Preamble
preamblemask = [0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];
preamblepos = strfind(res, preamblemask)

if(isempty(preamblepos))
    disp('no premable')
    bytes = []
    return
end
preamblestart = preamblepos(1);
preambleend = preamblepos(end) + length(preamblemask) - 1

%plot(linspace(1,length(preamblematch)), preamblematch');

%% Find sync word
%sync code from si1000 datasheet & sik sourcecode
syncword = [0 0 1 0 1 1 0 1 1 1 0 1 0 1 0 0];
syncpos = strfind(res, syncword)
headerstart = syncpos + length(syncword)

%% dewhiten/decode data
% lfsr reverse engineered from output with known cleartext
lfsr = comm.PNSequence('Polynomial',[9 5 0], 'InitialConditions', [0 1 1 1 1 0 0 0 0], 'SamplesPerFrame',8);
cursor = headerstart;
header3 = bi2de(xor(res(cursor:cursor+7), lfsr.step()'),'left-msb')
cursor = cursor + 8;
header2 = bi2de(xor(res(cursor:cursor+7), lfsr.step()'),'left-msb')
cursor = cursor + 8;
packetlen = bi2de(xor(res(cursor:cursor+7), lfsr.step()'),'left-msb')
cursor  = cursor +8;

if( cursor + packetlen*8 > length(res))
    print('packet size error');
end

data = reshape(res(cursor:cursor + packetlen*8 - 1),8, [])';
bytes = zeros(0,size(data,1));
for i = 1 : size(data,1)
    bytes(i) = bi2de( xor(data(i,:),lfsr.step()'),'left-msb');
end




end

