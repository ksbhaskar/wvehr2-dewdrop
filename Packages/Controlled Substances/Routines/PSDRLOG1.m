PSDRLOG1 ;BIR/JPW-CS Inspector's Log By Date (cont'd) ; 24 Aug 94
 ;;3.0; CONTROLLED SUBSTANCES ;;13 Feb 97
START ;compile data
 K ^TMP("PSDRLOG",$J) S (FLAG,PSDCNT,PSDOUT)=0,PSDTR=""
 I $D(PSDG) F PSD=0:0 S PSD=$O(PSDG(PSD)) Q:'PSD  F PSDN=0:0 S PSDN=$O(^PSI(58.2,PSD,3,PSDN)) Q:'PSDN  I $D(^PSD(58.8,PSDN,0)),'$P(^(0),"^",7),$P(^(0),"^",3)=+PSDSITE S NAOU(PSDN)="",CNT=CNT+1
 I $D(ALL) F PSD=0:0 S PSD=$O(^PSD(58.8,PSD)) Q:'PSD  I $D(^PSD(58.8,PSD,0)),$P(^(0),"^",2)="N",$P(^(0),"^",3)=+PSDSITE,'$P(^(0),"^",7) S NAOU(+PSD)=""
 S PSD="" F  S PSD=$O(NAOU(PSD)) Q:PSD=""!(PSDOUT)  F PSDN=PSDSD:0 S PSDN=$O(^PSD(58.81,"AK",PSDN)) Q:'PSDN!(PSDOUT)  F PSDA=0:0 S PSDA=$O(^PSD(58.81,"AK",PSDN,PSD,PSDA)) Q:'PSDA!(PSDOUT)  D LOOP
 I $G(PSDRET) F PSDN=PSDRD:0 S PSDN=$O(^PSD(58.81,"ACT",PSDN)) Q:'PSDN!(PSDOUT)  F JJ=0:0 S JJ=$O(^PSD(58.81,"ACT",PSDN,JJ)) Q:'JJ!(PSDOUT)  D
 .F KK=0:0 S KK=$O(^PSD(58.81,"ACT",PSDN,JJ,KK)) Q:'KK!(PSDOUT)  F PSDA=0:0 S PSDA=$O(^PSD(58.81,"ACT",PSDN,JJ,KK,3,PSDA)) Q:'PSDA!(PSDOUT)  S FLAG=3 D LOOP
 F PSDN=PSDSD:0 S PSDN=$O(^PSD(58.81,"ATRN",PSDN)) Q:'PSDN!(PSDOUT)  F PSDA=0:0 S PSDA=$O(^PSD(58.81,"ATRN",PSDN,PSDA)) Q:'PSDA!(PSDOUT)  S FLAG=1 D LOOP
 G:$D(ZTQUEUED) PRTQUE
 I ASKN G PRINT^PSDRLOG3
 G PRINT^PSDRLOG2
 Q
PRTQUE ;queues print after compile
 K ZTSAVE,ZTIO S ZTIO=PSDIO,ZTRTN=$S(ASKN:"PRINT^PSDRLOG3",1:"PRINT^PSDRLOG2"),ZTDESC="Print Narcotic Inspector Log",ZTDTH=$H
 S (ZTSAVE("^TMP(""PSDRLOG"",$J,"),ZTSAVE("CNT"),ZTSAVE("ASK"),ZTSAVE("ASKN"),ZTSAVE("PSDRET"))=""
 D ^%ZTLOAD K ^TMP("PSDRLOG",$J),ZTSK
END K %,%H,%I,%ZIS,ALL,ASK,ASKN,CNT,DA,DIC,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,EXP,EXPD,FLAG,JJ,KK,LNUM,NAOU,NODE,NODE1,NODE3,NODE7,NUM
 K OK,PSD,PSDA,PSDATE,PSDCNT,PSDDT,PSDG,PSDIO,PSDOK,PSDOUT,PSDN,PSDNA,PSDR,PSDRD,PSDRET,PSDRN,PSDSD,PSDST,PSDTR,PSDTYP
 K QTY,SEL,STAT,TYP,TYPN,X,Y,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 K ^TMP("PSDRLOG",$J) D ^%ZISC
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
LOOP ;starts drug loop
 Q:'$D(^PSD(58.81,+PSDA,0))  S NODE=^PSD(58.81,PSDA,0)
 S PSDR=+$P(NODE,"^",5),STAT=+$P(NODE,"^",11),PSDTYP=+$P(NODE,"^",2)
 S NODE1=$G(^PSD(58.81,PSDA,1)),NODE7=$G(^PSD(58.81,PSDA,7)),NODE3=$G(^PSD(58.81,PSDA,3))
 S:PSDTYP=5 FLAG=2
 I FLAG S PSD=+$P(NODE,"^",18) Q:'$D(NAOU(+PSD))
 S:FLAG=1 PSDTR=+$P(NODE7,"^",3),PSDTR=$S($P($G(^PSD(58.8,PSDTR,0)),"^")]"":$P(^(0),"^"),1:"UNKNOWN")
 S PSDNA=$S($P($G(^PSD(58.8,+PSD,0)),"^")]"":$P(^(0),"^"),1:"ZZ/"_PSD)
 S PSDOK=$S(FLAG=3:"#",FLAG=2:"**",FLAG=1:"*",1:"")
 S PSDRN=$S($P($G(^PSDRUG(PSDR,0)),"^")]"":$P(^(0),"^"),1:"ZZ/"_PSDR)
 S QTY=$S(FLAG=3:+$P(NODE3,"^",2),FLAG=1:+$P(NODE7,"^",7),1:+$P(NODE1,"^",8))
 S NUM=$S($P(NODE,"^",17)]"":$P(NODE,"^",17),1:"UNKNOWN"),EXP=$P(NODE,"^",15),EXPD="" I EXP S Y=EXP X ^DD("DD") S EXPD=Y
 S Y=$E(PSDN,1,7) X ^DD("DD") S PSDDT=Y
 S PSDCNT=PSDCNT+1,FLAG=0
 I ASKN D LOOP0 Q
SET ;sets ^tmp
 S:ASK="D" ^TMP("PSDRLOG",$J,PSDNA,PSDRN,NUM,PSDCNT)=QTY_"^"_PSDDT_"^"_EXPD_"^"_PSDOK_"^"_PSDTR
 S:ASK="N" ^TMP("PSDRLOG",$J,PSDNA,NUM,PSDRN,PSDCNT)=QTY_"^"_PSDDT_"^"_EXPD_"^"_PSDOK_"^"_PSDTR
 Q
LOOP0 ;sets sort for inventory type sort
 I '$O(^PSD(58.8,PSD,1,PSDR,2,0)) S TYPN="ZZ** NO INVENTORY TYPE DATA **" D LOOP1 Q
 ;F NAOU=0:0 S NAOU=$O(NAOU(NAOU)) Q:'NAOU
 F TYP=0:0 S TYP=$O(^PSD(58.8,+PSD,1,PSDR,2,TYP)) Q:'TYP  S TYPN=$S($P($G(^PSI(58.16,+TYP,0)),"^")]"":$P(^(0),"^"),1:"TYPE NAME MISSING") D LOOP1
 Q
LOOP1 ;sets inv typ ^tmp
 ;S:ASK="D" ^TMP("PSDRLOG",$J,PSDNA,TYPN,PSDRN,NUM,PSDCNT)=QTY_"^"_PSDDT_"^"_EXPD_"^"_PSDOK_"^"_PSDTR
 S:'$G(TYP) TYP=999999
 D:ASK="D"
 .S ^TMP("PSDRLOG",$J,"B",PSDNA,PSD)="",^TMP("PSDLOG",$J,PSD,+TYP)=0
 .S ^TMP("PSDRLOG",$J,PSD,"B",TYPN,+TYP)=""
 .S ^TMP("PSDRLOG",$J,PSD,+TYP,PSDR,NUM,PSDCNT)=QTY_U_PSDDT_U_EXPD_U_PSDOK
 .S ^TMP("PSDRLOG",$J,PSD,+TYP,"B",PSDRN,PSDR)=""
 ;S:ASK="N" ^TMP("PSDRLOG",$J,PSDNA,TYPN,NUM,PSDRN,PSDCNT)=QTY_"^"_PSDDT_"^"_EXPD_"^"_PSDOK_"^"_PSDTR
 D:ASK="N"
 .S ^TMP("PSDRLOG",$J,"B",PSDNA,PSD)="",^TMP("PSDRLOG",$J,PSD,+TYP)=0
 .S ^TMP("PSDRLOG",$J,PSD,"B",TYPN,+TYP)=""
 .S ^TMP("PSDRLOG",$J,PSD,+TYP,NUM,PSDR,PSDCNT)=QTY_U_PSDDT_U_EXPD_U_PSDOK_U_PSDTR_U_PSDRN
 Q
