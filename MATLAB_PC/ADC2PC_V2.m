% 22/08/2022 
% main code project ADC to PC 
% 1Mbuad UART / 3 ADC ,12bit : ~15Khz sample frequency for 1 ADC
clear all;
close all;
samples = 20; 
device = serialport("COM9",1000000);
device.StopBits = 2;
device.Timeout = 0.5;

time = 1:1:samples; 
i = 1;
channel_0 = zeros(1,samples,'uint16');
channel_1 = zeros(1,samples,'uint16');
channel_2 = zeros(1,samples,'uint16');

f1 = figure;    

xlim([0 samples]);
ylim([0 5000]);
axis_x = [];
axis_y = [];

while 1
    
    write(device,240,"uint8");% synchronize UART data
    x = read(device,samples*3,"uint16");% data in ADC 12bit 
    
    if isempty(x) % wait for data from UART
        continue;
    end
    
    
    axis_x = [];
    axis_y = [];
    axis_y1 = [];
    axis_y2 = [];

    s = samples;
    i = 1;
    for c = 1:s
        if i > samples*3
            delete(p1);
            delete(p2);
            delete(p3);
            drawnow;
            break; % exit from loop for 
        else
            
            channel_0(1,c) = x(i);
            channel_1(1,c) = x(i+1);
            channel_2(1,c) = x(i+2);
            axis_x = [axis_x time(c)];
            axis_y = [axis_y channel_0(1,c)];
            axis_y1 = [axis_y1 channel_1(1,c)];
            axis_y2 = [axis_y2 channel_2(1,c)];
            subplot(3,1,1);
            p1 = plot(axis_x,axis_y);
            xlim([0 samples]);
            ylim([0 5000]);
            subplot(3,1,2);
            p2 = plot(axis_x,axis_y1);
            xlim([0 samples]);
            ylim([0 5000]);
            subplot(3,1,3);
            p3 = plot(axis_x,axis_y2);
            xlim([0 samples]);
            ylim([0 5000]);
            i = i + 3;
        end 
    
    end   
   
   pause(0.1);
   flush(device); % clear UART buffer 
end 





