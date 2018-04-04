close all; clear;

[x, Fs] = readfile('IQ_2short.wav');
%plot(1:length(x), real(x))
haspacket = filtfilt(ones(1,4)./4,1,abs(x)) > 0.2;
length(x)
packets = [];
cnt = 0;
for i=1:length(haspacket)
    if(haspacket(i) == 0)
        if(cnt > 10)
            packets(end,2) = i;
        end
        cnt = 0;
    else
        cnt = cnt + 1;
    end
    if(cnt == 10) 
        packets = [packets; i 0];
    end
end


for i = 1:size(packets,1)
    if packets(i,2) - packets(i,1) > 1000
        bytes = decodepacket(x(packets(i,1):packets(i,2)),Fs)
    end
end

% for i = 1:length(bytes)
%     dec2bin(bytes(i))
% end

check = [0:9];

check2 = bytes(1:21);

% crcpacket = [header3 header2 bytes]
% 
% [one, two] = CRC16(crcpacket)
% 
% check = [crcpacket one two]
% 
%  [one1 two2] = CRC16(check2)
%  
%  check3 = [bytes(1:21) one1 two2]
%  
%  [one1 two2] = CRC16(check3)
 
 checkcrc = comm.CRCDetector([16 15 2 0], 'InitialConditions', [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
 gen = comm.CRCGenerator('x^16+x^15+x^2+1', 'InitialConditions', [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1], 'DirectMethod', 0);
 
 si = [99];
 si2 = transpose(si);
 
 [test99, test98] = CRC16(si)
 
 sires = step(gen, si2)
 sirest = char(mat2str(transpose(sires)))
 %decsir = bin2dec(sirest)
 testd = '1001'
 tests = bin2dec('1001')
 
 [~, errt] = step(checkcrc, sires)
 
 
 
 bits2 = arrayfun(@(x) dec2bin(x,8), bytes(1:21),'UniformOutput',false)
 
 bits22 = arrayfun(@(x) dec2bin(x,8), bytes,'UniformOutput',false)
 
 bits3 = cell2mat(bits2)
 
 bits33 = cell2mat(bits22)
 
 bits4 = double(bits3(:)'-'0')
 bits44 = double(bits33(:)'-'0')
 
 A = transpose(bits4);
 AA = transpose(bits44);
 
 comp = step(gen, A);

 [~,err] = step(checkcrc, AA)
 
 msg = randi([0 1],12,1)
 
gen = comm.CRCGenerator([16 12 5 0]);
codeword = step(gen,msg);

[~,err2] = step(checkcrc, codeword)
