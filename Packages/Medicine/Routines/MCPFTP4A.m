MCPFTP4A ;WISC/TJK-PREDICTED VALUES FOR SPECIAL STUDIES ;9/12/90  08:28;09/17/91  11:24 AM
 ;;2.3;Medicine;;09/13/1996
SETNULL S PRED=""
PRINT S ACT=$P(ND,U,PC) I ACT'="" D PRTLINE^MCPFTP2
 Q
PIMAX G SETNULL S PRED=$S(MCSEX="M":143-(.55*AGE),1:104-(.51*AGE)) G PRINT
RAW G SETNULL S PRED=.2 G PRINT
SGAW G SETNULL S PRED=.112 G PRINT
CST G SETNULL S PRED=$S(MCSEX="M":.0024*AGE+(.00516*HT)-.677,1:.0019*AGE+(.0039*HT)-.471) G PRINT
CDYN ;
FEF50 G SETNULL S PRED=40.8 G PRINT
VISOV G SETNULL S PRED=.291*AGE+4.917,PRED=(PRED-6.88) G PRINT
CV ;
CC ;
CVVC G SETNULL G SETNULL:$P(MCPFT0,U,8)'="N" S PRED=.318*AGE+1.919-4.61 Q
VEMAXB ;
BR ;
VDVTR ;
VDVTM ;
VEVCAT ;
VEMAXMVV G SETNULL S PRED=.57 Q
VERESTB ;
VO2REST ;
VO2MAX1 G SETNULL S PRED=(.001*WT)*(68.3-(11.9*$S(MCSEX="F":2,1:1))-(.413*AGE)) G PRINT
VO2MAX2 G VO2MAX3:MCSEX="F"
 S ER1=.79*HT-60.7,ER2=50.72-(0.372*AGE)
 G SETNULL S PRED=$S(WT>ER1:ER1*ER2,1:WT*ER2) G VO2MAX4
VO2MAX3 S ER1=(42.8+WT)*(22.78-(.17*AGE)),ER2=HT*(14.81-(.11*AGE))
 G SETNULL S PRED=$S(WT>.65*HT-42.8:ER2,1:ER1)
VO2MAX4 G SETNULL S PRED=PRED/1000 K ER1,ER2 G PRINT
AT ;
HRREST ;
HRMAX G SETNULL S PRED=210-(.65*AGE) G PRINT
VO2HR ;
BPMAX ;
RRREST ;
RRMAX ;
WMAX ;
WRIWRT ;
HCO3 ;
