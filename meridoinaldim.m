%%%%%%% meridoinaldim.m%%%%%%
%input flow rate,head,rotational speed,no.of streamlines
function [no,R2e,Bo,Roi,Ymi,Rli,Roe,Li,Le,X2e,Y2e,Yme,Rme]=meridoinaldim (Q,H,nr,N)
%constant
        g=9.81
        v2eo=0.27
        x2e=0.5
%dimensionless dimension of meridoinal plane

no=(nr*(Q/pi)^(0.5))/((2*g*H)^(3/4))       %dimensionless specific speed
bo=0.8*(2-no)*no                            %inlet blade thickness(width of the blade)

%i is for the hub whereas e is for the shrub 
roi=0.7+0.16/(no+0.08)                      
ymi=roi
rli=0.493/(no^(2/3))
if no<0.275
roe=0.493/(no^(2/3))
else
roe=1.255-0.3*no
end
li=3.2+3.2*(2-no)*no
le=2.4-1.9*(2-no)*no
x2e=0.5 %suppose constant
y2e=roe-1
y2ebyyme=curve(x2e,le)
yme=y2e/y2ebyyme
rme=roe-yme
% Normalizing dimensions
R2e=((Q/pi)/(v2eo*nr))^(1/3);
Bo=bo*R2e
Roi=roi*R2e
Ymi=ymi*R2e
Rli=rli*R2e
Roe=roe*R2e
Li=li*R2e
Le=le*R2e
X2e=x2e*R2e
Y2e=y2e*R2e
Yme=yme*R2e
Rme=rme*R2e