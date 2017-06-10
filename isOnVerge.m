function res = isOnVerge(r, c, xc, yc, w, h)
% xmax = xc + w / 2.0;
% xmin = xc - w /2.0;
% ymax = yc + h / 2.0;
% ymin = yc - h / 2.0;
xmax = xc + w;
xmin = xc;
ymax = yc + h;
ymin = yc;

ret = 0;

if r == ymin || r == ymax
    if c >= min(xmin,xmax) && c <= max(xmin,xmax)
       ret = 1;
    end
end

if c == xmin || c == xmax
    if r >= min(ymin,ymax) && r <= max(ymin,ymax)
       ret = 1;
    end
end
res = ret;
end