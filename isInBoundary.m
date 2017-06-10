function res = isInBoundary(r, c, xc, yc, w, h)
xmax = xc + w;
xmin = xc;
ymax = yc + h;
ymin = yc;

ret = false;

if r >= min(ymin, ymax) && r <= max(ymin, ymax)
    if c >= min(xmin,xmax) && c <= max(xmin,xmax)
       ret = true;
    end
end

res = ret;
end