% Luminance control analysis

% Probally V1 electrodes; pt 86(PTS1=45, PTS2=46) ;  pt 91(PT2=98)

% load('/Users/sina/Documents/Data/ECoG/Animal_data/elec_stim_face.mat');


elec_face_face1 = elec_stim_face1(:,facelum<120);
elec_face_face2 = elec_stim_face1(:,facelum>120);

elec_face_face3 = elec_stim_face1(:,facelum>120 & facelum<180);
elec_nonface_face1 = elec_stim_face1(:,nonfacelum>120 & nonfacelum<180);


en = size(elec_stim_face1);
pl= nan(en(1),3);
for e = 1:en(1)
   pl(e,1) =  ranksum(elec_face_face1(e,:), elec_face_face2(e,:));
   pl(e,2) =  ranksum(elec_face_face3(e,:), elec_nonface_face1(e,:));
   pl(e,3) =  ranksum(elec_stim_face1(e,1:100), elec_stim_face1(e,101:275));
   
%    if pl(e) <= 0.05   
%    end
end

%%

elecmatch_stim_face = elec_stim_face1(pl(1,:)>0.05,:);
 
RDM_face_match = squareform(pdist(elecmatch_stim_face','correlation'));
Cor_matchelec =1-RDM_face_match;
figure;imagesc(Cor_matchelec,[-0.5 1]);colormap(mycmap);
set (gca,'DataAspectRatio',[1 1 1],'XAxisLocation','top');


