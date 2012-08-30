FHOMSS2 ;Hines OIFO/RTK SPECIAL MEALS STATUS LIST  ;2/07/06  10:05
        ;;5.5;DIETETICS;**5,19**;Jan 28, 2005;Build 2
        ;
        W @IOF,!!?20,"S P E C I A L   M E A L S   S T A T U S   L I S T"
START   S (FHSELOC,FHSLCOM,FHSLPRO)=""
        W !! K DIR S DIR("A")="Print by LOCATION, COMM OFFICE, PRODUCTION FACILITY or ALL: "
        S DIR(0)="SAO^A:ALL;C:COMM OFFICE;L:LOCATION;P:PROD FACILITY" D ^DIR
        Q:$D(DIRUT)  S FHLBY=Y
        I FHLBY="L" W ! D OUTLOC^FHOMUTL Q:FHLOC=""  S FHSELOC=FHLOC,FHLOC=""
        I FHLBY="C" D  Q:FHSLCOM=""
        .W ! K DIC S DIC=119.73,DIC("A")="Select Communication Office: "
        .S DIC(0)="AEQZ" D ^DIC Q:$D(DUOUT)  I Y=-1 S FHSLCOM="" Q
        .S FHSLCOM=+Y
        I FHLBY="P" D  Q:FHSLPRO=""
        .W ! K DIC S DIC=119.71,DIC("A")="Select Production Facility: "
        .S DIC(0)="AEQZ" D ^DIC Q:$D(DUOUT)  I Y=-1 S FHSLPRO="" Q
        .S FHSLPRO=+Y
        W ! D STDATE^FHOMUTL I STDT="" Q
        W ! D ENDATE^FHOMUTL I ENDT="" Q
        D DEV,START Q
DEV     ;get device and set up queue
        W ! K %ZIS,IOP S %ZIS="Q" D ^%ZIS Q:POP
        I '$D(IO("Q")) U IO D LIST,^%ZISC,END Q
        S ZTSAVE("STDT")="",ZTSAVE("ENDT")="",ZTSAVE("FHLBY")=""
        S ZTSAVE("FHSELOC")="",ZTSAVE("FHSLCOM")="",ZTSAVE("FHSLPRO")=""
        S ZTRTN="LIST^FHOMSS2",ZTDESC="Special Meals Display" D ^%ZTLOAD
        D ^%ZISC K %ZIS,IOP
        D END Q
LIST    ; First build data in ^TMP global
        K ^TMP($J) S NUM=0,EX="",FHPG=0,ENDT=ENDT_.99
        F FHSMDT=STDT:0 S FHSMDT=$O(^FHPT("SM",FHSMDT)) Q:FHSMDT'>0!(FHSMDT>ENDT)!(EX=U)  D
        .S FHSMDTX=$E(FHSMDT,1,7)
        .S FHDFN=$O(^FHPT("SM",FHSMDT,"")) D PATNAME^FHOMUTL
        .S FHNODE=$G(^FHPT(FHDFN,"SM",FHSMDT,0)),FHSTAT=$P(FHNODE,U,2)
        .I FHSTAT="C" Q
        .S FHLOC=$P(FHNODE,U,3) Q:FHLOC=""  I FHLBY="L",FHSELOC'=FHLOC Q
        .S FHCOMM=$P($G(^FH(119.6,FHLOC,0)),U,8) I FHLBY="C",FHSLCOM'=FHCOMM Q
        .S FHPRD=$P($G(^FH(119.73,FHCOMM,0)),U,4) I FHLBY="P",FHSLPRO'=FHPRD Q
        .S FHPRORD=$P($G(^FH(119.6,FHLOC,0)),U,4) I FHPRORD="" S FHPRORD=99
        .S FHPRORD=$S(FHPRORD<1:99,FHPRORD<10:"0"_FHPRORD,1:FHPRORD)
        .S FHLOCNM=$P($G(^FH(119.6,FHLOC,0)),U,1),FHML=$P(FHNODE,U,9)
        .S FHML=$S(FHML="B":1,FHML="N":2,FHML="E":3,1:4)
        .S ^TMP($J,FHPRORD_"~"_FHLOCNM,FHSMDTX_"."_FHML,FHPTNM_"~"_FHDFN)=FHNODE
        .Q
        ; Now display data from the ^TMP global
        I '$D(^TMP($J)) W !!,"NO SPECIAL MEALS TO PRINT FOR GIVEN DATE RANGE" Q
        S FHLSRT="" F  S FHLSRT=$O(^TMP($J,FHLSRT)) Q:FHLSRT=""!(EX=U)  D
        .D:FHPG>0&(IOST?1"C".E) PG Q:EX=U
        .D HDR S FHPG=FHPG+1
        .F FHSMDT=0:0 S FHSMDT=$O(^TMP($J,FHLSRT,FHSMDT)) Q:FHSMDT'>0!(EX=U)  D
        ..S FHPTN="" F  S FHPTN=$O(^TMP($J,FHLSRT,FHSMDT,FHPTN)) Q:FHPTN=""!(EX=U)  D
        ...S FHNODE=$G(^TMP($J,FHLSRT,FHSMDT,FHPTN)),FHLOC=$P(FHNODE,U,3)
        ...S FHLOCZN=$G(^FH(119.6,FHLOC,0)),FHDFN=$P(FHPTN,"~",2)
        ...S FHSTAT=$P(FHNODE,U,2),FHSTAT=$S(FHSTAT="P":"PENDING",FHSTAT="A":"AUTH",FHSTAT="D":"DENIED",1:"CANCEL")
        ...S NUM=NUM+1 D PATNAME^FHOMUTL W !,$E(FHPTNM,1,20)
        ...S FHSMDTX=$P(FHNODE,U,1)
        ...S FHD=$$FMTE^XLFDT(FHSMDTX,"P") W ?22,$E(FHD,1,12)
        ...S FHLPT=$P(FHNODE,U,3),FHLOC=$E($P($G(^FH(119.6,FHLPT,0)),U,1),1,10)
        ...S FHRMBD=$P(FHNODE,U,13),FHRMBNM=""
        ...I FHRMBD'="" S FHRMBNM=$E($P($G(^DG(405.4,FHRMBD,0)),U,1),1,14)
        ...W ?36,FHRMBNM
        ...S FHDPT=$P(FHNODE,U,4),FHDIET=$S(FHDPT="":"",1:$E($P($G(^FH(111,FHDPT,0)),U,1),1,15))
        ...W ?52,FHDIET
        ...S FHMEAL=$P(FHNODE,U,9) W ?69,FHMEAL,?73,FHSTAT
        ...I $E(FHSTAT,1)="D" D
        ....S FHDENY=$P(FHNODE,U,6) W !?6,"Denied by: "
        ....I FHDENY'="" W $P($G(^VA(200,FHDENY,0)),U,1)
        ...S FHCMNT=$P(FHNODE,U,8) I FHCMNT'="" W !?6,"Comment: ",FHCMNT
        ...I $D(^FHPT(FHDFN,"SM",FHSMDTX,1)) D
        ....S FHEL=$G(^FHPT(FHDFN,"SM",FHSMDTX,1))
        ....W !?6,"Early/Late Tray Time: ",$P(FHEL,U,1)
        ....W "  Bagged Meal: ",$P(FHEL,U,2)
        ....Q
        ...Q
        ..Q
        .I $Y>(IOSL-4) D PG I EX=U Q
        .Q
        Q
PG      ;
        I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR I 'Y S EX=U Q
        D HDR Q
HDR     ;
        W:$Y @IOF
        W !?5,"S P E C I A L    M E A L S    S T A T U S    R E P O R T"
        W !!?5,"LOCATION: ",$P(FHLSRT,"~",2)
        W !!!,"Patient Name",?22,"Date",?36,"Room-Bed"
        W ?52,"Diet Ordered",?68,"Meal",?73,"Status"
        W !,"====================",?22,"============",?36,"=============="
        W ?52,"===============",?68,"====",?73,"======="
        Q
END     ;
        K STDT,ENDT,EX,FHNODE,FHSELOC,FHSLCOM,FHSLPRO,FHPRD,FHSTAT Q
