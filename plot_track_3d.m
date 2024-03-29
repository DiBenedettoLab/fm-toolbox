function plot_track_3d(smtracks, smangles, uid, particle_type, Rp)
% plot 2D reconstruction of particle with 3D orientation
% inputs
% smtracks: tracks array 
% smangles: angles array
% uid: ID of the track to plot
% particle_type: e.g. 'rods','d5'
% Rp: particle semimajor axis [m]

idx = find(smtracks(:,5)==uid);

% smangles(:,1) = abs(smangles(:,1));

% interpolate nan's
for i = 1:3
    smangles(idx,i) = naninterp(smangles(idx,i));
end

% subsample track for clarity
ss = idx(1):5:idx(end);

% set up color mapping
% c = parula(length(ss)+1); c = c(1:end-1,:); % color by time
c = turbo(100); % color by pz

% dimensions
M = 1; % scale factor
thk = Rp/5; % particle thickness [m]

% surfaces to project shadows on [m]
bottom_coord = min(smtracks(ss,2))-.005;  
side_coord = .05;

% plot track
for i = 1:length(ss)
    if ~any(isnan([smangles(ss(i),1:3), smtracks(ss(i),1:2)]))
        ci = round(abs(smangles(ss(i),2))*(length(c)-1))+1; 
        if strncmp(particle_type,'r',1)  % rods
            % particle axis
%             line([smtracks(ss(i),1) - 1.2*Rp*smangles_cont(ss(i),1), smtracks(ss(i),1) + 1.2*Rp*smangles_cont(ss(i),1)]'*1000, ...
%                 [0 - 1.2*Rp*smangles_cont(ss(i),3), 0 + 1.2*Rp*smangles_cont(ss(i),3)]'*1000, ...
%                 [smtracks(ss(i),2) - 1.2*Rp*smangles_cont(ss(i),2), smtracks(ss(i),2) + 1.2*Rp*smangles_cont(ss(i),2)]'*1000, ...
%                 'color','k','linewidth',0.75); hold on
            
            % particle surface
            [xc1,yc1,zc1] = cylinder2(thk/2*ones(2,1), Rp, [smangles(ss(i),1),smangles(ss(i),2),smangles(ss(i),3)]); 
            [xc2,yc2,zc2] = cylinder2(thk/2*ones(2,1), Rp, -[smangles(ss(i),1),smangles(ss(i),2),smangles(ss(i),3)]); 
            xc = [xc1,xc2]; yc = [yc1,yc2]; zc = [zc1,zc2];
            xc = (xc + smtracks(ss(i),1) - smtracks(ss(1),1))/M; yc = (yc + smtracks(ss(i),2))/M; zc = (zc + 0)/M; 
            surf(xc,zc,yc,'facecolor',c(ci,:),'edgecolor','none'); hold on  
            patch(xc',zc',yc',c(ci,:),'edgecolor','none');  

            % particle shadow
            surf(xc,side_coord*ones(size(xc))/M,yc,'facecolor',[.7 .7 .7],'edgecolor','none');
%             surf(xc,zc,bottom_coord*ones(size(xc)),'facecolor',[.7 .7 .7],'edgecolor','none');

        elseif strncmp(particle_type,'d',1)    % disks
            % particle axis
%             line([smtracks(ss(i),1) - Rp*smangles_cont(ss(i),1), smtracks(ss(i),1) + Rp*smangles_cont(ss(i),1)]'*1000, ...
%                 [0 - Rp*smangles_cont(ss(i),3), 0 + Rp*smangles_cont(ss(i),3)]'*1000, ...
%                 [smtracks(ss(i),2) - Rp*smangles_cont(ss(i),2), smtracks(ss(i),2) + Rp*smangles_cont(ss(i),2)]'*1000, ...
%                 'color','k','linewidth',0.75);

            % particle surface
            [xc,yc,zc] = cylinder2(Rp*ones(2,1), thk, [smangles(ss(i),1),smangles(ss(i),2),smangles(ss(i),3)]); 
            xc = (xc + smtracks(ss(i),1) - smtracks(ss(1),1))/M; yc = (yc + smtracks(ss(i),2))/M; zc = (zc + 0)/M; 
            surf(xc,zc,yc,'facecolor',c(ci,:),'edgecolor','none'); hold on  
            patch(xc',zc',yc',c(ci,:),'edgecolor','none');

            % particle shadow
            surf(xc,side_coord*ones(size(xc))/M,yc,'facecolor',[.7 .7 .7],'edgecolor','none'); hold on
            patch(xc',side_coord*ones(size(xc'))/M,yc',[.7 .7 .7],'edgecolor','none');
%             patch(xc',zc',bottom_coord*ones(size(xc')),[.7 .7 .7],'edgecolor','none');
        else
            error('can only reconstruct orientations of disks or rods')
        end
%     else
%         warning('Found NaN in track: not plotting')
    end
end

% finish plot
axis equal; grid on
axis([min(smtracks(ss,1)-smtracks(ss(1),1))-.004, max(smtracks(ss,1)-smtracks(ss(1),1))+.004, -side_coord, side_coord, bottom_coord, max(smtracks(ss,2))+.005]/M); 
axis vis3d; 
view(3); 
% set(gca,'view',[-34.1870   15.9478]);

% set(gca,'XTickLabel',[]); set(gca,'YTickLabel',[]); set(gca,'ZTickLabel',[]); 
xlabel('$x$'); ylabel('$y$'); zlabel('$z$'); %light
set(gca,'ticklength',[0 0]);