classdef FrancisTurbineApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure              matlab.ui.Figure
        IntroLabel            matlab.ui.control.Label
        HeadEditFieldLabel    matlab.ui.control.Label
        HeadEditField         matlab.ui.control.NumericEditField
        DischargeEditFieldLabel  matlab.ui.control.Label
        DischargeEditField    matlab.ui.control.NumericEditField
        RotationalSpeedEditFieldLabel  matlab.ui.control.Label
        RotationalSpeedEditField  matlab.ui.control.NumericEditField
        StreamlinesEditFieldLabel  matlab.ui.control.Label
        StreamlinesEditField  matlab.ui.control.NumericEditField
        CalculateButton       matlab.ui.control.Button
      
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
            % Get input values
            head(H) = app.HeadEditField.Value;
            discharge(Q) = app.DischargeEditField.Value;
            rotationalSpeed(nr) = app.RotationalSpeedEditField.Value;
            streamlines(N) = app.StreamlinesEditField.Value;

            % Call the main calculation script with input values
            mainScript(head(H), discharge(Q), rotationalSpeed(nr), streamlines(N));
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Francis Turbine Modeling';

            % Create IntroLabel
            app.IntroLabel = uilabel(app.UIFigure);
            app.IntroLabel.FontSize = 20;
            app.IntroLabel.Position = [170 380 300 40];
            app.IntroLabel.Text = 'Francis Turbine Modeling';
            %%parameters
              app.IntroLabel = uilabel(app.UIFigure);
            app.IntroLabel.FontSize = 16;
            app.IntroLabel.Position = [180 320 290 40];
            app.IntroLabel.Text = ' Input parameters';


            % Create HeadEditFieldLabel
            app.HeadEditFieldLabel = uilabel(app.UIFigure);
            app.HeadEditFieldLabel.HorizontalAlignment = 'right';
            app.HeadEditFieldLabel.Position = [190 290 60 22];
            app.HeadEditFieldLabel.Text = 'Head(H)';
             

            % Create HeadEditField
            app.HeadEditField = uieditfield(app.UIFigure, 'numeric');
            app.HeadEditField.Position = [270 290 100 22];

            % Create DischargeEditFieldLabel
            app.DischargeEditFieldLabel = uilabel(app.UIFigure);
            app.DischargeEditFieldLabel.HorizontalAlignment = 'right';
            app.DischargeEditFieldLabel.Position = [190 260 75 22];
            app.DischargeEditFieldLabel.Text = 'Discharge(Q)';

            % Create DischargeEditField
            app.DischargeEditField = uieditfield(app.UIFigure, 'numeric');
            app.DischargeEditField.Position = [270 260 100 22];

            % Create RotationalSpeedEditFieldLabel
            app.RotationalSpeedEditFieldLabel = uilabel(app.UIFigure);
            app.RotationalSpeedEditFieldLabel.HorizontalAlignment = 'right';
            app.RotationalSpeedEditFieldLabel.Position = [155 230 114 22];
            app.RotationalSpeedEditFieldLabel.Text = 'Rotational Speed(nr)';

            % Create RotationalSpeedEditField
            app.RotationalSpeedEditField = uieditfield(app.UIFigure, 'numeric');
            app.RotationalSpeedEditField.Position = [270 230 100 22];

            % Create StreamlinesEditFieldLabel
            app.StreamlinesEditFieldLabel = uilabel(app.UIFigure);
            app.StreamlinesEditFieldLabel.HorizontalAlignment = 'right';
            app.StreamlinesEditFieldLabel.Position = [180 200 90 22];
            app.StreamlinesEditFieldLabel.Text = 'Streamlines(N)';

            % Create StreamlinesEditField
            app.StreamlinesEditField = uieditfield(app.UIFigure, 'numeric');
            app.StreamlinesEditField.Position = [270 200 100 22];

            % Create CalculateButton
            app.CalculateButton = uibutton(app.UIFigure, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.Position = [265 130 70 22];
            app.CalculateButton.Text = 'Calculate';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = FrancisTurbineApp

            % Create UIFigure and components
            createComponents(app);

            % Register the app with App Designer
            registerApp(app, app.UIFigure);
            
            % Run the startup function
            runStartupFcn(app, @startupFcn);

            if nargout == 0
                clear app;
            end
        end

        % Code that executes after component creation
        function startupFcn(app)
            % Initialize your parameters here
            %app.HeadEditField.Value = 30;
            %app.DischargeEditField.Value = 39.9;
            %%app.StreamlinesEditField.Value = 69;
        end
    end
end
function CalculateButtonPushed(app, event)
    try
      Q=39.9;
H=30.5;
N=40;   % streamlines
nr=300;
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
 %%axial view
plot(xx, yy, '-o');
xlabel('X-axis');
ylabel('Y-axis');
title('Axial View of Turbine');
grid on;

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
    % Generate axial view plot

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

%%%%%%% meridoinaldim.m%%%%%%
%constant
        g=9.81;
        v2eo=0.27;
        x2e=0.5;

        %dimensionless dimension of meridoinal plane
no=(nr*(Q/pi)^(0.5))/((2*g*H)^(3/4));       %dimensionless specific speed
bo=0.8*(2-no)*no;                            %inlet blade thickness(width of the blade)

%i is for the hub whereas e is for the shrub 
roi=0.7+0.16/(no+0.08);                      
ymi=roi;
rli=0.493/(no^(2/3));
if no<0.275
    roe=0.493/(no^(2/3));
else
    roe=1.255-0.3*no;
end
li=3.2+3.2*(2-no)*no;
le=2.4-1.9*(2-no)*no;
x2e=0.5; %suppose constant
y2e=roe-1;
y2ebyyme=curve(x2e,le);
yme=y2e/y2ebyyme;
rme=roe-yme;
% Normalizing dimensions
R2e=((Q/pi)/(v2eo*nr))^(1/3);
Bo=bo*R2e;
Roi=roi*R2e;
Ymi=ymi*R2e;
Rli=rli*R2e;
Roe=roe*R2e;
Li=li*R2e;
Le=le*R2e;
X2e=x2e*R2e;
Y2e=y2e*R2e;
Yme=yme*R2e;
Rme=rme*R2e;

%%%%%%meri_lines.m%%%%%

%for hub curve
x1=nan(1,n);            % NaN = create a memories for arrays which is not a number but a floating point values.
x2=nan(1,n);
y1=nan(1,n);
y2=nan(1,n);
p=Li/4;                  %     figure 2 ; pg no 3
q=p/n;                  %       interval length for fittting 
b=0;                    % intial assumption for sum

for i=1:n               
    x1(1,i)=b;                      
    y1=Ymi.*curve(x1,Li);           %ymi = leading edge staring point at hub = 
    b=b+q;
end

%transforming hub curve
 x1=-x1;
 y1=-y1;
 x_trans=Le+Bo;
 y_trans=Roi;
for i=1:n
    x1(1,i)=x1(1,i)+x_trans;
    y1(1,i)=y1(1,i)+y_trans;
end
figure(1);
plot(y1,x1);
hold on;
grid on;

%%% shroud curve
p=Le;
q=p/n;
b=0;
for i=1:n
    x2(1,i)=b;
    y2=Yme.*curve(x2,Le);
    b=b+q;
end

%transforming shroud curve
x2=-x2;
y2=-y2;
x_tran=Le;
y_tran=Roe;
for i=1:n
    x2(1,i)=x2(1,i)+x_tran;
    y2(1,i)=y2(1,i)+y_tran;
end
plot(y2,x2);

% meridional view with streamline
x = nan(N,n);
y = nan(N,n);
for i=1:N
    x(i,:) = x1 + (x2-x1).*i/(N+1);
    y(i,:) = y1 + (y2-y1).*i/(N+1);
end
for i=1:N
    plot(y(i,:),x(i,:),'g')
end
title('Meridoinal plane')
%%%% Leading and trailing edge point
%%intersection of leading and trailing edge in hub and shroud curve respectively
x_le1=0:0.001:(Le+Bo);
y_le1=x_le1*0+Rli;
LE1=InterX([y_le1;x_le1],[y1;x1]);
plot(LE1(1,1),LE1(2,1),'*')
x_le2=0:0.001:Le+Bo;
y_le2=0*x_le2+R2e*r1e(no);
Le2=InterX([y_le2;x_le2],[y2;x2]);
[pnt,idx]=max(Le2(2,:));
LE2=Le2(:,idx)
plot(LE2(1,1),LE2(2,1),'*')
x_te1=0:0.001:Le+Bo;
y_te1=0*x_te1+R2e*r2i(no);
TE1=InterX([y_te1;x_te1],[y1;x1]);

plot(TE1(1,1),TE1(2,1),'*')
x_te2=0:0.001:Le+Bo;
y_te2=0*x_te2+R2e;
Te2=InterX([y_te2;x_te2],[y2;x2]);
[pnt,idx]=min(Te2(2,:));
TE2=Te2(:,idx);
plot(TE2(1,1),TE2(2,1),'*');

%%%Leading and trailing edge curve
xl=nan(1,n);
yl=nan(1,n);
xt=nan(1,n);
yt=nan(1,n);

%Leading edge
a=(LE1(2,1)-LE2(2,1))/((LE1(1,1)-LE2(1,1))^2);
p=LE2(1,1)-LE1(1,1);
q=(p)/(n-1);
r=LE1(1,1);
for i=1:n
    xl(1,i)=r;
    yl(1,i)=a*(xl(1,i)-LE2(1,1))^2+LE2(2,1);
    r=r+q;
end
plot(xl,yl);

%trailing edge
a=(TE1(2,1)-TE2(2,1))/((TE1(1,1)-TE2(1,1))^2);
p=abs(TE2(1,1)-TE1(1,1));
q=p/(n-1);
r=TE1(1,1);
for i=1:n
    xt(1,i)=r;
    yt(1,i)=a*(xt(1,i)-TE2(1,1))^2+TE2(2,1);
    r=r+q;
end
plot(xt,yt)
xlabel('r');
ylabel('z');
hold off;


     
    end
end

