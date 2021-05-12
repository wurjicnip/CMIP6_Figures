load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "/home/L.wurjicnip/CMIP6_PAPER/pdf/taylor_diagram_fig3.ncl"
;*********************************************************
begin
;=======================================================================  Grace
fils1 = systemfunc ("ls /home/L.wurjicnip/CMIP6_PAPER/model_CMIP5_2003_2005/*DSPER_Ann_*.nc")
f1    = addfiles (fils1, "r")
ListSetType (f1,"join")
A1     = f1[:]->Result(:,:,0,:)           ; member-river-month

printVarSummary(A1)

fils2 = systemfunc ("ls /home/L.wurjicnip/CMIP6_PAPER/model_CMIP6_2003_2005/*DSPER_Ann_*.nc")
f2    = addfiles (fils2, "r")
ListSetType (f2,"join")
A2     = f2[:]->Result(:,:,0,:)           ; member-river-month
delete(f2)
printVarSummary(A2)

A     = new((/46,14,12/),"float") ; 19CMIP5 27CMIP6

A(0:18,:,:) = A1
A(19:45,:,:) = A2

f2    = addfile("/home/L.wurjicnip/CMIP6_PAPER/obs_2003_2005/GRACE_river_Ann_mascon_06_2003_2005.nc","r")
B     = f2->Result                       ; river-month


cor   = new((/14,46/),"float")
std   = new((/14,46/),"float")
ran   = new((/14,46/),"float")
rmse  = new((/14,46/),"float")

cor_ma= new((/14,46/),"float")
std_ma= new((/14,46/),"float")

River = (/"Amazon","Congo","Danube","Ganges","Lena","Mackenzie","Mississippi","Murray","Niger","Nile","Ob","Parana",\
"Yangtze","Yenisei"/)


do i = 0,13
do j = 0,45


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

;ran(i,10:11) = ran@_FillValue
print(River(i)+"  small: "+num(ran(i,:).lt.1)+"    big: "+num(ran(i,:).gt.1))

end do 


delete([/A,B/])
;========================================================================

var =(/"","","","","","","","","","10","","","","","","","","","19"\
,"ACCESS-CM2","ACCESS-ESM1-5","AWI-ESM-1-1-LR","BCC-CSM2-MR","BCC-ESM1","CanESM5","CESM2","CESM2-WACCM"\
,"CNRM-CM6-1","CNRM-ESM2-1","","","GFDL-CM4","GISS-E2-1-G"\
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
  wks   = gsn_open_wks("pdf","Fig3_2020_CMIP5_CMIP6")
  plot  = new(20,graphic)

  res   = True                           ; default taylor diagram
  res@gsnDraw  = False
  res@gsnFrame = False

  res@caseLabelsFontHeightF = 0.18
 ; res@tiMainFontHeightF = 0.0265
  res@gsMarkerSizeF = 0.006
  res@ccRays = (/ 0.6, 0.9 /)

  res@Markers   = (/16,2/)     ; make all solid fill
  res@Colors    = (/"red","blue"/)
  res@centerDiffRMS = False
  res@caseLabels= (/"CMIP5","CMIP6"/)
  res@tiMainString    = ""

RATIO = new((/14,2,27/),"float")
CC    = new((/14,2,27/),"float")

RATIO(:,0,0:18) = ratio(:,0:18)
RATIO(:,1,0:26) = ratio(:,19:45)
CC(:,0,0:18)    = cc(:,0:18)
CC(:,1,0:26)    = cc(:,19:45)


do i = 0,13
  res@tiMainString    = case1(i)
  plot(i)  = taylor_diagram(wks,RATIO(i,:,:),CC(i,:,:),res)
  delete([/res@tiMainString/])
end do 

;================================================================== Range Ratio

  resp = True
  resp@gsnMaximize = True
;  resp@gsnPanelFigureStrings            = (/"(a)","(b)","(c)","(d)","(e)"/)

;  resp@gsnPanelFigureStringsPerimOn     = False
;  resp@gsnPanelFigureStringsFontHeightF = 0.010 
;  resp@amJust                           = "TopLeft"
;  resp@amOrthogonalPosF                 = -0.585


;  resp@gsnPanelDebug                    = True 
  resp@gsnPanelRowSpec                  = True
  gsn_panel(wks,plot,(/4,4,4,2/),resp)    


end 
