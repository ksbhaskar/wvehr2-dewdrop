GMRVSC0 ;HIOFO/MD,YH,FT-CUMULATIVE VITALS/MEASUREMENTS FOR PATIENT OVER GIVEN DATE RANGE ;9/27/07
        ;;5.0;GEN. MED. REC. - VITALS;**23**;Oct 31, 2002;Build 25
        ;
        ; This routine uses the following IAs
        ; #10039 - ^DIC(42 references     (supported)
        ; #10040 - FILE 44 references     (supported)
        ; #10061 - ^VADPT calls           (supported)
        ; #10090 - FILE 4 references      (supported)
        ;
        ;EN1 ; ENTRY FROM OPTION GMRV CUMULATIVE V/M
        ;K ^TMP($J) S DIC="^DPT(",DIC(0)="AEQM" D ^DIC K DIC Q:+Y'>0  S DFN=+Y
        ;EN2 ; ENTRY IF DFN IS KNOWN TO PRINT CUMULATIVE VITALS
        ;S GMROUT=0 D DEM^VADPT,INP^VADPT S GMRRMBD=$S(VAIN(5)'="":VAIN(5),1:"  BLANK"),GMRNAM=$S(VADM(1)'="":VADM(1),1:"  BLANK"),^TMP($J,GMRRMBD,GMRNAM,DFN)=""
        ;S GMRX=$S(VAIN(7)'="":$P(VAIN(7),"^",2),1:"")
        ;EN2A ; ENTRY FROM PRINT CUMULATIVE REPORT BY WARD
        ;D DATE G:GMROUT Q
        ;DEV S %ZIS="Q",%ZIS("B")="" D ^%ZIS K %ZIS G:POP Q I $E(IOST)="P",'$D(IO("Q")),'$D(IO("S")) D ^%ZISC W !,?3,"PRINTED REPORTS MUST BE QUEUED!!",$C(7) G DEV
        ;I $D(IO("Q")) S (ZTSAVE("^TMP($J,"),ZTSAVE("GMRVSDT"),ZTSAVE("GMRVFDT"))="",ZTIO=ION,ZTDESC="Cumulative vital/measurement report",ZTRTN="START^GMRVSC0" D ^%ZTLOAD K ZTSK,ZTIO G Q
        ;START ;
        ;S (GMROUT,GMRPG)=0 D NOW^%DTC S Y=% D D^DIQ S GMRPDT=$P(Y,"@")_" ("_$P($P(Y,"@",2),":",1,2)_")",$P(GMRDSH,"-",80)="" U IO S GMRRMBD=""
        ;N GPEDIS S GPEDIS=$O(^GMRD(120.52,"B","DORSALIS PEDIS",0)) Q:GPEDIS'>0
        ;F  S GMRRMBD=$O(^TMP($J,GMRRMBD)) Q:GMRRMBD=""!GMROUT  S GMRNAM="" F  S GMRNAM=$O(^TMP($J,GMRRMBD,GMRNAM)) Q:GMRNAM=""!GMROUT  S DFN=0 F  S DFN=$O(^TMP($J,GMRRMBD,GMRNAM,DFN)) Q:DFN'>0!GMROUT  S GMRPG=0 D WRT Q:GMROUT  D EN1^GMRVSC1
        ;Q W:$E(IOST)'="C" @IOF D Q^GMRVSC1 K GMRBMI,GMRVHT,^TMP($J),GMRINF,GMRPG,GMREDB,GMRNAM,GMRRMBD,GMRVWLOC,GMRWARD,GMRMSL,GMRROOM,GMRRMST,GMRVHLOC,GMRLEN,GMRI,GMROUT,GMRVSDT,GMRVFDT,GPRT Q
DATE    ;W !,"CALLED BY IA 1444 - NURSING, BCMA"
        S %DT="AET",%DT("B")=$S(GMRX'="":$P(GMRX,"@"),1:"T-7"),%DT("A")="Start with DATE (TIME optional): " D ^%DT K %DT I +Y'>0 S GMROUT=1 Q
        S GMRVSDT=+Y
        S %DT="AET",%DT("A")="go to DATE (TIME optional): ",%DT("B")="NOW" D ^%DT K %DT I X="^" S GMROUT=1 Q
        I +Y'>0!($P(Y,".",2)'>0&(DT=Y)) D NOW^%DTC S Y=%
        I $P(Y,".",2)'>0 S Y=Y_$S(Y[".":"2400",1:".2400")
        I GMRVSDT>+Y W !,?3,$C(7),"THE START DATE MUST BE BEFORE THE END DATE OF THIS REPORT" G DATE
        S GMRVFDT=+Y
        Q
FOOTER  ;REPORT FOOTER SUBROUTINE
        W !!,"*** (E) - Error entry",!! W:VADM(1)'="" ?$X-3,$E(VADM(1),1,15) W:VADM(2)'="" ?17,$P($P(VADM(2),"^",2),"-",3) W:VADM(3)'="" ?30,$P(VADM(3),"^",2) W:VADM(4)'="" ?43,$P(VADM(4),"^")_" YRS"
        W:VADM(5)'="" ?51,$P(VADM(5),"^",2)
        W ?65,"VAF 10-7987j" W !,"Unit: "_$S($P(VAIN(4),"^",2)'="":$P(VAIN(4),"^",2),1:"     "),?32,"Room: "_$S($P(VAIN(5),"^")'="":$P(VAIN(5),"^"),1:"   "),!
        I '$D(GMRVHLOC) S GMRVHLOC=$P($G(^DIC(42,+$G(VAIN(4)),44)),"^")
        W "Division: "_$S(GMRVHLOC>0:$$GET1^DIQ(4,+$$GET1^DIQ(44,+GMRVHLOC,3,"I"),.01,"I"),1:""),!
        Q
        ;WRT ;
        ;S GMR1ST=1 K GMRSITE D DEM^VADPT,INP^VADPT S GWARD=$S($P(VAIN(4),"^",2)'="":$P(VAIN(4),"^",2),1:"   "),GBED=$S(VAIN(5)'="":$P(VAIN(5),"^"),1:"   ") D HDR^GMRVSC2
        ;Q
EN3(DFN,GMRVSDT,GMRVFDT)        ; APPLICATION PROGRAM INTERFACE FOR PATIENT CUMULATIVE VITALS REPORT
        ; INPUT VARIABLES:    DFN=PATIENT NUMBER
        ;                     GMRVSDT=START DATE
        ;                     GMRVFDT=FINISH DATE OF REPORT
        ;CALLED BY IA 1444: NURSING, BCMA
        S GMRVOR=1
EN5     ;CALLED BY [NURCPP-VIT-CUM] - IA 1444, NURSING, BCMA
        S (GMROUT,GMRPG)=0 D DEM^VADPT,INP^VADPT S GBED=$S(VAIN(5)'="":VAIN(5),1:"   "),GWARD=$S($P(VAIN(4),"^",2)="":"   ",1:$P(VAIN(4),"^",2))
        S GMR1ST=1,GMRDATE(0)=0 D NOW^%DTC S Y=% D D^DIQ S GMRPDT=$P(Y,"@")_" ("_$P($P(Y,"@",2),":",1,2)_")",$P(GMRDSH,"-",81)=""
        N GPEDIS S GPEDIS=$O(^GMRD(120.52,"B","DORSALIS PEDIS",0)) Q:GPEDIS'>0
        K ^TMP($J,"GMRV") F GMRVTY="T","P","R","BP","HT","WT","CVP","CG","PO2","PN" D
        . S GMRVITY=$O(^GMRD(120.51,"C",GMRVTY,0)) I GMRVITY>0 D SETAR^GMRVSC1,SETAR1^GMRVSC1
        U IO D HDR^GMRVSC2
        I $O(^TMP($J,"GMRV",0))'>0 W !!,"No cumulative vitals data for "_$S($D(OPSPNM):ORSPNM,1:"this patient"),! S:$D(ORSPNM) GMROUT=1 G Q3
        S GMRDATE=9999999
        F  S GMRDATE=$O(GMRVDT(GMRDATE),-1) Q:GMRDATE'>0!GMROUT  I $D(^TMP($J,"GMRV",GMRDATE)) D PRT^GMRVSC1
Q3      I IOSL'<($Y+10) F X=1:1 W ! Q:IOSL<($Y+10)
        I 'GMROUT W ! D FOOTER^GMRVSC0 I '$D(GMRVOR),$E(IOST)'="P",'GMROUT W !,"Press return to continue or ""^"" to exit " R X:DTIME S:'$T!(X["^") GMROUT=1
        D KVAR^VADPT K GMRVOR,VA,GBED,GWARD,^TMP($J,"GMRV"),GMR1ST,GMRVTY,GMRVITY,GMRVDATE,GMRSITE,GMRDSH,GMRQUAL,GMRVX,GMRX,GX,GMRDAT,GMRLN,GMRPDT,GMRSP,GMRVDA,GMRY
        I $D(ORSPNM) K GMRPG,GMRVSDT,GMRVFDT S:$D(ZTQUEUED) ZTREQ="@" D ^%ZISC
        Q
        ;EN4 ;V/M CUMULATIVE REPORTS BY WARD/ROOM/PT
        ;S (GMRVWLOC,GMROUT)=0 D WARDPAT^GMRVED0 G:GMROUT Q2
        ;I "Pp"[GMREDB D DEM^VADPT,INP^VADPT S GMRRMBD=$S(VAIN(5)'="":VAIN(5),1:"  BLANK"),GMRNAM=$S(VADM(1)'="":VADM(1),1:"  BLANK"),^TMP($J,GMRRMBD,GMRNAM,DFN)="" S GMRX=$S(VAIN(7)'="":$P(VAIN(7),"^",2),1:"")
        ;I "Aa"[GMREDB D EN1^GMRVED2 S GMRX=""
        ;I "Ss"[GMREDB D EN3^GMRVED6 D:'GMROUT EN1^GMRVED2 S GMRX=""
        ;G:GMROUT Q2 D EN2A
        ;Q2 K GMROUT,GMRVWLOC,GMRMSL,GMREDB,I,DFN Q
