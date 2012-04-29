PXQDVST ;ISL/JVS - DISPLAY ENCOUNTERS-NORMAL ;8/29/96  10:30
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**4**;Aug 12, 1996
 ;
EN0 ;---Main entry point
 ;
 ;
 D DVST4("BEGIN")
 W IOINORM
 Q
 ;
 ;
DVST4(SIGN) ;--Display the ENCOUNTERS
 ;
 ;SIGN=
 ; '+' add 10 to the starting point in ^TMP("PXBDVST",$J)
 ; '-' subtract 10 from the starting point but not less that 0
 ; 'BEGIN' start at the beginning
 ; 'SAME' start stays where it's at
 ; '3'--any number set start to that number
 ;
 N PXBSTART
 I SIGN="BEGIN" S ^TMP("PXBDVST",$J,"START")=0,PXBSTART=0
 I SIGN="SAME" S PXBSTART=^TMP("PXBDVST",$J,"START")
 I SIGN="+" S PXBSTART=($G(^TMP("PXBDVST",$J,"START"))+(10)) S:PXBSTART'<PXBCNT PXBSTART=(PXBCNT-(10)) S ^TMP("PXBDVST",$J,"START")=PXBSTART
 I SIGN="-" S PXBSTART=$G(^TMP("PXBDVST",$J,"START"))-10,^TMP("PXBDVST",$J,"START")=PXBSTART I PXBSTART<0 S PXBSTART=0 S ^TMP("PXBDVST",$J,"START")=0
 I +SIGN>0&(SIGN#10) S PXBSTART=$P((SIGN/10),".")*10 S:PXBSTART<10 PXBSTART=0  Q:^TMP("PXBDVST",$J,"START")=PXBSTART  S ^TMP("PXBDVST",$J,"START")=PXBSTART
 I +SIGN>0&'(SIGN#10) S PXBSTART=(($P((SIGN/10),".")*10)-10) S:PXBSTART<10 PXBSTART=0 Q:^TMP("PXBDVST",$J,"START")=PXBSTART  S ^TMP("PXBDVST",$J,"START")=PXBSTART
 ;
 ;
 I SIGN'="BEGIN" D LOC^PXBCC(3,0) W IOEDEOP
HEAD4 ;--HEADER ON LIST
 S HEAD="- - "_$G(PXBCNT)_"  E N C O U N T E R S - -"
 W IOINHI,!,IOCUU,?(IOM-$L(HEAD))\2,HEAD ;--F  W $C(32) Q:$X=(IOM-(4))
 W IOINLOW,IOELEOL K HEAD
 ;
 ;
 N ENTRY,J
 D UNDON^PXBCC
 I '$G(COSTATUS) W !,"No.",?4,"DATE           TIME",?29,"HOSPITAL LOCATION",?51,"CATEGORY",?63,"UNIQUE I D"
 E  W !,"No.",?4,"DATE           TIME",?29,"HOSPITAL LOCATION",?51,"CATEGORY",?63,"C/O STATUS"
 W IOEDEOP
 D UNDOFF^PXBCC
 I '$D(^TMP("PXBSAM",$J)) D NONE^PXBUTL(6)
 ;
 S J=PXBSTART F  S J=$O(^TMP("PXBSAM",$J,J)) Q:J=""  Q:J=(PXBSTART+(11))  D
 .S ENTRY=$G(^TMP("PXBSAM",$J,J)),PXBHIGH=$S($G(PXBHIGH)>J:$G(PXBHIGH),$G(PXBHIGH)<J:J,1:$G(PXBHIGH))
 .I $G(COSTATUS) W !,J,?4,$P(ENTRY,"^",1),?29,$E($P(ENTRY,"^",3),1,19),?51,$E($P(ENTRY,"^",5),1,10),?63,$E($P(ENTRY,"^",8),1,17)
 .E  W !,J,?4,$P(ENTRY,"^",1),?29,$E($P(ENTRY,"^",3),1,19),?51,$E($P(ENTRY,"^",5),1,14),?67,$E($P(ENTRY,"^",7),1,13)
 I J="",$G(PXBCNT)'<1 D HELP1^PXBUTL1("LST")
 I SIGN'="BEGIN" W !!
 Q
 ;
