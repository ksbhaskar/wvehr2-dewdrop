XDRDCOMP        ;SF-IRMFO/IHS/OHPRD/JCM - COMPARE TWO PATIENTS VIA DUP CHECKER ;8/28/08  17:58
        ;;7.3;TOOLKIT;**23,113**;Apr 25, 1995;Build 5
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;;
        ; This routine will compare two records (patients), and will result with
        ; a score (0 - 100%) as to how they match up.  You can not compare the
        ; same record.
        ;
        ; *** NOTE *** As of patch XT*7.3*113, this routine is no longer
        ; available for use on the PATIENT file. *****
        ;
START   ;
        S XDRQFLG=0
        ; XT*7.3*113 - Input param to FILE^XDRDPICK makes PATIENT file unselectable.
        S XDRFL=$$FILE^XDRDPICK(1) Q:XDRFL'>0
        G:XDRQFLG END
        S XDRGL=^DIC(XDRFL,0,"GL")
        S XDRDTYPE="BASIC" ; ADDED 4/11/96  JLI
        D LKUP G:XDRQFLG END
        S %ZIS="Q" D ^%ZIS G:POP END
        S (IOP,XDRDCOMP("DEVICE"))=ION_";"_IOM_";"_IOSL
        I $D(IO("Q")) D  G:XDRQFLG END
        .S ZTRTN="DQ^XDRDCOMP",ZTIO=ION,ZTDESC=$P(^DIC(XDRFL,0),U)_" COMPARISON LIST"
        .F %="XDRCD","XDRCD2","XDRFL","XDRDTYPE","XDRGL","XDRD(","XDRDCOMP(" S ZTSAVE(%)=""
        .D ^%ZTLOAD W:$D(ZTSK) !,"Queued as task "_ZTSK,!
        .S XDRQFLG=1
DQ      ; Entry Point for Taskman
        U IO W @IOF
        D ^XDRDSCOR
        D ^XDRDUP ;S XDRD("NOADD")="" D ^XDRDUP
        D DITC
        D SCORE
        D ^%ZISC
END     D EOJ
        Q
        ;
LKUP    ;Look up both reocord.
        S DIC=XDRGL,DIC(0)="QEAM"
        S DIC("A")="COMPARE "_$P(^DIC(XDRFL,0),U)_": "
        D ^DIC ;W !,"X: ",X,"Y: ",Y
        I $D(DIRUT)!(Y=-1) K DIC,DA S XDRQFLG=1 G LKUPX
        S XDRCD=+Y S DIT(1)=+Y
LKUP2   S DIC("A")="    WITH "_$P(^DIC(XDRFL,0),U)_": "
        D ^DIC K DIC,DA
        G:$D(DIRUT)!(Y=-1) LKUP
        S XDRCD2=+Y S DIT(2)=+Y
        I XDRCD=XDRCD2 W *7,!!,"    CAN NOT COMPARE SAME PATIENT!!  ",!! G LKUP
LKUPX   Q
        ;
DITC    ;
        D SHOW^XDRDSHOW(XDRFL,XDRCD,XDRCD2)
        ;S DFF=XDRFL,DIC=XDRGL,DIT(1)=XDRCD,DIT(2)=XDRCD2,DDIF=2
        ;S IOP=XDRDCOMP("DEVICE")
        ;D EN^DITC K DIC,DFF,DIT,IOP,DDIF
        Q
SCORE   ;
        S:XDRDSCOR("MAX")>0 XDRD("DUPSCORE%")=XDRD("DUPSCORE")/XDRDSCOR("MAX")
        S:XDRDSCOR("MAX")=0 XDRD("DUPSCORE%")=0
        S XDRD("DUPSCORE%")=$J(XDRD("DUPSCORE%"),1,2)
        S XDRD("DUPSCORE%")=$S(XDRD("DUPSCORE%")<0:0,XDRD("DUPSCORE%")<1:$E(XDRD("DUPSCORE%"),3,4),1:100)
        ;S IOP=XDRDCOMP("DEVICE") D ^%ZIS U IO
        W !! F I=0:0 S I=$O(XDRDUP("TEST SCORE",I)) Q:I'>0  I +XDRDUP("TEST SCORE",I)'=0 S J=XDRDTEST(I) W !,$P(J,U),?25,"VALUE = ",$J(XDRDUP("TEST SCORE",I),3,0),"   MAX POSSIBLE = ",$J($P(J,U,6),3,0)
        W !!,?40,"DUPLICATE THRESHOLD % ",XDRDSCOR("PDT%")
        W !,?40,"DUPLICATE SCORE % ",$G(XDRD("DUPSCORE%")),!
        K %,XDRDCNT
        I '$D(ZTQUEUED),$E(IOST,1,2)'="P-" S DIR(0)="E" D ^DIR K DIR S:X=U XDRQFLG=1
        ;D ^%ZISC
        Q
QUEUE   ;** Remove after testing **
        I '$D(IOP),'$D(XDRDCOMP("DEVICE")) S %ZIS="QMN" D ^%ZIS
        I POP S XDRQFLG=1 G QUEUEX
        I $D(IO("Q")),IO=IO(0) W !!,"Sorry, you can't queue to your screen or a slave device.",! K IO("Q") G QUEUE
        S (IOP,XDRDCOMP("DEVICE"))=ION_";"_IOM_";"_IOSL K %ZIS
        I '$D(IO("Q")) G QUEUEX
        S ZTRTN="DQ^XDRDCOMP",ZTIO=ION,ZTDESC=$P(^DIC(XDRFL,0),U)_" COMPARISON LIST"
        F %="XDRCD","XDRCD2","XDRFL","XDRDTYPE","XDRGL","XDRD(","XDRDCOMP(" S ZTSAVE(%)=""
        K %
        ;S XYY=AAA ***************************
        D ^%ZTLOAD W:$D(ZTSK) !,"Queued as task "_ZTSK,!
        S XDRQFLG=1
        K ZTSK
QUEUEX  Q
        ;
EOJ     ;
        K XDRDCOMP,XDRDUP,XDRD,XDRFL,XDRGL,XDRQFLG,XDRDTEST,XDRDSCOR
        K XDRCD,XDRCD2,%IS,POP,IO("C"),IOP,IO("Q"),X,Y,ZTSK
        S:$D(ZTQUEUED) ZTREQ="@"
        Q
