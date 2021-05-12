load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;=======================================================================
begin

Name =(/"ACCESS-CM2","ACCESS-ESM1-5","AWI-ESM-1-1-LR","BCC-CSM2-MR","BCC-ESM1","CanESM5","CESM2","CESM2-FV2","CESM2-WACCM","CESM2-WACCM-FV2"\
,"CIESM","CNRM-CM6-1","CNRM-CM6-1-HR","CNRM-ESM2-1","EC-Earth3","EC-Earth3-Veg","EC-Earth3-Veg-LR","GFDL-CM4","GFDL-ESM4","GISS-E2-1-G"\
,"GISS-E2-1-H","IPSL-CM6A-LR","KIOST-ESM","MIROC6","MIROC-ES2L","MPI-ESM-1-2-HAM","MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorESM2-LM"\
,"NorESM2-MM","SAM0-UNICON","TaiESM1","UKESM1-0-LL"/)

var =(/"ACCESS-CM2","ACCESS-ESM1-5","AWI-ESM-1-1-LR","BCC-CSM2-MR","BCC-ESM1","CanESM5","CESM2","CESM2-WACCM"\
,"CNRM-CM6-1","CNRM-ESM2-1","EC-Earth3","EC-Earth3-Veg","GFDL-CM4","GISS-E2-1-G"\
,"GISS-E2-1-H","IPSL-CM6A-LR","MIROC6","MIROC-ES2L","MPI-ESM-1-2-HAM","MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorESM2-LM"\
,"NorESM2-MM","SAM0-UNICON","TaiESM1","UKESM1-0-LL"/)


;Name 34, Var 27

river = (/"Amazon","Congo","Danube","Ganges","Lena","Mackenzie","Mississippi","Murray","Niger","Nile","Ob","Parana",\
"Yangtze","Yenisei"/)

f0_1 = addfile("../model/CMIP6_DSPER.nc","r")

Result_1 = f0_1->Result    ; dis-recharge(2), DS-P-E-R and P-E-R (5), river(14), number of models(30)


Result = new((/2,5,14,34/),"float")
Result = Result_1
Result(:,:,:,14:15) = Result@_FillValue

Recharge  = Result(0,:,:,:)
discharge = Result(0,:,:,:)

do j = 0,13
do i = 0,33

if (.not.ismissing(Result(0,0,j,i)) .and. Result(0,0,j,i).lt.0)

discharge(0,j,i)  = (/Result(0,0,j,i)/)
Recharge(0,j,i)   = (/Result(1,0,j,i)/)
discharge(4,j,i)  = (/Result(0,4,j,i)/)
Recharge(4,j,i)   = (/Result(1,4,j,i)/)

else

discharge(0,j,i)  = (/Result(1,0,j,i)/)
Recharge(0,j,i)   = (/Result(0,0,j,i)/)
discharge(4,j,i)  = (/Result(1,4,j,i)/)
Recharge(4,j,i)   = (/Result(0,4,j,i)/)
end if

end do 
end do 

wks  = gsn_open_wks("pdf","14_river_cmip6_obs")             ; send graphics to PNG file

plot = new(14,graphic) 

res                     = True                   ; plot mods desired
res@gsnMaximize         = False                   ; maximize plot in frame

res@gsnDraw             = False
res@gsnFrame            = False

res@xyMarkLineMode      = "Markers"              ; choose which have markers
res@xyMonoMarker        = True
res@xyMarker            = 16                     ; choose type of marker 
res@xyMarkerSizeF       = 0.010                  ; Marker size (default 0.01)

res@xyMonoMarkerColor   = True
res@xyMarkerColor      = "red"

res@tmXBMode        = "Manual"
res@tmYLMode        = "Manual"
res@tmXBFormat = "f"
res@tmYLFormat = "f"
res@tmXBTickSpacingF= 60
res@tmYLTickSpacingF= 60
res@tmXBLabelFontHeightF = 0.010

res@txFuncCode = ":"
res@tiYAxisString = "sum of (P-E-R), mm"
res@tiXAxisString = "dS, mm"
res@tiYAxisFontHeightF    = 0.02

DTWS  = asciiread("/home/L.wurjicnip/CMIP6_PAPER/obs/grace06.txt",(/14/),"float") ; only later month - front month
P1    = asciiread("/home/L.wurjicnip/CMIP6_PAPER/obs/gpcc_grace06.txt",(/2,14/),"float")

E3    = asciiread("/home/L.wurjicnip/CMIP6_PAPER/obs/GLEAM_grace06.txt",(/2,14/),"float")

R2    = asciiread("/home/L.wurjicnip/CMIP6_PAPER/obs/grun_grace06.txt",(/2,14/),"float")


XX   = new((/14,68/),"float")
YY   = new((/14,68/),"float")
XX(:,0:33)  = discharge(0,:,:)
XX(:,34:67) = Recharge(0,:,:)
YY(:,0:33)  = discharge(4,:,:)
YY(:,34:67) = Recharge(4,:,:)


do i = 0,13


X = transpose((/XX(i,:),XX(i,:)/))   ; dis-recharge(2), DS-P-E-R and P-E-R (5), river(14)
Y = transpose((/YY(i,:),YY(i,:)/))   ; dis-recharge(2), DS-P-E-R and P-E-R (5), river(14)

res@tiMainString = river(i) + ", red dots: models"

if (max(X).gt.max(Y))
res@trXMaxF      = round(max(X)+100,3)                  ; axis max
res@trYMaxF      = round(max(X)+100,3)                  ; axis max
end if 

if (max(Y).gt.max(X))
res@trXMaxF      = round(max(Y)+100,3)                  ; axis max
res@trYMaxF      = round(max(Y)+100,3)                  ; axis max
end if

if (min(Y).lt.min(X))
res@trXMinF      = round(min(Y)-100,3)                  ; axis max
res@trYMinF      = round(min(Y)-100,3)                  ; axis max
end if

if (min(X).lt.min(Y))
res@trXMinF      = round(min(X)-100,3)                  ; axis max
res@trYMinF      = round(min(X)-100,3)                  ; axis max
end if

res@tmYROn = False            ; Turn off right tickmarks.
res@tmXTOn = False            ; Turn off top tickmarks.


plot(i)  = gsn_csm_xy(wks,X,Y,res)
delete([/res@trXMinF, res@trXMaxF, res@trYMinF, res@trYMaxF, X, Y/])

end do

;=================================================================================================  add observed data 
res_lines                   = True                  ; polyline mods desired
res_lines@gsLineDashPattern = 0.                    ; solid line
res_lines@gsLineThicknessF  = 1.5                    ; line thicker
xx = (/-1000,1000/)
res_lines@gsLineColor       = "black"               ; line color
yy = (/-1000,1000/)

res_lines@gsLineColor       = "grey"
xx2 = (/-1500,1500/)
yy2 = (/-750,750/)
xx3 = (/-750,750/)
yy3 = (/-1500,1500/)

res_lines_d                   = True                  ; polyline mods desired
res_lines_d@gsLineDashPattern = 1.                    ; solid line
res_lines_d@gsLineThicknessF  = 0.5                    ; line thicker
xx1 = (/0,0/)
res_lines_d@gsLineColor         = "black"               ; line color
yy1 = (/-1000,1000/)

res_text                    = True                  ; text mods desired
res_text@txFontHeightF      = 0.025                  ; change text size
res_text@txJust             = "CenterLeft"          ; text justification
res_text@txFontColor = (/"black"/)


res_marker_dis                  = True
res_marker_dis@gsMarkerIndex    = 16            ; choose circle as polymarker
res_marker_dis@gsMarkerSizeF    = 8.0           ; select size to avoid streaking
res_marker_dis@gsMarkerColor    = (/"blue"/)   ; choose color

res_marker_re                  = True
res_marker_re@gsMarkerIndex    = 16            ; choose circle as polymarker
res_marker_re@gsMarkerSizeF    = 8.0           ; select size to avoid streaking
res_marker_re@gsMarkerColor    = (/"darkgreen"/)   ; choose color



dum    = new(14,graphic)
dum_d  = new(14,graphic)
dum_b1 = new(14,graphic)
dum_b2 = new(14,graphic)


do i = 0,13
res_lines@gsLineColor       = "black"
dum(i) = gsn_add_polyline(wks,plot(i),xx,yy,res_lines)                        ; add polyline
dum_d(i) = gsn_add_polyline(wks,plot(i),xx1,yy1,res_lines_d)                        ; add polyline
res_lines@gsLineColor       = "grey"
dum_b1(i) = gsn_add_polyline(wks,plot(i),xx2,yy2,res_lines)                        ; add polyline
dum_b2(i) = gsn_add_polyline(wks,plot(i),xx3,yy3,res_lines)                        ; add polyline
end do

obs_M_dis = new(14,graphic)
obs_M_re = new(14,graphic)


obs_range_re = new(14,graphic)
obs_range_dis = new(14,graphic)

res_line_dis                   = True                  ; polyline mods desired
res_line_dis@gsLineDashPattern = 0.                    ; solid line
res_line_dis@gsLineThicknessF  = 2.0                  ; line thicker
res_line_dis@gsLineColor       = "blue"               ; line color

res_line_re                   = True                  ; polyline mods desired
res_line_re@gsLineDashPattern = 0.                    ; solid line
res_line_re@gsLineThicknessF  = 2.0                  ; line thicker
res_line_re@gsLineColor       = "darkgreen"               ; line color

P  = new((/1,14/),"float")
E  = new((/1,14/),"float")
R  = new((/1,14/),"float")


do i = 0,13
if (DTWS(i).lt.0)

XX_dis   = DTWS(i)
YY_dis   = P1(0,i) - E3(0,i) - R2(0,i)

P(0,i) = P1(0,i)
E(0,i) = E3(0,i)
R(0,i) = R2(0,i)
;YY_dis_MIN = dim_min_n(P,0)-dim_max_n(E,0)-dim_max_n(R,0)
;YY_dis_MAX = dim_max_n(P,0)-dim_min_n(E,0)-dim_min_n(R,0)


XX_Re    = -DTWS(i)
YY_Re    = P1(1,i) - E3(1,i)- R2(1,i)


P(0,i) = P1(1,i)
E(0,i) = E3(1,i)
R(0,i) = R2(1,i)

;YY_Re_MIN = dim_min_n(P,0)-dim_max_n(E,0)-dim_max_n(R,0)
;YY_Re_MAX = dim_max_n(P,0)-dim_min_n(E,0)-dim_min_n(R,0)

else 
XX_dis   = -DTWS(i)
YY_dis    = P1(1,i) - E3(1,i)- R2(1,i)


P(0,i) = P1(1,i)
E(0,i) = E3(1,i)
R(0,i) = R2(1,i)

;YY_dis_MIN = dim_min_n(P,0)-dim_max_n(E,0)-dim_max_n(R,0)
;YY_dis_MAX = dim_max_n(P,0)-dim_min_n(E,0)-dim_min_n(R,0)

XX_Re   = DTWS(i)
YY_Re   = P1(0,i) - E3(0,i) - R2(0,i)

P(0,i) = P1(0,i)
E(0,i) = E3(0,i)
R(0,i) = R2(0,i)

;YY_Re_MIN = dim_min_n(P,0)-dim_max_n(E,0)-dim_max_n(R,0)
;YY_Re_MAX = dim_max_n(P,0)-dim_min_n(E,0)-dim_min_n(R,0)

end if 

obs_M_dis(i) = gsn_add_polymarker(wks,plot(i),XX_dis,YY_dis,res_marker_dis)  ; draw polymarkers
obs_M_re(i)  = gsn_add_polymarker(wks,plot(i),XX_Re,YY_Re,res_marker_re)  ; draw polymarkers

;obs_range_dis(i) = gsn_add_polyline(wks,plot(i),(/XX_dis,XX_dis/),(/YY_dis_MIN(i),YY_dis_MAX(i)/),res_line_dis)
;obs_range_re(i) = gsn_add_polyline(wks,plot(i),(/XX_Re,XX_Re/),(/YY_Re_MIN(i),YY_Re_MAX(i)/),res_line_re)

end do 


resP = True
resP@gsnMaximize = True
gsn_panel(wks,plot,(/4,4/),resP)

end 
