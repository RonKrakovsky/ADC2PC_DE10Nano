% x = 1:0.1:25;
% y = sin(x);
% n = numel(x);
% figure
% hold on
% for i = 1:n
%     plot(x(1:i),y(1:i))
%     xlim([0 25])
%     ylim([-1.1 1.1])
%     pause(0.05)
% end
% 
x = 1:1:9;
y = [1,2,3,4,5,6,7,8,9];
figure;
hold on;
axis([min(x) max(x) min(y) max(y)]);
X = [];
Y = [];
for i=1:length(x)
    X = [X x(i)];
    Y = [Y y(i)];
        
    plot(X,Y,'red');
    
    pause(.5);
end