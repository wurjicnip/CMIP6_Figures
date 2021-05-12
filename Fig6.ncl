load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;=======================================================================
begin

var =(/"ACCESS-CM2","ACCESS-ESM1-5","AWI-ESM-1-1-LR","BCC-CSM2-MR","BCC-ESM1","CanESM5","CESM2","CESM2-WACCM"\
,"CNRM-CM6-1","CNRM-ESM2-1","GFDL-CM4","GISS-E2-1-G"\
,"GISS-E2-1-H","IPSL-CM6A-LR","MIROC6","MIROC-ES2L","MPI-ESM-1-2-HAM","MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NorESM2-LM"\
,"NorESM2-MM","SAM0-UNICON","TaiESM1","UKESM1-0-LL"/)


river = new((/14/),"string") 
river(0) = "Amazon"
river(1) = "Congo"
river(2) = "Danube"
river(3) = "Ganges"
river(4) = "Lena"
river(5) = "Mackenzie"
river(6) = "Mississippi"
river(7) = "Murray"
river(8) = "Niger"
river(9) = "Nile"
river(10) = "Ob"
river(11) = "Parana"
river(12) = "Yangtze"
river(13) = "Yenisei"

nvar = dimsizes(var)

f0   = addfile("../model/CMIP6_DSPER.nc","r")

Result   = f0->Result      ; dis-recharge(2), DS-P-E-R and P-E-R (5), river(14), number of models(30)

f1   = addfile("../model/CMIP6_obs_PER.nc","r")

TWS   = asciiread("../obs/grace06.txt",-1,"float")

P    = new((/2,14,34/),"float")     ; dis-recharge (P,E,R)+ds, region, member
P    = f1->Result(:,0,:,:)

E    = new((/2,14,34/),"float")     ; dis-recharge (P,E,R)+ds, region, member
E    = f1->Result(:,1,:,:)

R    = new((/2,14,34/),"float")     ; dis-recharge (P,E,R)+ds, region, member
R    = f1->Result(:,2,:,:)

A    = new((/7,14,34/),"float")     ; dis-recharge (P,E,R)+ds, region, member
A(0:2,:,:) = Result(0,1:3,:,:)
A(3:5,:,:) = Result(1,1:3,:,:)
A(6,:,:)   =(/Result(0,0,:,:)/)


A(:,:,14:15) = A@_FillValue
P(:,:,14:15) = P@_FillValue
E(:,:,14:15) = E@_FillValue
R(:,:,14:15) = R@_FillValue

STD  = addfile("../model/CMIP6_obs_PER_STD_12_samples_2003_2014.nc","r")
PSTD = new((/2,14,34/),"float")     ; dis-recharge (P,E,R)+ds, region, member
PSTD = STD->Result(:,0,:,:)

ESTD = new((/2,14,34/),"float")     ; dis-recharge (P,E,R)+ds, region, member
ESTD = STD->Result(:,1,:,:)

RSTD = new((/2,14,34/),"float")     ; dis-recharge (P,E,R)+ds, region, member
RSTD = STD->Result(:,2,:,:)

; done by 20170215-18:25
; Depletion period: GRACE < 0; Recharge period: GRACE > 0
; 1. decide CMIP5 majority bias, bigger cylce or smaller cycle (B_C or S_C)
; 2. base on 1, draw the prefer factor in both periods.

; if CMIP5_tws < GRACE
; in Depletion phase, P'> 0 , E'R' < 0
; in recharge phase,  P'<0,   E'R' > 0


B    = new((/7,14,25/),"float")     ; the PER bias in 2 phase, 3x2 = 6, 14 river basins and 23 models
C    = new((/6,14,25/),"integer")   ; discharge(3) and recharge(3) bias
C50  = new((/6,14,25/),"integer")   ; discharge(3) and recharge(3) bias over 1STD
OBS  = new((/6,14,25/),"float")     ; the PER base on CMIP5 water cycle.

OBSSTD= new((/6,14,25/),"float")


j    = -1
do  i = 0,33
if (.not.ismissing(A(0,0,i)))
j    = j+1
B(:,:,j)   = A(:,:,i)
OBS(0,:,j) = P(0,:,i)
OBS(1,:,j) = E(0,:,i)
OBS(2,:,j) = R(0,:,i)
OBS(3,:,j) = P(1,:,i)
OBS(4,:,j) = E(1,:,i)
OBS(5,:,j) = R(1,:,i)
OBSSTD(0,:,j) = PSTD(0,:,i)
OBSSTD(1,:,j) = ESTD(0,:,i)
OBSSTD(2,:,j) = RSTD(0,:,i)
OBSSTD(3,:,j) = PSTD(1,:,i)
OBSSTD(4,:,j) = ESTD(1,:,i)
OBSSTD(5,:,j) = RSTD(1,:,i)
end if
end do

B_C = new((/14/),"integer")                 ; bigger range than obs
S_C = new((/14/),"integer")                 ; smaller range than obs

B_C = 0
S_C = 0 

do i = 0,13
do k = 0,24

if (abs(B(6,i,k)).lt.abs(TWS(i)))
S_C(i) = S_C(i)+1
else
B_C(i) = B_C(i)+1
end if 

end do 
end do 

do i = 0,13
do k = 0,24

if      (S_C(i) .gt. B_C(i) .and. abs(B(6,i,k)).lt.abs(TWS(i)) .and. B(6,i,k).lt.0)   

C(0,i,k) = where((B(0,i,k)-OBS(0,i,k)).gt.0, 1, 0)
C(1,i,k) = where((B(1,i,k)-OBS(1,i,k)).lt.0, 1, 0)
C(2,i,k) = where((B(2,i,k)-OBS(2,i,k)).lt.0, 1, 0)
C(3,i,k) = where((B(3,i,k)-OBS(3,i,k)).lt.0, 1, 0)
C(4,i,k) = where((B(4,i,k)-OBS(4,i,k)).gt.0, 1, 0)
C(5,i,k) = where((B(5,i,k)-OBS(5,i,k)).gt.0, 1, 0)

C50(0,i,k) = where(abs(B(0,i,k)-OBS(0,i,k)).gt.OBSSTD(0,i,k) .and. C(0,i,k).eq.1, 1, 0)
C50(1,i,k) = where(abs(B(1,i,k)-OBS(1,i,k)).gt.OBSSTD(1,i,k) .and. C(1,i,k).eq.1, 1, 0)
C50(2,i,k) = where(abs(B(2,i,k)-OBS(2,i,k)).gt.OBSSTD(2,i,k) .and. C(2,i,k).eq.1, 1, 0)
C50(3,i,k) = where(abs(B(3,i,k)-OBS(3,i,k)).gt.OBSSTD(3,i,k) .and. C(3,i,k).eq.1, 1, 0)
C50(4,i,k) = where(abs(B(4,i,k)-OBS(4,i,k)).gt.OBSSTD(4,i,k) .and. C(4,i,k).eq.1, 1, 0)
C50(5,i,k) = where(abs(B(5,i,k)-OBS(5,i,k)).gt.OBSSTD(5,i,k) .and. C(5,i,k).eq.1, 1, 0)

else if (S_C(i) .gt. B_C(i) .and. abs(B(6,i,k)).lt.abs(TWS(i)) .and. B(6,i,k).gt.0)

C(0,i,k) = where((B(3,i,k)-OBS(3,i,k)).gt.0, 1, 0)
C(1,i,k) = where((B(4,i,k)-OBS(4,i,k)).lt.0, 1, 0)
C(2,i,k) = where((B(5,i,k)-OBS(5,i,k)).lt.0, 1, 0)
C(3,i,k) = where((B(0,i,k)-OBS(0,i,k)).lt.0, 1, 0)
C(4,i,k) = where((B(1,i,k)-OBS(1,i,k)).gt.0, 1, 0)
C(5,i,k) = where((B(2,i,k)-OBS(2,i,k)).gt.0, 1, 0)

C50(0,i,k) = where(abs(B(0,i,k)-OBS(0,i,k)).gt.OBSSTD(0,i,k) .and. C(0,i,k).eq.1, 1, 0)
C50(1,i,k) = where(abs(B(1,i,k)-OBS(1,i,k)).gt.OBSSTD(1,i,k) .and. C(1,i,k).eq.1, 1, 0)
C50(2,i,k) = where(abs(B(2,i,k)-OBS(2,i,k)).gt.OBSSTD(2,i,k) .and. C(2,i,k).eq.1, 1, 0)
C50(3,i,k) = where(abs(B(3,i,k)-OBS(3,i,k)).gt.OBSSTD(3,i,k) .and. C(3,i,k).eq.1, 1, 0)
C50(4,i,k) = where(abs(B(4,i,k)-OBS(4,i,k)).gt.OBSSTD(4,i,k) .and. C(4,i,k).eq.1, 1, 0)
C50(5,i,k) = where(abs(B(5,i,k)-OBS(5,i,k)).gt.OBSSTD(5,i,k) .and. C(5,i,k).eq.1, 1, 0)

else if (S_C(i) .lt. B_C(i) .and. abs(B(6,i,k)).gt.abs(TWS(i)) .and. B(6,i,k).lt.0)                

C(0,i,k) = where((B(0,i,k)-OBS(0,i,k)).lt.0, 1, 0)
C(1,i,k) = where((B(1,i,k)-OBS(1,i,k)).gt.0, 1, 0)
C(2,i,k) = where((B(2,i,k)-OBS(2,i,k)).gt.0, 1, 0)
C(3,i,k) = where((B(3,i,k)-OBS(3,i,k)).gt.0, 1, 0)
C(4,i,k) = where((B(4,i,k)-OBS(4,i,k)).lt.0, 1, 0)
C(5,i,k) = where((B(5,i,k)-OBS(5,i,k)).lt.0, 1, 0)

C50(0,i,k) = where(abs(B(0,i,k)-OBS(0,i,k)).gt.OBSSTD(0,i,k) .and. C(0,i,k).eq.1, 1, 0)
C50(1,i,k) = where(abs(B(1,i,k)-OBS(1,i,k)).gt.OBSSTD(1,i,k) .and. C(1,i,k).eq.1, 1, 0)
C50(2,i,k) = where(abs(B(2,i,k)-OBS(2,i,k)).gt.OBSSTD(2,i,k) .and. C(2,i,k).eq.1, 1, 0)
C50(3,i,k) = where(abs(B(3,i,k)-OBS(3,i,k)).gt.OBSSTD(3,i,k) .and. C(3,i,k).eq.1, 1, 0)
C50(4,i,k) = where(abs(B(4,i,k)-OBS(4,i,k)).gt.OBSSTD(4,i,k) .and. C(4,i,k).eq.1, 1, 0)
C50(5,i,k) = where(abs(B(5,i,k)-OBS(5,i,k)).gt.OBSSTD(5,i,k) .and. C(5,i,k).eq.1, 1, 0)

else if (S_C(i) .lt. B_C(i) .and. abs(B(6,i,k)).gt.abs(TWS(i)) .and. B(6,i,k).gt.0)

C(0,i,k) = where((B(3,i,k)-OBS(3,i,k)).lt.0, 1, 0)
C(1,i,k) = where((B(4,i,k)-OBS(4,i,k)).gt.0, 1, 0)
C(2,i,k) = where((B(5,i,k)-OBS(5,i,k)).gt.0, 1, 0)
C(3,i,k) = where((B(0,i,k)-OBS(0,i,k)).gt.0, 1, 0)
C(4,i,k) = where((B(1,i,k)-OBS(1,i,k)).lt.0, 1, 0)
C(5,i,k) = where((B(2,i,k)-OBS(2,i,k)).lt.0, 1, 0)

C50(0,i,k) = where(abs(B(0,i,k)-OBS(0,i,k)).gt.OBSSTD(0,i,k) .and. C(0,i,k).eq.1, 1, 0)
C50(1,i,k) = where(abs(B(1,i,k)-OBS(1,i,k)).gt.OBSSTD(1,i,k) .and. C(1,i,k).eq.1, 1, 0)
C50(2,i,k) = where(abs(B(2,i,k)-OBS(2,i,k)).gt.OBSSTD(2,i,k) .and. C(2,i,k).eq.1, 1, 0)
C50(3,i,k) = where(abs(B(3,i,k)-OBS(3,i,k)).gt.OBSSTD(3,i,k) .and. C(3,i,k).eq.1, 1, 0)
C50(4,i,k) = where(abs(B(4,i,k)-OBS(4,i,k)).gt.OBSSTD(4,i,k) .and. C(4,i,k).eq.1, 1, 0)
C50(5,i,k) = where(abs(B(5,i,k)-OBS(5,i,k)).gt.OBSSTD(5,i,k) .and. C(5,i,k).eq.1, 1, 0)

end if
end if 
end if 
end if 

end do
end do 

C  = where(C.ne.1, 0, C)
C  = where(ismissing(C),0,C)
C50= where(C50.ne.1, 0, C50)
C50= where(ismissing(C50),0,C50)

;====================================================== draw 

  wks = gsn_open_wks("pdf","FigS1_sma6_1STD")  ; send graphics to PNG file

  plot               = new(14,graphic)
  plot_p             = new(6, graphic)
;
; Set resources for blank plot. Be sure to set axes limits
; that represent d that will be added later via polygons.
;
  res                          = True

  res@gsnMaximize              = True    ; Maximize plot in frame
  res@gsnDraw                  = False   ; Don't draw
  res@gsnFrame                 = False   ; Don't advance frame

  res@vpWidthF                 = 0.8     ; Make long and
  res@vpHeightF                = 0.2     ; narrow

;---Set axes limits. Add extra space for X max.
  res@trYMinF                  = 0
  res@trYMaxF                  = 6  
  res@trXMinF                  = 0
  res@trXMaxF                  = nvar + 1
;  res@tiMainString             = river(Num)+", dS: CMIP5 < OBS"  
  res@tmYLLabelsOn             = False

;---Put city labels on X axis
  res@tmXBMode                 = "Explicit"
  res@tmXBValues               = ispan(1,nvar,1)
  res@tmXBLabels               = (/"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25"/)
  res@tmXBLabelJust            = "BottomCenter"

;  res@tmXBLabelAngleF          = -45

  res@tmXBLabelFontThicknessF  = 0.08
  res@tmXBLabelFontHeightF     = 0.015

  res@tiXAxisString            = "Model ID"
  res@tiXAxisFontHeightF       = 0.030

  res@gsnScale                 = True    ; Make labels on axes same size

;--Turn off X axis tickmarks
  res@tmXBMajorLengthF         = 0.
  res@tmXBMajorOutwardLengthF  = 0.  
  res@tmYLMajorLengthF         = 0.01
  res@tmYLMajorOutwardLengthF  = 0.01

  res@tmYLOn                   = False
  res@tmYROn                   = False        

;---Create blank plot with Y grid lines
  res@tmYMajorGrid                = True    ; Turn on grid lines
  res@tmYMajorGridLineDashPattern = 2       ; Dashed lines
  res@tmYMajorGridThicknessF      = 1.0     ; default is 2 (?)

  bres           = True
  bres@gsEdgesOn = False      ; Outline the polygons (bars)
;
; Loop through each city and attach bar to plot that
; doesn't have grid lines.

  dum1   = new((/14,nvar/),graphic)
  dum2   = new((/14,nvar/),graphic)
  dum3   = new((/14,nvar/),graphic)
  dum4   = new((/14,nvar/),graphic)
  dum5   = new((/14,nvar/),graphic)
  dum6   = new((/14,nvar/),graphic)

  dum1_A = new((/14,nvar/),graphic)
  dum2_A = new((/14,nvar/),graphic)
  dum3_A = new((/14,nvar/),graphic)
  dum4_A = new((/14,nvar/),graphic)
  dum5_A = new((/14,nvar/),graphic)
  dum6_A = new((/14,nvar/),graphic)

coding = (/"(a)","(a)","","(b)","(b)","(c)","(c)","","(d)","(e)","(d)","(e)","(f)","(f)"/)

NUMBER = (/"1","2","6","3","11","12","7","8","4","5","13","9","10","14"/)

    pmres = True
    pmres@gsMarkerColor = "red"
    pmres@gsMarkerIndex = 16
    pmres@gsMarkerSizeF = 0.008

do j=0,13
  res@tiMainString             = ""
  res@gsnLeftString            = coding(j)+" "+river(j)
  res@gsnLeftStringFontHeightF = 0.030
  plot(j) = gsn_csm_blank_plot(wks,res)

print(river(j)+" C: "+tofloat(sum(C50(:,j,:)))/tofloat(sum(C(:,j,:))))
do i=1,nvar
    xbar      = (/i-0.25,i-0.25,i+0.25,i+0.25,i-0.25/)

    if (C(0,j,i-1).eq.0)
    bres@gsFillColor           = "white"
    ybar      = (/0,1,1,0,0/)+3+2
    dum1(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    else
    bres@gsFillColor           = (/"(/0.1298118,0.4431373,0.7098039/)"/)
    ybar      = (/0,1,1,0,0/)+3+2
    dum1(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    end if 
  
    if (C(0,j,i-1).eq.1 .and. C50(0,j,i-1).eq.1)
    dum1_A(j,i-1)  = gsn_add_polymarker(wks, plot(j), i, 0.5+3+2, pmres)
    end if

    if (C(1,j,i-1).eq.0)
    bres@gsFillColor           = "white"
    ybar      = (/1,2,2,1,1/)+3
    dum2(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    else
    bres@gsFillColor          = "gold4"
    ybar      = (/1,2,2,1,1/)+3
    dum2(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    end if

    if (C(1,j,i-1).eq.1 .and. C50(1,j,i-1).eq.1)
    dum2_A(j,i-1)  = gsn_add_polymarker(wks, plot(j), i, 1.5+3, pmres)
    end if

    if (C(2,j,i-1).eq.0)
    bres@gsFillColor           = "white"
    ybar      = (/2,3,3,2,2/)+3-2
    dum3(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    else
    bres@gsFillColor          = "forestgreen"
    ybar      = (/2,3,3,2,2/)+3-2
    dum3(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    end if

    if (C(2,j,i-1).eq.1 .and. C50(2,j,i-1).eq.1)
    dum3_A(j,i-1)  = gsn_add_polymarker(wks, plot(j), i, 2.5+1, pmres)
    end if

    if (C(3,j,i-1).eq.0)
    bres@gsFillColor           = "white"
    ybar      = (/3,4,4,3,3/)-3+2
    dum4(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    else
    bres@gsFillColor          = "cyan"
    ybar      = (/3,4,4,3,3/)-3+2
    dum4(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    end if

    if (C(3,j,i-1).eq.1 .and. C50(3,j,i-1).eq.1)
    dum4_A(j,i-1)  = gsn_add_polymarker(wks, plot(j), i, 3.5-1, pmres)
    end if

    if (C(4,j,i-1).eq.0)
    bres@gsFillColor           = "white"
    ybar      = (/4,5,5,4,4/)-3
    dum5(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    else
    bres@gsFillColor          = "gold"
    ybar      = (/4,5,5,4,4/)-3
    dum5(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    end if

    if (C(4,j,i-1).eq.1 .and. C50(4,j,i-1).eq.1)
    dum5_A(j,i-1)  = gsn_add_polymarker(wks, plot(j), i, 4.5-3, pmres)
    end if

    if (C(5,j,i-1).eq.0)
    bres@gsFillColor           = "white"
    ybar      = (/5,6,6,5,5/)-3-2
    dum6(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    else
    bres@gsFillColor          = "lawngreen"
    ybar      = (/5,6,6,5,5/)-3-2
    dum6(j,i-1) = gsn_add_polygon(wks,plot(j),xbar,ybar,bres)
    end if

    if (C(5,j,i-1).eq.1 .and. C50(5,j,i-1).eq.1)
    dum6_A(j,i-1)  = gsn_add_polymarker(wks, plot(j), i, 5.5-5, pmres)
    end if

end do 
end do 

  txres = True
  txres@txFontHeightF = 0.012
  txres@txFontColor   = "white"

  txres@txBackgroundFillColor = (/"(/0.1298118,0.4431373,0.7098039/)"/)
  gsn_text_ndc(wks,"Discharge_P'>0", 0.6,0.12,txres)
  txres@txBackgroundFillColor = "gold4"                                          ; x-loc: 0.85 0.15, y-loc: 0.30 0.25 0.20 for 5 panels
  gsn_text_ndc(wks,"Discharge_E'<0", 0.75,0.12,txres)                            ; x-loc: 0.1, 0.25, 0.4, 0.6, 0.75, 0.9/ y-loc: 0.22 for 4 panels
  txres@txBackgroundFillColor = "forestgreen"
  gsn_text_ndc(wks,"Discharge_R'<0", 0.9,0.12,txres)


  txres@txFontColor   = "black"
  txres@txBackgroundFillColor = "cyan"
  gsn_text_ndc(wks,"Recharge_P'<0", 0.1,0.12,txres)
  txres@txBackgroundFillColor = "gold"
  gsn_text_ndc(wks,"Recharge_E'>0", 0.25,0.12,txres)
  txres@txBackgroundFillColor = "lawngreen"
  gsn_text_ndc(wks,"Recharge_R'>0", 0.4,0.12,txres)

; sc G1 = (0,3,6,8,9,12), bc G2 = (1,4,5,10,11,13)

resP = True
resP@gsnMaximize = True

plot_p(0) = plot(0)
plot_p(1) = plot(3)
plot_p(2) = plot(6)
plot_p(3) = plot(8)
plot_p(4) = plot(9)
plot_p(5) = plot(12)

gsn_panel(wks,plot_p(0:5),(/3,2/),resP)

end 
