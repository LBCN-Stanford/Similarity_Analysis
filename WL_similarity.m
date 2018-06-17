% Wavelet physical similarity

clear ;clc

% bf=(1:25);bb=(26:50);hf=(51:75);hb=(76:100);af=(101:125);ab=(126:150);
% ff=(151:175);fb=(176:200);ob=(201:225);pl=(226:250);li=(251:275);

impath='/Users/sina/Documents/Data/ECoG/Animal_data/allstim2/';


%% Compute full Wavelet similarity matrix
i =1;
for ii = 1:275
    
    switch numel(num2str(ii))
        case 1
            pre = 'S00';
        case 2
            pre = 'S0';
        case 3
            pre = 'S';
    end
    
    imname = [pre,num2str(ii),'.jpg'];
    Idat = imread (strcat(impath,imname));
    
    [C,S] = wavedec2(Idat,3,'db1');
    B_all(i,:) = C;
    i=i+1;
end

wl_simmat = pdist(B_all);
% wl_simmat = pdist(B_all,'cosine');

wl_simmat = squareform(wl_simmat);


% wl_RDM = wl_simmat([af ab bf bb ff fb hf hb ob pl li],[af ab bf bb ff fb hf hb ob pl li]);
RDM_wavelet = wl_simmat([(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)],...
    [(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);
wl_Corr = 1-wl_RDM;



%% plot

% figure;imagesc(RDM_wavelet);
figure;imagesc(r3);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
% set (gca,'TickDir','out','XTick',[13 38 63 88 113 138 163 188 213 238 263],'XTickLabel',{'animal_F','animal_B','bird_F','bird_B','fish_F','fish_B','human_F','human_B','object','place','limb'},'XTickLabelRotation',90,...
%     'YTick',[13 38 63 88 113 138 163 188 213 238 263],'YTickLabel',{'animal_F','animal_B','bird_F','bird_B','fish_F','fish_B','human_F','human_B','object','place','limb'});
% colormap(jet);
load ('J2Colormap.mat');
mycmap = mycmap(end:-1:1,:);
% mycmap = mycmap(64:-1:1,:); %Inverse the colormap
colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
set (gca,'TickDir','out','XTick',[13 38 63 88 113 138 163 188 213 238 263],'XTickLabel',{'Human_F','Mammal_F','Bird_F','Marine_F','Human_B','Mammal_B','Bird_B','Marine_B','Place','Object','Limb'},...
    'XTickLabelRotation',90,'YTick',[13 38 63 88 113 138 163 188 213 238 263],'YTickLabel',{'Human_F','Mammal_F','Bird_F','Marine_F','Human_B','Mammal_B','Bird_B','Marine_B','Place','Object','Limb'});
%  set (gca, 'XTickLabels',{}, 'YTickLabels',{});
%     title(['Time: ',num2str(-100+(tti*50))]);



% wl_face=wl_RDM([af,bf,ff,hf],[af,bf,ff,hf]);
% figure;imagesc(wl_face);
% set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
% set (gca,'TickDir','out','XTick',[13 38 63 88],'XTickLabel',{'animal_F','bird_F','fish_F','human_F'},'XTickLabelRotation',90,...
%     'YTick',[13 38 63 88],'YTickLabel',{'animal_F','bird_F','fish_F','human_F'});
% colormap(jet);
% set (gcf,'PaperPositionMode','auto');
% set (gca,'DataAspectRatio',[1 1 1]);

return

%% MDS

opts = statset('MaxIter',1000);
scrsz = get(0,'ScreenSize');

%     [Ymds{tti+1},stress] = mdscale(RDM_other{tti+1},2,'criterion','stress','Options',opts);
[Ymds,stress] = mdscale(r3,2);

tita = ('MDS_wavelet');
figure('Position',[1 1 scrsz(3)*4/6 scrsz(4)]);
PlotMDS_animal(Ymds,tita);


% getImII_anim2(Ymds/10000,tita,impath);
