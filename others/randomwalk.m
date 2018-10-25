clear all
close all
lbox=20;

figure('Color',[0 0 0])

%random fluctuation
eta = (2.*pi).*1;
vs=0.02;
n=300;
birdl=[1:n];


axis([0 lbox 0 lbox])
axis('square')
hold on
xb=rand(n,1).*lbox;  %first possition
yb=rand(n,1).*lbox;    %first possition
vxb = 1;
vyb = 1;

for steps=1:5000;
    xb = xb + vxb;
    yb = yb+ vyb;

    for bird1 = 1:n;
        %periodic boundary condition
        if (xb(bird1)<0);xb(bird1)=xb(bird1)+lbox; end
        if (yb(bird1)<0);yb(bird1)=yb(bird1)+lbox;end
        if (xb(bird1)>lbox);xb(bird1)=xb(bird1)-lbox;end
        if (yb(bird1)>lbox);yb(bird1)=yb(bird1)-lbox;end

    end
    ang=eta.*(rand(n,1)-0.5);

    vxb = vs.*cos(ang);
    vyb = vs.*sin(ang);

    cla
    set(gca,'Color',[0 0 0]);
    set(gcf,'doublebuffer','on')
    set(gca,'YTick',[]);
    set(gca,'XTick',[]);

    plot(xb,yb,'.g','markersize',10)
    % this should draw lines, but its slow and not as neat as a web app
%     plot([xb xb-vxb*5]',[yb yb-vyb*5]','g') 

    drawnow
end
