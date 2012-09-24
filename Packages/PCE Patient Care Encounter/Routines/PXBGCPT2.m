PXBGCPT2        ;ISL/JVS,ESW - DOUBLE ?? GATHERING OF CPT CODES ; 10/31/02 12:05pm
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**11,19,108,149,194**;Aug 12, 1996;Build 2
        ;
        ;
        ;
        W !,"NOT" Q
        ;
DOUBLE(FROM)    ;--Entry
        ;
        N FILE,FIELD,TITLE,HEADING,SUB,CODE,NAME,START,SCREEN,BACK,NUM
        N SCREEN,TEMP,FIRST
        S BACK="",NUM=0,SCREEN=""
        D LOC
        I $D(DIC("S")) S SCREEN=DIC("S")
        ;
START   ;
        ;
        S TITLE="- - A L L  P R O C E D U R E (CPT CODES) - -"
        ;
        D SETUP
        D LIST^DIC(FILE,"",FIELD,BACK,10,.START,"","",SCREEN,"","^TMP(""PXBTANA"",$J)","^TMP(""PXBTANA"",$J)")
        ;
        D LOC,HEAD,SUB
        ;
PROMPT  ;--PROMPT
        D WIN17^PXBCC(PXBCNT),LOC^PXBCC(15,1)
        W !!,"Enter '^' to quit,  '-' for previous page."
        S DIR("A")="Select a single 'ITEM NUMBER' or 'RETURN' to continue: "
        S DIR("?")="Enter ITEM 'No' to select , '^' to quit,  '-' for previous page."
        S DIR(0)="N,A,O^0:10:0^I X'?.1""-"".1""^"".2N!(+X>10) K X"
        D ^DIR
        I X="-" S BACK="B" D BACK G START
        I X="" S BACK="" D FORWARD G START
        I $G(DIRUT) K DIRUT S VAL="^C" G EXIT
FINISH  ;--FINISH
        ;
        S VAL=$G(^TMP("PXBTANA",$J,"DILIST",2,X))_U_$G(^TMP("PXBTANA",$J,"DILIST","ID",X,FIRST))_"--"_$G(^TMP("PXBTANA",$J,"DILIST","ID",X,SECOND))
EXIT    ;--EXIT
        K DIR,^TMP("PXBTANA",$J),^TMP("PXBTOTAL",$J)
        Q VAL
        ;
DOUBLE1(FROM)   ;--Entry
        ;
NEW     ;
        N FILE,FIELD,TITLE,HEADING,SUB,CODE,NAME,START,SCREEN,CNT,OK,INDEX,CYCLE
        N TOTAL,FIRST,SUB2
        ;---SETUP
        S BACK="",INDEX=""
        S START=DATA,SUB=0,SUB2=0
        ;
START1  ;--RECYCLE
        S TITLE="- - S E L E C T E D  P R O C E D U R E S (CPT CODES) - -"
        S FILE=81
        S FIELD=".01;2"
        N TMP,LL,TT
        S LL=$L(DATA),TT="0000"
        I DATA?1.4N!(DATA?1A.3N) D
        .S START=$O(^ICPT("B",DATA_$E(TT,1,5-LL)),-1)
        I DATA?5N!(DATA?1A4N)!(DATA?4N1A) D
        .S START=$O(^ICPT("B",START),-1)
XXX     W IOCUOFF,IOCUF,IOCUF
        N TMP
        S SUBT=START,TOTAL=0 F  S SUBT=$O(^ICPT("B",SUBT)) Q:SUBT'[DATA  D
        .I '$$CPTSCREN^PXBUTL($O(^ICPT("B",SUBT,0)),IDATE) Q
        .S TOTAL=TOTAL+1 S PXBMOD=TOTAL#100 D WAIT^PXBUTL
        .S ^TMP("PXBTOTAL",$J,"DILIST","ID",TOTAL,.01)=SUBT
        .S ^TMP("PXBTOTAL",$J,"DILIST","ID",TOTAL,2)=$P($$CPT^ICPTCOD($O(^ICPT("B",SUBT,0)),IDATE),U,3)
        .S TMP(SUBT)=""
        I DATA?1.4N!(DATA?.3N1A) D
        .S START=$O(^ICPT("B",$E(TT,1,5-LL)_DATA),-1)
        .S SUBT=START F  S SUBT=$O(^ICPT("B",SUBT)) Q:SUBT'[DATA  D
        ..Q:$D(TMP(SUBT))
        ..I '$$CPTSCREN^PXBUTL($O(^ICPT("B",SUBT,0)),IDATE) Q
        ..S TOTAL=TOTAL+1 S PXBMOD=TOTAL#100 D WAIT^PXBUTL
        ..S ^TMP("PXBTOTAL",$J,"DILIST","ID",TOTAL,.01)=SUBT
        ..S ^TMP("PXBTOTAL",$J,"DILIST","ID",TOTAL,2)=$P($$CPT^ICPTCOD($O(^ICPT("B",SUBT,0)),IDATE),U,3)
        W IOCUON
        ;
        ;
        ;
        I DATA?2.A W IOCUOFF,IOCUF,IOCUF D
        .N IEN,CODE,ARRAY,XX
        .D FIND^DIC(81,"","","M",DATA,"","","","","ARRAY")
        .I $D(ARRAY("DILIST"))<10 S Y=-1 Q
        .S I=0 F  S I=$O(ARRAY("DILIST",2,I)) Q:'I  D
        ..S MIEN=ARRAY("DILIST",2,I),XX=$$CPT^ICPTCOD(MIEN,IDATE)
        ..Q:'$P(XX,U,7)
        ..S TOTAL=TOTAL+1 S PXBMOD=TOTAL#100 D WAIT^PXBUTL
        ..S ^TMP("PXBTOTAL",$J,"DILIST","ID",TOTAL,.01)=$P(XX,U,2)
        ..S ^TMP("PXBTOTAL",$J,"DILIST","ID",TOTAL,2)=DATA_", "_$P(XX,U,3)
        W IOCUON
        K SUBT
        ;
        ;
        ;
        ;--NO MATCH
        I TOTAL=0 D
        .I DATA?1A W ! D HELP^PXBUTL0("CPT4")
        .I DATA'?1A W ! D HELP^PXBUTL0("CPTM")
        .S ERROR=1,CYCL=1
        I TOTAL=0 Q TOTAL
        ;
        ;--LIST
        S HEADING="W !,""ITEM"",?6,""CODE"",?15,""DESCRIPTION   "",IOINHI,TOTAL,"" MATCHES"",IOINLOW"
LIST    ;-DISPLAY LIST TO THE SCREEN
        I TOTAL=1 S X=1 G VAL
        D LOC W !
        X HEADING
        S SUB=SUB-1
        S NUM=0 F  S SUB=$O(^TMP("PXBTOTAL",$J,"DILIST","ID",SUB)) S NUM=NUM+1 Q:NUM=11  Q:SUB'>0  S SUB2=SUB2+1 D
        .S CODE=$G(^TMP("PXBTOTAL",$J,"DILIST","ID",SUB,.01))
        .S NAME=$E($G(^TMP("PXBTOTAL",$J,"DILIST","ID",SUB,2)),1,64)
        .W !,SUB,?6,CODE,?15,NAME
        ;
        ;--one
        I TOTAL=1 G PRMPT2
        ;
PRMPT   ;--PROMPT
        D WIN17^PXBCC(PXBCNT)
        D LOC^PXBCC(15,1)
        W !
        I SUB>0 W !,"Enter '^' to quit"
        E  I TOTAL>10 W !,"               END OF LIST"
        I SUB>0 S DIR("A")="Select a single 'ITEM NUMBER' or 'RETURN' to continue: "
        E  S DIR("A")="Select a single 'ITEM NUMBER' or 'RETURN' to exit: "
        S DIR("?")="Enter ITEM 'No' to select , '^' to quit"
        S DIR(0)="N,A,O^0:"_SUB2_":0^I X'?.1""^"".N K X"
        D ^DIR
        I X="",SUB>0 G LIST
        I X="",SUB'>0 S X="^"
VAL     ;--VAL equal value
        S VAL=$G(^TMP("PXBTOTAL",$J,"DILIST",2,X))_U_$G(^TMP("PXBTOTAL",$J,"DILIST","ID",X,.01))_"--"_$G(^TMP("PXBTOTAL",$J,"DILIST","ID",X,2))
EXITNEW ;--EXIT
        K DIR,DIRUT,^TMP("PXBTANA",$J),^TMP("PXBTOTAL",$J)
        K TANA,TOTAL
        Q VAL
        Q
        ;
        ;--SUBROUTINES
BACK    ;
        S START=$G(^TMP("PXBTANA",$J,"DILIST",1,1))
        S START("IEN")=$G(^TMP("PXBTANA",$J,"DILIST",2,1))
        Q
FORWARD ;
        S START=$G(^TMP("PXBTANA",$J,"DILIST",1,10))
        S START("IEN")=$G(^TMP("PXBTANA",$J,"DILIST",2,10))
        Q
LOC     ;--LOCATE CURSOR
        D LOC^PXBCC(3,1) ;--LOCATE THE CURSOR
        W IOEDEOP ;--CLEAR THE PAGE
        Q
HEAD    ;--HEAD
        W !,IOCUU,IOBON,"HELP SCREEN",IOSGR0,?(IOM-$L(TITLE))\2,IOINHI,TITLE,IOINLOW,IOELEOL
        Q
SUB     ;--LIST
        I $P(^TMP("PXBTANA",$J,"DILIST",0),U)=0 W !!,"     E N D  O F  L I S T" Q
        X HEADING
        S SUB=0,CNT=0 F  S SUB=$O(^TMP("PXBTANA",$J,"DILIST","ID",SUB)) Q:SUB'>0  S CNT=CNT+1 D
        .S CODE=$G(^TMP("PXBTANA",$J,"DILIST","ID",SUB,FIRST))
        .S NAME=$G(^TMP("PXBTANA",$J,"DILIST","ID",SUB,SECOND))
        .W !,SUB,?6,CODE,?15,NAME
        Q
SETUP   ;--SET
        S FILE=81,FIRST=.01,SECOND=2
        S FIELD=FIRST_";"_SECOND
        S HEADING="W !,""ITEM"",?6,""CODE"",?15,""DESCRIPTION"""
        Q
PRMPT2  ;--Yes and No prompt
        D WIN17^PXBCC(PXBCNT)
        D LOC^PXBCC(15,1)
        S DIR("A")="Is this the correct entry "
        S DIR("B")="YES"
        S DIR(0)="Y"
        D ^DIR
        I Y=0 S X="^"
        I Y=1 S X=1
        G VAL
        ;
