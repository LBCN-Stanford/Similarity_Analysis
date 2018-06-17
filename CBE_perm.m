% Permutation for Category Boundary Effect (CBE)
% CBE computed by the difference between mean 'cat1/cat1' and 'cat1/cat2'
% dinstaces
% If cbe=1,  Category Boundary Effect will also calculate


function [pval, cc] = CBE_perm(RDM,cbe,cat1,cat2,Iter)

vRDM = squareform(RDM);

if  nargin == 5 && cbe==1
    ci = nan(Iter,1);
    aa = RDM(cat1,cat1);aa = aa(itriu(size(aa),1));
    ab = RDM(cat1,cat2);ab = reshape(ab,size(ab,1)*size(ab,2),1);
%     vRDM = [aa;ab];
    cc = abs(mean(aa)-mean(ab));
    for b_idx=1:Iter
        mtr1 = randi([1 length(vRDM)],1,length(aa));
        mtr2 = randi([1 length(vRDM)],1,length(ab));
        ci1 = mean(vRDM(mtr1));
        ci2 = mean(vRDM(mtr2));
        ci(b_idx)= abs(ci1-ci2);
    end
    crlist = sort(ci(:));
    
elseif nargin == 5 && cbe==0
    ci = nan(Iter,1);
    ab = RDM(cat1,cat2);ab = reshape(ab,size(ab,1)*size(ab,2),1);
    cc = mean(ab);
    for b_idx=1:Iter
        mtr1 = randi([1 length(vRDM)],1,length(ab));
        ci(b_idx)= mean(vRDM(mtr1));
    end
    crlist = sort(ci(:));

elseif nargin == 4
    Iter=cat2; ci = nan(Iter,1);
    aa = RDM(cat1,cat1);aa = aa(itriu(size(aa),1));
    cc = mean(aa);
    for b_idx=1:Iter
        mtr1 = randi([1 length(vRDM)],1,length(aa));
        ci(b_idx)= mean(vRDM(mtr1));
    end
    crlist = sort(ci(:));
end
   
pval = (length(find(crlist>=cc))+1)/(Iter+1);


