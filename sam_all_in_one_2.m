Q=0.3;
H=15;
N=10;   % streamlines
nr=1500;
n=40; % no pf points

%initial calculation
P=(0.9)*(0.96)*(9810).*Q.*H;
ns=(nr.*sqrt(P.*10.^-3))/(H.^(5/4));
w=2.*pi.*nr/60;
r2=(Q/(pi.*0.24.*w)).^(1/3);
d2=2.*r2;
d1=(0.4+94.5/ns).*d2;
r1=d1/2;
dm=d2/(0.96+0.00038.*ns);
rm=dm/2;
h1=d2.*(0.094+0.00025.*ns);

if ns<111
    h2=d2.*(-0.05+42/ns);
else
    h2=d2/(3.16-0.0013.*ns);
end

b1=2.*h1;
height=h1+h2;

%%% hub and shroud
le=h2-h1;
ymi=r1;
li=b1/0.24;
yme=r2/8.711;

x1=nan(1,n);
x2=nan(1,n);
y1=nan(1,n);
y2=nan(1,n);

%%% hub
p=li/4;
q=p/n;
b=0;
for i=1:n
    y1(1,i)=b;
    x1=ymi*3.08*(1-y1/li).^(3/2).*(y1/li).^(1/2);
    b=b+q;
end

%hub point
x1=-x1;
y1=-y1;
x_trans=r1;
y_trans=h1+h2;

for i=1:n
    xx(1,i)=x1(1,i)+x_trans;
    yy(1,i)=y1(1,i)+y_trans;
end

% plot (xx,yy);
rb=xx(1,1)/3

for i=1:n
    error=xx(1,i)-rb;
    if error<0.001
        break
    end
    point=i;
end

point;
yvalue=-y1(1,point)

%hub again
p=yvalue;
q=p/n;
b=0;

for i=1:n
    y1(1,i)=b;
    x1=ymi*3.08*(1-y1/li).^(3/2).*(y1/li).^(1/2);
    b=b+q;
end

%%% shroud
p=0+le;
q=p/n;
b=0;
for i=1:n
    y2(1,i)=b;
    x2=yme*3.08*(1-y2/le).^(3/2).*(y2/le).^(1/2);
    b=b+q;
end

%offset shroud
d_leading=r1-rm;
for i=1:n
    y2(1,i)=y2(1,i)+b1;
    x2(1,i)=x2(1,i)+d_leading;
end

x = nan(N-1,n);
y = nan(N-1,n);

for i=1:N-1
    x(i,:) = x1 + (x2-x1).*i/N;
    y(i,:) = y1 + (y2-y1).*i/N;
end

a = nan(N+1,n);
b = nan(N+1,n);
c=N+1;
d=n;

for i=1:d
    a(1,i)=-x1(1,i);
    b(1,i)=-y1(1,i);
    a(N+1,i)=-x2(1,i);
    b(N+1,i)=-y2(1,i);
end

for i=2:N
    for j=1:d
        a(i,j)= -x(i-1,j);
        b(i,j)=-y(i-1,j);
    end
end

%%%% transformation of coordinates
x_trans=r1;
y_trans=h1+h2;
xx=nan(c,d);
yy=nan(c,d);

for i=1:c
    for j=1:d
        xx(i,j)=a(i,j)+x_trans;
        yy(i,j)=b(i,j)+y_trans;
    end
end

%%transform again
xtrans=r2-xx(c,d);

for i=1:c
    for j=1:d
        xx(i,j)=xx(i,j)+xtrans;
    end
end

% inlet and outlet
nh=0.96;
g=9.81;
b2=xx(c,d)-xx(1,d);
r1_new=xx(1,1);
d1_new=2.*r1_new;
d1=d1_new;
u1=(pi.*nr.*d1)/60;
vf1=Q/(pi.*d1.*b1);
vw1=(nh.*g.*H)/u1;

if vw1>u1
    beta1=atan(vf1/(vw1-u1));
else
    beta1=atan(vf1/(u1-vw1));
end

u2=(pi.*nr.*d2)/60;
vf2=Q/(pi.*d2.*b2);
beta2=atan(vf2/u2);
alpha1=atan(vf1/vw1);
vr1=(u1-vw1)/cos(beta1);
v1=vf1/sin(alpha1);
vr2=vf2/sin(beta2);

% perpendicular view
lm=nan(1,c);

for i=1:c
    lm(i)=yy(i,1)-yy(i,n);
end

disp(['lm = ' num2str(lm)]);

%plot of perpendicular view
bb=tan(beta2);
m=tan(beta1);
n=tan(beta2);
A=2*lm/(m+n);
aa=nan(1,c);

for i=1:c
    aa(i)=(m-n)/(2*A(i));
end

zz=nan(c,d);

for i=1:c
    for j=1:d
        m=aa(i);
        v=yy(i,j);
        zz(i,j)=(m.*v.^2+bb.*v);
    end
end

%%%perpendicular view
    figure;
    plot(yy(:, 1), zz(:, 1), 'r-');
    xlabel('Y');
    ylabel('Z');
    title('Perpendicular View');
    % Plotting the axial view
    figure;
    plot(Rmat(1:end, :), Zmat(1:end, :), 'b.-');
    xlim([0.4 0.8]);
    xlabel('Radius');
    ylabel('Height');
    title('Axial View Plot');
    grid on;

 
%3D
%%combine view
% Combine and visualize the profiles
    figure;
% Plot combined profiles
    subplot(1, 1, 1);
    plot(yy(1, :), zz(1, :), 'b-', yy(:, 1), zz(:, 1), 'r-');
    xlabel('Y');
    ylabel('Z');
    title('Combined Meridional and Perpendicular View Profiles');
    legend('Shroud Profile', 'Perpendicular View Profile');

%%3D
    subplot(1, 2, 1);
    surf(xx, yy, zz);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Complete 3D Runner Blade Design');

% Create a new figure
    figure;
    
% Inlet velocity triangle
    subplot(1, 2, 1);
    hold on;
    
% Draw the velocities
    line([0, vw1], [0, 0], 'Color', 'b', 'LineWidth', 2);
    line([0, u1], [0, 0], 'Color', 'r', 'LineWidth', 2);
    line([0, vw1], [0, vf1], 'Color', [0.5,0,0], 'LineWidth', 2);
    line([vw1, vw1], [0, vf1], 'Color', 'g', 'LineWidth', 2);
    line([u1,vw1], [0, vf1], 'Color', [0.5,0.5,0.5], 'LineWidth', 2);

% Draw labels
    text(u1/2, -1, 'u1', 'Color', 'r', 'FontSize', 12);
    text(vw1/2, -1, 'vw1', 'Color', 'b', 'FontSize', 12);
    if u1>vw1
        text(vw1/2, 0.75.*vf1, 'v1', 'Color', [0.5,0,0], 'FontSize', 12);
        text(0.9.*vw1, vf1/2, 'vf1', 'Color', 'g', 'FontSize', 12);
    else
        text(u1/2, 0.75*vf1, 'v1', 'Color', [0.5,0,0], 'FontSize', 12);
        text(0.9.*u1, vf1/2, 'vf1', 'Color', 'g', 'FontSize', 12);
    end
   
% Set plot properties
    xlim([-100, 100]);
    ylim([-100, 100]);
   title('Inlet velocity triangle');

    grid on;
    axis equal;
    hold off;
    title('Inlet Velocity Triangle');
     
% Outlet velocity triangle
    subplot(1, 2, 2);
    
    %figure;
    hold on;
    
    % Draw the velocities
    line([0, u2], [vf2, vf2], 'Color', 'r', 'LineWidth', 2);
    line([0, 0], [0, vf2], 'Color', 'g', 'LineWidth', 2);
    line([0, u2], [0, vf2], 'Color', [0.5,0.5,0.5], 'LineWidth', 2);

% Draw labels
    text(u2/2, vf2+0.5, 'u2', 'Color', 'r', 'FontSize', 12);
    text(0.7*u2, vf2/2, 'vr2', 'Color', 'b', 'FontSize', 12);
    text(-1.5, vf2/2, 'vf1', 'Color', 'g', 'FontSize', 12);
   
% Set plot properties
    xlim([-100, 100]);
    ylim([-100, 100]);
    title('Outlet velocity triangle');

    grid on;
    axis equal;
    hold off;




%Define parameters
    num_blades = 10;
    radius = 0.2;
% Calculate blade positions
theta = linspace(0, 2*pi, num_blades);
xposition = radius * cos(theta);
yposition = radius * sin(theta);
zposition = zeros(size(xposition)); % Assuming blades start from the origin 

% Create a figure
figure;
hold on;
grid on;
axis equal;

blade_x=xx;
blade_y=yy;
blade_z=zz;

% Clone and rotate blades
for i = 1:num_blades
    blade_x_shifted = blade_x + xposition(i);
    blade_y_shifted = blade_y + yposition(i);
    blade_z_shifted = blade_z + zposition(i);
    % Plot the blade surface
    surf(blade_x_shifted, blade_y_shifted, blade_z_shifted, 'FaceColor', [0.5,0,0], 'EdgeColor', [0,0,1]);
end

% Set labels
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Turbine Runner with Circular Arrangement of Blades');

% Show the plot
view(3);
rotate3d on;
hold off;




