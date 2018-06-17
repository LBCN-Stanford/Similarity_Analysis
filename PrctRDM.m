
function prcrdm = PrctRDM(vrdm)

[ro, cm] = size(vrdm);

%% methode Sina
if cm>1 && ro>1
    vrdm = squareform(vrdm); % Convert to vector
end
vrdm = ((tiedrank(vrdm))/(length(vrdm)))*100;
prcrdm = squareform(vrdm);


%% method 1 MR

% if cm==1 || ro==1
%     [n, bin] = histc(vrdm,min(vrdm):.001:max(vrdm));
%     cum_n = cumsum(n);
%     vrdm = cum_n(bin+1) / cum_n(end);
%     prcrdm = squareform(vrdm*100); %Conver to matrix
% else
%     vrdm = squareform(vrdm); %Conver to vector
%     [n, bin] = histcounts(vrdm,min(vrdm):.001:max(vrdm));
%     cum_n = cumsum(n);
%     vrdm = cum_n(bin+1) / cum_n(end);
%     prcrdm = squareform(vrdm*100); %Conver to matrix
% end



