% Correlation matrix, RDM, Clustering using Jessica every face-selctive sites.
clear; clc

base_path = '/Users/sina/Documents/data/ECoG/Animal_data/';

datafil = {'HighGammartf_aeMfffdspm8_iEEGS14_62_60.mat';'HighGammartf_aeMfffdR_spm8_iEEGS14_64_SP_23.mat'; 'HighGammartf_aeMfffdspm8_iEEGS14_66_CZ_05.mat'; ...
    'HighGammartf_aeMfffdspm8_iEEGS14_67_RH_20.mat'; 'HighGammartf_aeMfffdspm8_iEEGS14_70_AP_06.mat'; 'HighGammartf_aeMfffdspm8_iEEGS15_83_RR_46.mat'; ...
    'HighGammartf_aeMfffdspm8_iEEGS15_86_CL_08.mat'; 'HighGammartf_aeMfffECoG_E15-695_0014.mat'};

actvfil = {'Active_S62.mat'; 'Active_S64.mat'; 'Active_S66.mat'; 'Active_S67.mat'; 'Active_S70.mat'; 'Active_S83.mat'; 'Active_S86.mat'; 'Active_S91.mat';};

vtc_elec = {[1:24,34,35,38,39,41,42,45:48,63,64],[1:40,47:52,53:58,65:80],[31,32,38:40,45:48,65:94,97:116],[15:56,65:80],...
    [16,23,24,30:32,38:40,46:48,77:83,97:110],[9:16,25:56,65,66,73,74,81,82,89:91,96:98,104:106,112:114,121:123],...
    [1:29,45:58,81:92,117:122,123:128],[1:32,89:132]};

face_elec ={(20),[2,3,9,10,12,17,34,50,51,52,67,73,74,75,80],[67,70,72,78,110,111,112],[34,35,36,50],[78,80,83,110],[10,12,28,29,35,40,41,53],...
    [17,50,52,53,54,83,84,89],[14,99,100,109,112,129,130]}; %Face_paper

anawin = 450:800;
totpt = size(datafil);
elec_stim_pt = cell(totpt(1),1); act_elec= cell(1,totpt(1)); elec_stim_face=[];elec_stim_act=[];

%%

for pt = 1:totpt(1)
    filnam = cell2mat(datafil(pt,:));
    D = spm_eeg_load([base_path,filnam]);
    load([base_path,'Active/',cell2mat(actvfil(pt,:))]);
    elecn = size(D);
    allcnd = condlist(D);
    elec_stim_time = [];
    act_elec{pt} = setdiff(find(ismember(D.chanlabels, res.sign_chans)==1),face_elec{pt}); % non-face
%     act_elec{pt} = find(ismember(D.chanlabels, res.sign_chans)==1); % All responsive sites

    for ss = 1:length(allcnd)
        sttr = indtrial(D,allcnd(ss));
        elec_stim_time(:,:,ss) = nanmean(D(:,:,sttr),3);
        res_avg = nanmean(elec_stim_time(:,anawin,ss),2);
        elec_stim_pt{pt}(:,ss) = res_avg;
    end
    if pt == 1
        % If only include Pt. 14_62_60
        elec_stim_pt{1}(:,251:275)=nan;
    end
    elec_stim_face = [elec_stim_pt{pt}(face_elec{pt},:); elec_stim_face];
    elec_stim_act = [elec_stim_pt{pt}(act_elec{pt},:); elec_stim_act];
end

nfs = length(cell2mat(face_elec));% number of face sites
nas = length(cell2mat(act_elec));% number of active sites


return

%% Correlation matrix
elec_stim_face2 = elec_stim_face(1:end-length(face_elec{1}),:);
elec_stim_face1 = elec_stim_face(:,[(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);
elec_stim_face2 = elec_stim_face2(:,[(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);
RDM_face_elec1 = squareform(pdist(elec_stim_face1','correlation'));
RDM_face_elec2 = squareform(pdist(elec_stim_face2','correlation'));
RDM_face_elec1(251:end,:) = RDM_face_elec2(251:end,:);
RDM_face_elec1(:,251:end) = RDM_face_elec2(:,251:end);

elec_stim_act2 = elec_stim_act(1:end-length(act_elec{1}),:);
elec_stim_act1 = elec_stim_act(:,[(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);
elec_stim_act2 = elec_stim_act2(:,[(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);
RDM_act_elec1 = squareform(pdist(elec_stim_act1','correlation'));
RDM_act_elec2 = squareform(pdist(elec_stim_act2','correlation'));
RDM_act_elec1(251:end,:) = RDM_act_elec2(251:end,:);
RDM_act_elec1(:,251:end) = RDM_act_elec2(:,251:end);

RDMp_face = PrctRDM(RDM_face_elec1);
RDMp_act = PrctRDM(RDM_act_elec1);

clear RDM_act_elec2 RDM_face_elec2 elec_stim_face elec_stim_act



%% plot corr matrix
% load ('JColormap.mat');
% Cor_elec =1-RDM_face_elec1;
% figure;imagesc(Cor_elec,[-0.5 1]);colormap(mycmap);
% set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
% set (gca, 'XTickLabels',{}, 'YTickLabels',{});
% set (gcf,'PaperPositionMode','auto');
% set (gca,'DataAspectRatio',[1 1 1]);

load ('J2Colormap.mat');
mycmap = mycmap(end:-1:1,:);
figure;imagesc(RDMp_face);colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
set (gca, 'XTickLabels',{}, 'YTickLabels',{});
set (gcf,'PaperPositionMode','auto');
set (gca,'DataAspectRatio',[1 1 1]);

% load ('J2Colormap.mat');
% mycmap = mycmap(end:-1:1,:);
% figure;imagesc(RDM_lum);colormap(mycmap);
% set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
% set (gca, 'XTickLabels',{}, 'YTickLabels',{});
% set (gcf,'PaperPositionMode','auto');
% set (gca,'DataAspectRatio',[1 1 1]);


figure;imagesc(RDMp_act);colormap(mycmap);
% figure;imagesc(RDM_act_elec1);colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
set (gca, 'XTickLabels',{}, 'YTickLabels',{});
set (gcf,'PaperPositionMode','auto');
set (gca,'DataAspectRatio',[1 1 1]);

return

%% Category boundary effect

r1 = RDMp_face;
% r1 = RDMp_act;

[pval, cbe] = CBE_perm(r1,1,(1:100),(101:275),10000)
[pval, cbe] = CBE_perm(r1,1,(1:25),(101:275),10000)
[pval, cbe] = CBE_perm(r1,1,(26:50),(101:275),10000)
[pval, cbe] = CBE_perm(r1,1,(51:75),(101:275),10000)
[pval, cbe] = CBE_perm(r1,1,(76:100),(101:275),10000)


[pval, cbe] = CBE_perm(r1,1,(1:25),(26:50),10000)
[pval, cbe] = CBE_perm(r1,1,(1:25),(51:75),10000)
[pval, cbe] = CBE_perm(r1,1,(1:25),(76:100),10000)
[pval, cbe] = CBE_perm(r1,1,(26:50),(51:75),10000)
[pval, cbe] = CBE_perm(r1,1,(26:50),(76:100),10000)


f11=r1(1:25,1:25); f11=f11(itriu(size(f11),1)); FaFa(1,1)=mean2(f11); FaFa(1,2)=std2(f11);
f12=r1(1:25,26:50); FaFa(2,1)=mean2(f12); FaFa(2,2)=std2(f12);
f13=r1(1:25,51:75); FaFa(3,1)=mean2(f13); FaFa(3,2)=std2(f13);
f14=r1(1:25,76:100); FaFa(4,1)=mean2(f14); FaFa(4,2)=std2(f14);
f22=r1(26:50,26:50); f22=f22(itriu(size(f22),1)); FaFa(5,1)=mean2(f22); FaFa(5,2)=std2(f22);
f33=r1(51:75,51:75); f33=f33(itriu(size(f33),1)); FaFa(6,1)=mean2(f33); FaFa(6,2)=std2(f33);
f44=r1(76:100,76:100); f44=f44(itriu(size(f44),1)); FaFa(7,1)=mean2(f44); FaFa(7,2)=std2(f44);
f23=r1(26:50,51:75); FaFa(8,1)=mean2(f23); FaFa(8,2)=std2(f23);
f24=r1(26:50,76:100); FaFa(9,1)=mean2(f24); FaFa(9,2)=std2(f24);
f34=r1(51:75,76:100); FaFa(10,1)=mean2(f34); FaFa(10,2)=std2(f34);


%% Avergaed correlation matrix
% Cor_elec = RDMp_face;
Cor_elec = RDMp_act;

new_cor = zeros(11,11);
ro = 1;
for st1 = 1:25:275
    cl = 1;
    for st2 = 1:25:275
        mat1 = Cor_elec(st1:st1+24,st2:st2+24);
        if st1 == st2
           mat1 = mat1(itriu(size(mat1),1));
        end
        new_cor(ro,cl) = mean2(mat1);
        cl = cl+1;
    end
    ro = ro+1;
end

load ('J2Colormap.mat');
mycmap = mycmap(end:-1:1,:);
figure;imagesc(new_cor,[0 100]);
% figure;imagesc(new_cor,[0 0.8]);

colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
set (gca, 'XTickLabels',{}, 'YTickLabels',{});
% set (gca,'TickDir','out','XTick',(1:11),'XTickLabel',{'Human_F','Mammal_F','Bird_F','Marine_F','Human_B','Mammal_B','Bird_B','Marine_B','Place','Object','Limb'},...
%     'XTickLabelRotation',90,'YTickLabel',{'Human_F','Mammal_F','Bird_F','Marine_F','Human_B','Mammal_B','Bird_B','Marine_B','Place','Object','Limb'});

% textStrings = num2str(new_cor(:),'%0.2f');  %# Create strings from the matrix values
textStrings = num2str(round(new_cor(:)),'%0.0f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:11);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center','FontWeight','bold');
midValue = mean(get(gca,'CLim'))-45;  %# Get the middle value of the color range
textColors = repmat(new_cor(:) < midValue,1,3);  %# Choose white or black
% textColors(1,:) = 1;
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors


%% MDS
impath = '/Users/sina/Documents/Data/ECoG/Animal_data/allstim/';
[Ymds,stress] = mdscale(RDM_face_elec1,2);
tita = ('MDS_facesite');
getImII_anim2(Ymds,tita,impath);

[Ymds,stress] = mdscale(RDM_act_elec1,2);
titb = ('MDS_activesite');
getImII_anim2(Ymds,titb,impath);



%% Clustering
labels = cell(1,275);

for testl= (1:275)
    labels{testl} = '**********';
end

elec_stim_face1(54,251:275) = elec_stim_face1(53,251:275);
elec_stim_face1(54,251:275) = elec_stim_face1(53,251:275);

% H1C = linkage(elec_stim_face1','average','correlation');
H1C = linkage(elec_stim_act2','average','correlation');

figure; clf
polardendrogram(H1C,labels,0,'colorthreshold', .9);
zoom(0.45); view(2);



%% ROC, face versus other categories
for e = 1:nfs
    pref = elec_stim_face1(e,1:100);
    nonp = elec_stim_face1(e,101:275);
    aucf(e) = ComputeROC(pref', nonp');
end
for e = 1:nas
    pref = elec_stim_act1(e,1:100);
    nonp = elec_stim_act1(e,101:275);
    auca(e) = ComputeROC(pref', nonp');
end

Mf = mean(aucf);
Ma = mean(auca);

[pv h] = ranksum(aucf,auca);
figure;hold on;h2=histogram(auca,10);h1=histogram(aucf,10);
h1.Normalization='probability'; h2.Normalization='probability';
h1.BinWidth = 0.05; h2.BinWidth = 0.05;

xlabel('ROC','FontSize',14,'FontName','Arial');
ylabel('Fraction of cells','FontSize',14,'FontName','Arial');
% text (.4,.7,['Pvalue = ',num2str(roundn(pv,-6))],'Units','Normalized');
line ([Mf,Mf],[0,.5],'LineStyle','--','color','r','LineWidth',2);
line ([Ma,Ma],[0,.5],'LineStyle','--','color','b','LineWidth',2);
% legend_handle = legend(lg1,lg3,'Location','Best');
% set(legend_handle, 'Box', 'off');



