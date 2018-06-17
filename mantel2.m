function [pp,cc] = mantel2(rd1,rd2,Iter)

cc = corr2(rd1,rd2);
for itr=1:Iter
    ind=randperm(size(rd2,1));
    rd3 = rd2(ind,ind);
    ccr(itr) = corr2(rd1,rd3);
end

if cc >= 0
    pp = (length(find(ccr>cc))+1)/(Iter+1);
elseif cc < 0
    pp = (length(find(ccr<cc))+1)/(Iter+1);
end
