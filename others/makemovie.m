% Generate some data
t=0:.01:2*pi;
sin_x=sin(t);
cos_x=cos(t);
% Open a figure and crate the axes
figure
axes;
%
% STEP 1:
%
% Create and open the video object
vidObj = VideoWriter('juggling.mpeg','MPEG-4');
open(vidObj);
%
% Loop over the data to create the video
for i=1:length(t)
   % Plot the data
   h(1)=plot(t(i),sin_x(i),'o','markerfacecolor','r','markersize',5);
   hold on
   plot(t(1:i),sin_x(1:i),'r')
   plot(t(1:i),cos_x(1:i),'b')
   h(2)=plot(t(i),cos_x(i),'o','markerfacecolor','b','markersize',5);
   set(gca,'xlim',[0 2*pi],'ylim',[-1.3 1.3])
   %
   % STEP 2
   %
   % Get the current frame
   currFrame = getframe;
   %
   % STEP 3
   %
   % Write the current frame
   writeVideo(vidObj,currFrame);
   %
   delete(h)
end
%
% STEP 4
%
% Close (and save) the video object
close(vidObj);
