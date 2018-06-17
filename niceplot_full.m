% size (trial X time)

function h = niceplot_full(xidx, matr, sd, c1, a, lns)

xidx1 = xidx;
y=matr;
y1=matr+sd;
y2=matr-sd;
y3=y2(size(matr, 2):-1:1);
y2=y3;
Y=[y1 y2];
X=[xidx1 xidx1(end:-1:1)];

h = fill(X, Y, c1*1.7, 'LineStyle', lns);
alpha(h,a);
hold on;
% plot(xidx1, y,  'color', c1,'LineWidth',1.5, 'LineStyle', lns);
plot(xidx1, y,  'color', c1*1.7,'LineWidth',1.5, 'LineStyle', lns);
% axis([0 size(input,2), 0 .2]);


