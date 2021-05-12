load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "/home/L.wurjicnip/taylor/taylor_diagram_ncl/taylor_diagram_rm_number_14river.ncl"

;*********************************************************
begin
;=======================================================================  Grace
a1 = addfile("/home/L.wurjicnip/CMIP5/Ann/river_basin_per/CMIP5_DS-P-E-R/DSPER_Ann_CLM4V7_TWS_0305.nc","r")

a4 = addfile("/home/L.wurjicnip/CMIP5/Ann/river_basin_per/CMIP5_DS-P-E-R/TaiESM_TWS_03_05.nc","r")


A           = new((/5,14,12/),"float")

A(0,:,:) = a1->Result(:,0,:)          ; member-river-month
A(1,:,:) = a1->Result(:,1,:)          ; member-river-month
A(2,:,:) = a1->Result(:,2,:)          ; member-river-month
A(3,:,:) = a4->Result(:,0,:)          ; member-river-month
A(4,:,:) = a4->Result(:,1,:)          ; member-river-month


f2    = addfile("/home/L.wurjicnip/CMIP6_PAPER/obs/GRACE_river_Ann_mascon_06_2003_2014.nc","r")
B     = f2->Result                       ; river-month


cor   = new((/14,5/),"float")
std   = new((/14,5/),"float")

do i = 0,13
do j = 0,4

cor(i,j)  = escorc(A(j,i,:),B(i,:))
std(i,j)  = stddev(A(j,i,:))/stddev(B(i,:))

end do 
end do 

delete([/A,B/])
;========================================================================

;var = (/"bcc-csm1-1","BNU-ESM","CanESM2","CCSM4","CESM1-BGC","CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","CNRM-CM5",\
;"CSIRO-Mk3-6-0","FGOALS-g2","GFDL-CM3","GISS-E2-H","GISS-E2-R","inmcm4","MIROC4h","MIROC5","MIROC-ESM-CHEM","MIROC-ESM",\
;"MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","NorESM1-M","E3SM"/)

;var = (/"CCSM4","CESM1-BGC","CESM1-CAM5","CESM1-FASTCHEM","CESM1-WACCM","E3SM"/)
var = (/"CLM4V7","CLM4V7_no_VOLR","CLM4V7_no_WA","TaiESM","TaiESM_no_WA"/)
;===============================================================
  nVar       = dimsizes(var )                 ; # of Cases [Cases] ; variables compared
  case = (/"Amazon","Congo","Danube","Ganges","Lena","Mackenzie","Mississippi","Murray","Niger","Nile","Ob","Parana",\
"Yangtze","Yenisei"/)
  nCase      = dimsizes(case)



;  case1= (/"Amazon-1","Congo-2","Ganges-3","Niger-4","Nile-5","Lena-11","Mackenzie-12","Ob-13","Yenise-14","Danube-6","Mississippi-7","Yangtze-8",\
;"Murray-9","Parana-10"/)


  case1= (/"Amazon","Congo","Ganges","Niger","Nile","Lena","Mackenzie","Ob","Yenise","Danube","Mississippi","Yangtze",\
"Murray","Parana"/)


; arrays to be passed to taylor plot 
  ratio      = new ((/nCase, nVar/),"float")  
  cc         = new ((/nCase, nVar/),"float") 

  cc         = cor
  ratio      = std


  A          = cc
  B          = ratio

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


;**********************************
; create plot
;**********************************
  wks   = gsn_open_wks("pdf","CLM4V7_TaiESM_GROUP_0305")
  plot  = new(3,graphic)

  res   = True                           ; default taylor diagram
  res@gsnDraw  = False
  res@gsnFrame = False
  res@varLabels    = var
  res@varLabelsYloc= 1.625
  res@caseLabelsFontHeightF = 0.15
  res@varLabelsFontHeightF  = 0.016

  res@gsMarkerSizeF = 0.006
  res@ccRays = (/ 0.6, 0.9 /)
  res@centerDiffRMS = False

  res@Markers   = (/16,2,3,4,5/)     ; make all solid fill
  res@Colors    = (/"red","blue","darkgreen","purple","gold4"/)
  res@caseLabels= case1(0:4)

  res@tiMainString    = "Tropical"
  plot(0)  = taylor_diagram(wks,ratio(0:4,:),cc(0:4,:),res)

  delete([/res@Markers, res@Colors, res@caseLabels/])
  res@Markers   = (/16,2,3,4/)     ; make all solid fill
  res@Colors    = (/"red","blue","darkgreen","purple"/)
  res@caseLabels= case1(5:8)
  res@tiMainString    = "High-Latitude"
  plot(2)  = taylor_diagram(wks,ratio(5:8,:),cc(5:8,:),res)

  delete([/res@Markers, res@Colors, res@caseLabels/])
  res@Markers   = (/16,2,3,4,5/)     ; make all solid fill
  res@Colors    = (/"red","blue","darkgreen","purple","gold4"/)
  res@caseLabels= case1(9:13)
  res@tiMainString    = "Mid-Latitude"
  plot(1)  = taylor_diagram(wks,ratio(9:13,:),cc(9:13,:),res)
  delete([/res@Markers, res@Colors, res@caseLabels/])
;==================================================================
  txres               = True                      ; text mods desired
  txres@txFontHeightF = 0.0075                     ; text font height
  txres@txFontColor   = "red"
  txres@txJust        = "CenterLeft"              ; Default is "CenterCenter".

  resp = True
  resp@gsnMaximize = True
  resp@gsnPanelFigureStrings            = (/"(a)","(b)","(c)","(d)","(e)","(f)"/)
  resp@gsnPanelFigureStringsPerimOn     = False
  resp@gsnPanelFigureStringsFontHeightF = 0.010 
  resp@amJust                           = "TopLeft"
  resp@amOrthogonalPosF                 = -0.585
  resp@amParallelPosF                   = -0.5

  gsn_panel(wks,plot,(/1,3/),resp)    

; using panel taylor diagram -> comment last paragraph in "./taylor_diagram_ncl/taylor_diagram_rm_number_14river.ncl"

end 
