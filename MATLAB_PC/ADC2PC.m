clear all;
close all;
% device = serialport("COM9",1000000);
% device.StopBits = 2;
%device.Timeout = 60;

time = 1:1:10;
i = 1;
channel_0 = zeros(1,10,'uint16');
f1 = figure;    
hold on;
xlim([0 10]);
ylim([0 5000]);
axis_x = [];
axis_y = [];

while 1
    device = serialport("COM9",1000000);
    device.StopBits = 2;
    
    write(device,240,"uint8");% synchronize UART data from FPGA
    x = read(device,30,"uint16");% data in ADC 12bit 
    axis_x = [];
    axis_y = [];

    
    
    s = 10;
    i = 1;
    for c = 1:s
        if i > 30
            drawnow;
            break;
        else
            
            channel_0(1,c) = x(i);
            axis_x = [axis_x time(c)];
            axis_y = [axis_y channel_0(1,c)];
            p1 = plot(axis_x,axis_y);
            i = i + 3;
        end 
    
    end
   %clf;
   
   
   pause(1);
   f1 = clf('reset');
   delete(device);
  % flush(device);
end 





