PSXCSUTL ;BIR/JMB-Utilities for Cost Routines ;[ 04/09/98  9:41 AM ]
 ;;2.0;CMOP;**11,16,38**;11 Apr 97
 ;reference to ^PSDRUG( supported by DBIA #1983
NAME ;Gets drug name by looking up drug ID #
 K PSXNAM S PSXI=$O(^PSDRUG("AQ1",PSXDGID,0))
 S:PSXI PSXNAM=$P($G(^PSDRUG(PSXI,0)),"^")
 S:'PSXI PSXNAM="UNKNOWN" K PSXI
 Q
MN ;Gets month & yr
 S PSXRPT="MN"
 S %DT("A")="Enter Month/Year: ",%DT="AQEP" D ^%DT I "^"[X S PSXOUT=1 Q
 G:Y'>0 MN S PSXBDT=$E(Y,1,5)_"00",PSXEDT=$E(Y,1,5)_$P("31^29^31^30^31^30^31^31^30^31^30^31^","^",$E(Y,4,5))
 S PSXFND=$O(^PSX(552.5,"AD",PSXBDT-1))
 D:PSXFND>PSXEDT!(+PSXFND=0) NODATA Q:$G(PSXOUT)  ;Determine if no data for date range
IDYN K PSXEDATE,PSXSDATE W ! S DIR("A")="Do you want to look at data concerning a specific drug",DIR("B")="Y",DIR(0)="Y" D ^DIR K DIR I $G(DIRUT) S PSXOUT=1 Q
 I 'Y G:$G(PSXRPT)="MN" FACYN G BEG
ID S DIC="^PSDRUG(",DIC(0)="AEQMZ" S DIC("S")="I $P($G(^(""ND"")),U,10)]"""""
 D ^DIC K DIC I $D(DTOUT)!$D(DUOUT) S PSXOUT=1 Q
 G:X="" IDYN S PSXID=$P($G(^PSDRUG(+Y,"ND")),"^",10),PSXIDG=+Y
 K X,Y
 G:$G(PSXRPT)="MN" FACYN
BEG W ! S %DT("A")="Beginning Date: ",%DT="AEP" D ^%DT I X["^" S PSXOUT=1 Q
 G:Y<0 BEG S (%DT(0),PSXBDT)=Y
 I Y>DT W !!,"Future dates are not allowed!",! K %DT G BEG
EN W ! S %DT("A")="Ending Date: " D ^%DT I X["^" S PSXOUT=1 Q
 G:Y<0 EN S PSXEDT=Y
 S PSXFND=$O(^PSX(552.5,"AD",PSXBDT-1))
 D:PSXFND>PSXEDT!(+PSXFND=0) NODATA Q:$G(PSXOUT)  ;Determine if no data for date range
FACYN ;Gets facility
 K ^UTILITY("DIQ1",$J)
 W ! S DIR("A")="Print data for a specific facility",DIR("B")="Y",DIR(0)="Y" D ^DIR K DIR I $G(DIRUT) S PSXOUT=1 Q
FAC K PSXEDATE,PSXSDATE Q:'Y  S DIC(0)="AEQMZ",DIC="^DIC(4,",DIC("A")="Select FACILITY: " D ^DIC K DIC G:$G(DTOUT)!($G(DUOUT)) END
 G:Y<0 FAC S XSITE=X,DA=+Y K Y
 S DIC=4,DIQ(0)="I",DR="99" D EN^DIQ1
 S PSXFAC=$G(^UTILITY("DIQ1",$J,4,DA,99,"I"))
 I 'PSXFAC S DA(1)=DA,DA=1,IENS=DA_","_DA(1),PSXFAC=$$GET1^DIQ(4.9999,IENS,.02) I +PSXFAC S PSXFAC=1_PSXFAC ;****DOD L1
 I '$D(^PSX(552.5,PSXFAC,0)) W !,"There is no data for "_XSITE G FACYN
 W ! S DIR("A")="Print data for a specific division",DIR("B")="Y",DIR(0)="Y" D ^DIR K DIR I $G(DIRUT) S PSXOUT=1 Q
DV Q:'Y  S DIC(0)="AEQM",DIC="^PSX(552.5,"_PSXFAC_",1,",DIC("A")="Select DIVISION: " D ^DIC K DIC I $G(DTOUT)!($G(DUOUT)) S PSXOUT=1 Q
 G:Y<0 DV S PSXIENDV=+Y,PSXDV=$P(Y,"^",2)
 Q
NODATA ;No data in file
 S Y=PSXBDT X ^DD("DD") S PSXSDATE=Y,Y=PSXEDT X ^DD("DD") S PSXEDATE=Y W !!?4,"** There is no CMOP cost data between "_PSXSDATE_" and "_PSXEDATE_". **"
 W !!?4,"Use the Date Range Compile/Recompile Cost Data option to compile the",!?4,"cost data for this date range." S PSXOUT=1 K PSXEDATE,PSXFND,PSXSDATE
 Q
END K ^TMP($J),%,%DT,%H,%T,%Y,%ZIS,DA,DIC,DIE,DIK,DINUM,DIR,DIRUT,DLAYGO,DR
 K DTOUT,DUOUT,POP,PSX50,PSXAVCST,PSXAVG,PSXBDT,PSXBDTE,PSXBDTH,PSXBDTR
 K PSXBEG,PSXBMN,PSXBY,PSXBYR,PSXCDT,PSXCID,PSXCMN,PSXCNT,PSXCNTO
 K PSXCNTDV,PSXCNTR,PSXCOM,PSXCOST,PSXCST,PSXCUT,PSXCYR,PSXDG,PSXDGID
 K PSXDIV,PSXDLN,PSXDT90,PSXDT90R,PSXDR0,PSXDRCST,PSXDT,PSXDV,PSXDVCNT
 K PSXEDT,PSXEDTE,PSXEDTR,PSXEND,PSXEMN,PSXERR,PSXEXIT,PSXEYR,PSXFAC
 K PSXFACN,PSXFACR,PSXFACYN,PSXFCID,PSXFL,PSXFLS,PSXFLD,PSXFND,PSXG
 K PSXID,PSXI,PSXIDG,PSXIDV,PSXIEN,PSXIENDV,PSXJOB,PSXJOBE,PSXLAYGO
 K PSXLGN,PSXLOC,PSXMAX,PSXMC,PSXMCDT,PSXMN,PSXMON,PSXNAM,PSXNEXT
 K PSXNODE,PSXOUT,PSXPC,PSXPDT,PSXPG,PSXPSDT,PSXQTY,PSXRF,PSXRPT,PSXRUN
 K PSXRXN,PSXSLN,PSXSPDV,PSXSUB,PSXT,PSXT1,PSXT2,PSXT3,PSXT4,PSXT5,PSXT6
 K PSXTH,PSXTH1,PSXTH2,PSXTH3,PSXTH4,PSXTH5,PSXTH6,PSXTMP,PSXTOT,PSXVAPRT
 K PSXX,PSXYR,X,X1,X2,Y,ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTSK,ZTIO
 S:$D(ZTQUEUED) ZTREQ="@"
 K PSXION,PSXSTA,PSXSTART,^UTILITY("DIQ1",$J) Q
