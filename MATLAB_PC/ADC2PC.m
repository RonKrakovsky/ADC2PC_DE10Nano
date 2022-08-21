clear all;
close all;
device = serialport("COM9",250000);
device.StopBits = 2;
%device.Timeout = 60;

time = 1:1:20;
i = 1;
figure;    
hold on;
channel_0 = zeros(1,20,'uint16');
xlim([0 20]);
ylim([0 5000]);
axis_x = [];
axis_y = [];
while 1
    
    write(device,240,"uint8");% synchronize UART data from FPGA
    x = read(device,3,"uint16");% data in ADC 12bit 

    channel_0(1,i) = x(1);
    %channel_1 = x(2);
    %channel_2 = x(3);
    axis_x = [axis_x time(i)];
    axis_y = [axis_y channel_0(i)];
     plot(axis_x,axis_y);
     
     
     if i == 20
         break;
     else
         i = i + 1;
     end 
    
end 





