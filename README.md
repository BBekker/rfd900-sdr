# rfd900-sdr

Files:

  -test.m Main file which reads the input file
  -decodepacket.m function that decodes single packet IQ into bytes
  -CRC16.m attempt to make the CRC check work, outputs last 2 byts that would be appended to a packet
  
  To run, just run the test.m file which will output all the packets in the input file to bytes in the terminal.
  To see intermediate results remove the semicolon from a line.
