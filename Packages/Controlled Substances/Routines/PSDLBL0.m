PSDLBL0 ;BIR/JPW-CS Label Prt for CS Disp Drug (cont'd) ; 17 May 94
 ;;3.0; CONTROLLED SUBSTANCES ;;13 Feb 97
START ;entry for compile and print labels
 K ^TMP("PSDLBL",$J),PSDPRT D NOW^%DTC S PSDT=+$E(%,1,12)
 F JJ=0,1 S @("PSDBAR"_JJ)="" I $D(^%ZIS(2,^%ZIS(1,IOS,"SUBTYPE"),"BAR"_JJ)) S @("PSDBAR"_JJ)=^("BAR"_JJ)
 I PSDBAR1]"",PSDBAR0]"" S PSDPRT=1
 S PSDCNT=1
 I ANS="R" S PSD1="" F  S PSD1=$O(PSD1(PSD1)) Q:PSD1=""  D LOOP
 I ANS="R" G PRINT
 I ANS="N",$D(PSDG) F PSD=0:0 S PSD=$O(PSDG(PSD)) Q:'PSD  F PSDN=0:0 S PSDN=$O(^PSI(58.2,PSD,3,PSDN)) Q:'PSDN  I $D(^PSD(58.8,PSDN,0)),'$P(^(0),"^",7),$P(^(0),"^",3)=+PSDSITE S NAOU(PSDN)="",CNT=CNT+1
 I ANS="N",$D(ALL) F PSD=0:0 S PSD=$O(^PSD(58.8,PSD)) Q:'PSD  I $D(^PSD(58.8,PSD,0)),$P(^(0),"^",2)="N",$P(^(0),"^",3)=+PSDSITE S NAOU(+PSD)=""
 S STAT=3
 F PSD=0:0 S PSD=$O(^PSD(58.81,"AD",STAT,PSD)) Q:'PSD  F PSDJ=0:0 S PSDJ=$O(^PSD(58.81,"AD",STAT,PSD,PSDJ)) Q:'PSDJ  D SET1
PRINT ;print labels
 S (PSDCNT,PSDOUT)=0,PSDX2=1
 S PSD="" F  S PSD=$O(^TMP("PSDLBL",$J,PSD)) Q:PSD=""!(PSDOUT)  S PSDCNT=PSDCNT+1,TEMP(PSDCNT)=$E($P(^TMP("PSDLBL",$J,PSD),"^",2),1,28),TEST(PSDCNT)=$P(^TMP("PSDLBL",$J,PSD),"^")_"  "_$P(^TMP("PSDLBL",$J,PSD),"^",3) D:PSDCNT=3 PRINT1
 I PSDCNT,PSDCNT<3 D PRINT1
DONE I $E(IOST)'="C" W @IOF
 I $E(IOST,1,2)="C-",'PSDOUT W ! K DIR,DIRUT S DIR(0)="EA",DIR("A")="END OF REPORT!  Press <RET> to return to the menu" D ^DIR K DIR
END ;kill variables and exit
 K %,%DT,%H,%I,%ZIS,ALL,ANS,CNT,DA,DIC,DIE,DIR,DIROUT,DIRUT,DR,DRUG,DTOUT,DUOUT,JJ,JLP1,LIQ,NAOU,NAOUN,NODE,OK
 K POP,PSD,PSD1,PSD2,PSDA,PSDBAR0,PSDBAR1,PSDCNT,PSDEV,PSDG,PSDJ,PSDN,PSDPN,PSDOUT,PSDR,PSDRG,PSDPRT,PSDRN,PSDS,PSDSN,PSDT,PSDX1,PSDX2
 K SEL,STAT,TEMP,TEST,TEXT,X,Y,ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK
 K ^TMP("PSDLBL",$J)
 D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
 Q
LOOP S PSDPN=$P(PSD1(PSD1),",",PSDCNT),PSDCNT=PSDCNT+1 I PSDPN="" S PSDCNT=1 Q
 F PSDJ=0:0 S PSDJ=$O(^PSD(58.81,"D",PSDPN,PSDJ)) Q:'PSDJ  D SET1
 G LOOP
 Q
PRINT1 ;prints labels
 W ! F PSDX1=0:1:PSDCNT-1 W ?PSDX1*33+1,$E(TEMP(PSDX1+1),1,30)
 I $D(PSDPRT) W !! F PSDX1=1:1:PSDCNT W @PSDBAR1,$P(TEST(PSDX1)," "),@PSDBAR0
 W ! F PSDX1=0:1:PSDCNT-1 W ?PSDX1*32+3,TEST(PSDX1+1)
 W !!
 S PSDCNT=0,PSDX2=PSDX2+1 S:PSDX2=11 PSDX2=1
 Q
SET1 ;sets disp info
 Q:'$D(^PSD(58.81,+PSDJ,0))  Q:$P($G(^PSD(58.81,+PSDJ,"CS")),"^",5)  S NODE=^PSD(58.81,+PSDJ,0) Q:+$P(NODE,"^",3)'=+$G(PSDS)
 I ANS="N" Q:'$D(NAOU(+PSD))  S PSDPN=$P(NODE,"^",17) Q:PSDPN']""
 I ANS="R" S STAT=+$P(NODE,"^",11) Q:STAT'=3
 S NAOU=+$P(NODE,"^",18) Q:'NAOU  S NAOUN=$P($G(^PSD(58.8,+NAOU,0)),"^")
 S PSDR=+$P(NODE,"^",5) Q:'PSDR
 S PSDA=+$P(NODE,"^",20) Q:'PSDA
 S PSDN=$P($G(^PSDRUG(+PSDR,0)),"^")
 S TEXT(PSDR)=PSDN_"^"_NAOUN
SET ;sets ^tmp
 S ^TMP("PSDLBL",$J,PSDPN)=PSDPN_"^"_$P(TEXT(PSDR),"^")_"^"_$E($P(TEXT(PSDR),"^",2),1,12)
DIE ;update label printed
 Q:'PSDJ
 K DA,DIE,DR S DA=+PSDJ,DIE=58.81,DR="104////"_PSDT D ^DIE K DA,DIE,DR
 Q
