PRCBP   ;WISC/CTB-PRINT OPTIONS FOR PRCB ;10/31/01 12:50pm
V       ;;5.1;IFCAP;**3,43,139**;Oct 20, 2000;Build 16
        ;Per VHA Directive 2004-038, this routine should not be modified.
SE      W !!,$C(7),"ENTRY TO THIS ROUTINE IS ONLY PERMITTED THROUGH THE APPROPRIATE",!,"MENU OR DRIVER" Q
OUT     K %,%Y,DIJ,DP,IOX,IOY,POP,PRCB,PRCF,PRC("CP"),X,Y,NOLCK Q
EN1     ;PRINT RANGE OF TRANSACTIONS
        S PRCF("X")="ABFS" D ^PRCFSITE G:'% OUT
R1      S C="R1",D=1 W !,"START WITH TRANSACTION NUMBER: 1// " R X:$S($D(DTIME):DTIME,1:300) S:X="" X=1 G:X["^" OUT G:X["?"!(X'?1.5N)!(+X'=X)!(X<1)!(X>PRCB("LAST")) Q1 S FR=X K X
R2      S C="R2",D=FR R !!,"GO TO TRANSACTION NUMBER: LAST// ",X:$S($D(DTIME):DTIME,1:300) S:X="" X=PRCB("LAST") G:X["^" OUT G:X["?"!(X'?1.4N)!(+X'=X)!(X<FR)!(X>PRCB("LAST")) Q1 S TO=X
        S X="0000"_FR,X=$E(X,$L(X)-4,$L(X)),FR=PRCF("SIFY")_"-"_X S X="0000"_TO,X=$E(X,$L(X)-4,$L(X)),TO=PRCF("SIFY")_"-"_X
        D ZIS G:POP OUT S FLDS=$S(IOM<81:"[PRCB TRANS RANGE DISPLAY]",1:"[PRCB TRANS RANGE LIST]")
        S DIC="^PRCF(421,",BY="[PRCB BY TRANSACTION NUMBER]",L=0 D EN1^DIP D H G OUT
Q1      W !!,$C(7),"ENTER A NUMBER BETWEEN ",D," AND ",PRCB("LAST"),".  ('^' TO EXIT)" G @(C)
        ;
EN2     ;PRINT SELECTED CONTROL POINTS
        ;Patch 3: This section no longer calls the PRCFQ. It calls %ZTLOAD.
        S NOTSK=0,NOLCK=0,EN2Q=0,EN2P=0,RECFLG=0
        K DIC("A") S PRCF("X")="ABFS" D ^PRCFSITE G:'% OUT
        S ^XTMP("PRCBP",$J)=""
        S DIC("A")="Select FUND CONTROL POINT: "
        F ZX=1:1 D  Q:$G(Y)<0!($G(Y)="")  Q:$G(OUT)=1
        .S DIC(0)="AEQZMN",DIC="^PRC(420,PRC(""SITE""),1,"
        .D ^DIC K DIC("A")
        .Q:Y<0
        .S CP=+Y
        .D EN23
        .I X=U K ^XTMP("PRCBP",$J) S OUT=1 Q
        .I RECFLG=0 D
        ..D EOP^PRC0A(.X,.Y,"No TXN for selected STATION, FISCAL, and Fund Control Point.","AO","")
        .S DIC("A")="ANOTHER FUND CONTROL POINT: "
        K ZX
        I $G(OUT)=1 K OUT G OUT
        I X=U K ^XTMP("PRCBP",$J) G CLNUP
        I '$O(^XTMP("PRCBP",$J,"AM",0)) G CLNUP
        K IO("Q"),IOP,ZTSK,%ZIS,IOC,ZTIO
        S %ZIS="NQ",%ZIS("B")="" D ^%ZIS I POP K ^XTMP("PRCBP",$J) G CLNUP
        I '$D(IO("Q")) S CP=9999 D EN23 S EN2P=1,EN2Q=0 G EN2P
        S EN2Q=1,EN2P=0
        S ZTDESC="PRINT SELECTED CONTROL POINTS",ZTRTN="EN2Q^PRCBP"
        S ZTSAVE("PRCF*")="",ZTSAVE("PRC*")=""
        D ^%ZTLOAD D ^%ZISC
        I '$D(ZTSK) S NOTSK=1 D ERRMSG G CLNUP
        W !,"  <Request Queued> Your Task number is: ",ZTSK,$C(7),!
        S TSKNUM=ZTSK,AQ=0,NOLCK=0
        S ^XTMP("PRCBP",TSKNUM)=""
        L +^XTMP("PRCBP",TSKNUM):5
        E  S NOLCK=1 D ERRMSG G CLNUP
        F LOOP=1:1 S AQ=$O(^XTMP("PRCBP",$J,"AM",1,AQ)) Q:AQ=""  D
        .S ^XTMP("PRCBP",TSKNUM,"AQ",1,AQ)=""
        S AQ=$O(^PRCF(421,"AC",PRCF("SIFY")_"-"_9999,AQ))
        S ^XTMP("PRCBP",TSKNUM,"AQ",1,AQ)=""
        K ^XTMP("PRCBP",$J)
        L -^XTMP("PRCBP",TSKNUM)
        G CLNUP
        ;
EN2Q    ;Queue the Print Task(s).
        ;
        D:$D(ZTQUEUED) KILL^%ZTLOAD
        I '$D(ZTSK) S NOTSK=1 D ERRMSG G CLNUP
        K TSKNUM S AQ=0,TSKNUM=ZTSK,NOTSK=0,NOLCK=0,EN2Q=1,EN2P=0
        G EN2P
        ;
ERRMSG  ;Write the error messages.
        ;
        N DTIME S DTIME=60
        I NOTSK=1 D
        .W !,"Could not get a Task Number. Enter RETURN or '^' to exit. "
        .R !,ANS:DTIME
        ;
CLNUP   ;Clean variables that no longer needed.
        ;
        D OUT
        K TSKNUM,PRC,IOP,%ZIS,IOC,ZTIO,IO("Q"),ION,IOP,RECFLG,NOTSK
        K AQ,LOOP,DIC,L,BY,FLDS,CP,ANS,I,N,EN2P,EN2Q,NOLCK,AM
        K ZTDESC,ZTQUEUED,ZTRTN,ZTSAVE("PRC*"),ZTSAVE("PRCF*")
        Q
        ;
EN2P    ;Print the Task(s).
        ;
        D:$D(ZTQUEUED) KILL^%ZTLOAD
        S AM=0,AQ=0
        S FLDS=$S(IOM<81:"[PRCB FCP DISPLAY]",1:"[PRCB FCP LIST]")
        S DIC="^PRCF(421,",BY="[PRCB BY SEARCH/FCP/TRANS]"
        S L=0,IOP=ION
        I EN2P  D
        .F LOOP=1:1 S AM=$O(^XTMP("PRCBP",$J,"AM",1,AM)) Q:AM=""  D
        ..S ^PRCF(421,"AM",1,AM)=""
        .K ^XTMP("PRCBP",$J)
        I EN2Q  D
        .F LOOP=1:1 S AQ=$O(^XTMP("PRCBP",TSKNUM,"AQ",1,AQ)) Q:AQ=""  D
        ..S ^PRCF(421,"AM",1,AQ)=""
        .K ^XTMP("PRCBP",TSKNUM)
        D EN1^DIP
        K ^PRCF(421,"AM")
        G CLNUP
        ;
EN23    ;Setup the temp file with selected records (FCP).
        ;
        S N=0,RECFLG=0
        F I=1:1 S N=$O(^PRCF(421,"AC",PRCF("SIFY")_"-"_CP,N)) Q:N=""  D
        .S RECFLG=1
        .S ^XTMP("PRCBP",$J,"AM",1,N)=""
        .S $P(^PRCF(421,N,2),"^",14)=1
        .W:CP'=9999 "."
        Q
EN3     ;PRINT BY TDA NUMBER
        S PRCF("X")="ABFS" D ^PRCFSITE G:'% OUT
        S FR=$O(^PRCF(421,"B",PRCF("SIFY")_"-00000")) I FR="" W !,"NO TRANSACTIONS IN FY ",PRC("FY") R X:2 G OUT
Q31     D DD^PRC0A(.X,.Y,"Beginning TDA Number","421,3O",1)
        G EN3:Y=""!(Y["^")
        S PRCA=Y
Q32     D DD^PRC0A(.X,.Y,"Ending TDA Number","421,3O",9999)
        G EN3:Y["^",Q31:Y=""
        I PRCA]Y D EN^DDIOL("Beginning/Ending TDA numbers are not in order") G Q32
        S PRCB=Y
        S FR=PRCF("SIFY")_","_PRCA,TO=PRCF("SIFY")_","_PRCB
        S ZTDESC="PRINT TDA LISTING",ZTRTN="EN1Q^PRCBP",ZTSAVE("PRC*")="",ZTSAVE("PRCF*")="",ZTSAVE("FR")="",ZTSAVE("TO")="" D ^PRCFQ,H,OUT Q
EN1Q    S IOP=ION,FLDS=$S(IOM<81:"[PRCB TDA DISPLAY]",1:"[PRCB TDA LIST]")
        ;S DIC="^PRCF(421,",BY="[PRCB BY TRANS/TDA]",L=0 D EN1^DIP,H,OUT
        S DIC="^PRCF(421,",BY="]@.5,3",L=0 D EN1^DIP,H,OUT
        Q
EN4     ;FTEE SUMMARY BY PROGRAM
        S PRCF("X")="ABFS" D ^PRCFSITE G:'% OUT S L=0,DIC="^PRCF(421,",BY="[PRCB BY APPROP/TDA]",FR=PRCF("SIFY"),TO=PRCF("SIFY")_"Z",FLDS="[PRCB FTEE SUMMARY]" D EN1^DIP,OUT Q
EN5     ;APPROPRIATION SUMMARY (DETAIL)
        S PRCF("X")="ABFS" D ^PRCFSITE G:'% OUT
        S ZTDESC="APPROPRIATION SUMMARY (DETAIL)",ZTRTN="EN5Q^PRCBP",ZTSAVE("PRC*")="",ZTSAVE("PRCF*")="" D ^PRCFQ,OUT Q
EN5Q    S FLDS=$S(IOM<81:"[PRCB DISPLAY APP SUM DETAIL]",1:"[PRCB APPROP SUM  DETAIL]")
        S IOP=ION,L=0,DIC="^PRCF(421,",BY="[PRCB BY APP/FCP]",FR=PRCF("SIFY"),TO=PRCF("SIFY") D EN1^DIP,OUT Q
EN6     ;APPROPTIATION SUMMARY (TOTALS)
        S PRCF("X")="ABFS" D ^PRCFSITE G:'% OUT
        S ZTDESC="APPROPRIATION SUMMARY (TOTALS)",ZTRTN="EN6Q^PRCBP",ZTSAVE("PRC*")="",ZTSAVE("PRCF*")="" D ^PRCFQ,OUT Q
EN6Q    S IOP=PRIOP,L=0,DIC="^PRCF(421,",BY="[PRCB BY APP/FCP]",FR=PRCF("SIFY"),TO=PRCF("SIFY"),FLDS="[PRCB APPROP SUM  TOTAL]" D EN1^DIP,OUT Q
H       I $D(IO(0)),IO=IO(0),$D(IOST),IOST["C-" W !,"PRESS RETURN TO CONTINUE",$C(7) R X:$S($D(DTIME):DTIME,1:300)
        Q
ZIS     K DQTIME,IOP S %ZIS="QN" D ^%ZIS Q:POP  S IOP=ION I IO'=IO(0) S %ZIS="Q",IOP="Q;"_ION
