clear all
close all
lbox = 20;

%random fluctuation 
eta = (2.*pi).*1;
vs = 0.05;
n = 200;

set(gcf, 'doublebuffer', 'on', 'Color', 'k');
set(gca, 'Visible', 'off');
axis([0 lbox 0 lbox])
axis('square')
hold on
xb = rand(n, 1).*lbox;  %first possition
yb = rand(n, 1).*lbox;  %first possition
vxb = 1;
vyb = 1;

hList = [];
nStore = 30;
cMap = [zeros(nStore+1, 1) linspace(1, 0, nStore+1).' zeros(nStore+1, 1)];

for steps = 1:200

  xb = xb + vxb;
  yb = yb + vyb;

  %periodic boundary condition
  index = (xb < 0);
  xb(index) = xb(index) + lbox;
  index = (yb < 0);
  yb(index) = yb(index) + lbox;
  index = (xb > lbox);
  xb(index) = xb(index) - lbox;
  index = (yb > lbox);
  yb(index) = yb(index) - lbox;

  ang = eta.*(rand(n,1)-0.5);

  vxb = vs.*cos(ang);
  vyb = vs.*sin(ang);

  h = plot(xb, yb, '.g', 'MarkerSize', 12);
  if (numel(hList) == nStore)
    delete(hList(nStore));
    hList = [h hList(1:end-1)];
  else
    hList = [h hList];
  end

  set(hList, {'Color'}, num2cell(cMap(1:numel(hList), :), 2));

  drawnow
end
