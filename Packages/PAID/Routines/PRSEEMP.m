PRSEEMP ;HISC/JH-ATTENDANCE RPT BY SERVICE ;9/17/1998
 ;;4.0;PAID;**44**;Sep 21, 1995
EN1 ;TRAINING REPORT
 S X=$G(^PRSE(452.7,1,"OFF")) I X=""!(X=1) D MSG6^PRSEMSG Q
 S (NQ,POUT,NSW1,NPC)=0,HOLD=1 D EN2^PRSEUTL3($G(DUZ)) I PRSESER=""&'(DUZ(0)["@") D MSG3^PRSEMSG G Q
 K POUT W ! S DATSEL="N+" D DATSEL^PRSEUTL G Q:$D(POUT) D INS^PRSEUTL G Q:$D(POUT)
 S DIC("S")="I +$$EN4^PRSEUTL3($G(DUZ))!(DUZ(0)[""@"")"
 I '+$$EN4^PRSEUTL3($G(DUZ)),'(DUZ(0)["@") S PSPC=PRSESER("TX") G AR
 D EN3^PRSEUTL1 G Q:$D(POUT)
AR I PRSESEL'="A" D EN5^PRSEUTL2 G Q:$D(POUT)
 W ! S ZTRTN="START^PRSEEMP" D L^PRSEEMP2,DEV^PRSEUTL G:POP!($D(ZTSK)) Q
START ;
 K ^TMP("PRSE",$J)
 S (POUT,SHRS,SHRS("CEU"),SHRS("CON"),PHRS,PHRS("CEU"),PHRS("CON"),RHRS,RHRS("CEU"),RHRS("CON"),RCNT,SCNT,PCNT)=0,PRSE132=$S(IOM'<132:1,1:0)
 S PRDA=DUZ I '+$$EN3^PRSEUTL3($G(PRDA)),DUZ(0)'="@",'+$$EN4^PRSEUTL3($G(DUZ)) S PSPC=PRSESER("TX"),PSP=0
 F DAT=(YRST-.0000001):0 S DAT=$O(^PRSE(452,"H",DAT)) Q:DAT>YREND!(DAT="")  F DA=0:0 S DA=$O(^PRSE(452,"H",DAT,DA)) Q:DA'>0  I $D(^PRSE(452,DA,0)) W:$E(IOST,1,2)="C-"&('$R(200)) "." D SORT^PRSEEMP2
 I '$D(^TMP("PRSE",$J,"L")) D NHDR W !,"THERE IS NO DATA FOR THIS REPORT" W:$G(PSPC)]"" !,"SERVICE: ",PSPC W:$G(PRSECLS)]"" !,"CLASS: ",PRSECLS G Q
 S PRSELOC="" F  S PRSELOC=$O(^TMP("PRSE",$J,"L",PRSELOC)) Q:PRSELOC=""!POUT  S HOLD=1 D  Q:POUT  D BRK
 .S NIC="" F  S NIC=$O(^TMP("PRSE",$J,"L",PRSELOC,NIC)) Q:NIC=""!POUT  S NSORT=$G(^TMP("PRSE",$J,"L",PRSELOC,NIC)) S HOLD(1)=1 D  Q:POUT  D BRK1
 ..S PRSETL="" F  S PRSETL=$O(^TMP("PRSE",$J,"L1",NSORT,PRSETL)) Q:PRSETL=""!POUT  S HOLD(2)=1 D  Q:POUT
 ...S N1="" F  S N1=$O(^TMP("PRSE",$J,"L1",NSORT,PRSETL,N1)) Q:N1=""!POUT  D  Q:POUT
 ....S NCD="" F  S NCD=$O(^TMP("PRSE",$J,"L1",NSORT,PRSETL,N1,NCD)) Q:NCD=""!POUT  S DA=$O(^TMP("PRSE",$J,"L1",NSORT,PRSETL,N1,NCD,0)) Q:DA'>0  D  Q:POUT
 .....I NSW1'>0!($Y>(IOSL-1))!(HOLD=1) D NHDR Q:POUT
 .....S PCNT=(PCNT+1),PRDATA=$G(^TMP("PRSE",$J,"L1",NSORT,PRSETL,N1,NCD,DA)),PHRS=(PHRS+$P(PRDATA,U)) I $P(PRDATA,U,4)="C" S PHRS("CEU")=PHRS("CEU")+$P(PRDATA,U,2),PHRS("CON")=(PHRS("CON")+$P(PRDATA,U,3))
 .....I HOLD=1 W "Service: "_$S(PRSELOC="  BLNK":"",1:PRSELOC),! S HOLD=0
 .....I HOLD(1)=1 W !,$S(PRSE132:NIC,1:$E(NIC,1,25)) W:$P($G(^PRSE(452,DA,6)),U,2)'="" ?$S(PRSE132:55,1:30),$E($P(^(6),U,2),1,29) W ?$S(PRSE132:90,1:54),"Length: ",$S($P(PRDATA,U)>0:$J($P(PRDATA,U),4,2),1:"") S HOLD(1)=0
 .....W !,?5,$S(N1="  BLNK":"",1:$S(PRSE132:N1,1:$E(N1,1,20)))
 .....I HOLD(2)=1 W ?$S(PRSE132:60,1:35),$S(PRSETL="  BLNK":"",1:$S(PRSE132:PRSETL,1:$E(PRSETL,1,29))) S HOLD(2)=0
 .....S Y=$E(NCD,1,7) D:+Y D^DIQ W ?$S(PRSE132:106,1:67),$P(Y,"@"),!
 .....I $P(PRDATA,U,4)="C" W ?5,"CEUs: ",+$P(PRDATA,U,2),?$S(PRSE132:88,1:49),"Contact HRS: ",$J($P(PRDATA,U,3),4,2),!
 .....Q
 ....Q
 ...Q
 ..S HOLD(2)=1 Q
 .S HOLD(1)=1 Q
 S HOLD=1
 G:$G(PSPC)'="" Q  W !!,?2,"Report Classes: ",RCNT,?$S(PRSE132:96,1:41),"Report Length Hours: ",$J(RHRS,4,2),! S (RHRS,RCNT)=0
 I PRSESEL="C"!(PRSESEL="A") W ?5,"Report CEUs: ",$J(RHRS("CEU"),4,2),?$S(PRSE132:95,1:40),"Report Contact Hours: ",$J(RHRS("CON"),4,2)
Q ;
 K ^TMP("PRSE",$J) D CLOSE^PRSEUTL,^PRSEKILL
 Q
BRK1 ;
 I ($Y>(IOSL-1)),$E(IOST,1,2)="C-",HOLD=0 Q:POUT
 W ?3,"Total Attendees: ",PCNT,?$S(PRSE132:95,1:42),"Total Length Hours: ",$J(PHRS,4,2),!
 I PRSESEL="C"!(PRSESEL="A") W:+PHRS("CEU")>0 ?6,"Total CEUs: ",$J(PHRS("CEU"),4,2) W:+PHRS("CON")>0 ?$S(PRSE132:94,1:41),"Total Contact Hours: ",$J(PHRS("CON"),4,2),!
 S SCNT=(SCNT+PCNT),SHRS=(SHRS+PHRS),(PCNT,PHRS)=0 I PRSESEL="C"!(PRSESEL="A") S SHRS("CEU")=(SHRS("CEU")+PHRS("CEU")),SHRS("CON")=(SHRS("CON")+PHRS("CON")),(PHRS("CEU"),PHRS("CON"))=0
 Q
BRK ;
 W !,?1,"Service Attendees: ",SCNT,?$S(PRSE132:95,1:40),"Service Length Hours: ",$J(SHRS,4,2),! S RHRS=(RHRS+SHRS),RCNT=(RCNT+SCNT),(SHRS,SCNT)=0
 I PRSESEL="C"!(PRSESEL="A") W ?4,"Service CEUs: ",$J(SHRS("CEU"),4,2),?$S(PRSE132:94,1:39),"Service Contact Hours: ",$J(SHRS("CON"),4,2) S RHRS("CEU")=(RHRS("CEU")+SHRS("CEU")),RHRS("CON")=(RHRS("CON")+SHRS("CON")),(SHRS("CEU"),SHRS("CON"))=0
 I ($Y>(IOSL-1)),$E(IOST,1,2)="C-",HOLD=0 Q:POUT
 Q
NHDR I 'NQ,NSW1,$E(IOST,1,2)="C-" D ENDPG^PRSEUTL Q:POUT
 S NPC=NPC+1
 W:$E(IOST,1,2)="C-"!(NPC>1) @IOF
 W !,$S(PRSESEL="C":"C.E.",PRSESEL="M":"M.I.",PRSESEL="O":"OTHER",PRSESEL="W":"WARD",1:"COMPLETE")_" SERVICE TRAINING REPORT FOR "_$S(TYP="C":"CY ",TYP="F":"FY ",1:" ")_$S(TYP="C"!(TYP="F"):$G(PYR),1:$G(YRST(1))_" - "_$G(YREND(1)))
 S X="T" D ^%DT D:+Y D^DIQ
 I PRSE132 D
 .W ?101,Y,?121,"PAGE: ",NPC
 .W !,"Class Name",?55,"Class Presenter"
 .W !,?5,"Student Name",?60,"Title",?114,"Date"
 E  D
 .W ?55,Y,?71,"PAGE: ",NPC
 .W !,"Class Name",?30,"Class Presenter"
 .W !,?5,"Student Name",?35,"Title",?67,"Date"
 S NI="",$P(NI,"-",$S(PRSE132:133,1:81))="" W !,NI
 S (HOLD,HOLD(1),HOLD(2),NSW1)=1
 W !
 Q
