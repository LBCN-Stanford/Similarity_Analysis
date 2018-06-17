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
    [17,50,52,53,54,83,84,89],[14,99,100,109,112,129,130]}; %Face_paper updated

totpt = size(datafil); 
ROL=1;


%% Win check
plotrdm = 0;
strt = 100;nd = 1100;
% wnd=150; shft = 10; 
wnd=100; shft = 10; 
% wnd=50; shft = 10; 
tti=0;resp_time = (strt+(tti*shft):wnd+strt+(tti*shft));
while resp_time(end)< nd
    resp_time = (strt+(tti*shft):wnd+strt+(tti*shft));
    win_chk{tti+1} = [resp_time(1),resp_time(end)];
    tti=tti+1;
end
totwnd = length(win_chk)-1;
% elec_stim_pt = cell(totpt(1),totwnd);

%%
% for pt = 1:totpt(1)
%     disp(pt);
%     filnam = cell2mat(datafil(pt,:));
%     D = spm_eeg_load([base_path,filnam]);
%     elecn = size(D);
%     allcnd = condlist(D);
%     elec_stim_time = [];
%     load([base_path,'Active/',cell2mat(actvfil(pt,:))]);
%     act_elec{pt} = setdiff(find(ismember(D.chanlabels, res.sign_chans)==1),face_elec{pt}); % non-face
% %     elec_stim_time = NaN(elecn(1),elecn(2),length(allcnd));
    
%         for tti = 0:totwnd
%             resp_time = (strt+(tti*shft):wnd+strt+(tti*shft));
%             for ss = 1:length(allcnd)
%                 sttr = indtrial(D,allcnd(ss));
%                 elec_stim_time(:,:,ss) = nanmean(D(:,:,sttr),3);
%                 res_avg = nanmean(elec_stim_time(:,resp_time,ss),2);
%                 elec_stim_pt{pt,tti+1}(:,ss) = res_avg;
%             end
%         end
% end

% for tti = 0:totwnd
%     elec_stim_pt{1,tti+1}(:,251:275)=nan;
% end
% save ('/Users/sina/Documents/Data/ECoG/elec_stim_animal_150.mat','elec_stim_pt');

load('/Users/sina/Documents/data/ECoG/act_elec.mat');
load(['/Users/sina/Documents/data/ECoG/elec_stim_animal_',num2str(wnd),'.mat']);


%% Calculate RDM 
nowin = (length(elec_stim_pt)-1);

for tti = 0:nowin
    
    elec_stim_face1 = [elec_stim_pt{1,tti+1}(face_elec{1},:);elec_stim_pt{2,tti+1}(face_elec{2},:); ...
        elec_stim_pt{3,tti+1}(face_elec{3},:); elec_stim_pt{4,tti+1}(face_elec{4},:);elec_stim_pt{5,tti+1}(face_elec{5},:); ...
        elec_stim_pt{6,tti+1}(face_elec{6},:); elec_stim_pt{7,tti+1}(face_elec{7},:);elec_stim_pt{8,tti+1}(face_elec{8},:)];
    
    elec_stim_face2 = [elec_stim_pt{2,tti+1}(face_elec{2},:); ...
        elec_stim_pt{3,tti+1}(face_elec{3},:); elec_stim_pt{4,tti+1}(face_elec{4},:);elec_stim_pt{5,tti+1}(face_elec{5},:); ...
        elec_stim_pt{6,tti+1}(face_elec{6},:); elec_stim_pt{7,tti+1}(face_elec{7},:);elec_stim_pt{8,tti+1}(face_elec{8},:)];
    
    elec_stim_face1 = elec_stim_face1(:,[(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);
    elec_stim_face2 = elec_stim_face2(:,[(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);
    
    RDM_face_elec1{tti+1} = squareform(pdist(elec_stim_face1','correlation')); % 'correlation' , 'euclidean'
    RDM_face_elec2{tti+1} = squareform(pdist(elec_stim_face2','correlation')); % 'correlation' , 'euclidean'
    RDM_face_elec1{tti+1}(251:end,:) = RDM_face_elec2{tti+1}(251:end,:);
    RDM_face_elec1{tti+1}(:,251:end) = RDM_face_elec2{tti+1}(:,251:end);
    RDM_face_elec1{tti+1} = PrctRDM(RDM_face_elec1{tti+1}); % Convert to percentile rank
    
    elec_stim_act1 = [elec_stim_pt{1,tti+1}(act_elec{1},:);elec_stim_pt{2,tti+1}(act_elec{2},:); ...
        elec_stim_pt{3,tti+1}(act_elec{3},:); elec_stim_pt{4,tti+1}(act_elec{4},:);elec_stim_pt{5,tti+1}(act_elec{5},:); ...
        elec_stim_pt{6,tti+1}(act_elec{6},:); elec_stim_pt{7,tti+1}(act_elec{7},:);elec_stim_pt{8,tti+1}(act_elec{8},:)];
    
    elec_stim_act2 = [elec_stim_pt{2,tti+1}(act_elec{2},:); ...
        elec_stim_pt{3,tti+1}(act_elec{3},:); elec_stim_pt{4,tti+1}(act_elec{4},:);elec_stim_pt{5,tti+1}(act_elec{5},:); ...
        elec_stim_pt{6,tti+1}(act_elec{6},:); elec_stim_pt{7,tti+1}(act_elec{7},:);elec_stim_pt{8,tti+1}(act_elec{8},:)];
    
%     elec_stim_act2 = elec_stim_act(1:end-length(act_elec{1}),:);
    elec_stim_act1 = elec_stim_act1(:,[(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);
    elec_stim_act2 = elec_stim_act2(:,[(151:175),(1:25),(51:75),(101:125),(176:200),(26:50),(76:100),(126:150),(226:250),(201:225),(251:275)]);
    RDM_act_elec1{tti+1} = squareform(pdist(elec_stim_act1','correlation'));
    RDM_act_elec2{tti+1} = squareform(pdist(elec_stim_act2','correlation'));
    RDM_act_elec1{tti+1}(251:end,:) = RDM_act_elec2{tti+1}(251:end,:);
    RDM_act_elec1{tti+1}(:,251:end) = RDM_act_elec2{tti+1}(:,251:end);
    
end


%% Plot RDM

if plotrdm == 1
    load ('J2Colormap.mat');
    mycmap = mycmap(end:-1:1,:);
    for tti = 0:nowin
        % plot
            figure;imagesc(RDM_face_elec1{tti+1},[0 100]);colormap(mycmap);
%         figure;imagesc(PrctRDM(RDM_act_elec1{tti+1}),[0 100]);colormap(mycmap);
        set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');
        set (gca,'TickDir','out','XTick',[13 38 63 88 113 138 163 188 213 238 263],'XTickLabel',{'Human_F','Mammal_F','Bird_F','Marine_F','Human_B','Mammal_B','Bird_B','Marine_B','Place','Object','Limb'},'XTickLabelRotation',90,...
            'YTick',[13 38 63 88 113 138 163 188 213 238 263],'YTickLabel',{'Human_F','Mammal_F','Bird_F','Marine_F','Human_B','Mammal_B','Bird_B','Marine_B','Place','Object','Limb'});
        title(['Time: ',num2str(-100+(wnd/2)+(tti*shft))]);
        set (gcf,'PaperPositionMode','auto');
        set (gca,'DataAspectRatio',[1 1 1]);
        colorbar
        tiname =['poolface_',num2str(tti)];
            saveas(gca,tiname, 'png');
    end
end

%% Pairwise comparing the correlation
for tti = 0:nowin
    
    al = RDM_face_elec1{tti+1}(1:100,1:100); %allface/allface
    hh = RDM_face_elec1{tti+1}(1:25,1:25); %human/human
    ha = RDM_face_elec1{tti+1}(1:25,26:50); %human/mammal
    hb = RDM_face_elec1{tti+1}(1:25,51:75); %human/bird
    hf = RDM_face_elec1{tti+1}(1:25,76:100); %human/marine
    aa = RDM_face_elec1{tti+1}(26:50,26:50); %mammal/mammal
    bb = RDM_face_elec1{tti+1}(51:75,51:75); %bird/bird
    ff = RDM_face_elec1{tti+1}(76:100,76:100); %marine/marine
    fn = RDM_face_elec1{tti+1}(1:100,101:275); %allface/nonface
    hn = RDM_face_elec1{tti+1}(1:25,101:275); %humanface/nonface
    nn = RDM_face_elec1{tti+1}(101:275,101:275); %nonface/nonface
    ab = RDM_face_elec1{tti+1}(26:50,51:75); %mammal/bird
    af = RDM_face_elec1{tti+1}(26:50,76:100); %mammal/marine
    bf = RDM_face_elec1{tti+1}(51:75,76:100); %bird/marine
    an = RDM_face_elec1{tti+1}(1:200,1:200); %anim/anim
    in = RDM_face_elec1{tti+1}(201:250,201:250); %inanim/inanim
    ai = RDM_face_elec1{tti+1}(1:200,201:250); %anim/inanim
    

%     al = RDM_act_elec1{tti+1}(1:100,1:100); %allface/allface
%     hh = RDM_act_elec1{tti+1}(1:25,1:25); %human/human
%     ha = RDM_act_elec1{tti+1}(1:25,26:50); %human/mammal
%     hb = RDM_act_elec1{tti+1}(1:25,51:75); %human/bird
%     hf = RDM_act_elec1{tti+1}(1:25,76:100); %human/marine
%     aa = RDM_act_elec1{tti+1}(26:50,26:50); %mammal/mammal
%     bb = RDM_act_elec1{tti+1}(51:75,51:75); %bird/bird
%     ff = RDM_act_elec1{tti+1}(76:100,76:100); %marine/marine  
%     hn = RDM_act_elec1{tti+1}(1:25,101:275); %humanface/nonface
%     fn = RDM_act_elec1{tti+1}(1:100,101:275); %allface/nonface
%     nn = RDM_act_elec1{tti+1}(101:275,101:275); %humanface/nonface
%     ab = RDM_act_elec1{tti+1}(26:50,51:75); %mammal/bird
%     af = RDM_act_elec1{tti+1}(26:50,76:100); %mammal/marine
%     bf = RDM_act_elec1{tti+1}(51:75,76:100); %bird/marine

    v10(tti+1,:) = al(itriu(size(al),1)); %allface/allface
    v1(tti+1,:) = hh(itriu(size(hh),1)); %human/human
    v2(tti+1,:) = reshape(ha,625,1); %human/mammal
    v3(tti+1,:) = reshape(hb,625,1); %human/bird
    v4(tti+1,:) = reshape(hf,625,1); %human/marine
    v5(tti+1,:) = aa(itriu(size(aa),1)); %mammal/mammal
    v6(tti+1,:) = bb(itriu(size(bb),1)); %bird/bird
    v7(tti+1,:) = ff(itriu(size(ff),1)); %marine/marine
    v8(tti+1,:) = reshape(fn,17500,1); %allface/nonface
    v9(tti+1,:) = reshape(hn,4375,1); %humanface/nonface
    v11(tti+1,:) = nn(itriu(size(nn),1)); %nonface/nonface
    v12(tti+1,:) = reshape(ab,625,1); %mammal/bird
    v13(tti+1,:) = reshape(af,625,1); %mammal/marine
    v14(tti+1,:) = reshape(bf,625,1); %bird/marine
    v15(tti+1,:) = an(itriu(size(an),1)); %anim/anim
    v16(tti+1,:) = reshape(ai,10000,1); %anim/inanim
end

cr{1} = 1-v1; cr{2} = 1-v2; cr{3} = 1-v3; cr{4} = 1-v4;cr{11} = 1-v11;cr{12} = 1-v12;cr{13} = 1-v13;
cr{5} = 1-v5; cr{6} = 1-v6; cr{7} = 1-v7; cr{8} = 1-v8;cr{9} = 1-v9;cr{10} = 1-v10;cr{14} = 1-v14;
cr{15} = 1-v15;cr{16} = 1-v16;
% cr1=v1;cr2=v2;cr3=v3;cr4=v4;cr5=v5;cr6=v6;cr7=v7;cr8=v8;



%% Category Boundary Effect 
smot = 3;
liwt = 5;
cbe(1,:) = abs(mean(cr{1},2)- mean(cr{8},2)); %Human/Nonface
cbe(2,:) = abs(mean(cr{1},2)- mean(cr{2},2)); %Human/Mammal
cbe(3,:) = abs(mean(cr{1},2)- mean(cr{3},2)); %Human/Bird
cbe(4,:) = abs(mean(cr{1},2)- mean(cr{4},2)); %Human/Marine
cbe(5,:) = abs(mean(cr{5},2)- mean(cr{8},2)); %Mammal/Nonface
cbe(6,:) = abs(mean(cr{6},2)- mean(cr{8},2)); %Bird/Nonface
cbe(7,:) = abs(mean(cr{7},2)- mean(cr{8},2)); %Marine/Nonface
cbe(8,:) = abs(mean(cr{5},2)- mean(cr{2},2)); %Mammal/Human
cbe(9,:) = abs(mean(cr{6},2)- mean(cr{3},2)); %Bird/Human
cbe(11,:) = abs(mean(cr{7},2)- mean(cr{4},2)); %Marine/Human
cbe(10,:) = abs(mean(cr{10},2)- mean(cr{8},2)); %Allface/Nonface
cbe(12,:) = abs(mean(cr{5},2)- mean(cr{12},2)); %Mammal/Bird
cbe(13,:) = abs(mean(cr{5},2)- mean(cr{13},2)); %Mammal/Marine
cbe(14,:) = abs(mean(cr{6},2)- mean(cr{14},2)); %Bird/Marine
cbe(15,:) = abs(mean(cr{15},2)- mean(cr{16},2)); %Anim/inAnim


%% Significant difference from Baseline and Peak (Correlation)

if ROL==1
    sig_bas1 = zeros(nowin+1,length(cr)); sig_bas2 = zeros(nowin+1,length(cr));
    for pa=1:length(cr)-1
        
        Mcr{pa} = nanmean(cr{pa},2);
        st{pa} = std(cr{pa},0,2);
        ba{pa} = mean(cr{pa}(1:3,:),1);
        ba2(pa) = mean(cbe(pa,1:3));
%         thr{pa} = mean(ba{pa})+(std(ba{pa})*3);
%         sigp1 = find(Mcr{pa}(11:end) > thr{pa});
%         if ~isempty(sigp1)
%             sigp1 = sigp1+10; sig_bas(1,pa)=(-100+(wnd/2)+((sigp1(1)-1)*shft));
%         end
%         sigp2 = find(Mcr{pa}(31:end) < thr{pa});
%         if ~isempty(sigp2)
%             sigp2=sigp2+30; sig_bas(2,pa)=(-100+(wnd/2)+((sigp2(1)-1)*shft));
%         end
        [m,i] = max(Mcr{pa}); corr_pik(pa)=(-100+(wnd/2)+((i-1)*shft));
        [m1,i1] = max(cbe(pa,:)); cbe_pik(pa)=(-100+(wnd/2)+((i1-1)*shft));
        
        for tti = 0:nowin
            [p,h] = signrank(ba{pa},cr{pa}(tti+1,:),'alpha', 0.01);
%             [p1,h1] = signrank(ba2{pa},cbe{pa}(tti+1,:),'alpha', 0.001);
            if h == 1
                sig_bas1(tti+1,pa) = (-100+(wnd/2)+(tti*shft));
            end           
        end
        
    end
    
end


%% Significant difference from each other
% Category Boundary Effect permutation test
% 
% for tti = 0:nowin
%     [pval(tti+1), cc(tti+1)] = CBE_perm(RDM_face_elec1{tti+1},1,26:50,101:275,10000);
% end


%% Plot Correlation over time

slab = strt-200+(wnd/2);
elab = nd-200-(wnd/2);
xidx = (slab:shft:elab);xidx = xidx(1:length(elec_stim_pt))/1000;
ns = sqrt(100);

figure;
hold('all');
[h4] = niceplot_full (xidx,mean(cr{4},2)',(st{4}./ns)',[.33,.41,.25],.8,'-');
[h3] = niceplot_full (xidx,mean(cr{3},2)',(st{3}./ns)',[.47,.4,.1],.6,'-');
[h2] = niceplot_full (xidx,mean(cr{2},2)',(st{2}./ns)',[.23,.14,.38],.6,'-');
[h1] = niceplot_full (xidx,mean(cr{1},2)',(st{1}./ns)',[.46,.03,.24],.6,'-');
% ylabel('Correlation coefficient','FontSize',14);
% xlabel('Time (S)','FontSize',14);
% title('Correlation between Face selective electrodes','FontSize',14);
legend_handle = legend([h1 h2 h3 h4],'Human-Human','Human-Mammal','Human-Bird','Human-Marine');
set(legend_handle, 'Box', 'off','Location','NorthWest','FontSize',14);
% ylim ([-0.1 .9]); xlim([-.1 .8]);
% ylim ([0 90]); xlim([-.1 .8]);

hold('off');


figure;
hold('all');
[h4] = niceplot_full (xidx,mean(cr{7},2)',(st{7}./ns)',[.03,.46,.24],.8,'-');
[h3] = niceplot_full (xidx,mean(cr{6},2)',(st{6}./ns)',[.46,.24,.03],.6,'-');
[h2] = niceplot_full (xidx,mean(cr{5},2)',(st{5}./ns)',[.03,.24,.46],.6,'-');
[h1] = niceplot_full (xidx,mean(cr{1},2)',(st{1}./ns)',[.46,.03,.24],.6,'-');
% ylabel('Correlation coefficient','FontSize',14);
% xlabel('Time (S)','FontSize',14);
% title('Correlation between Face selective electrodes','FontSize',14);
legend_handle = legend([h1 h2 h3 h4],'Human-Human','Mammal-Mammal','Bird-Bird','Marine-Marine');
set(legend_handle, 'Box', 'off','Location','NorthWest','FontSize',14);
% ylim ([-0.1 .9]); xlim([-.1 .8]);
hold('off');



%% All CBE in 1 plot

figure;
hold('all');
[h11] = plot (xidx,SmoothN(cbe(15,:),smot),'color',[.15,.15,.15]*1.5,'LineWidth',liwt);
[h10] = plot (xidx,SmoothN(cbe(14,:),smot),'color',[.5,.55,.35]*1.5,'LineWidth',liwt);
[h9] = plot (xidx,SmoothN(cbe(13,:),smot),'color',[.35,.5,.5]*1.5,'LineWidth',liwt);
[h8] = plot (xidx,SmoothN(cbe(12,:),smot),'color',[.5,.4,.5]*1.5,'LineWidth',liwt);
[h7] = plot (xidx,SmoothN(cbe(4,:),smot),'color',[.33,.41,.25]*1.5,'LineWidth',liwt);
[h6] = plot (xidx,SmoothN(cbe(3,:),smot),'color',[.47,.4,.1]*1.5,'LineWidth',liwt);
[h5] = plot (xidx,SmoothN(cbe(2,:),smot),'color',[.23,.14,.38]*1.5,'LineWidth',liwt);
[h4] = plot (xidx,SmoothN(cbe(7,:),smot),'color',[.03,.46,.24]*1.5,'LineWidth',liwt);
[h3] = plot (xidx,SmoothN(cbe(6,:),smot),'color',[.46,.24,.03]*1.5,'LineWidth',liwt);
[h2] = plot (xidx,SmoothN(cbe(5,:),smot),'color',[.03,.24,.46]*1.5,'LineWidth',liwt);
[h1] = plot (xidx,SmoothN(cbe(1,:),smot),'color',[.46,.03,.24]*1.5,'LineWidth',liwt);
ylabel('Percent','FontSize',14);
xlabel('Time (S)','FontSize',14);
title('Category Boundary Effect','FontSize',14);
legend_handle = legend([h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11],'Humanface-Nonface','Mammalface-Nonface','Birdface-Nonface','Marineface-Nonface',...
'Human-Mammal (face)','Human-Bird (face)','Human-Marine (face)','Mammal-Bird (face)','Mammal-Marine (face)','Bird-Marine (face)', 'Anim-inAnim');
set(legend_handle, 'Box', 'off','Location','northwest','FontSize',14);
% ylim ([-5 60]); xlim([-.1 .8]);
hold('off');


