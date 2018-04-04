close all; clear;

[x, Fs] = readfile('IQ_2short.wav');
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

[res1, res2] = CRC16(bytes);