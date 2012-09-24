PSBOMM  ;BIRMINGHAM/EFC-MISSED MEDS ;Mar 2004
        ;;3.0;BAR CODE MED ADMIN;**26,32,56**;Mar 2004;Build 10
        ;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified.
        ;
        ; Reference/IA
        ; ^DPT/10035
        ; EN^PSJBCMA/2828
        ; EN^PSJBCMA2/2830
EN      ;
        N PSBSTRT,PSBSTOP,DFN,PSBODATE,PSBFLAG,PSBCNT,PSBEDIT,PSBFUTR
        S PSBSTART=$P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,7),PSBSTOP=$P(PSBRPT(.1),U,8)+$P(PSBRPT(.1),U,9)
        D DEFLT^PSBOMM2
        K PSBOCRIT,PSBACRIT,PSBS
        S PSBOCRIT="^A^H^O" ;PSB*3*56 Adds the On Call Status to the Missed Meds Report
        S:$P(PSBFUTR,U,8) PSBOCRIT=PSBOCRIT_"^D^DE" S:$P(PSBFUTR,U,7) PSBOCRIT=PSBOCRIT_"^E"
        S PSBACRIT="MG"
        S:$P(PSBFUTR,U,17) PSBACRIT=PSBACRIT_"H" S:$P(PSBFUTR,U,18) PSBACRIT=PSBACRIT_"R"
        S PSBINCC=0 S:$P(PSBRPT(.2),U,8) PSBINCC=1
        K ^TMP("PSJ",$J),^TMP("PSB",$J),^TMP("PSB1",$J)
        S PSBSTRT=$P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,7)-.0000001
        F DFN=0:0 S DFN=$O(^TMP("PSBO",$J,DFN)) Q:'DFN  D EN1
        D PRINT
        K ^TMP("PSJ",$J),^TMP("PSB",$J),^TMP("PSBO",$J),PSBS
        Q
EN1     ;
        N PSBGBL,PSBHDR,PSBX,PSBDFN,PSBDT,PSBEVDT,PSBH
        K ^TMP("PSJ",$J) S PSBEVDT=PSBSTRT
        D EN^PSJBCMA(DFN,PSBSTRT)
        Q:^TMP("PSJ",$J,1,0)=-1
        S PSBX=""
        F  S PSBX=$O(^TMP("PSJ",$J,PSBX)) Q:PSBX=""  D
        .Q:^TMP("PSJ",$J,PSBX,0)=-1
        .D NOW^%DTC
        .D CLEAN^PSBVT
        .D PSJ^PSBVT(PSBX)
        .Q:PSBIVT="A"
        .Q:PSBIVT="H"
        .I PSBIVT["S",PSBISYR'=1 Q
        .I PSBIVT["C",PSBCHEMT'="P",PSBISYR'=1 Q
        .I PSBIVT["C",PSBCHEMT="A" Q
        .Q:PSBONX["P"
        .Q:PSBOSP<PSBSTART
        .I %>PSBOSP,PSBOSTS'="D",PSBOSTS'="DE",PSBOSTS'="H" S PSBOSTS="E"
        .I PSBSCHT="C" D  Q
        ..S (PSBYES,PSBODD)=0
        ..S PSBDOW="SU^MO^TU^WE^TH^FR^SA" F I=1:1:7 I $P(PSBDOW,"^",I)=$E(PSBSCH,1,2) S PSBYES=1
        ..I PSBYES,PSBADST="" Q
        ..F I=1:1 Q:$P(PSBSCH,"-",I)=""  I $P(PSBSCH,"-",I)?2N!($P(PSBSCH,"-",I)?4N) S PSBYES=1
        ..S PSBFREQ=$$GETFREQ^PSBVDLU1(DFN,PSBONX)
        ..I PSBFREQ="O" S PSBYES=1,PSBFREQ=1440
        ..I 'PSBYES,PSBADST="",PSBFREQ<1 Q
        ..I (PSBFREQ#1440'=0),(1440#PSBFREQ'=0) S PSBODD=1
        ..I PSBODD,PSBADST'="" Q
        ..Q:PSBOCRIT'[PSBOSTS
        ..Q:PSBNGF
        ..Q:PSBOSTS="N"
        ..Q:PSBSM
        ..S PSBS(DFN,PSBONX,$S(PSBOSTS="A":"Active",PSBOSTS="H":"On Hold",PSBOSTS="D":"DC'd",PSBOSTS="DE":"DC'd (Edit)",PSBOSTS="E":"Expired",PSBOSTS="O":"On Call",1:" *Unknown* "))=""
        ..S PSBSTXP(PSBONX,$$DTFMT^PSBOMM2(PSBOSP))=""
        ..S PSBCADM=0
        ..I PSBADST="" D  Q:$G(PSBADST)=""  S PSBCADM=1
        ...S X=PSBOST D H^%DTC S X1=((%H*24)*60)+(%T/60)
        ...S X=PSBSTRT,X3=0 D H^%DTC S X2=((%H*24)*60)+(%T/60)
        ...I X2'<X1 S X3=X2-X1 S PSBOST=$$FMADD^XLFDT(PSBSTRT,,,(-1*(X3#PSBFREQ)))
        ...K PSBADST S PSBOST2=PSBOST,PSBDT2=PSBSTRT
        ...F XZ=0:1 S PSBADST(XZ,PSBDT2)=$$GETADMIN^PSBVDLU1(DFN,PSBONX,PSBOST2,PSBFREQ,PSBDT2) D  Q:PSBDT2>PSBSTOP
        ....I ($L(PSBADST(XZ,PSBDT2),"-")>$L($G(PSBADST),"-"))!($G(PSBADST)="") S PSBADST=PSBADST(XZ,PSBDT2)
        ....S Z=PSBDT2\1,J=$P(PSBADST(XZ,PSBDT2),"-",($L(PSBADST(XZ,PSBDT2),"-"))) S:J]"" PSBOST2=Z_"."_J
        ....S PSBDT2=($$FMADD^XLFDT(Z,1))+.2400
        ....S PSBDT2=$S($G(FLG):(PSBSTOP\1)+.2401,PSBDT2>PSBOSP:PSBOSP,1:PSBDT2) K FLG I PSBDT2=PSBOSP S FLG=1
        ..S Z=PSBADST I Z]"" K ^TMP("PSB",$J,"GETADMIN") S ^TMP("PSB",$J,"GETADMIN",0)=Z
        ..F Y=1:1:$L(Z,"-") D
        ...Q:($P(Z,"-",Y)'?2N)&($P(Z,"-",Y)'?4N)
        ..K PSBOACTL,^TMP("PSB1",$J) D EN^PSJBCMA2(DFN,PSBONX,1) I ^TMP("PSJ2",$J,0)'=1 M PSBOACTL=^TMP("PSJ2",$J) K ^TMP("PSJ2",$J)
        ..I 'PSBODD F XX=0:1 Q:'$D(^TMP("PSB",$J,"GETADMIN",XX))  S (PSBADST,Z)=$G(^TMP("PSB",$J,"GETADMIN",XX)) D
        ...D MISSED^PSBOMM2(Z,.PSBEDIT,PSBSTRT)
        ..I PSBODD F XX=0:1 Q:'$D(PSBADST(XX))  S XXX=$O(PSBADST(XX,"")) S (PSBADST,Z)=PSBADST(XX,XXX) D
        ...I Z]"" D MISSED^PSBOMM2(Z,.PSBEDIT,XXX)
        .K PSBHDDT,PSBUNHD,^TMP("PSB1",$J)
        .I PSBSCHT="O" D  Q
        ..Q:PSBOSTS="N"
        ..Q:PSBNGF
        ..Q:PSBSM
        ..Q:(PSBOSP=PSBOST)&(PSBOCRIT'["E")
        ..Q:PSBOST'<PSBSTOP
        ..S PSBDT="*** ONE-TIME ***"
        ..S (PSBSTXP(PSBONX,$$DTFMT^PSBOMM2(PSBOSP)),PSBSTXT(PSBONX,$$DTFMT^PSBOMM2(PSBOST)))=""
        ..S (PSBG,X,Y,PSBXSTS)="" K PSBEXST
        ..F  S X=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X),-1) Q:'X  D
        ...F  S Y=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X,Y),-1) Q:'Y  D
        ....S PSBXSTS=$P(^PSB(53.79,Y,0),U,9)
        ....I $P(^PSB(53.79,Y,.1),U)=PSBONX,PSBXSTS'="N",PSBXSTS'="M" S PSBG=1,PSBG(PSBONX,Y)="",(X,Y)=0
        ..I PSBG D PARTG1^PSBOMM2($O(PSBG(PSBONX,"")))
        ..D NOW^%DTC
        ..Q:(PSBOCRIT'[PSBOSTS)
        ..S PSBS(DFN,PSBONX,$S(PSBOSTS="A":"Active",PSBOSTS="H":"On Hold",PSBOSTS="D":"DC'd",PSBOSTS="DE":"DC'd (Edit)",PSBOSTS="E":"Expired",PSBOSTS="O":"On Call",1:" * ERROR * "))=""
        ..D:'PSBG!(PSBACRIT[$G(PSBXSTS,1))
        ...S VAR=""
        ...K ^TMP("PSJ2",$J),^TMP("PSB1",$J),PSBOACTL D EN^PSJBCMA2(DFN,PSBONX,1) I ^TMP("PSJ2",$J,0)'=1 D
        ....M PSBOACTL=^TMP("PSJ2",$J)
        ....D UDONE^PSBOMM2
        ....I PSBFLAG=1 S VAR="(On Hold) "_$$DTFMT^PSBOMM2(PSBHDDT)
        ....I PSBFLAG=2 S VAR="(On Hold) "_$$DTFMT^PSBOMM2(PSBHDDT)_"  (Off Hold) "_$$DTFMT^PSBOMM2(PSBUNHD)
        ...I '$G(PSBEXST,0)!(PSBXSTS="M") S $P(^TMP("PSB",$J,DFN,"*** ONE-TIME ***",PSBOITX,PSBONX),U,1,4)=VAR
        ...I $G(PSBEXST,0) D
        ....S VAR1=$G(^TMP("PSB",$J,DFN,"*** ONE-TIME ***","* "_PSBOITX,PSBONX)) I VAR1]"" S $P(VAR1,U,1,4)=VAR_VAR1
        ...K PSBHDDT,PSBUNHD,^TMP("PSB1",$J),PSBCNT
        K PSBOACTL
        Q
PRINT   ;
        N PSBHDR,PSBDT,PSBOITX,PSBONX,DFN
        K PSBNPG
        S Y=$S($P(PSBRPT(.1),U,8)]"":$P(PSBRPT(.1),U,8),1:$P(PSBRPT(.1),U,6))
        D:$P(PSBRPT(.1),U,1)="P"
        .S PSBHDR(1)="MISSED MEDICATIONS REPORT for "_$$FMTE^XLFDT($P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,7))_" to "_$$FMTE^XLFDT(Y+$P(PSBRPT(.1),U,9))
        .S PSBHDR(2)="Order Status(es): --"
        .F Y=5,8,7 I $P(PSBFUTR,U,Y) S $P(PSBHDR(2),": ",2)=$P(PSBHDR(2),": ",2)_$S(PSBHDR(2)["--":"",1:"/ ")_$P("^^^^Active^^Expired^DC'd^^^^^^^^^^",U,Y)_" " S PSBHDR(2)=$TR(PSBHDR(2),"-","")
        .S PSBHDR(3)="Admin Status(es): --"
        .F Y=16,17,18 I $P(PSBFUTR,U,Y) S $P(PSBHDR(3),": ",2)=$P(PSBHDR(3),": ",2)_$S(PSBHDR(3)["--":"",1:"/ ")_$P("^^^^^^^^^^^^^^^Missing Dose^Held^Refused",U,Y)_" " S PSBHDR(3)=$TR(PSBHDR(3),"-","")
        .I PSBINCC S PSBHDR(4)="Include Comments/Reasons"
        .S DFN=$P(PSBRPT(.1),U,2)
        .W $$PTHDR()
        .I $G(PSBEDIT) W !?7,"*Administration Times have been edited*"
        .I $O(^TMP("PSB",$J,DFN,""))="" W !,"No Missed Medications Found",$$PTFTR^PSBOHDR() Q
        .S PSBDT=""
        .F  S PSBDT=$O(^TMP("PSB",$J,DFN,PSBDT)) Q:PSBDT=""  D
        ..W !
        ..S PSBOITX=""
        ..F  S PSBOITX=$O(^TMP("PSB",$J,DFN,PSBDT,PSBOITX)) Q:PSBOITX=""  D
        ...S PSBONX=""
        ...F  S PSBONX=$O(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX)) Q:PSBONX=""  D
        ....K VAR1,VAR2,VAR3,SP I $Y>(IOSL-9) W $$PTFTR^PSBOHDR(),$$PTHDR()
        ....S VAR1=$G(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX))
        ....S VAR2=$G(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX,"X"))
        ....S VAR3=$G(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX,.3))
        ....I PSBDT["ONE-TIME" D  Q
        .....W !
        .....W !,$O(PSBS(DFN,PSBONX,"")),?15,PSBDT,?43,PSBOITX,!
        .....I VAR1]"" W ?43,VAR1 S SP=1
        .....I VAR2]"" W:$G(SP) ! W ?43,VAR2
        .....I VAR3]"" W !,$$WRAP^PSBO(43,80,VAR3)
        .....W !,"Start Date/Time:  ",?18,$O(PSBSTXT(PSBONX,""))
        .....W !,"Stop Date/Time:  ",?18,$O(PSBSTXP(PSBONX,""))
        ....W !,$O(PSBS(DFN,PSBONX,"")),?15,$S(+PSBDT>0:$$DTFMT^PSBOMM2(PSBDT),1:PSBDT),?43,PSBOITX,?95,$O(PSBSTXP(PSBONX,"")),!
        ....I VAR1]"" W ?43,VAR1 S SP=1
        ....I VAR2]"" W:$G(SP) ! W ?43,VAR2
        ....I VAR3]"" W !,$$WRAP^PSBO(43,80,VAR3)
        .W $$PTFTR^PSBOHDR()
        .Q
        D:$P(PSBRPT(.1),U,1)="W"
        .S PSBHDR(1)="MISSED MEDICATIONS REPORT for "_$$FMTE^XLFDT($P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,7))_" to "_$$FMTE^XLFDT(Y+$P(PSBRPT(.1),U,9))
        .S PSBHDR(2)="Order Status(es): --"
        .F Y=5,7,8 I $P(PSBFUTR,U,Y) S $P(PSBHDR(2),": ",2)=$P(PSBHDR(2),": ",2)_$S(PSBHDR(2)["--":"",1:"/ ")_$P("^^^^Active^^Expired^DC'd^^^^^^^^^^",U,Y)_" " S PSBHDR(2)=$TR(PSBHDR(2),"-","")
        .S PSBHDR(3)="Admin Status(es): --"
        .F Y=16,17,18 I $P(PSBFUTR,U,Y) S $P(PSBHDR(3),": ",2)=$P(PSBHDR(3),": ",2)_$S(PSBHDR(3)["--":"",1:"/ ")_$P("^^^^^^^^^^^^^^^Missing Dose^Held^Refused",U,Y)_" " S PSBHDR(3)=$TR(PSBHDR(3),"-","")
        .I PSBINCC S PSBHDR(4)="Include Comments/Reasons"
        .S PSBWARD=$P(PSBRPT(.1),U,3)
        .W $$WRDHDR()
        .I '$O(^TMP("PSB",$J,0)) W !,"No Missed Medications Found" Q
        .S PSBSORT=$P(PSBRPT(.1),U,5)
        .F DFN=0:0 S DFN=$O(^TMP("PSB",$J,DFN)) Q:'DFN  D
        ..S PSBDX=$S(PSBSORT="P":$P(^DPT(DFN,0),U),1:$G(^DPT(DFN,.1))_" "_$G(^(.101)))
        ..S:PSBDX="" PSBDX=$P(^DPT(DFN,0),U)
        ..S ^TMP("PSB",$J,"B",PSBDX,DFN)=""
        .S PSBDX=""
        .F  S PSBDX=$O(^TMP("PSB",$J,"B",PSBDX)) Q:PSBDX=""  D
        ..F DFN=0:0 S DFN=$O(^TMP("PSB",$J,"B",PSBDX,DFN)) Q:'DFN  D
        ...W !
        ...S PSBDT=""
        ...F  S PSBDT=$O(^TMP("PSB",$J,DFN,PSBDT)) Q:PSBDT=""  D
        ....W !
        ....W:PSBDT["ONE-TIME" !
        ....S PSBOITX=""
        ....F  S PSBOITX=$O(^TMP("PSB",$J,DFN,PSBDT,PSBOITX)) Q:PSBOITX=""  D
        .....S PSBONX=""
        .....F  S PSBONX=$O(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX)) Q:PSBONX=""  D
        ......K VAR1,VAR2,VAR3,SP I $Y>(IOSL-9) W $$WRDHDR()
        ......W !,$O(PSBS(DFN,PSBONX,"")),?15,$G(^DPT(DFN,.101),"**"),?35,$P(^DPT(DFN,0),U)," (",$E($P(^(0),U,9),6,9),")"
        ......S VAR1=$G(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX))
        ......S VAR2=$G(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX,"X"))
        ......S VAR3=$G(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX,.3))
        ......I PSBDT["ONE-TIME" D  Q
        .......W !,PSBDT,?30,PSBOITX S SP=1
        .......I VAR1]"" W !,?30,$P(VAR1,U,1) S SP=1
        .......I VAR2]"" W:$G(SP) ! W ?30,VAR2
        .......I VAR3]"" W !,$$WRAP^PSBO(30,95,VAR3)
        .......W !,"Start Date/Time:  ",?18,$O(PSBSTXT(PSBONX,""))
        .......W !,"Stop Date/Time:  ",?18,$O(PSBSTXP(PSBONX,""))
        .......W !
        ......W ?67,$S(+PSBDT>0:$$DTFMT^PSBOMM2(PSBDT),1:PSBDT),?85,PSBOITX S SP=1
        ......I VAR1]"" W !,?50,VAR1 S SP=1
        ......I VAR2]"" W:$G(SP) ! W ?50,VAR2
        ......I VAR3]"" W !,$$WRAP^PSBO(50,75,VAR3)
        Q
WRDHDR()        ;
        D WARD^PSBOHDR(PSBWRD,.PSBHDR)
        W !,"Order Status",?15,"Room-Bed",?35,"Patient",?67,"Admin Date/Time",?85,"Medication"
        D LN1^PSBOMM2
        Q ""
PTHDR() ;
        D PT^PSBOHDR(DFN,.PSBHDR)
        W !,"Order Status",?15,"Administration Date/Time",?43,"Medication",?95,"Order Stop Date"
        D LN1^PSBOMM2
        Q ""
