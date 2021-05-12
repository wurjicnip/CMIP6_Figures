load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;***************************************************
begin
;***************************************************
T1  = addfile("../obs/GRACE_river_Ann_mascon_06_2003_2014.nc","r")

P2  = addfile("../nc/gpcc_Ann.nc","r")
E3  = addfile("../nc/gleam_Ann.nc","r")
R2  = addfile("../nc/grun_Ann.nc","r")

TWS = T1->Result(0,:)
P   = P2->Result(0,:)
E   = E3->Result(0,:)
R   = R2->Result(0,:)

Flux = new((/36/),"float")
Flux(0::3) = P
Flux(1::3) = E
Flux(2::3) = R


xmonth = fspan(1,12,12)

x = (/0.75,1,1.25,1.75,2,2.25,2.75,3,3.25,3.75,4,4.25,4.75,5,5.25,5.75,6,6.25,6.75,7,7.25,7.75,8,8.25,8.75,9,9.25,9.75,10,10.25,10.75,11,11.25,11.75,12,12.25/)
;====================================================================================== plot
figname = "Fig2_2020"

wks = gsn_open_wks("pdf",figname)
plot=new(10,graphic)
res = True
res@gsnDraw = False
res@gsnFrame= False
res@gsnMaximize = True

res@trXMinF = 0.5    ; set minimum X-axis value
res@trXMaxF = 12.5            ; set maximum X-axis value

res@tmXBMode        = "Manual"
res@tmXBTickStartF  = 1
res@tmXBTickEndF    = 12
res@tmXBTickSpacingF= 1
res@tmXBFormat = "f"
res@tmXBLabelFontHeightF = 0.015
res@tmYLLabelFontHeightF = 0.015
res@tmYRLabelFontHeightF = 0.015
res@tmYLLabelFontColor   = "black"

res2 = res
res@gsnYRefLine           = 0.              ; reference line   
res@gsnXYBarChart         = True            ; create bar chart 
res@gsnAboveYRefLineColor = "red"           ; above ref line fill red


res@gsnXYBarChartColors2 = (/"cyan","gold","lawngreen"/)
res@trYMinF  = 35                   ; min value on y-axis
res@trYMaxF  = 300
res@tiYAxisFontHeightF= 0.018
res@tiYAxisString = "P, ET, Roff (mm)"

res@gsnXYBarChartBarWidth = 0.25     
;====================================================
;res@tiMainString = "Water Budget Schematic"
res@tiMainString = ""

res@tiXAxisFontHeightF= 0.018
res@tiXAxisString = "Month"
res@gsnRightString= ""
res@gsnLeftString = ""
;=====================================================

;res@gsnYRefLine           = 0.              ; reference line
;res2@gsnXYBarChart         = True            ; create bar chart
res@gsnAboveYRefLineColor = "red"           ; above ref line fill red

res2@xyLineThicknesses = (/5/)
res2@xyDashPattern     = (/0/)      ; make all lines solid

res2@xyLineColors      = (/"black"/)
res2@trYMinF  = -250                   ; min value on y-axis
res2@trYMaxF  =  250
res2@tiYAxisFontHeightF= 0.018
res2@tiYAxisString = "TWSA(mm)"
res2@tmXTLabelsOn = False
res2@tmXTOn = False

plot(0) = gsn_csm_x2y2(wks,x,xmonth,Flux,TWS,res,res2)

res_text                    = True                  ; text mods desired
res_text@txFontHeightF      = 0.016                 ; change text size
res_text@txJust             = "CenterLeft"          ; text justification

res_lines                   = True                  ; polyline mods desired
res_lines@gsLineDashPattern = 0.                    ; solid line
res_lines@gsLineThicknessF  = 4.                    ; line thicker

xx = (/6.5,6.7/)

txref = True
txref@txFontHeightF = 0.015                     ; text font height
txref@txJust        = "CenterLeft"              ; Default is "CenterCenter".

txref@txBackgroundFillColor = "cyan"
gsn_text_ndc(wks,"Precipitation(P)", .62,  .81, txref)

txref@txBackgroundFillColor = "gold"
gsn_text_ndc(wks,"Evapotranspiration(ET)",   .62,  .76, txref)

txref@txBackgroundFillColor = "lawngreen"
gsn_text_ndc(wks,"Runoff(Roff)",        .62,  .71, txref)

yy = (/273,273/)
res_lines@gsLineColor       = "black"                                 ; change to blue
gsn_polyline(wks,plot(0),xx,yy,res_lines)                ; add polyline
gsn_text(wks,plot(0),"GRACE",6.8, yy(0),res_text)       ; add text

yy = (/297,297/)

res_lines@gsLineColor       = "darkgreen"                                 ; change to blue
res_text@txFontColor        = "darkgreen"
res_text@txFontHeightF      = 0.015
gsn_text(wks,plot(0),"~F34~,~",0.8, yy(0),res_text)       ; add text
gsn_polyline(wks,plot(0),(/0.85,1.5/),yy,res_lines)                ; add polyline
gsn_text(wks,plot(0),"Recharge",1.8, yy(0),res_text)       ; add text
gsn_polyline(wks,plot(0),(/3.5,3.88/),yy,res_lines)                ; add polyline
gsn_text(wks,plot(0),"~F34~.~",3.60, yy(0),res_text)       ; add text

res_lines@gsLineColor       = "blue"                                 ; change to blue
res_text@txFontColor        = "blue"
gsn_text(wks,plot(0),"~F34~,~",4.05, yy(0),res_text)       ; add text
gsn_polyline(wks,plot(0),(/4.05,6.5/),yy,res_lines)
gsn_text(wks,plot(0),"Discharge",6.8, yy(0),res_text)       ; add text
gsn_polyline(wks,plot(0),(/8.5,9.98/),yy,res_lines)        
gsn_text(wks,plot(0),"~F34~.~",9.70, yy(0),res_text)       ; add text

res_lines@gsLineColor       = "darkgreen"                                 ; change to blue
res_text@txFontColor        = "darkgreen"
gsn_text(wks,plot(0),"~F34~,~",10.10, yy(0),res_text)       ; add text
gsn_polyline(wks,plot(0),(/10.15,10.41/),yy,res_lines)
gsn_text(wks,plot(0),"Recharge",10.51, yy(0),res_text)       ; add text
gsn_polyline(wks,plot(0),(/12.05,12.31/),yy,res_lines)
gsn_text(wks,plot(0),"~F34~.~",12.05, yy(0),res_text)       ; add text

resP = True
resP@gsnMaximize = True
gsn_panel(wks,plot,(/1,1/),resP)

delete(wks)
;========================Transform Image File========================
         figtype = "png"
         system("convert -density 600 -trim "+figname+".pdf "+figname+"."+figtype)
;        system("/bin/rm "+figname+".ps")
;====================================================================
end


