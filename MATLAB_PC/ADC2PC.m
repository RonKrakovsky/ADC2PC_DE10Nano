clear all
% device = serialport("COM9",9600)
% device.StopBits = 2

% data16bit = cannel[15..12] / data[11..0]
% x = read(device,7,"uint8")
% channel = fix(x/2^12)
% data = x - channel*2^12
x = [224,47,224,15,224,31,224]
number=zeros(1,3)
channel_test = fix(x(1)/2^4)
if (x(1,1) == 0) || (x(1,1) == 1) || (x(1,1) == 2)
    number(1) = x(1)*2^8 + x(2)
    number(2) = x(3)*2^8 + x(4)
    number(3) = x(5)*2^8 + x(6)
else
    number(1) = x(2)*2^8 + x(3)
    number(2) = x(4)*2^8 + x(5)
    number(3) = x(6)*2^8 + x(7)
end



% while channel > 2
%     x = read(device,1,"uint16")
%     channel = fix(x/2^12)
% end 
% 
% if (channel == 0)
%     data_channel_0 = data
% elseif (channel == 1)
%     data_channel_1 = data
% elseif (channel == 2)
%     data_channel_2 = data
% end 


