EN ;(WASH ISC)/DLM-Engineering Driver ;8-24-94
V ;;7.0;ENGINEERING;**18**;Aug 17, 1993
 ;CAN BE RUN DIRECTLY OR OVERLAYED BY VA SECURITY
 ;CALLS ^%ZIS,DT^DICRW,^DIC,^DIE,^DII
 ;      ENWO,ENINV,ENMAN,ENPROJ,ENSP,ENFSANOA,PRCSE,PRCSP,XM
 ;REQUIRES PROGRAMS : FILE MANAGER, VA KERNEL
 ;REQUIRES GLOBALS  : %ZOSF,DIC(3) (USER FOR MAILMAN)
 D:'$D(DT) DT^DICRW S U="^",S=";",O=$T(OPT) I $D(^DOPT($P(O,S,5),"VERSION")),($P($T(V),S,3)=^DOPT($P(O,S,5),"VERSION")) G IN
 K ^DOPT($P(O,S,5))
 F I=1:1 Q:$T(OPT+I)=""  S ^DOPT($P(O,S,5),I,0)=$P($T(OPT+I),S,3),^DOPT($P(O,S,5),"B",$P($P($T(OPT+I),S,3),"^",1),I)=""
 S K=I-1,^DOPT($P(O,S,5),0)=$P(O,S,4)_U_1_U_K_U_K K I,K,X S ^DOPT($P(O,S,5),"VERSION")=$P($T(V),S,3)
IN I $P(O,S,6)'="" D @($P(O,S,6))
PR S O=$T(OPT),S=";" D HOME^%ZIS W:$E(IOST,1,2)="C-" @IOF
 D HDR F J=1:1 Q:'$D(^DOPT($P(O,S,5),J,0))  W !,?15,J,". ",$P(^DOPT($P(O,S,5),J,0),U,1)
RE W ! S DIC("A")="Select "_$P($T(OPT),S,4)_": EXIT// ",DIC="^DOPT("_""""_$P($T(OPT),S,5)_""""_",",DIC(0)="AEQMN" D ^DIC G:X=""!(X=U) EXIT G:Y<0 RE K DIC,J,O D @($P($T(OPT+Y),S,4)) G PR
 ;
INIT ;INITIALIZE VARIABLES FOR ENGINEERING SYSTEM
 S:$D(DTIME)<1 DTIME=600
 D DT^DICRW S U="^"
ZIS D HOME^%ZIS I $D(^%ZIS(2)) S:$D(^%ZIS(2,IOST(0),7)) ENHI=$P(^(7),U,1),ENLO=$S($P(^(7),U,3)]"":$P(^(7),U,3),1:$P(^(7),U,2)) I $D(ENHI),$D(ENLO) Q
 S ENLO="*0",ENHI="*0" Q
 ;
HDR W @IOF,!,?14,"AUTOMATED ENGINEERING MANAGEMENT SYSTEM"
 N %,%H,%I,X
 W !,?29,"VERSION ",^ENG("VERSION")
 I $D(^DIC(6910,1,0)) S X=34-($L($P(^DIC(6910,1,0),"^",1))\2) W !,?X,$P(^DIC(6910,1,0),"^",1)
 D NOW^%DTC W !,?22,$$FMTE^XLFDT(%,"1P")
 W !!! Q
FM ;FILE MANAGER
 K ^DISV($I) W @IOF,!!,"FILE MANAGER",!! D ^DII Q
XM ;TESTS FOR VALID USER CODE FOR MAILMAN
 W @IOF,!! G:$D(^VA(200,DUZ,0))>0 ^XM W !!,"USER IDENTIFICATION (FILE 3) NEEDED FOR MAILMAN (ELECTRONIC MAIL)",!! R X:5 Q
EXIT K A,DA,DIC,ENHI,ENLO,ENERR,I,J,K,O,S,X,Y,Z Q
 ;
OPT ;;ENGINEERING MAIN MENU OPTIONS;Engineering MAIN MENU OPTION;EN;INIT
 ;;WORK ORDER + MERS;^ENWO
 ;;EQUIPMENT MANAGEMENT;^ENEQ
 ;;CONSTRUCTION PROJECT;^ENPROJ
 ;;SPACE MANAGEMENT;^ENSP
 ;;PROGRAM MANAGEMENT;^ENMAN
 ;;ACCIDENT REPORTING;^ENFSA
 ;;ASSIGN ELECTRONIC WORK ORDERS;^ENETRAN
