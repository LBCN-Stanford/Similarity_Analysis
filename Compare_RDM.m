% Compare the pairwise values between 2 RDMs

clear; close

load('/Users/labuser/Documents/Data/ECoG/Animal_data/RDM_resp.mat');
load('/Users/labuser/Documents/Data/ECoG/Animal_data/RDM_resplum.mat');
load('/Users/labuser/Documents/Data/ECoG/Animal_data/RDM_pixel.mat');
load('/Users/labuser/Documents/Data/ECoG/Animal_data/RDM_wavelet.mat');


%% Convert RDM values to percentile

r1 = PrctRDM(RDM_resp);
r1l = PrctRDM(RDM_resplum);
r2 = PrctRDM(RDM_pixel);
r3 = PrctRDM(RDM_wavelet);
r1v = PrctRDM(RDM_nov1);


%% Vectorizing the matrix

a1 = r1(itriu(size(r1),1));
a1l = r1l(itriu(size(r1l),1));
a1v = r1v(itriu(size(r1v),1));
% f1 = r1(1:25,1:25);f1 = f1(itriu(size(f1),1));
% f2 = r1(26:50,26:50);f2 = f2(itriu(size(f2),1));
% f3 = r1(51:75,51:75);f3 = f3(itriu(size(f3),1));
% f4 = r1(76:100,76:100);f4 = f4(itriu(size(f4),1));
fa = r1(1:100,1:100);fa = fa(itriu(size(fa),1));
d0 = r1(1:100,101:275);d0 = reshape(d0,size(d0,1)*size(d0,2),1);

a11 = r2(itriu(size(r2),1));
% f11 = r2(1:25,1:25);f11 = f11(itriu(size(f11),1));
% f22 = r2(26:50,26:50);f22 = f22(itriu(size(f22),1));
% f33 = r2(51:75,51:75);f33 = f33(itriu(size(f33),1));
% f44 = r2(76:100,76:100);f44 = f44(itriu(size(f44),1));
faa = r2(1:100,1:100);faa = faa(itriu(size(faa),1));
d00 = r2(1:100,101:275);d00 = reshape(d00,size(d00,1)*size(d00,2),1);

a111 = r3(itriu(size(r3),1));
% f111 = r3(1:25,1:25);f111 = f111(itriu(size(f111),1));
% f222 = r3(26:50,26:50);f222 = f222(itriu(size(f222),1));
% f333 = r3(51:75,51:75);f333 = f333(itriu(size(f333),1));
% f444 = r3(76:100,76:100);f444 = f444(itriu(size(f444),1));
faaa = r3(1:100,1:100);faaa = faaa(itriu(size(faaa),1));
d000 = r3(1:100,101:275);d000 = reshape(d000,size(d000,1)*size(d000,2),1);

c1 = corr(fa,faa,'type','Spearman');
c2 = corr(fa,faaa,'type','Spearman');
c3 = corr(a1,a11,'type','Spearman');
c4 = corr(a1,a111,'type','Spearman');
c5 = corr(a1,a1l,'type','Spearman');



%% Bootstrap
Iter=1000;
[ci, bootstat] = bootci(Iter,{@mycorr,a1,a1l});
zval = mean(bootstat)/std(bootstat);
pval = (1-normcdf(zval,0,1))*2;

%  pcorr(a1,a1l,Iter);


%% PLot percentile RDM

load ('J2Colormap.mat');
mycmap = mycmap(end:-1:1,:);
figure;imagesc(r1);colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
figure;imagesc(r1l);colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
figure;imagesc(r1v);colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
figure;imagesc(r2);colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
figure;imagesc(r3);colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');



%% PLot comparison scatter
b=1;

figure('Position',[0, 0, 700,700]);
set (gca,'DataAspectRatio',[1 1 1]);
hold('on');
scatter(d0,d00,15,[.75 .75 .75],'filled');
scatter(f1,f11,30,[.8 .06 .8]*b,'filled');
scatter(f2,f22,30,[.06 .4 .8]*b,'filled');
scatter(f3,f33,30,[.8 .4 .06]*b,'filled');
scatter(f4,f44,30,[.06 .8 .4]*b,'filled');
line ([0,100],[0,100],'LineStyle','--','color','k','LineWidth',2);
% set (gca,'XTickLabel','','YTickLabel','');
xlim([0 100]);ylim([0 100]);
xlabel('Pairwise distances in neural space');
ylabel('Pairwise distances in physical space (pixel)');
hold('off');



figure('Position',[0, 0, 700,700]);
set (gca,'DataAspectRatio',[1 1 1]);
hold('on');
scatter(d0,d000,15,[.75 .75 .75],'filled');
scatter(f1,f111,30,[.8 .06 .8]*b,'filled');
scatter(f2,f222,30,[.06 .4 .8]*b,'filled');
scatter(f3,f333,30,[.8 .4 .06]*b,'filled');
scatter(f4,f444,30,[.06 .8 .4]*b,'filled');
line ([0,100],[0,100],'LineStyle','--','color','k','LineWidth',2);
% set (gca,'XTickLabel','','YTickLabel','');
xlim([0 100]);ylim([0 100]);
xlabel('Pairwise distances in neural space');
ylabel('Pairwise distances in physical space (wavelet)');
hold('off');




figure('Position',[0, 0, 700,700]);
set (gca,'DataAspectRatio',[1 1 1]);
hold('on');
scatter(d00,d000,15,[.75 .75 .75],'filled');
scatter(f11,f111,30,[.8 .06 .8]*b,'filled');
scatter(f22,f222,30,[.06 .4 .8]*b,'filled');
scatter(f33,f333,30,[.8 .4 .06]*b,'filled');
scatter(f44,f444,30,[.06 .8 .4]*b,'filled');
line ([0,100],[0,100],'LineStyle','--','color','k','LineWidth',2);
% set (gca,'XTickLabel','','YTickLabel','');
xlim([0 100]);ylim([0 100]);
xlabel('Pairwise distances in physical space (pixel)');
ylabel('Pairwise distances in physical space (wavelet)');
hold('off');

