DGPTFTR3 ;ALB/MJK - TRANSMISSION OF PTF/CENSUS ; 03/12/2004
 ;;5.3;Registration;**568**;Aug 13, 1993
 ;
BULL ;CREATE BULLETIN
 G BULLQ:DGTR<1
 S Y=$TR($$FMTE^XLFDT(DT,"5DF")," ","0")
 S ^UTILITY($J,"DGPTSTAT",1,0)="                           RUN DATE: "_Y,Y=$TR($$FMTE^XLFDT(DGSD,"5DF")," ","0")
 S %="        RELEASE DATE RANGE SELECTED: "_Y_" - " S Y=$TR($$FMTE^XLFDT($P(DGED,"."),"5DF")," ","0"),^UTILITY($J,"DGPTSTAT",2,0)=%_Y
 S ^UTILITY($J,"DGPTSTAT",4,0)="      TOTAL # OF "_$P(DGRTY0,U)_" RECORDS TRANSMITTED: "_$J(DGTR,6,0)
 F %=3,5,6 S ^UTILITY($J,"DGPTSTAT",%,0)=" "
 S ^UTILITY($J,"DGPTSTAT",7,0)="LOCAL MESSAGE ID#'S - COMPARE TO AUSTIN'S CONFIRMATION MESSAGES",DGUT=8,%=""
 F DGID=0:0 S DGID=$O(DGIDN(DGID)) Q:'DGID  S %=%_DGIDN(DGID)_"     " I $L(%)>70 S ^UTILITY($J,"DGPTSTAT",DGUT,0)=%,%="",DGUT=DGUT+1
 I $L(%) S ^UTILITY($J,"DGPTSTAT",DGUT,0)=%
 S XMSUB=$P(DGRTY0,U)_" TRANSMISSION STATISTICS SUMMARY("_$S(VATNAME["125":125,1:80)_" COLS)",XMDUZ=.5,XMTEXT="^UTILITY($J,""DGPTSTAT"",",XMY(DUZ)=""
 D ^XMD
BULLQ K DGD,J,DGCNT,VAT,VATERR,VATNAME,DGID,DGIDN,DGSDI,DGTR,DGUT,XMZ,DGERR,PTF,T1,T2,Y,DFN,DGJ,DGK,XMSUB,XMTEXT,XMY,XMDUZ,% Q
 ;
SCAN ; -- see if all released recs are xmited
 F DGD=DGSD-.01:0 S DGD=$O(^DGP(45.83,DGD)) Q:'DGD!(DGD>DGED)  D SCAN1
 Q
SCAN1 ; -- scan rec log
 S DGYES=1
 F DGI=0:0 S DGI=$O(^DGP(45.83,DGD,"P",DGI)) Q:'DGI  I $D(^(DGI,0)),'$P(^(0),U,2) S DGYES=0 Q
 I DGYES S DIE="^DGP(45.83,",DA=DGD,DR="1///TODAY" D ^DIE
 K DGYES,DIE,DR,DGI
 Q
 ;
CEN ; -- test to see if PTF rec can be sent
 S Y=1
 F DGCI=0:0 S DGCI=$O(^DGPT("ACENSUS",J,DGCI)) Q:'DGCI  I $D(^DGPT(DGCI,0)),$P(^(0),U,13)=DGCN S Y=0 Q
 I 'Y S Y=$P(DGCN0,U,3) X ^DD("DD") W !?5,*7,"[PTF #",J," for ",$P(^DPT(+^DGPT(J,0),0),U)," cannot be transmitted until ",Y,"." S Y=+DGCN0 X ^DD("DD") W !?6,"This admission is a ",Y," Census admission.]" S Y=0
 K DGCI Q
 ;
OPEN ;
 S DGPTIFN=J,DGPTFX=""
 S DIK="^DGP(45.83,DGD,""P"",",DA(1)=DGD,DA=DGPTIFN D ^DIK
 I '$O(^DGP(45.83,DGD,"P",0)) S DIK="^DGP(45.83,",DA=DGD D ^DIK
 D KDGP^DGPTFDEL
 I DGRTY=2,$D(^DGPT(+DGPTIFN,0)) S DGPTFX=+$P(^(0),U,12) I $D(^DGPT(DGPTFX,0)),$D(^DGP(45.84,DGPTFX,0)) S DGJ=DGPTIFN,DGPTIFN=DGPTFX D KDGP^DGPTFDEL S DGPTIFN=DGJ K DGJ
 K XMY
 I 'DGPTFX S DGJ(1,0)="PTF Record "_DGPTIFN_" of "_$P(^DPT(+^DGPT(DGPTIFN,0),0),U)_" re-opened."
 I DGPTFX S DGJ(1,0)="PTF Record #"_DGPTFX_" of "_$P(^DPT(+^DGPT(DGPTFX,0),0),U)_" re-opened for census." ;,DGJ(2,0)=" ",DGJ(3,0)="CENSUS Record #"_DGPTIFN_" has been deleted."
 S XMTEXT="DGJ(",XMDUZ=.5,XMSUB=$P(DGRTY0,U)_" RECORD REOPENED",XMY(DUZ)="" D ^XMD
 S DGCNT=DGSTCNT("P",DGPTIFN) K DGSTCNT("P",DGPTIFN) F K=DGCNT-.01:0 S K=$O(^XMB(3.9,DGXMZ,2,K)) Q:K'>0  K ^(K,0)
 I DGRTY=2 D KDGPT^DGPTFDEL
 W !,$P(DGRTY0,U)," RECORD RE-OPENED"
 K DIK,DA,XMY,XMTEXT,XMDUZ,XMSUB,DGPTIFN,DGPTFX Q
 ;
