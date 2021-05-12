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
delete([f0])
;=======================================================================
wtype          = "png"
wtype@wkWidth  = 4000    ; Increase size of PNG image.
wtype@wkHeight = 4000

plot=new(50,graphic)

wks=gsn_open_wks(wtype,"Fig1_river_basin_location_xy_2020")

;gsn_define_colormap(wks,"grads_default")
;gsn_define_colormap(wks,"CBR_set3")
gsn_define_colormap(wks,"Cat12")

res =True
res@gsnFrame        = False

res@vpXF            = 0.1         
res@vpWidthF        = 0.9	    
res@vpYF            = 0.9
res@vpHeightF       = 0.9   
res@gsnMaximize     = True

res@mpMinLatF = -60
res@mpMaxLatF = 90

res@cnFillOn =True
res@cnLinesOn=True
res@cnLineThicknessF = 11
res@gsnSpreadColors=True

res@gsnAddCyclic = True
res@mpGeophysicalLineThicknessF = 3.0

res@lbLabelFont      = "Helvetica-Bold"     ; label font
res@lbLabelFontHeightF= .015
res@lbLabelPosition  = "Center"             ; label position
res@lbLabelAlignment = "BoxCenters"         ; label orientation
;res@lbLabelStrings =  (/"","","1","2","3","4","5","6","7","8","9","10","11","12","13","14"/)
;res@cnFillColors   = (/0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15/)

res@lbLabelStrings =  (/"","","1","2","3","4","5","6","7","8","9","10","11","12","13","14"/)
;res@cnFillColors   = (/0,1,2,3,4,5,6,7,8,9,10,11,12,13,13/)
res@cnFillColors   =  (/ 0, 0, 9, 13, 9, 13, 13, 9, 13, 9, 13, 9, 13, 0, 9, 0/)




;1,AMAZON,0.5,-50.5,6108475.7
;2,CONGO,-5.5,12.5,3710249.8
;3,MISSISSIPPI,29.5,-90.5,3244557.7
;4,OB,66.5,70.5,2965730.2
;5,PARANA,-34.5,-58.5,2998410.4
;6,NILE,30.5,30.5,2888268.7
;7,YENISEY,71.5,83.5,2588224.3
;8,LENA,73.5,124.5,2342784.9
;9,NIGER,4.5,6.5,2110736.6
;10,CHANGJIANG,31.5,120.5,1823412.1
;11,MACKENZIE,68.5,-134.5,1679776.3
;12,MURRAY,-35.5,139.5,1065409.0
;13,GANGES,22.5,88.5,1026952.9
;14,DANUBE,45.5,29.5,804912.2



res@lbLabelBarOn   = False

;res@cnFillMode = "RasterFill"
res@cnLineLabelsOn = False
res@cnLevelSelectionMode="ExplicitLevels"

level = fspan(0.5,14.5,15)
res@cnLevels=(/level/)

;res@mpDataBaseVersion = "MediumRes"
res@tiMainString       = ""   ; add title
res@mpOutlineDrawOrder = "PostDraw"

plot(0)=gsn_csm_contour_map(wks,a,res)

txres = True
txres@txFontHeightF = 0.01                    ; text font height
txres@txJust        = "CenterLeft"            ; Default is "CenterCenter".

text1 = gsn_add_text(wks, plot(0), "1  : Amazon",     -175, -20, txres)
text2 = gsn_add_text(wks, plot(0), "2  : Congo",      -175, -26, txres)
text3 = gsn_add_text(wks, plot(0), "3  : Ganges",     -175, -32, txres)
text4 = gsn_add_text(wks, plot(0), "4  : Niger",      -175, -38, txres)
text5 = gsn_add_text(wks, plot(0), "5  : Nile",       -175, -44, txres)
text6 = gsn_add_text(wks, plot(0), "6  : Danube",     -175, -50, txres)
text7 = gsn_add_text(wks, plot(0), "7  : Mississippi",-175, -56, txres)
text8 = gsn_add_text(wks, plot(0), "9  : Murray",     -135, -26, txres)
text9 = gsn_add_text(wks, plot(0), "10 : Parana",     -135, -32, txres)
text0 = gsn_add_text(wks, plot(0), "8  : Yangtze",    -135, -20, txres)
texta = gsn_add_text(wks, plot(0), "11 : Lena",       -135, -38, txres)
textb = gsn_add_text(wks, plot(0), "12 : Mackenzie",  -135, -44, txres)
textc = gsn_add_text(wks, plot(0), "13 : Ob",         -135, -50, txres)
textd = gsn_add_text(wks, plot(0), "14 : Yenisei",    -135, -56, txres)
gsn_text_ndc(wks, "Unit: mm", 0.90, 0.70, txres)

txres@txFontHeightF = 0.009

l1    = gsn_add_text(wks, plot(0), "1" , -65.0,  -8.0, txres)
l2    = gsn_add_text(wks, plot(0), "2" ,  21.0,  -2.5, txres)
l3    = gsn_add_text(wks, plot(0), "7" , -97.5,  39.5, txres)
l4    = gsn_add_text(wks, plot(0), "13",  70.5,  57.5, txres)
l5    = gsn_add_text(wks, plot(0), "10" , -58.5, -23.5, txres)
l6    = gsn_add_text(wks, plot(0), "5" ,  31.5,  10.5, txres)
l7    = gsn_add_text(wks, plot(0), "14",  95.5,  60.5, txres)
l8    = gsn_add_text(wks, plot(0), "11", 120.5,  62.5, txres)
l9    = gsn_add_text(wks, plot(0), "4" ,   2.5,  15.5, txres)
l10   = gsn_add_text(wks, plot(0), "8", 105.5,  30.0, txres)
l11   = gsn_add_text(wks, plot(0), "12",-123.0,  60.0, txres)
l12   = gsn_add_text(wks, plot(0), "9" , 145.0, -32.5, txres)
l13   = gsn_add_text(wks, plot(0), "3" ,  80.5,  26.5, txres)
l14   = gsn_add_text(wks, plot(0), "6" ,  19.5,  46.0, txres)

draw(plot(0))
;==============================================================================================================

var =(/"ACCESS-CM2","ACCESS-ESM1-5","AWI-ESM-1-1-LR","BCC-CSM2-MR","BCC-ESM1","CanESM5","CESM2","CESM2-WACCM"\
,"CNRM-CM6-1","CNRM-ESM2-1","GFDL-CM4","GISS-E2-1-G"\
,"GISS-E2-1-H","IPSL-CM6A-LR","MIROC6","MIROC-ES2L","MPI-ESM-1-2-HAM","MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorESM2-LM"\
,"NorESM2-MM","SAM0-UNICON","TaiESM1","UKESM1-0-LL"/)


river = (/"Amazon","Congo","Danube","Ganges","Lena","Mackenzie","Mississippi","Murray","Niger","Nile","Ob","Parana",\
"Yangtze","Yenisei"/)

f0 = addfile("../obs/GRACE_river_Ann_mascon_06_2003_2014.nc","r")

OBS= f0->Result                                                   ; 14 rivers x 12 months
OBS= dim_rmvmean_n(OBS,1)

fils1 = systemfunc ("ls ../model/*DSPER_Ann_*.nc")
f1    = addfiles (fils1, "r")
ListSetType (f1,"join")
tws   = f1[:]->Result
TWS   = dim_rmvmean_n(tws(:,:,0,:),2)                             ; 23 CMIP5 models x 14 rivers x 12 months

TWS_M = dim_avg_n(TWS,0)

X           = fspan(1,12,12)
Y           = new((/26,14,12/),"float")

Y(25,:,:)    = (/OBS/)
Y(0:24,:,:)  = (/TWS/) 

resxy                     = True                   ; plot mods desired
resxy@gsnFrame            = False

resxy@trXMinF = 1    ; set minimum X-axis value
resxy@trXMaxF = 12            ; set maximum X-axis value

resxy@tmXBMode         = "Manual"
resxy@tmXBLabelsOn     = False
resxy@tmYLLabelsOn     = True
resxy@tmXTOn           = False

resxy@tmXBTickStartF  = 1
resxy@tmXBTickEndF    = 12
resxy@tmXBTickSpacingF= 1
resxy@tmXBFormat = "f"

resxy@tiXAxisString = "month"   ; Y-axis title
;resxy@tiYAxisFontHeightF = 0.015
;resxy@gsnRightString = "mm"   

;resxy@gsnXYFillColors = "Red"
;resxy@tmXBLabelFontHeightF = 0.01
resxy@tmYLLabelFontHeightF  = 0.005

resxy@xyLineThicknesses = (/1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,10/)
resxy@xyDashPattern     = (/0/)      ; make all lines solid

resxy@xyLineColors = (/"blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue",\
"blue","blue","blue","blue","blue","blue","blue","blue","blue","black"/)
;====================================================
resxy@tiYAxisString = ""
resxy@tiXAxisString = ""
resxy@vpWidthF             = 0.040*1.42
resxy@vpHeightF            = 0.040*1.42
resxy@tiMainFontHeightF    = 0.006
;=================================================================================================
;river = (/"Amazon","Congo","Danube","Ganges","Lena","Mackenzie","Mississippi","Murray","Niger","Nile","Ob","Parana","Yangtze","Yenisei"/)
;=================================================================================================  Amazon - No.1
resxy@tiMainString         = "1 (25,0)"
resxy@vpXF                 = 0.253
resxy@vpYF                 = 0.484     

AA                    = floor(min(Y(:,0,:)))
BB                    = ceil(max(Y(:,0,:)))
resxy@trYMinF         = floor(min(Y(:,0,:)))
resxy@trYMaxF         = ceil(max(Y(:,0,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)

plot(1)  = gsn_csm_xy(wks,X,Y(:,0,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,0,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,0,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,0,:))
                 res1@trYMaxF     = max(Y(:,0,:))
                 res1@gsnYRefLine = min(Y(:,0,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(30)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(30),plot(1))
draw(plot(30))
;===============================================================
;=================================================================================================  Congo- No.2
resxy@tiMainString         = "2 (4,21)"
resxy@vpXF                 = 0.49
resxy@vpYF                 = 0.442

AA                    = floor(min(Y(:,1,:)))
BB                    = ceil(max(Y(:,1,:)))
resxy@trYMinF         = floor(min(Y(:,1,:)))
resxy@trYMaxF         = ceil(max(Y(:,1,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)

plot(2)  = gsn_csm_xy(wks,X,Y(:,1,:),resxy)
delete(resxy@tiMainString)
;=================================================================================================  Danube-No.6
resxy@tiMainString         = "6 (13,12)"
resxy@vpXF                 = 0.48
resxy@vpYF                 = 0.61

AA                    = floor(min(Y(:,2,:)))
BB                    = ceil(max(Y(:,2,:)))
resxy@trYMinF         = floor(min(Y(:,2,:)))
resxy@trYMaxF         = ceil(max(Y(:,2,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)

plot(3)  = gsn_csm_xy(wks,X,Y(:,2,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,2,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,2,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,2,:))
                 res1@trYMaxF     = max(Y(:,2,:))
                 res1@gsnYRefLine = min(Y(:,2,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(40)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(40),plot(3))
draw(plot(40))
;===============================================================
;=================================================================================================  Ganges-No.3
resxy@tiMainString         = "3 (25,0)"
resxy@vpXF                 = 0.712
resxy@vpYF                 = 0.495

AA                    = floor(min(Y(:,3,:)))
BB                    = ceil(max(Y(:,3,:)))
resxy@trYMinF         = floor(min(Y(:,3,:)))
resxy@trYMaxF         = ceil(max(Y(:,3,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)

plot(4)  = gsn_csm_xy(wks,X,Y(:,3,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,3,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,3,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,3,:))
                 res1@trYMaxF     = max(Y(:,3,:))
                 res1@gsnYRefLine = min(Y(:,3,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(41)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(41),plot(4))
draw(plot(41))
;===============================================================
;=================================================================================================  Lena -No.11
resxy@tiMainString         = "11 (1,24)"
resxy@vpXF                 = 0.883
resxy@vpYF                 = 0.665

AA                    = floor(min(Y(:,4,:)))
BB                    = ceil(max(Y(:,4,:)))
resxy@trYMinF         = floor(min(Y(:,4,:)))
resxy@trYMaxF         = ceil(max(Y(:,4,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)

plot(5)  = gsn_csm_xy(wks,X,Y(:,4,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,4,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,4,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,4,:))
                 res1@trYMaxF     = max(Y(:,4,:))
                 res1@gsnYRefLine = min(Y(:,4,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(39)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(39),plot(5))
draw(plot(39))
;===============================================================
;=================================================================================================  Mackenzie -No.12
resxy@tiMainString         = "12 (2,23)"
resxy@vpXF                 = 0.123
resxy@vpYF                 = 0.655

AA                    = floor(min(Y(:,5,:)))
BB                    = ceil(max(Y(:,5,:)))
resxy@trYMinF         = floor(min(Y(:,5,:)))
resxy@trYMaxF         = ceil(max(Y(:,5,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)


plot(6)  = gsn_csm_xy(wks,X,Y(:,5,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,5,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,5,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,5,:))
                 res1@trYMaxF     = max(Y(:,5,:))
                 res1@gsnYRefLine = min(Y(:,5,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(42)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(42),plot(6))
draw(plot(42))
;===============================================================
;=================================================================================================  Mississippi -No.7
resxy@tiMainString         = "7 (18,7)"
resxy@vpXF                 = 0.180
resxy@vpYF                 = 0.565

AA                    = floor(min(Y(:,6,:)))
BB                    = ceil(max(Y(:,6,:)))
resxy@trYMinF         = floor(min(Y(:,6,:)))
resxy@trYMaxF         = ceil(max(Y(:,6,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)


plot(7)  = gsn_csm_xy(wks,X,Y(:,6,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,6,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,6,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,6,:))
                 res1@trYMaxF     = max(Y(:,6,:))
                 res1@gsnYRefLine = min(Y(:,6,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(38)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(38),plot(7))
draw(plot(38))
;===============================================================
;=================================================================================================  Murray -No.9
resxy@tiMainString         = "9 (11,14)"
resxy@vpXF                 = 0.905
resxy@vpYF                 = 0.42

AA                    = floor(min(Y(:,7,:)))
BB                    = ceil(max(Y(:,7,:)))
resxy@trYMinF         = floor(min(Y(:,7,:)))
resxy@trYMaxF         = ceil(max(Y(:,7,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)

plot(8)  = gsn_csm_xy(wks,X,Y(:,7,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,7,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,7,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,7,:))
                 res1@trYMaxF     = max(Y(:,7,:))
                 res1@gsnYRefLine = min(Y(:,7,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(37)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(37),plot(8))
draw(plot(37))
;===============================================================
;=================================================================================================  Niger -No.4
resxy@tiMainString         = "4 (22,3)"
resxy@vpXF                 = 0.43
resxy@vpYF                 = 0.52

AA                    = floor(min(Y(:,8,:)))
BB                    = ceil(max(Y(:,8,:)))
resxy@trYMinF         = floor(min(Y(:,8,:)))
resxy@trYMaxF         = ceil(max(Y(:,8,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)


plot(9)  = gsn_csm_xy(wks,X,Y(:,8,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,8,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,8,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,8,:))
                 res1@trYMaxF     = max(Y(:,8,:))
                 res1@gsnYRefLine = min(Y(:,8,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(36)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(36),plot(9))
draw(plot(36))
;===============================================================
;=================================================================================================  Nile -No.5
resxy@tiMainString         = "5 (21,4)"
resxy@vpXF                 = 0.628
resxy@vpYF                 = 0.535

AA                    = floor(min(Y(:,9,:)))
BB                    = ceil(max(Y(:,9,:)))
resxy@trYMinF         = floor(min(Y(:,9,:)))
resxy@trYMaxF         = ceil(max(Y(:,9,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)


plot(10)  = gsn_csm_xy(wks,X,Y(:,9,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,9,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,9,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,9,:))
                 res1@trYMaxF     = max(Y(:,9,:))
                 res1@gsnYRefLine = min(Y(:,9,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(35)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(35),plot(10))
draw(plot(35))
;===============================================================
;=================================================================================================  Ob  -No.13
resxy@tiMainString         = "13 (6,19)"
resxy@vpXF                 = 0.605
resxy@vpYF                 = 0.647

AA                    = floor(min(Y(:,10,:)))
BB                    = ceil(max(Y(:,10,:)))
resxy@trYMinF         = floor(min(Y(:,10,:)))
resxy@trYMaxF         = ceil(max(Y(:,10,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)


plot(11)  = gsn_csm_xy(wks,X,Y(:,10,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,10,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,10,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,10,:))
                 res1@trYMaxF     = max(Y(:,10,:))
                 res1@gsnYRefLine = min(Y(:,10,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(34)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(34),plot(11))
draw(plot(34))
;===============================================================
;=================================================================================================  Parana  -No.10
resxy@tiMainString         = "10 (8,17)"
resxy@vpXF                 = 0.402
resxy@vpYF                 = 0.380

AA                    = floor(min(Y(:,11,:)))
BB                    = ceil(max(Y(:,11,:)))
resxy@trYMinF         = floor(min(Y(:,11,:)))
resxy@trYMaxF         = ceil(max(Y(:,11,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)


plot(12)  = gsn_csm_xy(wks,X,Y(:,11,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,11,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,11,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,11,:))
                 res1@trYMaxF     = max(Y(:,11,:))
                 res1@gsnYRefLine = min(Y(:,11,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(31)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(31),plot(12))
draw(plot(31))
;===============================================================

;=================================================================================================  Yangtze  -No.8
resxy@tiMainString         = "8 (20,5)"
resxy@vpXF                 = 0.835
resxy@vpYF                 = 0.575

AA                    = floor(min(Y(:,12,:)))
BB                    = ceil(max(Y(:,12,:)))
resxy@trYMinF         = floor(min(Y(:,12,:)))
resxy@trYMaxF         = ceil(max(Y(:,12,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)


plot(13)  = gsn_csm_xy(wks,X,Y(:,12,:),resxy)
delete(resxy@tiMainString)
;================================================================
y=Y(23,12,:)
res1=resxy
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,12,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,12,:))
                 res1@trYMaxF     = max(Y(:,12,:))
                 res1@gsnYRefLine = min(Y(:,12,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(33)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(33),plot(13))
draw(plot(33))
;===============================================================
;=================================================================================================  Yenisei  -No.14
resxy@tiMainString         = ""
resxy@vpXF                 = 0.73
resxy@vpYF                 = 0.710

AA                    = floor(min(Y(:,13,:)))
BB                    = ceil(max(Y(:,13,:)))
resxy@trYMinF         = floor(min(Y(:,13,:)))
resxy@trYMaxF         = ceil(max(Y(:,13,:)))
resxy@tmYLMode        = "Explicit"
resxy@tmYLValues      = (/AA, BB/)
resxy@tmYLLabels      = (/AA, BB/)

plot(14)  = gsn_csm_xy(wks,X,Y(:,13,:),resxy)
;================================================================
y=Y(23,13,:)
res1=resxy
res1@tiMainString         = "14 (2,23)"
         ymin=min(y) ; calculate this or specify a value
         ymax=max(Y(:,13,:)) ; calculate this or specify a value
         y2=y/y ; create dummy variable y2
         y2=y2*ymax ; all values of y2=ymax
                 res1@trYMinF     = min(Y(:,13,:))
                 res1@trYMaxF     = max(Y(:,13,:))
                 res1@gsnYRefLine = min(Y(:,13,:))
                 res1@gsnAboveYRefLineColor = "white"
plot(32)=gsn_csm_xy(wks,X,y2,res1)
delete([/res1,y,y2/])
overlay(plot(32),plot(14))
draw(plot(32))
;===============================================================

frame(wks)
end 
