%%%%% curve.m%%%%
function y= curve(x,l)
x=x./l;
y=3.08.*(1-x).^(3/2).*(x).^(0.5);
end