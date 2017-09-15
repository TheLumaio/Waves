
function lerp(a,b,t) return (1-t)*a + t*b end
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end

-- shamelessly stolen from stackoverflow
function rotatepoint(cx, cy, x, y, angle)
	local p = {
		x = x,
		y = y
	}
	local s = math.sin(angle);
	local c = math.cos(angle);

	p.x = p.x - cx;
	p.y = p.y - cy;

	local xnew = p.x * c - p.y * s;
	local ynew = p.x * s + p.y * c;

	p.x = xnew + cx;
	p.y = ynew + cy;
	
	return p
end
