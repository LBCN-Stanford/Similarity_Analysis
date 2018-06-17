function im = getImII_anim2(MDS_data,fname,impath)

xp = MDS_data(:,1);
yp = MDS_data(:,2);
aug = .1;
X = [min(xp)-aug max(xp)+aug];
Y = [min(yp)-aug max(yp)+aug];

aug = .1;
BseClr = 200;
% bgClr = 127;
r = 1;
res = 3200;
xran = (X(2) - X(1)) + aug;
yran = (Y(2) - Y(1)) + aug;
im1 = BseClr*ones(round(yran*res),round(xran*res));
im2 = im1; im3 =im1; %make 3d, compatible to color
 

%% read all of images
rim=9;
imcont = dir(impath); imcont = imcont(3:end);
for f = 1:length(imcont)
    img{f} = imresize(imread([impath ,imcont(f).name],'jpg'),r);
    if numel(size(img{f})) < 3
        img{f} = repmat(img{f},[1,1,3]); %make 3d, compatible to color
    end
    
    % Make pink color around human face
    if ismember (f,(151:175))
        rgb = [200 10 150];
        img{f}(1:rim,1:end,1)=rgb(1); img{f}(1:rim,1:end,2)=rgb(2); img{f}(1:rim,1:end,3)=rgb(3);
        img{f}(end-rim:end,1:end,1)=rgb(1); img{f}(end-rim:end,1:end,2)=rgb(2); img{f}(end-rim:end,1:end,3)=rgb(3);
        img{f}(1:end,1:rim,1)=rgb(1);img{f}(1:end,1:rim,2)=rgb(2); img{f}(1:end,1:rim,3)=rgb(3);
        img{f}(1:end,end-rim:end,1)=rgb(1);img{f}(1:end,end-rim:end,2)=rgb(2); img{f}(1:end,end-rim:end,3)=rgb(3);
    end
     % Make blue color around mammal face
    if ismember (f,(1:25))
        rgb = [10 100 200];
        img{f}(1:rim,1:end,1)=rgb(1); img{f}(1:rim,1:end,2)=rgb(2); img{f}(1:rim,1:end,3)=rgb(3);
        img{f}(end-rim:end,1:end,1)=rgb(1); img{f}(end-rim:end,1:end,2)=rgb(2); img{f}(end-rim:end,1:end,3)=rgb(3);
        img{f}(1:end,1:rim,1)=rgb(1);img{f}(1:end,1:rim,2)=rgb(2); img{f}(1:end,1:rim,3)=rgb(3);
        img{f}(1:end,end-rim:end,1)=rgb(1);img{f}(1:end,end-rim:end,2)=rgb(2); img{f}(1:end,end-rim:end,3)=rgb(3);
    end   
    % Make orange color around bird face
    if ismember (f,(51:75))
        rgb = [200 100 10];
        img{f}(1:rim,1:end,1)=rgb(1); img{f}(1:rim,1:end,2)=rgb(2); img{f}(1:rim,1:end,3)=rgb(3);
        img{f}(end-rim:end,1:end,1)=rgb(1); img{f}(end-rim:end,1:end,2)=rgb(2); img{f}(end-rim:end,1:end,3)=rgb(3);
        img{f}(1:end,1:rim,1)=rgb(1);img{f}(1:end,1:rim,2)=rgb(2); img{f}(1:end,1:rim,3)=rgb(3);
        img{f}(1:end,end-rim:end,1)=rgb(1);img{f}(1:end,end-rim:end,2)=rgb(2); img{f}(1:end,end-rim:end,3)=rgb(3);
    end 
    % Make green color around marine face
    if ismember (f,(101:125))
        rgb = [10 200 100];
        img{f}(1:rim,1:end,1)=rgb(1); img{f}(1:rim,1:end,2)=rgb(2); img{f}(1:rim,1:end,3)=rgb(3);
        img{f}(end-rim:end,1:end,1)=rgb(1); img{f}(end-rim:end,1:end,2)=rgb(2); img{f}(end-rim:end,1:end,3)=rgb(3);
        img{f}(1:end,1:rim,1)=rgb(1);img{f}(1:end,1:rim,2)=rgb(2); img{f}(1:end,1:rim,3)=rgb(3);
        img{f}(1:end,end-rim:end,1)=rgb(1);img{f}(1:end,end-rim:end,2)=rgb(2); img{f}(1:end,end-rim:end,3)=rgb(3);
    end
    
    
end

% Reorder images
img = img([151:175,1:25,51:75,101:125,176:200,26:50,76:100,126:150,226:250,201:225,251:275]);


% H = double(img{1} ~= bgClr);
% H = imfilter(H,fspecial('disk',50),'replicate');
% H  = H > .8;


mm = size(img{1},1)/2;

xp = round((xp - X(1))*res) + mm;
yp = round((Y(2) - yp)*res) + mm;

[mt nt] = size(im1);
iix = reshape(1:mt*nt,mt,nt);


for i = 1:length(img)
    ix = iix((yp(i)-mm:yp(i)+mm-1),(xp(i)-mm:xp(i)+mm-1));

    %     if i < 10
    %         ixf = (img{i} ~= bgClr) | H;
    %     else
    %         ixf = (img{i} ~= bgClr);
    %     end
    %     ix = ix(ixf);
    %     im(ix) = img{i}(ixf);
    
    im1(ix) = img{i}(:,:,1);
    im2(ix) = img{i}(:,:,2);
    im3(ix) = img{i}(:,:,3);
end

im(:,:,1) = im1;im(:,:,2) = im2;im(:,:,3) = im3; %make 3d, compatible to color
im = cast(im,'uint8');
imwrite(im,['/Users/sina/Documents/Data/ECoG/Animal_data/' fname '.png'],'png')

 
 