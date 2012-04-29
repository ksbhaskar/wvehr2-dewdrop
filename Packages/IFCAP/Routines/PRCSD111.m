PRCSD111 ;WISC/SAW-CONTROL POINT ACTIVITY 1358 DISPLAY CON'T ;3-19-91/15:34
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 S Z=$S($D(PRCSPO):PRC("SITE")_"-"_PRCSPO,1:0)
 I 'Z!('$D(^PRC(424,"AC",Z))) W !,"Daily Record entries have not yet been entered for this request.",!,"The total committed cost of this request is $" W:$D(^PRCS(410,DA,4)) $J($P(^(4),U),0,2) W !,L G P
 D HDR1 S PRCSX=0 D OB S (ET,AT,UT,CT)="" D PO1 W !!,?7,"TOTALS",?26,"$",$J(ET,9,2),?38,$J(AT,9,2),?70,"$",$J((PRCSOT-UT),9,2) K PRCSX,PRCSOT,UT,CT,AT,ET,CAT,CET,PRCSR,PRCSX,PRCSXX,J,JJ D P Q
OB ;DISPLAY ONLY OBLIGATIONS
 I '$D(^PRC(424,"AC",Z)) G OB1
 S (PRCSOT,X1,UT)="" F I=1:1 S X1=$O(^PRC(424,"AF",Z,X1)) Q:X1'>0  I $D(^PRC(424,X1,0)) S Z1=$P(^(0),U,3,6),PRCSOT=PRCSOT+$P(^(0),U,5) X "I IOSL-$Y<5 D HOLD^PRCSD11 Q:Z3=U  D NEWP^PRCSD11,HDR1" D DR1
 W !,L Q:$D(PRCSX)
OB1 W !!,"The following 1358 obligation/adjustment request is ready for processing:"
 S X=$P(^PRCS(410,DA,0),U,1,2) W !,"TRANSACTION NUMBER: ",$P(X,U),?40,"TYPE: ",$S($P(X,U,2)="O":"OBLIGATION",1:"ADJUSTMENT"),?50,"AMOUNT: $",$J($P(^(4),U,8),0,2) W !,L G P
PO1 I $D(^PRCS(410,DA,10)) S PRCSY=$P(^(10),U,3) I PRCSY,$D(^PRC(442,PRCSY,0)) D PO11
 Q
PO11 K ^TMP("PRCSR",$J) D HDR F J=1:1 S PRCSX=$O(^PRC(424,"AD",PRCSY,PRCSX)) Q:PRCSX'>0  I $D(^PRC(424,PRCSX,0)),"SF"[$P(^(0),U,4) S Z1=$P(^(0),U,6,10) I Z1 S ^TMP("PRCSR",$J,$S($P(Z1,U,2)]"":$P(Z1,U,2),1:"NONE"),PRCSX)=Z1
 S PRCSXX="" F J=1:1 S PRCSXX=$O(^TMP("PRCSR",$J,PRCSXX)) Q:PRCSXX=""  D PO12
 K ^TMP("PRCSR",$J) Q
PO12 S (CAT,CET)="",PRCSX=0 F JJ=1:1 S PRCSX=$O(^TMP("PRCSR",$J,PRCSXX,PRCSX)) Q:PRCSX'>0  S Z1=^TMP("PRCSR",$J,PRCSXX,PRCSX),Y=$P(Z1,U) D T X "I IOSL-$Y<3 D HOLD^PRCSD11 Q:Z3=U  D NEWP^PRCSD11,HDR" D PO2
 S CT=$S(CAT:CT+CAT,1:CT+CET) W !?47,"$",$J(CT,9,2) K A,E,CAT,CET
 Q
PO2 W !,Y,?7,$P($P(^PRC(424,PRCSX,0),U),"-",3),?12,$P(Z1,U,2),?26,"$"
 S E=$P(Z1,U,5),A=$P(Z1,U,3),UT=UT+$P(Z1,U,4),AT=AT+A,ET=ET+E,CAT=CAT+A,CET=CET+E
 I '$D(Z1) S Z1=^TMP("PRCSR",$J,PRCSXX,PRCSX)
 ;the naked reference below refers to ^PRC(424,PRCSX,0)
 W $J(E,9,2),?38,$J(A,9,2),?59,"$",$J($P(Z1,U,4),9,2) I $D(PRCSA) W !,?15,$P(^(0),U,14)
 Q
P W:Z3'=U !!,"VA FORM 4-1358a-ADP (NOV 1987)",! Q
DR1 I '$D(Z1) S Z1=^TMP("PRCSR",$J,PRCSXX,PRCSX)
 ;the naked reference below refers to ^PRC(424,PRCSX,0)
 S Y=$P(Z1,U,4) D T W !,Y,?7,$P($P(^(0),U),"-",3),?13,$S($D(^PRCS(410,+$P(Z1,U,1),0)):$P(^(0),U,1),1:""),?36,"$",$J($P(Z1,U,3),9,2) W:$D(PRCSX) ?56,"$",$J(PRCSOT,9,2) Q
HDR W !,"AUTHORIZATION & ORDER RECORD",?59,"LIQUIDATION RECORD"
 W !,?28,"INDIVIDUAL/DAILY",!,"DATE",?7,"SEQ#",?14,"REFERENCE",?28,"ESTIMATED",?39,"ACTUAL",?47,"CUMULATIVE",?60,"LIQUID",?71,"UNLIQ BAL" W !,L Q
HDR1 W !,"ESTIMATED OBLIGATION RECAP",!,"DATE",?7,"REF#",?13,"CPA#",?37,"AMOUNT",?57,"BALANCE" Q
T S Y=$E(Y,4,5)_"/"_$E(Y,6,7) Q  ;_"/"_$E(Y,2,3)_$S(Y[".":"  "_$E($P(Y,".",2)_"0000",1,2)_":"_$E($P(Y,".",2)_"0000",3,4),1:"") Q
