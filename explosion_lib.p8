pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--Explosion library
--Brian Vaughn
--History: 11/14/16, 2/16/17, 4/17/19

--[[
	Basic explosion particle library (340 tokens)
	In-game use:
	explode_add(x,y, numberOfParticles, optionsTable, drawLayer)
    
    x                   X coordinate of origin
    y                   Y coordinate of origin
    numberOfParticles   Total number of particles to make
    optionsTable        Optional. Custom settings, see below.
    drawLayer           Optional. Draw layer you want your explosion to be on. Default: 1
    
	
    You only need to pass the options that you want to change
        optionsTable={
            dur=30,     -- Duration of individual particle in frames
            rad=3,      -- Starting radius of particle circle
            decay=.2,  -- Rate of reduction per frame. Use negative to grow circle.
            colors={7,10,9,8}, -- Table of colors. Randomly picked per particle.
            smin=.7,   -- Minimum speed of particle. Randomly picked.
            smax=2,     -- Maximum speed of particle. Randomly picked.
            grav=0,    -- Gravity increase applied per frame
            dir=0,      -- Direction of force. 0 for all directions
            range=0,    -- Distribution of particles around the direction (half of value)
			fill=false -- Fill pattern to use. Randomly applied.
        }
	
	
	Add these functions to your system loops:
	explode_init(layers)  Call in _init() to declare and clear tables.
	explode_update()      Updates all explosions and layers
	explode_draw(layer)   Updates single draw layer. Default: 1
    
    You can call explode_draw() in multiple places assuming you provide a layer. This
    allows you to have explosions where you want them compared to other graphics. Just
    make sure you provide the layer number when you create your explosion.
]]


function explode_init(l)
	explode_loop={}
	local l=l or 1
	for n=0,l do add(explode_loop,{}) end
end


function explode_add(x,y, qty, options, layer)
    layer=layer or 1

	for n=0,qty do
		local obj={
			x=x,y=y,
			t=0,
			dur=30,
			rad=3,
			decay=.2,
			fill=false,
			colors={7,10,9,8},
			smin=.7,
			smax=2,
			grav=0,
			layer=layer,
			dir=0,
			range=0,
			_update=function(o)
				o.dy+=o.g
				o.y+=o.dy
				o.x+=o.dx
				o.t+=1
				o.rad-=o.decay

				if o.t>o.dur or o.rad<0 then del(explode_loop[o.layer],o) end
			end,
			_draw=function(o)
				if rnd()<.5 then fillp(o.fill) end
				circfill(o.x,o.y, o.rad, o.c)
				fillp()
			end
		}
		
		if options then 
			for k,v in pairs(options) do obj[k]=v end
		end
		
		local c=flr(rnd(#obj.colors))+1
		local sp=rnd(obj.smax-obj.smin)+obj.smin

		if obj.dir>0 then
			local dirh=obj.range/2
			local dira=obj.dir-dirh
			local dirb=obj.dir+dirh
			
			obj.dir=rnd(dirb-dira)+dira
		else
			obj.dir=rnd()	
		end
	
		obj.c=obj.colors[c]
		obj.g=rnd(abs(obj.grav))
		obj.dx=cos(obj.dir)*sp
		obj.dy=sin(obj.dir)*sp
		
		if obj.grav<0 then obj.g*=-1 end

		add(explode_loop[layer],obj)
	end
end

function explode_update()
	for _,e in pairs(explode_loop) do 
		for _,p in pairs(e) do p:_update(p) end
	end
end

function explode_draw(l)
	local l=l or 1
	for _,e in pairs(explode_loop[l]) do e:_draw(p) end
end



-- ..............................
-- DEMO ONLY

function _init()
	explode_init(2) -- initialize with 2 draw layers
end

function _update()
	custom_cfg={dir=-1}
	
	if btnp(0) then custom_cfg={dir=.5,range=.5,x=54,y=64,rad=3,smax=8} end
	if btnp(1) then custom_cfg={dir=1,range=.5,x=74,y=64,rad=3,smax=8} end
	if btnp(2) then custom_cfg={dir=.25,range=.5,x=64,y=54,rad=3,smax=8} end
	if btnp(3) then custom_cfg={dir=.75,range=.5,x=64,y=74,rad=3,smax=8} end
	if btnp(4) then 
		custom_cfg={dir=0,rad=3,smax=8,grav=0,range=0} 
		explode_add(64,64, 32, custom_cfg, 2)
	end
	if btnp(5) then 
		custom_cfg={dir=0,rad=3,smax=8,grav=0,range=0}
		explode_add(64,64, 32, custom_cfg)
	end

	if custom_cfg.dir>0 then
		explode_add(custom_cfg.x,custom_cfg.y, 24, custom_cfg, 1)
	end

	explode_update()
	
end

function _draw()
	cls()
	print("arrow keys explode in direction",1,5,5)
	print("z explodes in front",1,13,5)
	print("x explodes in behind",1,21,5)
	
	
	explode_draw(1) --draws on layer 1, behind square
	rectfill(54,54, 74,74, 3)
	explode_draw(2) --draws on layer 2, in front of square
end

