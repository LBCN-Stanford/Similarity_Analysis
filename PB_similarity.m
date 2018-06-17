% Pixel base physical similarity

% clear ;clc


impath='/Users/sina/Documents/Data/ECoG/Animal_data/allstim2/';
Stnum = 275;


%% Calculate mean luminance

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
    Idat(:,:,ii) = imread (strcat(impath,imname));
    Imlum(ii) = mean2(Idat(:,:,ii));
    Idat_vect(ii,:) = reshape(Idat(:,:,ii),305*304,1);
end


%% Significancy for mean luminance

% load('/Users/labuser/Documents/Data/ECoG/Animal_data/RDM_face.mat');
group = {'Human_F','Mammal_F','Bird_F','Marine_F','nonface','nonface','nonface','nonface','nonface','nonface','nonface'};
Imlum1 = reshape(Imlum,25,11);
Imlum1 = Imlum1(:,[7,1,3,5,8,2,4,6,10,9,11]);
[p1,tbl,stats] = anova1(Imlum1,group,'off');
% [p1,tbl,stats] = anova1(Imlum1,[],'off');
muco = multcompare(stats,'Display','off');
% lu_simmat = squareform(pdist(Imlum1','euclidean'));
% lu_simmat = lu_simmat([7,1,3,5,8,2,4,6,10,9,11],[7,1,3,5,8,2,4,6,10,9,11]);

[Slum, Ilum] = sort(Imlum);
RDMp_face_lum = RDMp_face(Ilum,Ilum);


sidif = find(muco(:,6)<0.05);
in=1; Sel = [];
for i=sidif'
    c1 = Anim_name(muco(i,1),0);
    c2 = Anim_name(muco(i,2),0);
    Sel{in} = [c1,' sig. different from ',c2];
    in=in+1;
end



%% Luminance control analysis

% Probally V1 electrodes; pt 86(PTS1=45, PTS2=46) ;  pt 91(PT2=98)

% load('/Users/labuser/Documents/Data/ECoG/Animal_data/elec_stim_face.mat');
% load('/Users/labuser/Documents/Data/ECoG/Animal_data/elec_stim_act.mat');

 facelum = Imlum1(:,1:4);
 nonfacelum = Imlum1;
 nonfacelum(:,1:4) = nan;
 
elec_face_face1 = elec_stim_face1(:,facelum<120);
elec_face_face2 = elec_stim_face1(:,facelum>120);

elec_face_face3 = elec_stim_face1(:,facelum>120 & facelum<180);
elec_nonface_face3 = elec_stim_face1(:,nonfacelum>120 & nonfacelum<180);
en = size(elec_stim_face1);

pl= nan(en(1),2);
for e = 1:en(1)
%    pl(e,1) =  ranksum(elec_face_face1(e,:), elec_face_face2(e,:));
%    pl(e,2) =  ranksum(elec_face_face3(e,:), elec_nonface_face3(e,:));
   
   pl(e,1) =  meanperm(elec_face_face1(e,:), elec_face_face2(e,:),10000);
   pl(e,2) =  meanperm(elec_face_face3(e,:), elec_nonface_face3(e,:),10000);
   
end
pl=round(pl,3);

%%
figure;h1=histogram(nonfacelum);h1.Normalization='probability'; h1.BinWidth = 10; xlim([20 240]);
figure;h2=histogram(facelum);h2.Normalization='probability'; h2.BinWidth = 10; xlim([20 240]);



   
%% Calculating pixel based distance

for i = 1:Stnum-1
    for j = i+1:Stnum
        Sidx(i,j) = sum(sum(abs(Idat(:,:,i) - Idat(:,:,j)).^2));
        Lidx(i,j) = abs(mean2(Idat(:,:,i))-mean2(Idat(:,:,j)));
        Sidx(j,i) = Sidx(i,j);
        Lidx(j,i) = Lidx(i,j);
    end
end
pb_simmat = sqrt(Sidx);

pb_corr = pdist(Idat_vect,'correlation');
pb_corr = ((tiedrank(pb_corr)-1)/(length(pb_corr)-1))*100;
pb_corr = squareform(pb_corr);


pb_RDM = pb_simmat([(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)],...
    [(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);

pb_corr = pb_corr([(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)],...
    [(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);

lu_RDM = Lidx([(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)],...
    [(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);
     


%% RDM plot

figure;imagesc(pb_RDM);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
% set (gca,'TickDir','out','XTick',[13 38 63 88 113 138 163 188 213 238 263],'XTickLabel',{'animal_F','animal_B','bird_F','bird_B','fish_F','fish_B','human_F','human_B','object','place','limb'},'XTickLabelRotation',90,...
%     'YTick',[13 38 63 88 113 138 163 188 213 238 263],'YTickLabel',{'animal_F','animal_B','bird_F','bird_B','fish_F','fish_B','human_F','human_B','object','place','limb'});
% colormap(jet);
load ('JColormap.mat');
mycmap = mycmap(end:-1:1,:);
colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
    set (gca,'TickDir','out','XTick',[13 38 63 88 113 138 163 188 213 238 263],'XTickLabel',{'Human_F','Mammal_F','Bird_F','Marine_F','Human_B','Mammal_B','Bird_B','Marine_B','Place','Object','Limb'},...
        'XTickLabelRotation',90,'YTick',[13 38 63 88 113 138 163 188 213 238 263],'YTickLabel',{'Human_F','Mammal_F','Bird_F','Marine_F','Human_B','Mammal_B','Bird_B','Marine_B','Place','Object','Limb'});
%  set (gca, 'XTickLabels',{}, 'YTickLabels',{});
%     title(['Time: ',num2str(-100+(tti*50))]);


figure;imagesc(pb_corr);colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
set (gca,'TickDir','out','XTick',[13 38 63 88 113 138 163 188 213 238 263],'XTickLabel',{'Human_F','Mammal_F','Bird_F','Marine_F','Human_B','Mammal_B','Bird_B','Marine_B','Place','Object','Limb'},...
    'XTickLabelRotation',90,'YTick',[13 38 63 88 113 138 163 188 213 238 263],'YTickLabel',{'Human_F','Mammal_F','Bird_F','Marine_F','Human_B','Mammal_B','Bird_B','Marine_B','Place','Object','Limb'});


figure;imagesc(RDM_resplum);colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');


figure;imagesc(RDM_nov1);colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');

return;
    

%% MDS

opts = statset('MaxIter',1000);
scrsz = get(0,'ScreenSize');
[Ymds,stress] = mdscale(pb_simmat,2);

tita = ('MDS_pb');
figure('Position',[1 1 scrsz(3)*4/6 scrsz(4)]);
PlotMDS_animal(Ymds,tita);

% getImII_anim2(Ymds/1000,tita,impath);

