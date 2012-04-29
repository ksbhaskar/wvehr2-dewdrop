IMRLCNT3 ;ISC-SF/JLI-LOCAL COUNT OF PTS, STATUS, OP VISITS, IP STAYS, ETC. CONTINUED (PRINT) ;9/2/97  13:23
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
IPPRNT ;
 D GETNOW^IMRACESS
 Q:'$D(^TMP($J,IMR1C,"IP"))
 D PRTC^IMRLCNT2 Q:IMRUT
 S IMRX="SELECTED INPATIENT ACTIVITY" D HEDR
 W !!,"Totals:      " S X=^TMP($J,IMR1C,"IP"),Y=^("IP","ADMITS"),Z=^("DAYS") W X," patients for ",Y," stays and ",Z," days of inpatient care",!
 S IMRALOS=Z/Y ;average length of stay
 F I=0:0 S I=$O(^TMP($J,IMR1C,"IP","N",I)) Q:I'>0!(IMRUT)  D
 .I ($Y+4>IOSL) D PRTC^IMRLCNT2 Q:IMRUT  W @IOF
 .W !?10,$J(I,3)," stay",$S(I>1:"s",1:" ")," ",$S(^TMP($J,IMR1C,"IP","N",I)>1:"each",1:"    ")," for ",$J(^TMP($J,IMR1C,"IP","N",I),4)," patient",$S(^TMP($J,IMR1C,"IP","N",I)>1:"s",1:"")
 .Q
 Q:IMRUT
 S Z=0,X="",Y=^TMP($J,IMR1C,"IP","ADMITS"),Z1=Y#2,Y=Y\2,Y=$S(Z1:Y+1,1:Y)
 F I=-1:0 S I=$O(^TMP($J,IMR1C,"IP",I)) Q:+I'=I  S Z=Z+^(I) I Z'<Y S X=$S(X="":I,1:(X+I)\2) Q:Z1  Q:Z>Y
 W !!?10,"Median Length of Stay (MLOS): ",$J(X,4,1)," days."
 W !!?9,"Average Length of Stay (ALOS): ",$J(IMRALOS,4,1)," days."
 W ! S IMRBS=""
 F I=0:0 S IMRBS=$O(^TMP($J,IMR1C,"IP","BS",IMRBS)) Q:IMRBS=""!(IMRUT)  D
 .S X=^(IMRBS),Y=^(IMRBS,"STAYS"),Z=^("DAYS")
 .I ($Y+4>IOSL) D PRTC^IMRLCNT2 Q:IMRUT  W @IOF
 .W !,$E(IMRBS,1,18),?20,$J(X,4)," patient",$S(X>1:"s, ",1:",  "),$J(Y,4)," stay",$S(Y>1:"s, ",1:",  "),"and ",$J(Z,5)," days"
 .D IPPR1
 .Q
 Q:IMRUT
 I $D(^XUSEC("IMRMGR",DUZ)),$D(^TMP($J,IMR1C,"NO BS")) D  Q:IMRUT  D PRTC^IMRLCNT2
 .D PRTC^IMRLCNT2 Q:IMRUT  D HEDR
 .W !!,"OCCURRENCES OF NO BEDSECTION ID",!!
 .F IMRDFN=0:0 S IMRDFN=$O(^TMP($J,IMR1C,"NO BS",IMRDFN)) Q:IMRDFN'>0!(IMRUT)  D IPPR0
 .Q
 Q:IMRUT
TOPN ;I '$D(ZTQUEUED) S IMRRMAX=0 D:$D(^XUSEC("IMRMGR",DUZ)) ASKQ^IMRLCNT1
 Q:IMRUT!(IMRRMAX'>0)  K ^TMP($J,IMR1C,"OV"),^("IPST"),^("IPDA")
 F I=0:0 S I=$O(^TMP($J,IMR1C,"PAT",I)) Q:I'>0  I $D(^(I,"S")) S X=^("S"),Y=0 D OP1 S ^TMP($J,IMR1C,"OV",(99999-X),I)=X_U_Y_U_Z
 F I=0:0 S I=$O(^TMP($J,IMR1C,"PAT",I)) Q:I'>0  I $D(^(I,"IP")) S X=^("IP"),Y=^("IP","DAYS") S ^TMP($J,IMR1C,"IPST",(9999-X),I)=X_U_Y,^TMP($J,IMR1C,"IPDA",(9999-Y),I)=X_U_Y
 I $D(^TMP($J,IMR1C,"OV")) S IMRX="HIGHEST UTILIZATION OF VISITS" D HEDR,HEDRA S IMRN=0
 F I=0:0 Q:IMRN'<IMRRMAX!(IMRUT)  S I=$O(^TMP($J,IMR1C,"OV",I)) Q:I'>0!(IMRUT)  F J=0:0 S J=$O(^TMP($J,IMR1C,"OV",I,J)) Q:J'>0!(IMRUT)  D
 .S IMRN=IMRN+1,X=^TMP($J,IMR1C,"OV",I,J),DFN=J D NS^IMRCALL
 .I ($Y+4>IOSL) D PRTC^IMRLCNT2 Q:IMRUT  D HEDR,HEDRA
 .W !,IMRNAM,?32,IMRSSN,?45,$J(+X,8),?55,$J($P(X,U,3),8),?60,$J($P(X,U,2),10)
 .Q
 Q:IMRUT
 I $D(^TMP($J,IMR1C,"IPST")) S IMRX="HIGHEST NUMBER OF STAYS" D HEDR,HEDRB S IMRN=0
 F I=0:0 Q:IMRN'<IMRRMAX!(IMRUT)  S I=$O(^TMP($J,IMR1C,"IPST",I)) Q:I'>0!(IMRUT)  F J=0:0 S J=$O(^TMP($J,IMR1C,"IPST",I,J)) Q:J'>0!(IMRUT)  D
 .S IMRN=IMRN+1,X=^TMP($J,IMR1C,"IPST",I,J),DFN=J D NS^IMRCALL
 .I ($Y+4>IOSL) D PRTC^IMRLCNT2 Q:IMRUT  D HEDR,HEDRB
 .W !,IMRNAM,?32,IMRSSN,?45,$J(+X,8),?60,$J($P(X,U,2),10)
 .Q
 Q:IMRUT
 D PRTC^IMRLCNT2 Q:IMRUT  W @IOF
 I $D(^TMP($J,IMR1C,"IPDA")) S IMRX="HIGHEST NUMBER OF DAYS" D HEDR,HEDRB S IMRN=0
 F I=0:0 Q:IMRN'<IMRRMAX!(IMRUT)  S I=$O(^TMP($J,IMR1C,"IPDA",I)) Q:I'>0!(IMRUT)  F J=0:0 S J=$O(^TMP($J,IMR1C,"IPDA",I,J)) Q:J'>0!(IMRUT)  D
 .S IMRN=IMRN+1,X=^TMP($J,IMR1C,"IPDA",I,J),DFN=J D NS^IMRCALL
 .I ($Y+4>IOSL) D PRTC^IMRLCNT2 Q:IMRUT  D HEDR,HEDRB
 .W !,IMRNAM,?32,IMRSSN,?45,$J(+X,8),?60,$J($P(X,U,2),10) K DFN
 .Q
 Q:IMRUT  D PRTC^IMRLCNT2 W @IOF
 Q
IPPR0 ;
 F IMRD1=0:0 S IMRD1=$O(^TMP($J,IMR1C,"NO BS",IMRDFN,IMRD1)) Q:IMRD1'>0!(IMRUT)  D
 .I ($Y+4>IOSL) D PRTC^IMRLCNT2 Q:IMRUT  D HEDR W !!,"OCCURRENCES OF NO BEDSECTION ID",!!
 .D IPPR2
 .Q
 Q
 ;
OP1 F J=0:0 S J=$O(^TMP($J,IMR1C,"PAT",I,"OP",J)) Q:J'>0  S Y=Y+1
 S Z=0 F J=0:0 S J=$O(^TMP($J,IMR1C,"PAT",I,"S",J)) Q:J'>0  S Z=Z+^(J)
 Q
 ;
IPPR1 S X="",Z=0,Z1=Y#2,Y=Y\2,Y=$S(Z1:Y+1,1:Y) F J=-1:0 S J=$O(^TMP($J,IMR1C,"IP","BS",IMRBS,J)) Q:+J'=J  S Z=Z+^(J) I Z'<Y S X=$S(X="":J,1:(X+J)/2) Q:Z1  Q:Z>Y
 W "  MLOS:",$J(X,6,1)," days"
 Q
IPPR2 S IMRI=$O(^TMP($J,IMR1C,"NO BS",IMRDFN,IMRD1,0)),DFN=IMRDFN D NS^IMRCALL
 W !,$E(IMRNAM,1,25),?27,IMRSSN,"  moved in: ",$E(IMRD1,4,5),"/",$E(IMRD1,6,7),"/",$E(IMRD1,2,3),"   PTF entry: ",IMRI
 K DFN,VA,VADM
 Q
 ;
HEDR ;
 S IMRZ="INPATIENT AND OUTPATIENT ACTIVITY"
 W:$Y>0 @IOF W:IOST'["C-" !!! W !,?(IOM-$L(IMRZ)\2),IMRZ,!,?(IOM-$L(IMRX)\2),IMRX,!?(IOM-$L(IMRD)\2),IMRD,!?(IOM-$L(IMRLBL)\2),IMRLBL,!?(IOM-$L(IMRDTE)\2),IMRDTE,!! S IMRPG=IMRPG+1
 Q
 ;
HEDRA W ?69,"DIFFERENT",!,"PATIENT NAME",?35,"SSN",?48,"VISITS",?60,"STOPS",?68,"STOP CODES",!
 Q
 ;
HEDRB W "PATIENT NAME",?35,"SSN",?48,"# STAYS",?66,"# DAYS",!
 Q
 ;
