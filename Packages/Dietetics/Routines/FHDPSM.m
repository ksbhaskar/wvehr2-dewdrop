FHDPSM  ;Hines OIFO/RTK/FAI SPECIAL MEALS DISPLAY  ;10/20/04  14:22
        ;;5.5;DIETETICS;**19**;Jan 28, 2005;Build 2
        ;
LIST    ;
        K FHLIST S FHS="ACDP",NUM=0,EX="" D HDR
        F FHSMDT=STDT:0 S FHSMDT=$O(^FHPT(FHDFN,"SM",FHSMDT)) Q:FHSMDT'>0!(FHSMDT<STDT)!(FHSMDT>ENDT)!(EX=U)  D
        .S FHNODE=$G(^FHPT(FHDFN,"SM",FHSMDT,0)),FHSTAT=$P(FHNODE,U,2)
        .I FHS'[FHSTAT Q
        .S FHSTAT=$S(FHSTAT="P":"PENDING",FHSTAT="A":"AUTHORIZED",FHSTAT="D":"DENIED",1:"CANCELLED")
        .S NUM=NUM+1,PAD=$S($L(NUM)=1:" ",1:"") W !,PAD,NUM
        .D PATNAME^FHOMUTL
        .S FHD=$$FMTE^XLFDT(FHSMDT,"P") W ?8,$E(FHD,1,12)
        .S FHLPT=$P($G(FHNODE),U,3),FHLOC=$S(FHLPT="":"",1:$E($P($G(^FH(119.6,FHLPT,0)),U,1),1,10))
        .W ?26,FHLOC
        .S FHDPT=$P(FHNODE,U,4),FHDIET=$S(FHDPT="":"",1:$E($P($G(^FH(111,FHDPT,0)),U,1),1,12))
        .W ?40,FHDIET
        .S FHMEAL=$P(FHNODE,U,9) W ?57,FHMEAL,?65,FHSTAT
        .S FHLIST(NUM)=FHDFN_"^"_FHSMDT
        .I $E(FHSTAT,1)="D" D
        ..S FHDENY=$P(FHNODE,U,6)
        ..I FHDENY'="" W !,?6,"Denied By: ",$P($G(^VA(200,FHDENY,0)),U,1)
        .S FHCOMM=$P(FHNODE,U,8) I FHCOMM'="" W !?6,"Comment: ",FHCOMM
        .I $D(^FHPT(FHDFN,"SM",FHSMDT,1)) D
        ..S FHEL=$G(^FHPT(FHDFN,"SM",FHSMDT,1))
        ..W !?6,"Early/Late Tray Time: ",$P(FHEL,U,1)
        ..W "  Bagged Meal: ",$P(FHEL,U,2)
        ..Q
        .I $Y>(IOSL-4) D PG I EX=U Q
        .Q
        I NUM=0 W !!,"NO SPECIAL MEALS FOR THIS DATE RANGE" Q
        Q
PG      ;
        Q:$O(^FHPT(FHDFN,"SM",FHSMDT))'>0
        I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR I 'Y S EX=U Q
        D HDR Q
HDR     ;
        W:$Y @IOF
        W !?15,"S P E C I A L    M E A L S "
        W !!!?1,"#",?8,"Date/Time",?26,"Location",?40,"Diet Ordered",?57,"Meal",?65,"Status"
        W !,"===",?7,"============",?25,"==========",?39,"============",?56,"====",?65,"========="
        Q
END     ;
        K EX,FHNODE,FHSTAT Q
