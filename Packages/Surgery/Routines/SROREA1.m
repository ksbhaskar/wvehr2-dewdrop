SROREA1 ;B'HAM ISC/MAM - DELAY REASONS, ONE SPECIALTY ; [ 04/04/00  11:54 AM ]
 ;;3.0; Surgery ;**94**;24 Jun 93
 S SRSSNM=$P(^SRO(137.45,SRSS,0),"^"),(PAGE,SRSOUT,SRHDR)=0 K ^TMP("SR",$J),^TMP("SRT",$J) S ^TMP("SR",$J)=0,^TMP("SRT",$J)=0 D HDR Q:SRSOUT
 S SRSDATE=SRSD-.0001,SREDT=SRED+.9999
 F  S SRSDATE=$O(^SRF("AC",SRSDATE)) Q:'SRSDATE!(SRSDATE>SREDT)  S SRTN=0 F  S SRTN=$O(^SRF("AC",SRSDATE,SRTN)) Q:'SRTN  I $D(^SRF(SRTN,0)),$$MANDIV^SROUTL0(SRINSTP,SRTN) D UTIL
 S CAUSE=0 F  S CAUSE=$O(^TMP("SR",$J,CAUSE)) Q:'CAUSE!(SRSOUT)  D CAUSE
 Q:SRSOUT
 W !!,?3,"TOTAL DELAYS FOR "_SRSSNM,?65,$J($P(^TMP("SR",$J),"^"),5),!
 Q
UTIL I '$D(^SRF(SRTN,.2)) Q
 I '$P(^SRF(SRTN,.2),"^",12) Q
 I '$O(^SRF(SRTN,17,0)) Q
 S Y=$P(^SRF(SRTN,0),"^",4) I Y'=SRSS Q
 S SRDC=0 F I=0:0 S SRDC=$O(^SRF(SRTN,17,SRDC)) Q:'SRDC  S CAUSE=$P(^SRF(SRTN,17,SRDC,0),"^"),SRDEL=$P(^(0),"^",2) D SETUT
 Q
SETUT ; set ^TMP
 I '$D(^TMP("SR",$J)) S ^TMP("SR",$J)=0
 I '$D(^TMP("SR",$J,CAUSE)) S ^TMP("SR",$J,CAUSE)=0
 S ^TMP("SR",$J)=^TMP("SR",$J)+1,^TMP("SR",$J,CAUSE)=^TMP("SR",$J,CAUSE)+1
 Q
CAUSE I $Y+4>IOSL D PAGE I SRSOUT Q
 S SRCAUS=$P(^SRO(132.4,CAUSE,0),"^") W !,SRCAUS,?65,$J($P(^TMP("SR",$J,CAUSE),"^"),5)
 Q
PAGE S X="" I $E(IOST)'="P" W !!,"Press RETURN to continue, or '^' to quit:  " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 I X["?" W !!,"Enter RETURN to continue printing this report, or '^' to exit from this option." G PAGE
HDR ; print heading
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 S X=$E(SRSD,4,5)_"/"_$E(SRSD,6,7)_"/"_$E(SRSD,2,3),Y=$E(SRED,4,5)_"/"_$E(SRED,6,7)_"/"_$E(SRED,2,3),PAGE=PAGE+1 I $Y W @IOF
 I $E(IOST)="P" W !,?(80-$L(SRINST)\2),SRINST,?70,"PAGE: "_PAGE,!,?32,"SURGICAL SERVICE"
 W !,?28,"REPORT OF DELAY REASONS",!,?27,"FROM "_X_"  TO "_Y,!,?(80-$L(SRSSNM)\2),SRSSNM
 I $E(IOST)="P" W !!,?21,"REVIEWED BY:",?45,"DATE REVIEWED:"
 W !! F LINE=1:1:80 W "="
 W ! I SRHDR D CAUSE
 S SRHDR=1
 Q
