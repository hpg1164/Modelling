%%main.m%%

clc
clear

Q=39.9; % in m^3/s
H=30.5 % in m
nrpm=300; %in rpm
nr=2*pi*nrpm/60; %in rad per second
N=40;        %no of streamlines
n=50;                   % n is set to 50, which will determine the number of points in the curve.


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







%%%%% curve.m%%%%
function y= curve(x,l)
x=x./l;
y=3.08.*(1-x).^(3/2).*(x).^(0.5);
end

%%%%%%r1e.m%%%%%
function r1e= r1e(no)
r1e=-125.6*no^5 + 299.4*no^4 - 278.0*no^3 + 126.3*no^2 - 28.52*no + 3.674;
end

%%%%%% r2i%%%%%%
function r2i = r2i(no)
r2i= -25.824*no^5 + 61.275*no^4 - 56.035 *no^3 + 25.096*no^2 - 5.8833*no + 1.0977;
end


function P = InterX(L1,varargin)

    error(nargchk(1,2,nargin));
    if nargin == 1,
        L2 = L1;    hF = @lt;   %...Avoid the inclusion of common points
    else
        L2 = varargin{1}; hF = @le;
    end
       
    %...Preliminary stuff
    x1  = L1(1,:)';  x2 = L2(1,:);
    y1  = L1(2,:)';  y2 = L2(2,:);
    dx1 = diff(x1); dy1 = diff(y1);
    dx2 = diff(x2); dy2 = diff(y2);
    
    %...Determine 'signed distances'   
    S1 = dx1.*y1(1:end-1) - dy1.*x1(1:end-1);
    S2 = dx2.*y2(1:end-1) - dy2.*x2(1:end-1);
    
    C1 = feval(hF,D(bsxfun(@times,dx1,y2)-bsxfun(@times,dy1,x2),S1),0);
    C2 = feval(hF,D((bsxfun(@times,y1,dx2)-bsxfun(@times,x1,dy2))',S2'),0)';

    %...Obtain the segments where an intersection is expected
    [i,j] = find(C1 & C2); 
    if isempty(i),P = zeros(2,0);return; end;
    
    %...Transpose and prepare for output
    i=i'; dx2=dx2'; dy2=dy2'; S2 = S2';
    L = dy2(j).*dx1(i) - dy1(i).*dx2(j);
    i = i(L~=0); j=j(L~=0); L=L(L~=0);  %...Avoid divisions by 0
    
    %...Solve system of eqs to get the common points
    P = unique([dx2(j).*S1(i) - dx1(i).*S2(j), ...
                dy2(j).*S1(i) - dy1(i).*S2(j)]./[L L],'rows')';
              
    function u = D(x,y)
        u = bsxfun(@minus,x(:,1:end-1),y).*bsxfun(@minus,x(:,2:end),y);
    end
end