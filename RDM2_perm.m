% Permutation for RDM


function [pval, cc] = RDM2_perm(RDM1,RDM2,d1,d2,Iter)

vRDM1 = squareform(RDM1);
vRDM2 = squareform(RDM2);

ci = nan(Iter,1);
if length(d1)==length(d2)
    aa = RDM1(d1,d2);aa = aa(itriu(size(aa),1));
    ab = RDM2(d1,d2);ab = ab(itriu(size(ab),1));
else
    aa = RDM1(d1,d2);aa = reshape(aa,size(aa,1)*size(aa,2),1);
    ab = RDM2(d1,d2);ab = reshape(ab,size(ab,1)*size(ab,2),1);
end

cc = (mean(aa)-mean(ab));

for b_idx=1:Iter
    mtr1 = randi([1 length(vRDM1)],1,length(aa));
    mtr2 = randi([1 length(vRDM2)],1,length(ab));
    ci1 = mean(vRDM1(mtr1));
    ci2 = mean(vRDM2(mtr2));
    ci(b_idx)= (ci1-ci2);
end

crlist = sort(ci(:));
if cc > 0
    pval = (length(find(crlist>=cc))+1)/(Iter+1);
else
    pval = (length(find(crlist<=cc))+1)/(Iter+1);
end
