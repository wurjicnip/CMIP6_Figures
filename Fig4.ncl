load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "/home/L.wurjicnip/CMIP6_PAPER/pdf/taylor_diagram_fig3.ncl"
;*********************************************************
begin
;=======================================================================  Grace
fils1 = systemfunc ("ls /home/L.wurjicnip/CMIP6_PAPER/model/*DSPER_Ann_*.nc")
f1    = addfiles (fils1, "r")
ListSetType (f1,"join")
A     = f1[:]->Result(:,:,0,:)           ; member-river-month

printVarSummary(A)

f2    = addfile("/home/L.wurjicnip/CMIP6_PAPER/obs/GRACE_river_Ann_mascon_06_2003_2014.nc","r")
B     = f2->Result                       ; river-month


cor   = new((/14,25/),"float")
std   = new((/14,25/),"float")
ran   = new((/14,25/),"float")
rmse  = new((/14,25/),"float")

cor_ma= new((/14,25/),"float")
std_ma= new((/14,25/),"float")

River = (/"Amazon","Congo","Danube","Ganges","Lena","Mackenzie","Mississippi","Murray","Niger","Nile","Ob","Parana",\
"Yangtze","Yenisei"/)


do i = 0,13
do j = 0,24


cor(i,j)  = escorc(A(j,i,:),B(i,:))
std(i,j)  = stddev(A(j,i,:))/stddev(B(i,:))
ran(i,j)  = (max(A(j,i,:)) - min(A(j,i,:)))/(max(B(i,:)) - min(B(i,:)))

YYY       = A(j,i,:)-avg(A(j,i,:))
XXX       = B(i,:)-avg(B(i,:))
;rmse(i,j) = dim_rmsd(YYY,XXX)/stddev(B(i,:))


x_t   = std(i,j)*cos(acos(cor(i,j)))
y_t   = std(i,j)*sin(acos(cor(i,j)))
rmse(i,j) = sqrt((x_t-1)^2 +y_t^2)

end do 

ran(i,10:11) = ran@_FillValue
print(River(i)+"  small: "+num(ran(i,:).lt.1)+"    big: "+num(ran(i,:).gt.1))

end do 


delete([/A,B/])
;========================================================================

var =(/"ACCESS-CM2","ACCESS-ESM1-5","AWI-ESM-1-1-LR","BCC-CSM2-MR","BCC-ESM1","CanESM5","CESM2","CESM2-WACCM"\
,"CNRM-CM6-1","CNRM-ESM2-1","GFDL-CM4","GISS-E2-1-G"\
,"GISS-E2-1-H","IPSL-CM6A-LR","MIROC6","MIROC-ES2L","MPI-ESM-1-2-HAM","MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorESM2-LM"\
,"NorESM2-MM","SAM0-UNICON","TaiESM1","UKESM1-0-LL"/)

;===============================================================
  nVar       = dimsizes(var )                 ; # of Cases [Cases] ; variables compared
print(nVar)
  case = (/"Amazon","Congo","Danube","Ganges","Lena","Mackenzie","Mississippi","Murray","Niger","Nile","Ob","Parana",\
"Yangtze","Yenisei"/)
  nCase      = dimsizes(case)
  case1= (/"Amazon-1","Congo-2","Ganges-3","Niger-4","Nile-5","Lena-11","Mackenzie-12","Ob-13","Yenise-14","Danube-6","Mississippi-7","Yangtze-8",\
"Murray-9","Parana-10"/)

; arrays to be passed to taylor plot 
  ratio      = new ((/nCase, nVar/),"float")  
  cc         = new ((/nCase, nVar/),"float") 

  ratio_ma   = new ((/nCase, nVar/),"float")
  cc_ma      = new ((/nCase, nVar/),"float")

  cc         = cor
  ratio      = std

  cc_ma      = cor_ma
  ratio_ma   = std_ma

  A          = cc
  B          = ratio
  C          = cc_ma
  D          = ratio_ma

  cc(2,:)    = A(3,:)
  cc(3,:)    = A(8,:)
  cc(4,:)    = A(9,:)
  cc(5,:)    = A(4,:)
  cc(6,:)    = A(5,:)
  cc(7,:)    = A(10,:)
  cc(8,:)    = A(13,:)
  cc(9,:)    = A(2,:)
  cc(10,:)   = A(6,:)
  cc(11,:)   = A(12,:)
  cc(12,:)   = A(7,:)
  cc(13,:)   = A(11,:)

  ratio(2,:)    = B(3,:)
  ratio(3,:)    = B(8,:)
  ratio(4,:)    = B(9,:)
  ratio(5,:)    = B(4,:)
  ratio(6,:)    = B(5,:)
  ratio(7,:)    = B(10,:)
  ratio(8,:)    = B(13,:)
  ratio(9,:)    = B(2,:)
  ratio(10,:)   = B(6,:)
  ratio(11,:)   = B(12,:)
  ratio(12,:)   = B(7,:)
  ratio(13,:)   = B(11,:)

  cc_ma(2,:)    = C(3,:)
  cc_ma(3,:)    = C(8,:)
  cc_ma(4,:)    = C(9,:)
  cc_ma(5,:)    = C(4,:)
  cc_ma(6,:)    = C(5,:)
  cc_ma(7,:)    = C(10,:)
  cc_ma(8,:)    = C(13,:)
  cc_ma(9,:)    = C(2,:)
  cc_ma(10,:)   = C(6,:)
  cc_ma(11,:)   = C(12,:)
  cc_ma(12,:)   = C(7,:)
  cc_ma(13,:)   = C(11,:)

  ratio_ma(2,:)    = D(3,:)
  ratio_ma(3,:)    = D(8,:)
  ratio_ma(4,:)    = D(9,:)
  ratio_ma(5,:)    = D(4,:)
  ratio_ma(6,:)    = D(5,:)
  ratio_ma(7,:)    = D(10,:)
  ratio_ma(8,:)    = D(13,:)
  ratio_ma(9,:)    = D(2,:)
  ratio_ma(10,:)   = D(6,:)
  ratio_ma(11,:)   = D(12,:)
  ratio_ma(12,:)   = D(7,:)
  ratio_ma(13,:)   = D(11,:)

;**********************************
; create plot
;**********************************
  wks   = gsn_open_wks("pdf","Fig3_2020")
  plot  = new(20,graphic)

  res   = True                           ; default taylor diagram
  res@gsnDraw  = False
  res@gsnFrame = False

  res@caseLabelsFontHeightF = 0.18
 ; res@tiMainFontHeightF = 0.0265
  res@gsMarkerSizeF = 0.006
  res@ccRays = (/ 0.6, 0.9 /)

  res@Markers   = (/16,2,3,4,5/)     ; make all solid fill
  res@Colors    = (/"red","blue","darkgreen","purple","gold4"/)
  res@centerDiffRMS = False
  res@caseLabels= case1(0:4)
  res@tiMainString    = ""

  plot(0)  = taylor_diagram(wks,ratio(0:4,:),cc(0:4,:),res)

  delete([/res@Markers, res@Colors, res@caseLabels/])
  res@Markers   = (/16,2,3,4/)     ; make all solid fill
  res@Colors    = (/"red","blue","darkgreen","purple"/)
  res@caseLabels= case1(5:8)
;  res@tiMainString    = "High-Latitude"
  plot(2)  = taylor_diagram(wks,ratio(5:8,:),cc(5:8,:),res)

  delete([/res@Markers, res@Colors, res@caseLabels/])
  res@Markers   = (/16,2,3,4,5/)     ; make all solid fill
  res@Colors    = (/"red","blue","darkgreen","purple","gold4"/)
  res@caseLabels= case1(9:13)
;  res@tiMainString    = "Mid-Latitude"
  plot(1)  = taylor_diagram(wks,ratio(9:13,:),cc(9:13,:),res)
print(ratio(12,:)+"   "+cc(12,:))
  delete([/res@Markers, res@Colors, res@caseLabels/])
;================================================================== Range Ratio
  RAN         = ran
  RAN(2,:)    = ran(3,:)
  RAN(3,:)    = ran(8,:)
  RAN(4,:)    = ran(9,:)
  RAN(5,:)    = ran(4,:)
  RAN(6,:)    = ran(5,:)
  RAN(7,:)    = ran(10,:)
  RAN(8,:)    = ran(13,:)
  RAN(9,:)    = ran(2,:)
  RAN(10,:)   = ran(6,:)
  RAN(11,:)   = ran(12,:)
  RAN(12,:)   = ran(7,:)
  RAN(13,:)   = ran(11,:)

  ANS          = RAN  ; 14x23

  ANS(5:9,:)   = RAN(9:13,:)
  ANS(10:13,:) = RAN(5:8,:)

  BOX    = new((/14,5/),"float")
  BOX_OV = new((/14,5/),"float")

  do i     = 0,13
  STAT     = stat_dispersion(ANS(i,:), False)
;  BOX(i,0) = STAT(2)
  BOX(i,1) = STAT(6)
  BOX(i,2) = STAT(0)
  BOX(i,3) = STAT(10)
;  BOX(i,4) = STAT(14)
  delete(STAT)
  end do 

  BOX_OV(:,2) = BOX(:,2)

  X = (/-13,-11,-9,-7,-5,-3,-1,1,3,5,7,9,11,13/)

  resb              = True                         ; plot mods desired

;  resb@tmXBLabels        = (/"1-Amazon","2-Congo","3-Ganges","4-Niger","5-Nile","6-Danube","7-Mississippi","8-Yangtze",\
;"9-Murray","10-Parana","11-Lena","12-Mackenzie","13-Ob","14-Yenisei"/)

  resb@tmXBLabels        = (/"1","2","3","4","5","6","7","8","9","10","11","12","13","14"/)

  resb@tiMainString      = ""
  resb@tiMainFontHeightF = 0.020

; resb@tmXBLabelAngleF   = 30.
  resb@tmXBLabelFontHeightF = 0.020
  resb@tmYLLabelFontHeightF = 0.020
 
  resb@tiYAxisString     = "Ratio Model/GRACE TWSA Range"
  resb@tiXAxisString     = "River Basin ID"
  resb@tiYAxisFontHeightF= 0.020
  resb@tiXAxisFontHeightF= 0.020

  resb@vpWidthF                 = 0.55
  resb@vpHeightF                = 0.55


  resb@trYMinF                  = 0 
  resb@trYMaxF                  = 2.5

  plot(4) = boxplot(wks,X,BOX,False,resb,False)	

  resbov = resb
  resbov@boxColors = (/"red","red","red","red","red","red","red","red","red","red","red","red","red","red"/)
  plot_ov = boxplot(wks,X,BOX_OV,resbov,resb,False)
  overlay(plot(4),plot_ov)

  delete([/ANS,BOX,resb@trYMaxF,BOX_OV/])
;========================================================== Normal_RMSE
  RMSE         = rmse
;  print((rmse))
  RMSE(2,:)    = rmse(3,:)
  RMSE(3,:)    = rmse(8,:)
  RMSE(4,:)    = rmse(9,:)
  RMSE(5,:)    = rmse(4,:)
  RMSE(6,:)    = rmse(5,:)
  RMSE(7,:)    = rmse(10,:)
  RMSE(8,:)    = rmse(13,:)
  RMSE(9,:)    = rmse(2,:)
  RMSE(10,:)   = rmse(6,:)
  RMSE(11,:)   = rmse(12,:)
  RMSE(12,:)   = rmse(7,:)
  RMSE(13,:)   = rmse(11,:)

  ANS          = RMSE  ; 14x23

  ANS(5:9,:)   = RMSE(9:13,:)
  ANS(10:13,:) = RMSE(5:8,:)

  BOX    = new((/14,5/),"float")
  BOX_OV = new((/14,5/),"float")

  do i     = 0,13
  STAT     = stat_dispersion(ANS(i,:), False)
;  BOX(i,0) = STAT(2)
  BOX(i,1) = STAT(6)
  BOX(i,2) = STAT(0)
  BOX(i,3) = STAT(10)
;  BOX(i,4) = STAT(14)
  delete(STAT)
  end do

  BOX_OV(:,2) = BOX(:,2)

  resb@tiMainString      = ""

  resb@tiYAxisString     = "Centered pattern RMSE"
  resb@tiXAxisString     = "River Basin ID"

  resb@trYMaxF           = 1.5

  plot(3) = boxplot(wks,X,BOX,False,resb,False)


  resbov = resb
  resbov@boxColors = (/"red","red","red","red","red","red","red","red","red","red","red","red","red","red"/)
  plot_ov = boxplot(wks,X,BOX_OV,resbov,resb,False)
  overlay(plot(3),plot_ov) 

  delete([/ANS,BOX,BOX_OV/])

  txres               = True                      ; text mods desired
  txres@txFontHeightF = 0.0075                     ; text font height
  txres@txFontColor   = "red"
  txres@txJust        = "CenterLeft"              ; Default is "CenterCenter".

;  gsn_text_ndc(wks,"0.2",.852,.545,txres)
;  gsn_text_ndc(wks,"0.4",.880,.545,txres)
;  gsn_text_ndc(wks,"0.6",.904,.545,txres)
;  gsn_text_ndc(wks,"0.8",.932,.545,txres)
;  gsn_text_ndc(wks,"1.0",.960,.545,txres)
;  gsn_text_ndc(wks,"1.2",.723,.625,txres)
;  gsn_text_ndc(wks,"1.4",.723,.670,txres)
;  gsn_text_ndc(wks,"1.6",.723,.698,txres)
;  gsn_text_ndc(wks,"1.8",.723,.730,txres)
;  gsn_text_ndc(wks,"2.0",.723,.760,txres)



;  gsn_text_ndc(wks,"0.2",.517,.545,txres)
;  gsn_text_ndc(wks,"0.4",.545,.545,txres)
;  gsn_text_ndc(wks,"0.6",.569,.545,txres)
;  gsn_text_ndc(wks,"0.8",.597,.545,txres)
;  gsn_text_ndc(wks,"1.0",.625,.545,txres)
;  gsn_text_ndc(wks,"1.2",.388,.625,txres)
;  gsn_text_ndc(wks,"1.4",.388,.670,txres)
;  gsn_text_ndc(wks,"1.6",.388,.698,txres)
;  gsn_text_ndc(wks,"1.8",.388,.730,txres)
;  gsn_text_ndc(wks,"2.0",.388,.760,txres)


;  gsn_text_ndc(wks,"0.2",.182,.542,txres)
;  gsn_text_ndc(wks,"0.4",.210,.542,txres)
;  gsn_text_ndc(wks,"0.6",.234,.542,txres)
;  gsn_text_ndc(wks,"0.8",.262,.542,txres)
;  gsn_text_ndc(wks,"1.0",.290,.542,txres)
;  gsn_text_ndc(wks,"1.2",.052,.625,txres)
;  gsn_text_ndc(wks,"1.4",.052,.670,txres)
;  gsn_text_ndc(wks,"1.6",.052,.698,txres)
;  gsn_text_ndc(wks,"1.8",.052,.730,txres)
;  gsn_text_ndc(wks,"2.0",.052,.760,txres)

  resp = True
  resp@gsnMaximize = True
  resp@gsnPanelFigureStrings            = (/"(a)","(b)","(c)","(d)","(e)"/)

  resp@gsnPanelFigureStringsPerimOn     = False
  resp@gsnPanelFigureStringsFontHeightF = 0.010 
  resp@amJust                           = "TopLeft"
  resp@amOrthogonalPosF                 = -0.585
  resp@amParallelPosF                   = -0.5



;  resp@gsnPanelDebug                    = True 
  resp@gsnPanelRowSpec                  = True
  gsn_panel(wks,plot,(/3,2/),resp)    


end 
