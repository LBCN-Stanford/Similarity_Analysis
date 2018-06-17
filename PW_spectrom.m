% Images power spectrum plots

clear ;clc

impath='/Users/sina/Documents/Data/ECoG/Animal_data/allstim2/';
Stnum = 275;

%% Compute pixel based similarity matrix

for ii = 1:Stnum
    
    switch numel(num2str(ii))
        case 1
            pre = 'S00';
        case 2
            pre = 'S0';
        case 3
            pre = 'S';
    end
    
    imname = [pre,num2str(ii),'.jpg'];
    I = imread (strcat(impath,imname));
    Idat(:,:,ii) = I(1:304,:); % make the image square and remove 1 extra pixel dimension
    imf = fftshift(fft2(Idat(:,:,ii)));
    impf = abs(imf).^2;
    Pf(:,ii) = rotavg(impf);

end


cl=1;
for st1 = 1:25:275
    Avg_pw(:,cl) = mean(Pf(:,st1:st1+24),2);
    cl = cl+1;
end


[p1,tbl,stats] = anova1(Avg_pw,[],'off');
muco = multcompare(stats,'Display','off');

sidif = find(muco(:,6)<0.05);
in=1;
for i=sidif'
    c1 = Anim_name(muco(i,1));
    c2 = Anim_name(muco(i,2));
    Sel{in} = [c1,' sig. different from ',c2];
    in=in+1;
end
     


%%

f1 = 0:152;
figure;
loglog(f1,Avg_pw);
legend ({'Mammal_F','Mammal_B','Bird_F','Bird_B','Marine_F','Marine_B','Human_F','Human_B','Object','Place','Limb'});

