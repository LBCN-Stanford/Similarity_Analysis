
function smoothed = SmoothN(data,sigma)
%sigma = 10;
[m n] = size(data);
if m>n
    data = data';
end

y = normpdf(-1*sigma:1*sigma,0,sigma);
y1 = repmat(y,length(data),1); 
for i=0:sigma
    y1(i+1,1:sigma-i) = 0;
    y1(length(data)-i,end-(sigma-i) +1 :end) = 0;
end
smoothed = conv2(data,y,'same')./sum(y1,2)';
%smoothed = smooth(data,sigma);
end