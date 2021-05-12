load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;=======================================================================
begin

f0 = addfile("/home/L.wurjicnip/mask/mask_global_land_1x1.nc","r")
a  = f0->mask
a  = where(a.eq.1 .or. a.eq.2 .or. a.eq.3 .or. a.eq.4 .or. a.eq.5 .or. a.eq.6 .or. a.eq.7\
.or. a.eq.8 .or. a.eq.9 .or. a.eq.11 .or. a.eq.12 .or. a.eq.18 .or. a.eq.19\
.or.a.eq.26,a ,a@_FillValue)

a  = where(a.eq.11,10,a)
a  = where(a.eq.12,11,a)
a  = where(a.eq.18,12,a)
a  = where(a.eq.19,13,a)
a  = where(a.eq.26,14,a)

a  = where(a.eq.8,100,a)
a  = where(a.eq.9,8,a)
a  = where(a.eq.100,9,a)
a  = a+1
a  = where(ismissing(a), -2, a)
;=======================================================================
plot=new(10,graphic)
wks=gsn_open_wks("pdf","Fig4_river_basin_location_dominant_202012")
gsn_define_colormap(wks,"Cat12")
;=======================================================  gsn setting 
res =True
res@gsnDraw = False
res@gsnFrame= False 
res@gsnMaximize = True
res@gsnSpreadColors=True
res@gsnMaximize=True
res@gsnAddCyclic = True
res@mpMinLatF = -60
;=======================================================  contour setting
level = fspan(0.5,14.5,15)
res@cnLevelSelectionMode="ExplicitLevels"
res@cnFillMode = "RasterFill"
res@cnLevels=(/level/)
res@cnFillOn       = True
res@cnLinesOn      = True
res@cnLineThicknessF = 2.0
res@cnLineLabelsOn = False
;res@cnFillColors   = (/ 0, 0, 13, 9, 13, 9, 9, 13, 9, 13, 9, 13, 9, 13, 13, 13/)
;res@cnFillColors  =  (/ 0, 0, 9, 13, 9, 13, 13, 9, 13, 9, 13, 9, 13, 9, 9, 9/)
res@cnFillColors   =  (/ 0, 0, 9, 13, 9, 13, 13, 9, 13, 9, 13, 9, 13, 0, 9, 0/)

;=======================================================  map setting
res@mpGeophysicalLineThicknessF = 3.0
;res@mpDataBaseVersion = "MediumRes"
;=======================================================  label setting 
res@lbLabelBarOn        = False 
;res@mpOutlineDrawOrder  = "Draw"
res@tiMainString      = ""   ; add title
plot(0)=gsn_csm_contour_map_ce(wks,a,res)

txres = True
txres@txFontHeightF = 0.01                    ; text font height
txres@txJust        = "CenterLeft"            ; Default is "CenterCenter".

text1 = gsn_add_text(wks, plot(0), "1  : Amazon",     -170, -19, txres)
text2 = gsn_add_text(wks, plot(0), "2  : Congo",      -170, -25, txres)
text3 = gsn_add_text(wks, plot(0), "3  : Ganges",     -170, -31, txres)
text4 = gsn_add_text(wks, plot(0), "4  : Niger",      -170, -37, txres)
text5 = gsn_add_text(wks, plot(0), "5  : Nile",       -170, -43, txres)
text6 = gsn_add_text(wks, plot(0), "6  : Danube",     -170, -49, txres)
text7 = gsn_add_text(wks, plot(0), "7  : Mississippi",-170, -55, txres)
text8 = gsn_add_text(wks, plot(0), "9  : Murray",     -130, -25, txres)
text9 = gsn_add_text(wks, plot(0), "10 : Parana",     -130, -31, txres)
text0 = gsn_add_text(wks, plot(0), "8  : Yangtze",    -130, -19, txres)
texta = gsn_add_text(wks, plot(0), "11 : Lena",       -130, -37 , txres)
textb = gsn_add_text(wks, plot(0), "12 : Mackenzie",  -130, -43, txres)
textc = gsn_add_text(wks, plot(0), "13 : Ob",         -130, -49, txres)
textd = gsn_add_text(wks, plot(0), "14 : Yenisei",    -130, -55, txres)

txres@txFontHeightF = 0.009
l1    = gsn_add_text(wks, plot(0), "1" , -65.0,  -8.0, txres)
l2    = gsn_add_text(wks, plot(0), "2" ,  21.0,  -2.5, txres)
l3    = gsn_add_text(wks, plot(0), "7" , -97.5,  39.5, txres)
l4    = gsn_add_text(wks, plot(0), "13",  70.5,  57.5, txres)
l5    = gsn_add_text(wks, plot(0), "10", -58.5, -23.5, txres)
l6    = gsn_add_text(wks, plot(0), "5" ,  31.5,  10.5, txres)
l7    = gsn_add_text(wks, plot(0), "14",  95.5,  60.5, txres)
l8    = gsn_add_text(wks, plot(0), "11", 120.5,  62.5, txres)
l9    = gsn_add_text(wks, plot(0), "4" ,   2.5,  15.5, txres)
l10   = gsn_add_text(wks, plot(0), "8" , 105.5,  30.0, txres)
l11   = gsn_add_text(wks, plot(0), "12",-123.0,  60.0, txres)
l12   = gsn_add_text(wks, plot(0), "9" , 145.0, -32.5, txres)
l13   = gsn_add_text(wks, plot(0), "3" ,  80.5,  26.5, txres)
l14   = gsn_add_text(wks, plot(0), "6" ,  19.5,  46.0, txres)

plres= True
plres@gsLineThicknessF = 15.0

pmres= True
pmres@gsMarkerIndex    = 3
pmres@gsMarkerSizeF    = 0.005
pmres@gsMarkerColor    = "white"
;pmres@tfPolyDrawOrder  = "PostDraw"

plres@gsLineColor      = "gold4"
dum12 = gsn_add_polyline  (wks, plot(0), (/-88,-88/), (/-5,-12/), plres)
plres@gsLineColor      = "forestgreen"
dum13 = gsn_add_polyline  (wks, plot(0), (/-84,-84/), (/-5,-12/), plres)

mar11 = gsn_add_polymarker(wks, plot(0), -84, -6, pmres)
mar12 = gsn_add_polymarker(wks, plot(0), -84, -8.5, pmres)
mar13 = gsn_add_polymarker(wks, plot(0), -84, -11, pmres)

mar14 = gsn_add_polymarker(wks, plot(0), -88, -6, pmres)
mar15 = gsn_add_polymarker(wks, plot(0), -88, -8.5, pmres)
mar16 = gsn_add_polymarker(wks, plot(0), -88, -11, pmres)

plres@gsLineColor      = "cyan"
dum21 = gsn_add_polyline  (wks, plot(0), (/20.5,20.5/), (/-16,-23/), plres)

mar21 = gsn_add_polymarker(wks, plot(0), 20.5, -17, pmres)
mar22 = gsn_add_polymarker(wks, plot(0), 20.5, -19.5, pmres)
mar23 = gsn_add_polymarker(wks, plot(0), 20.5, -22, pmres)

plres@gsLineColor      = "gold"
dum32 = gsn_add_polyline  (wks, plot(0), (/-71,-71/), (/33,40/), plres)

mar31 = gsn_add_polymarker(wks, plot(0), -71, 34, pmres)
mar32 = gsn_add_polymarker(wks, plot(0), -71, 36.5, pmres)
mar33 = gsn_add_polymarker(wks, plot(0), -71, 39, pmres)

plres@gsLineColor      = "cyan"
dum41 = gsn_add_polyline  (wks, plot(0), (/66.5,66.5/), (/73,80/), plres)
plres@gsLineColor      = "forestgreen"
dum42 = gsn_add_polyline  (wks, plot(0), (/70.5,70.5/), (/73,80/), plres)

mar41 = gsn_add_polymarker(wks, plot(0), 70.5, 76.5, pmres)

;plres@gsLineColor      = "cyan"
;dum51 = gsn_add_polyline  (wks, plot(0), (/-45,-45/), (/-30,-37/), plres)

plres@gsLineColor      = "blue"
dum61 = gsn_add_polyline  (wks, plot(0), (/43,43/), (/10,3/), plres)
mar61 = gsn_add_polymarker(wks, plot(0), 43, 9, pmres)
mar62 = gsn_add_polymarker(wks, plot(0), 43, 6.5, pmres)
mar63 = gsn_add_polymarker(wks, plot(0), 43, 4, pmres)

plres@gsLineColor      = "cyan"
dum71 = gsn_add_polyline  (wks, plot(0), (/91.5,91.5/), (/73,80/), plres)
plres@gsLineColor      = "forestgreen"
dum72 = gsn_add_polyline  (wks, plot(0), (/95.5,95.5/), (/73,80/), plres)

mar71 = gsn_add_polymarker(wks, plot(0), 91.5, 74, pmres)
mar72 = gsn_add_polymarker(wks, plot(0), 91.5, 76.5, pmres)
mar73 = gsn_add_polymarker(wks, plot(0), 91.5, 79, pmres)
mar74 = gsn_add_polymarker(wks, plot(0), 95.5, 74, pmres)
mar75 = gsn_add_polymarker(wks, plot(0), 95.5, 76.5, pmres)
mar76 = gsn_add_polymarker(wks, plot(0), 95.5, 79, pmres)

plres@gsLineColor      = "cyan"
dum81 = gsn_add_polyline  (wks, plot(0), (/116.5,116.5/), (/76,83/), plres)
plres@gsLineColor      = "forestgreen"
dum82 = gsn_add_polyline  (wks, plot(0), (/120.5,120.5/), (/76,83/), plres)

mar81 = gsn_add_polymarker(wks, plot(0), 116.5, 77, pmres)
mar82 = gsn_add_polymarker(wks, plot(0), 116.5, 79.5, pmres)
mar83 = gsn_add_polymarker(wks, plot(0), 116.5, 82, pmres)
mar84 = gsn_add_polymarker(wks, plot(0), 120.5, 77, pmres)
mar85 = gsn_add_polymarker(wks, plot(0), 120.5, 79.5, pmres)
mar86 = gsn_add_polymarker(wks, plot(0), 120.5, 82, pmres)

;plres@gsLineColor      = "forestgreen"
;dum91 = gsn_add_polyline  (wks, plot(0), (/-10,-10/), (/21.5,28.5/), plres)

plres@gsLineColor      = "blue"
dum101 = gsn_add_polyline  (wks, plot(0), (/107.5,107.5/), (/37,44/), plres)
plres@gsLineColor      = "lawngreen"
dum102 = gsn_add_polyline  (wks, plot(0), (/111.5,111.5/), (/37,44/), plres)

mar101 = gsn_add_polymarker(wks, plot(0), 107.5, 38, pmres)
mar102 = gsn_add_polymarker(wks, plot(0), 107.5, 40.5, pmres)
mar103 = gsn_add_polymarker(wks, plot(0), 107.5, 43, pmres)
mar104 = gsn_add_polymarker(wks, plot(0), 111.5, 38, pmres)
mar105 = gsn_add_polymarker(wks, plot(0), 111.5, 40.5, pmres)
mar106 = gsn_add_polymarker(wks, plot(0), 111.5, 43, pmres)

plres@gsLineColor      = "forestgreen"
dum111 = gsn_add_polyline  (wks, plot(0), (/-135,-135/), (/47,54/), plres)
plres@gsLineColor      = "cyan"
dum112 = gsn_add_polyline  (wks, plot(0), (/-139,-139/), (/47,54/), plres)

mar111 = gsn_add_polymarker(wks, plot(0), -135, 48, pmres)
mar112 = gsn_add_polymarker(wks, plot(0), -135, 50.5, pmres)
mar113 = gsn_add_polymarker(wks, plot(0), -135, 53, pmres)
mar114 = gsn_add_polymarker(wks, plot(0), -139, 48, pmres)
mar115 = gsn_add_polymarker(wks, plot(0), -139, 50.5, pmres)
mar116 = gsn_add_polymarker(wks, plot(0), -139, 53, pmres)

;plres@gsLineColor      = "lawngreen"
;dum121 = gsn_add_polyline  (wks, plot(0), (/138,138/), (/-29,-22/), plres)

plres@gsLineColor      = "cyan"
dum132 = gsn_add_polyline  (wks, plot(0), (/70,70/), (/30,37/), plres)
plres@gsLineColor      = "lawngreen"
dum133 = gsn_add_polyline  (wks, plot(0), (/66,66/), (/30,37/), plres)
mar131 = gsn_add_polymarker(wks, plot(0), 66, 33.5, pmres)

;plres@gsLineColor      = "forestgreen"
;dum141 = gsn_add_polyline  (wks, plot(0), (/30,30/), (/49,56/), plres)

txres@txFontHeightF = 0.01 

t1   = gsn_add_text(wks, plot(0),"Recharge-Precipitation",  -20,  -41, txres)
plres@gsLineColor      = "cyan"
dumt1 = gsn_add_polyline   (wks, plot(0), (/-32,-25/), (/-41,-41/), plres)

t2   = gsn_add_text(wks, plot(0),"Recharge-ET",    -20,  -48, txres)
plres@gsLineColor      = "gold"
dumt2 = gsn_add_polyline   (wks, plot(0), (/-32,-25/), (/-48,-48/), plres)

t3   = gsn_add_text(wks, plot(0),"Recharge-Runoff",         -20,  -55, txres)
plres@gsLineColor      = "lawngreen"
dumt3 = gsn_add_polyline   (wks, plot(0), (/-32,-25/), (/-55,-55/), plres)

t4   = gsn_add_text(wks, plot(0),"Discharge-Precipitation",    67,  -41, txres)
plres@gsLineColor      = "blue"
dumt4 = gsn_add_polyline   (wks, plot(0), (/55,62/), (/-41,-41/), plres)

t5   = gsn_add_text(wks, plot(0),"Discharge-ET",      67,  -48, txres)
plres@gsLineColor      = "gold4"
dumt5 = gsn_add_polyline   (wks, plot(0), (/55,62/), (/-48,-48/), plres)

t6   = gsn_add_text(wks, plot(0),"Discharge-Runoff",           67,  -55, txres)
plres@gsLineColor      = "forestgreen"
dumt6 = gsn_add_polyline   (wks, plot(0), (/55,62/), (/-55,-55/), plres)

;cmap = read_colormap_file("temp_diff_1lev")
cmap = read_colormap_file("Cat12")

txref= True
txref@txFontHeightF = 0.015                     ; text font height
txref@txJust        = "CenterLeft"              ; Default is "CenterCenter".
txref@txBackgroundFillColor = cmap(7,:)
gsn_text_ndc(wks,"TWSA Range: Models < GRACE", .57,  .25, txref)
;txref@txPolyDrawOrder = "PostDraw" 
txref@txBackgroundFillColor = cmap(11,:)
gsn_text_ndc(wks,"TWSA Range: Models > GRACE", .17,  .25, txref)


draw(plot(0))
frame(wks) 
end 
