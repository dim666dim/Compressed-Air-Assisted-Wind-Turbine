clear all
close all

load mapdemo.mat
ax = worldmap(latlim, lonlim);
surfm(Lat_lon,Lon_lat,China_data);
symbols=makesymbolspec('Polygon',{'default','FaceColor','none', 'LineStyle','--','LineWidth',0.2, 'EdgeColor',[0 0 0]});
geoshow('bou2_4p.shp', 'FaceColor','w','FaceAlpha',0,'EdgeColor','black','LineWidth', 1)
colorbar