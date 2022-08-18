clear all;
device = serialport("COM9",9600);
device.StopBits = 2;
device.Timeout = 60;

time = 1:1:100;
i = 1;
while 1
    
    write(device,240,"uint8");% synchronize UART data from FPGA
    x = read(device,3,"uint16");% data in ADC 12bit 

    channel_0 = x(1);
    channel_1 = x(2);
    channel_2 = x(3);
    
    figure;
    hold on;
    plot(x(1:i),channel_0);
    xlim([0 100]);
    ylim([0 4096]);
    
    if i == 100
        i = 1;
    else
        i = i + 1;
    end 
    
end 





