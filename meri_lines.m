%%%%%%meri_lines.m%%%%%
function [x1,y1,x2,y2,x,y,LE1,LE2,TE1,TE2,xl,yl,xt,yt]=meri_lines(Q,H,nr,N) 
    [no,R2e,Bo,Roi,Ymi,Rli,Roe,Li,Le,~,~,Yme,~]= meridoinaldim (Q,H,nr,N);
    H = 30.5;    %input('Head Available (m) \n'); %Head Available in m
Q = 39.9;    %input('Discharge m^3/s\n');
nrpm = 500;  %input('Rotational speed  rpm\n');
N = 50;
nr=2*pi*nrpm/60; %in rad per second

%for hub curve
n=50;                    % n is set to 50, which will determine the number of points in the curve.
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
figure(1)
plot(y1,x1)
hold on
grid on
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
plot(y2,x2)

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
[~,idx]=max(Le2(2,:));
LE2=Le2(:,idx);
plot(LE2(1,1),LE2(2,1),'*')
x_te1=0:0.001:Le+Bo;
y_te1=0*x_te1+R2e*r2i(no);
TE1=InterX([y_te1;x_te1],[y1;x1]);

plot(TE1(1,1),TE1(2,1),'*')
x_te2=0:0.001:Le+Bo;
y_te2=0*x_te2+R2e;
Te2=InterX([y_te2;x_te2],[y2;x2]);
[~,idx]=min(Te2(2,:));
TE2=Te2(:,idx);
plot(TE2(1,1),TE2(2,1),'*')
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
plot(xl,yl)
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
hold off