SDWLR31 ;BPOI/TEH - WAIT LIST REPORT 30/120 (PCMM) PRINT;06/12/2002
        ;;5.3;scheduling;**524**;AUG 13 1993;Build 29
        ;
        ;
        ;
        ;
        ;
        Q
EN      ;ENTRY POINT
        Q:'$D(^TMP("SDWLR30"))  K ^TMP("SDWLR31",$J)
        S SDWLJOB=$G(^TMP("SDWLR30","JOB")) Q:SDWLJOB=""
        I '$D(^TMP("SDWLR30",SDWLJOB)) Q
        S %H=+$H D YMD^%DTC S SDWLDT=X
        D SORT
        D PRINT
        K SDWLJOB,SDWLDT,SDWLINS,SDWLDATE,SDWLOPEN,X,S1,S2,S3,S1T,S2T,S3T,SDWLDA
        K SDWLTY,SDWLTYP,SDWLFL,SDWLFLG
        Q
SORT    S (SDWLINS,SDWLDATE,SDWLOPEN)="" F X="INS","DATE","OPEN" I $D(^TMP("SDWLR30",SDWLJOB,X)) D
        . S @("SDWL"_X)=$G(^TMP("SDWLR30",SDWLJOB,X))
A0      I '$D(SDWLINS) Q
A1      I '$D(SDWLDATE) Q
A2      I '$D(SDWLOPEN) Q
        I SDWLDATE'="ALL" S SDWLDATB=$P(SDWLDATE,U),SDWLDATE=$P(SDWLDATE,U,2)
A3      S SDWLDA=0 F  S SDWLDA=$O(^SDWL(409.3,SDWLDA)) Q:SDWLDA<1  D
        . S SDWLX=$G(^SDWL(409.3,SDWLDA,0))
        . S SDWLIN=+$P(SDWLX,U,3) I SDWLINS'="ALL",SDWLINS'[SDWLIN Q
        . S SDWLTY=+$P(SDWLX,U,5)
        . S SDWLTYP=+$S(SDWLTY=1:$P(SDWLX,U,6),SDWLTY=2:$P(SDWLX,U,7),SDWLTY=3:$P(SDWLX,U,8),SDWLTY=4:$P(SDWLX,U,9),1:0)
        . S SDWLSTAT=$P(SDWLX,U,17)
        . S SDWLORDT=$P(SDWLX,U,2)
        . S SDWLDTQ=0 I $D(SDWLDATB) D
        . . I SDWLORDT<SDWLDATB S SDWLDTQ=1 Q
        . . I SDWLORDT>SDWLDATE S SDWLDTQ=1 Q
        . I SDWLDTQ Q
        . S SDWLFLG="O" I SDWLOPEN[SDWLSTAT,SDWLSTAT="C" D
        . . S SDWLFLG="C-ND" I $G(^SDWL(409.3,SDWLDA,"DIS")) S SDWLFLG="C",SDWLORDT=$P(^SDWL(409.3,SDWLDA,"DIS"),U)
        . S SDWLFLG=$S(SDWLFLG="O":1,SDWLFLG="C":2,1:3)
        . S X1=SDWLDT,X2=SDWLORDT D ^%DTC S SDWLAPD=X
        . I SDWLAPD<30 S SDWLFL=1
        . I SDWLAPD>29&(SDWLAPD<120) S SDWLFL=2
        . I SDWLAPD>120 S SDWLFL=3
        . S SDWLCNT=0 I $D(^TMP("SDWLR31",$J,SDWLIN,SDWLFLG,SDWLFL,SDWLTY,SDWLTYP)) S SDWLCNT=^(SDWLTYP)
        . S SDWLCNT=SDWLCNT+1 S ^TMP("SDWLR31",$J,SDWLIN,SDWLFLG,SDWLFL,SDWLTY,SDWLTYP)=SDWLCNT
        . ;S ^TMP("SDWLR31",$J,"B",SDWLDA,SDWLFL,SDWLTY,SDWLTYP,SDWLFLG)=""
        Q
PRINT   ;PRINT REPORT
        D HD
        S (SDWLIN,SDWLTY,SDWLTYP,SDWLFL)=0,(S1,S2,S3)=0
B0      F  S SDWLIN=$O(^TMP("SDWLR31",$J,SDWLIN)) Q:SDWLIN<1  D
        .S (S1,S2,S3,S1T,S2T,S3T)=0
        .S SDWLINX=$$GET1^DIQ(4,SDWLIN_",",.01) W !,$E(SDWLINX,1,20)," (",SDWLIN,")"
        .S SDWLFLG=0
        .F  S SDWLFLG=$O(^TMP("SDWLR31",$J,SDWLIN,SDWLFLG)) Q:SDWLFLG<1  D  D S2
        ..W ?22,$S(SDWLFLG=1:"(OPEN RECORDS)",SDWLFLG=2:"(CLOSED RECORDS)",SDWLFLG=3:"(CLOSED - WITH NO DISPOSITION RECORDED)",1:"UNKNOWN"),!!
        ..S SDWLFL=0
        ..F  S SDWLFL=$O(^TMP("SDWLR31",$J,SDWLIN,SDWLFLG,SDWLFL)) Q:SDWLFL<1  D
        ...S SDWLTY=0
        ...F  S SDWLTY=$O(^TMP("SDWLR31",$J,SDWLIN,SDWLFLG,SDWLFL,SDWLTY)) Q:SDWLTY<1  D  D S1
        ....S SDWLTYX=$$EXTERNAL^DILFD(409.3,4,,SDWLTY) W ?22,$E(SDWLTYX,1,15)
        ....S SDWLTYP=0
        ....F  S SDWLTYP=$O(^TMP("SDWLR31",$J,SDWLIN,SDWLFLG,SDWLFL,SDWLTY,SDWLTYP)) Q:SDWLTYP<1  D
        .....S SDWLF=$S(SDWLTY=1:404.51,SDWLTY=2:404.57,SDWLTY=3:409.31,SDWLTY=4:409.32,1:0) I 'SDWLF S SDWLTYN=""
        .....S SDWLTYN=$$GET1^DIQ(SDWLF,SDWLTYP_",",.01) W ?40,$E(SDWLTYN,1,12)
        .....S SDWLN=$G(^TMP("SDWLR31",$J,SDWLIN,SDWLFLG,SDWLFL,SDWLTY,SDWLTYP)) S @("S"_SDWLFL)=@("S"_SDWLFL)+SDWLN
        .....S @("S"_SDWLFL_"T")=@("S"_SDWLFL_"T")+SDWLN
        .....S TAB=$S(SDWLFL=1:55,SDWLFL=2:60,SDWLFL=3:65,1:65) D
        ......F SDX=1:1:3 D
        .......S TAB=$S(SDX=1:55,SDX=2:60,SDX=3:65,1:65) D
        ........W ?TAB I SDX=SDWLFL W $J(SDWLN,$S(SDWLFL<3:3,1:4))
        ........E  W ?TAB,$J(0,$S(SDX<3:3,1:4))
        ......W !
        Q
S1      W !,?55,"===",?60,"===",?65,"====",!,?40,"SUBTOTALS"
        W ?55,$J(S1,3),?60,$J(S2,3),?65,$J(S3,4) S (S1,S2,S3)=0 W !!
        Q
S2      W !,?55,"===",?60,"===",?65,"====",!,?43,"TOTALS"
        W ?55,$J(S1T,3),?60,$J(S2T,3),?65,$J(S3T,4),!!
        Q
HD      ;HEADER
        W:$D(IOF) @IOF W !!,?80-$L("EWL 30/60/120 DAY REPORT")\2,"EWL 30/60/120 DAY REPORT",!!
        W !,?5,"INSTITUTION",?25,"TYPE",?40,"LOCATION",?55,"<30",?60,">30",?65,">120"
        W !,?5,"===========",?25,"====",?40,"========",?55,"===",?60,"===",?65,"====",!
        Q
