SRONIN ;BIR/MAM,ADM - NURSE INTRAOPERATIVE REPORT ;05/30/06
 ;;3.0; Surgery ;**68,50,100,129,134,153,157**;24 Jun 93;Build 3
 ;** NOTICE: This routine is part of an implementation of a nationally
 ;**         controlled procedure. Local modifications to this routine
 ;**         are prohibited.
 ;
 ; Reference to UPDATE^TIUSRVP supported by DBIA #3535
 ; Reference to ES^TIUSROI supported by DBIA #3537
 ; Reference to EXTRACT^TIULQ supported by DBIA #2693
 ;
 I '$D(SRSITE) D ^SROVAR G:'$D(SRSITE) END S SRSITE("KILL")=1
 I '$D(SRTN) K SRNEWOP D ^SROPS G:'$D(SRTN) END S SRTN("KILL")=1
 N SRAGE,SRDIV,SRDIVNM,SRDO,SRFUNCT,SRHDR,SRINUSE,SRLEAVE,SRLOC,SRPARAM,SRPRINT,SRSEL,SRSINED,SRDTITL,SRTIU,SRAT,SRXX
 S SRDTITL="Nurse Intraoperative Report"
 S (SRFUNCT,SRLEAVE,SRSINED)=0,SRTIU=$P($G(^SRF(SRTN,"TIU")),"^",2)
 I SRTIU,$$STATUS^SROESUTL(SRTIU)=7 S SRSINED=1
 D:SRSINED FUNCT D:'SRSINED EN
ENF I 'SRLEAVE,SRFUNCT S SRSEL="" D FUNCT
 D END
 Q
DISPLY I SRSINED S SRTIU=$P($G(^SRF(SRTN,"TIU")),"^",2) I SRTIU D PRNT^SROESPR(SRTN,SRTIU,SRDTITL) S SRLEAVE=1 Q
 K %ZIS,IO("Q") S %ZIS="Q" D ^%ZIS I POP S SRLEAVE=1 Q
 I $D(IO("Q")) K IO("Q") N ZTRTN,ZTDESC,ZTSAVE,ZTQUEUED S ZTRTN="PRNT^SRONIN",ZTDESC=SRDTITL,(ZTSAVE("SRTN"),ZTSAVE("SRSITE*"))="" D ^%ZTLOAD,^%ZISC Q
EN D RPT^SRONRPT(SRTN) S DFN=$P(^SRF(SRTN,0),"^"),VAINDT=$P(^SRF(SRTN,0),"^",9)
 S Y=$E(VAINDT,1,7) D D^DIQ S SRSDATE=Y D OERR^VADPT
 S SRHDR=" "_VADM(1)_" ("_VA("PID")_")   Case #"_SRTN_" - "_SRSDATE
 S Y=$E($$NOW^XLFDT,1,12) D DD^%DT S SRPRINT="Printed: "_Y
 S SRLOC=" Pt Loc: "_$P(VAIN(4),"^",2)_"  "_VAIN(5)
 S SRAGE="",Z=$P(VADM(3),"^") I Z S X=$E($P(^SRF(SRTN,0),"^",9),1,12),Y=$E(X,1,7),SRAGE=$E(Y,1,3)-$E(Z,1,3)-($E(Y,4,7)<$E(Z,4,7))
 S SRDIV=$$SITE^SROUTL0(SRTN),SRDIVNM="" I SRDIV S X=$P(^SRO(133,SRDIV,0),"^"),SRDIVNM=$$EXTERNAL^DILFD(133,.01,"",X)
 S SRDIVNM=$S(SRDIVNM'="":SRDIVNM,1:SRSITE("SITE"))
 U IO S (SRPAGE,SRSOUT)=0,$P(SRLINE,"-",80)="" D HDR
 S SRI=0 F  S SRI=$O(^TMP("SRNIR",$J,SRTN,SRI)) Q:'SRI  D  Q:SRSOUT
 .I $E(IOST)="P",$Y+11>IOSL D FOOT Q:SRSOUT  D HDR
 .I $E(IOST)'="P",$Y+4>IOSL D FOOT Q:SRSOUT  D HDR
 .W !,^TMP("SRNIR",$J,SRTN,SRI)
 I SRSOUT D ^%ZISC Q
 D FOOT D  D ^%ZISC
 .I $D(SRALRT) S SRFUNCT=1 Q
 .I '$G(SRFUNCT) S SRLEAVE=1
 Q
SRHDR S DFN=$P(^SRF(SRTN,0),"^") D DEM^VADPT
 S Y=$E($P(^SRF(SRTN,0),"^",9),1,7) D D^DIQ S SRSDATE=Y
 S SRHDR=" "_VADM(1)_" ("_VA("PID")_")   Case #"_SRTN_" - "_SRSDATE
 Q
PRNT N SRDIV,SRFUNCT,SRLEAVE D EN
END K ^TMP("SRNIR",$J)
 W @IOF I $D(ZTQUEUED) Q:$G(ZTSTOP)  S ZTREQ="@" Q
 D ^SRSKILL K VAIN,VAINDT I $D(SRSITE("KILL")) K SRSITE
 I $D(SRTN("KILL")) K SRTN
 Q
PAGE I $D(SRNOEDIT) D LAST Q
 S (SRFUNCT,SRSOUT)=0
 W ! K DIR S DIR(0)="FOA",DIR("A",1)=" Press <return> to continue, 'A' to access Nurse Intraoperative Report",DIR("A")=" functions, or '^' to exit: " D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S (SRLEAVE,SRSOUT)=1 Q
 I X="A"!(X="a") S (SRFUNCT,SRSOUT)=1
 Q
LAST W ! K DIR S DIR(0)="E" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
FOOT ; print footer
 Q:SRSOUT  I $E(IOST)'="P" D PAGE Q
 I IOSL-9>$Y F X=$Y:1:(IOSL-10) W !
 W !,SRLINE,!,VADM(1),?50,SRPRINT,!,VA("PID")_"  Age: "_SRAGE,?50,SRLOC,!,SRDIVNM,?59,"Vice SF 509",!,SRLINE
 Q
HDR ; heading
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 S SRPAGE=SRPAGE+1 I $Y'=0 W @IOF
 I $E(IOST)'="P",SRPAGE=1 S DFN=$P(^SRF(SRTN,0),"^") D DEM^VADPT S SRXX=VADM(1)_" ("_VA("PID")_")" W !,?(80-$L(SRXX)\2),SRXX
 W:$E(IOST)="P" !!!!,SRLINE W !,?3,"MEDICAL RECORD       NURSE INTRAOPERATIVE REPORT - CASE #"_SRTN,?(79-$L("PAGE "_SRPAGE)),"PAGE "_SRPAGE,!
 W:$E(IOST)="P" SRLINE,!
 Q
FUNCT ; nurse intraop report functions
 K SRALRT
 D:'$D(SRHDR) SRHDR S SRSOUT=0,SRTIU=$P($G(^SRF(SRTN,"TIU")),"^",2)
 I 'SRSINED,SRTIU,$$STATUS^SROESUTL(SRTIU)=7 S SRSINED=1
 W @IOF,!,SRHDR I SRSINED W !!," * * The Nurse Intraoperative Report has been electronically signed. * *"
 W !!," Nurse Intraoperative Report Functions:",!
 S DIR("A",1)="  1. Edit report information",DIR("A",2)="  2. Print/View report from beginning"
 S DIR("A",3)=$S('SRTIU:"",'SRSINED:"  3. Sign the report electronically",1:"") I SRTIU,'SRSINED S DIR("A",4)=""
 S DIR("A")="Select number: ",DIR("B")=2,DIR(0)="SAM^1:Edit report information;2:Print/View report from beginning"_$S(('SRSINED&SRTIU):";3:Sign the report electronically",1:"")
 D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S (SRLEAVE,SRSOUT)=1 D END Q
 S SRSEL=Y,SRDO=$S(SRSEL=1:"EDIT",SRSEL=3:"SIGN",1:"DISPLY")
 D @SRDO D UNLOCK^SROUTL(SRTN)
 S SRSOUT=0,SRFUNCT=1 D ENF
 Q
EDIT ; edit report data fields
 D CHECK^SROES I SRSOUT Q
 N SROLOCK,SRX,SRZ D ^SROLOCK I SROLOCK S Q3("VIEW")=""
 N SRLCK S SRLCK=$$LOCK^SROUTL(SRTN) I 'SRLCK Q
 K DA,DR,DIE S SRDTIME=DTIME,DTIME=3600,DIE=130,DA=SRTN,DR="[SRONRPT]",ST="NURSE INTRAOP"_$S(SROLOCK:" **LOCKED",1:"") D EN2^SROVAR,^SRCUSS S DTIME=SRDTIME K Q3("VIEW")
 I '$P(^SRF(SRTN,0),"^",20) D ^SROPCE1
 I $D(SRODR) D ^SROCON1
 S SROERR=SRTN D ^SROERR0
 D EXIT^SROES
 Q
SIGN ; sign report if appropriate user
 N SRLCK,SRESIG S SRESIG=1,SRLCK=$$LOCK^SROUTL(SRTN) I 'SRLCK Q
 N SRMISS,SRNUR,SROK,SRA,SRII,SRJ,Y S SRII=$P($G(^SRF(SRTN,"TIU")),"^",2)
 S (SROK,SRNUR,SRJ)=0 F  S SRNUR=$O(^SRF(SRTN,19,SRNUR)) Q:'SRNUR  S SRJ=1 I $P(^SRF(SRTN,19,SRNUR,0),"^")=DUZ S SROK=1 Q
 I $D(^XUSEC("SROCHIEF",DUZ)) S SROK=1
 I 'SROK,'SRJ,SRII D EXTRACT^TIULQ(SRII,"SRA",.SRERR,"1302") I +$G(SRA(SRII,1302,"I"))=DUZ S SROK=1
 I 'SROK W !!,"Sorry, you are not authorized to sign this report." H 2 Q
 S SRMISS=0 D ALLIN Q:SRSOUT!SRMISS
ES D RPT^SRONRPT(SRTN) N SRAY,SRERR,SRI,SRP,SRSIG,SRTIU,X1
 S SRTIU=$P($G(^SRF(SRTN,"TIU")),"^",2)
 D SIG^XUSESIG I X1="" W !!,"Signature failed." H 2 Q
 F I=1:1 Q:'$D(^TMP("SRNIR",$J,SRTN,I))  S SRAY("TEXT",I,0)=^TMP("SRNIR",$J,SRTN,I)
 S SRAY(.05)=5 D UPDATE^TIUSRVP(.SRERR,SRTIU,.SRAY,1) K SRAY
 I +SRERR S SRSINED=1 D
 .D ES^TIUSROI(SRTIU,DUZ)
 .S XQAID="SRNIR-"_SRTN,XQAKILL=0 D DELETEA^XQALERT
 W ! K DIR S DIR(0)="FOA",DIR("A")="Press RETURN to continue... " D ^DIR K DIR
 Q
ALLIN N SRFLD,SRI,SRJJ,SRJK,SRM,SRMISS1,SRMISS2,SRMISS3,SRMISS82,SRMISS83,SRMISS84,SRMIS508,SRO,SROO,SRP,SRX,SRY,SRZ
 K DA,DIC,DIQ,DR S (SREDIT,SRMISS,SRMISS1,SRMISS2,SRMISS3,SRMISS82,SRMISS83,SRMISS84,SRMIS508,SRSOUT)=0
 S DIC="^SRF(",DA=SRTN,DIQ="SRY",DIQ(0)="I",DR=".205;.232;44;45;46;47;48;71;72;73;506" D EN^DIQ1
 F SRJJ=82,83,84,49 I '$O(^SRF(SRTN,SRJJ,0)) S SRJK=$S(SRJJ=49:508,1:SRJJ),SRY(130,SRTN,SRJK,"I")=""
 I $O(^SRF(SRTN,1,0)) S SRO=0 F  S SRO=$O(^SRF(SRTN,1,SRO)) Q:'SRO  S SROO=$G(^SRF(SRTN,1,SRO,2)) D
 .F SRM=1,2,3 S:$P(SROO,"^",SRM)']"" SRY(130.47,SRTN,SRO_";"_(SRM+7),"I")=""
 K DA,DIC,DIQ,DR D LIST
 I $G(SRX(.205))'=""!($G(SRX(.232))'="")!($G(SRX(71))'="")!($G(SRX(72))'="")!($G(SRX(73))'="")!($G(SRX(506))'="") S SRMISS1=1
 F SRJJ=71,72,73 I (SRY(130,SRTN,SRJJ,"I")="N")!(SRY(130,SRTN,SRJJ,"I")=""),('$O(^SRF(SRTN,SRJJ+11,0))) S @("SRMISS"_(SRJJ+11))=1
 I SRY(130,SRTN,506,"I")="S"!(SRY(130,SRTN,506,"I")="O"),('$O(^SRF(SRTN,49,0))) S SRMIS508=1
 I $G(SRX(48))="" F SRZ=44,45,46,47 I $G(SRX(SRZ))'="" S SRMISS2=1 Q
 I $O(^SRF(SRTN,1,0)) F SRZ=8,9,10 I $O(SRX(130.47,0)) S SRMISS3=1 Q
 I SRMISS1!SRMISS2!$G(SRMISS82)!$G(SRMISS83)!$G(SRMISS84)!$G(SRMIS508)!(SRMISS3) S SRMISS=1 D MESS Q:SRSOUT  I SREDIT D EDIT Q
 Q
MESS ; display list of missing items
 W @IOF,!,"The following information is required before this report may be signed:",!
 I SRMISS1 F SRZ=.205,.232,71,72,73,506 I $G(SRX(SRZ))'="" W !,?5,SRX(SRZ)
 I SRMISS2 F SRZ=44:1:47 I $G(SRX(SRZ))'="" W !,?5,SRX(SRZ)
 F SRJJ=82,83,84 I $G(@("SRMISS"_SRJJ)),$G(SRX(SRJJ))'="" W !,?5,SRX(SRJJ)
 I $G(SRMIS508),$G(SRX(508))'="" W !,?5,SRX(508)
 I SRMISS3 I $O(SRX(130.47,0)) S SRJ=0 F  S SRJ=$O(SRX(130.47,SRJ)) Q:'SRJ  S SRJJ=$P($G(^SRF(SRTN,1,SRJ,0)),"^") D
 .W !!,?5,"PROSTHESIS INSTALLED item: "_$P(^SRO(131.9,SRJJ,0),"^"),!,?6,"is missing at least one of the three required sterility fields."
 W ! K DIR S DIR("A")="Do you want to enter this information",DIR("B")="YES",DIR(0)="Y" D ^DIR K DIR,SRX I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
 I Y S SREDIT=1
 Q
CODE ; entry point from coding menu
 N SRAGE,SRDIV,SRDIVNM,SRDO,SRFUNCT,SRHDR,SRINUSE,SRLEAVE,SRLOC,SRNOEDIT,SRPARAM,SRPRINT,SRSEL,SRSINED,SRDTITL,SRTIU,SRSTAT,SRXX
 S SRNOEDIT=1,SRDTITL="Nurse Intraoperative Report"
 S (SRFUNCT,SRLEAVE,SRSINED)=0,SRTIU=$P($G(^SRF(SRTN,"TIU")),"^",2)
 I SRTIU,$$STATUS^SROESUTL(SRTIU)=7 S SRSINED=1
 D DISPLY,END
 Q
LIST S SRZ=0 F  S SRZ=$O(SRY(130,SRTN,SRZ)) Q:'SRZ  I SRY(130,SRTN,SRZ,"I")="" D TR S X=$T(@SRP),SRFLD=$P(X,";;",2),SRX(SRZ)=$P(SRFLD,"^",2)
 S SRZ=0,SROO="" F  S SROO=$O(SRY(130.47,SRTN,SROO)) Q:'SROO  I SRY(130.47,SRTN,SROO,"I")="" D
 .S SRX(130.47,$P(SROO,";"),$P(SROO,";",2))=""
 Q
TR S SRP=SRZ,SRP=$TR(SRP,"1234567890.","ABCDEFGHIJP")
 Q
PBJE ;;.205^TIME PAT IN OR
PBCB ;;.232^TIME PAT OUT OR
DD ;;44^SPONGE COUNT CORRECT (Y/N)
DE ;;45^SHARPS COUNT CORRECT (Y/N)
DF ;;46^INSTRUMENT COUNT CORRECT (Y/N)
DG ;;47^SPONGE, SHARPS, & INST COUNTER
DH ;;48^COUNT VERIFIER
GA ;;71^TIME OUT VERIFIED
GB ;;72^PREOPERATIVE IMAGING CONFIRMED
GC ;;73^MARKED SITE CONFIRMED
HB ;;82^TIME OUT VERIFY COMMENTS
HC ;;83^IMAGING CONFIRMED COMMENTS
HD ;;84^MARKED SITE COMMENTS
EJF ;;506^HAIR REMOVAL METHOD
EJH ;;508^HAIR REMOVAL COMMENTS
