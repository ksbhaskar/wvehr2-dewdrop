GMRVEE2 ;HIRMFO/YH-ENTERED IN ERROR EDIT (cont.) ;2/6/99
 ;;4.0;Vitals/Measurements;**1,7,11**;Apr 25, 1997
EN1 ; ENTER NEW DATE/TIME VITALS TAKEN
 S %DT(0)="-NOW",%DT("A")="Enter new date/time vitals were taken: ",%DT="AETRS" D ^%DT K %DT S:X?1"^".E!(+Y'>0) GMROUT=1 Q:GMROUT  S GMRCHC(1)=+Y
 Q
EN2 ; ENTER NEW READING
 S GMRENTY=8,GLVL=8,GMRVIT=GMRX,(GMRVITY,GMRTY)=$S($D(^GMRD(120.51,GMRX,0)):$P(^(0),"^",2),1:""),GMRVIT(1)=$P(^(0),"^"),GMRAINP=$S($D(^(1)):^(1),1:""),GSAVE=GMRVITY,GMRO2(GMRVITY)=""
 S GDT=GMRVIDT D EN1^GMRVADM G:GMROUT Q
ERRAT W !!,"NEW "_$S($P(GMRVIT(1),"^")'="":$P(GMRVIT(1),"^"),1:"VALUE")_": " R X:DTIME S:'$T X="^^" W ! I "^^"[X!(X="") W !,$C(7),?3,"NO UPDATING HAS OCCURRED!!" S GMROUT=1 G Q
 I X?1"?".E S GOPT=GMRTY_"^GMRVUT1" D @GOPT K GOPT G ERRAT
 I GMRTY="T"!(GMRTY="P")!(GMRTY="R") S X=$$RDSITE(X),GMRSITE=$P(X,U,2),X=$P(X,U) S GMRSITE=$$UP^XLFSTR(GMRSITE) D TPSITE^GMRVUT1
 I GMRTY="T"!(GMRTY="P")!(GMRTY="R") S:'$D(GMRSITE(GMRVITY)) GMROUT=1 S:GMROUT=0 GMRSITE=GMRSITE(GMRVITY) I GMROUT W !,"NO UPDATING HAS OCCURRED",!
 I GMRTY="CG" D  G:$G(X)="" ERRAT
 . X GMRAINP I $G(X)="" W !,?3,$C(7),"INVALID ENTRY??" Q
 . K GMRSITE(GMRVITY),GMRINF(GMRVITY) D LISTQ^GMRVQUAL,OTHERQ^GMRVQUAL
 G:GMROUT Q
 I GMRTY="PO2" X GMRAINP W:'$D(X) !,?3,$C(7),"INVALID ENTRY??" G:'$D(X) ERRAT S (GMRSITE(GMRVITY),GMRINF("GMRVITY"))="" D O2^GMRVUT3 G Q:GMROUT,Q1
 I GMRTY="PN" X GMRAINP W:'$D(X) !,?3,$C(7),"INVALID ENTRY??" G:'$D(X) ERRAT S (GMRSITE(GMRVITY),GMRINF("GMRVITY"))="" G Q:GMROUT,Q1
 I GMRTY="BP" X GMRAINP W:'$D(X) !,?3,$C(7),"INVALID ENTRY??" G:'$D(X) ERRAT D LISTQ^GMRVQUAL,OTHERQ^GMRVQUAL,CLEAR^GMRVQUAL G Q:GMROUT,Q1
 I GMRTY="WT" S GMRSITE=$P(X,+X,2) G:GMRSITE=""!("LlLk"'[$E(GMRSITE)) ERRAT D WTYPE^GMRVUT1 S:'$D(GMRSITE(GMRVITY)) GMROUT=1 S:GMROUT=0 GMRSITE=GMRSITE(GMRVITY) I GMROUT W !,"NO UPDATING HAS OCCURRED",!
 I GMRVITY="HT" S GMRSITE=$P(X,",",2),X=$P(X,",") S:GMRSITE="" GMRSITE="A" X GMRAINP W:'$D(X) !,?3,$C(7),"INVALID ENTRY??" G:'$D(X) ERRAT D TPSITE^GMRVUT1 G Q:GMROUT,Q1
 G:GMROUT Q X GMRAINP I '$D(X) W !,?3,$C(7),"INVALID ENTRY??" G ERRAT
Q1 G:GMROUT Q S GMRCHC(2)=X
Q S GMRVITY=GSAVE K GSAVE D CLEAR^GMRVQUAL Q
EN3 ; SELECT NEW PATIENT FOR VITALS
 S DIC("A")="Select the NEW Patient's name: ",DIC(0)="AEQM",DIC="^DPT(" D ^DIC K DIC S:$D(DTOUT)!$D(DUOUT)!(+Y'>0) GMROUT=1 Q:GMROUT  S GMRCHC(3)=+Y
 Q
DUPREC ;PRINT WARNING MESSAGE IF THE DATE/TIME CHANGE WILL CAUSE DUPLICATE RECORD
 W ! S GVIT=0 F GII=0:0 S GVIT=$O(GMRARTY(GVIT)) Q:GVIT'>0  I $D(^GMR(120.5,"AA",DFN,GVIT,GDATE)) D CHKER
 K GDA,GVIT,GII Q
CHKER ;
 S GDA=0 F GDA=0:0 S GDA=$O(^GMR(120.5,"AA",DFN,GVIT,GDATE,GDA)) Q:GDA'>0  I '$D(^GMR(120.5,GDA,2)) S GMROUT=1 W !,$P($S($D(^GMRD(120.51,GVIT,0)):^(0),1:0),"^"),"  already exists on ",Y,"   reading - ",$P(^GMR(120.5,GDA,0),"^",8)
 Q
DUPDT ;SET EXISTING OLD VITAL AS ERROR RECORD
 S GMRDA=0 F GMRDA=0:0 S GMRDA=$O(^GMR(120.5,"AA",DFN,GMRY,GDATE,GMRDA)) Q:GMRDA'>0  I '$D(^GMR(120.5,GMRDA,2)) D ERREN^GMRVEE1 Q
 Q
PRTEED ; PRINT ERROR RECORD
 S GMRDAT=^GMR(120.5,GMRDA,0)
 S GMRTY=$S($D(^GMRD(120.51,GMRX,0)):^(0),1:""),GMRAINP=$S($D(^GMRD(120.51,$P(GMRDAT,"^",3),1))#2:^(1),1:""),GMRVX=$P(GMRTY,"^",2),GMRVX(0)=$P(GMRDAT,U,8),GMRVX(1)=0 D:GMRVX(0)>0 EN1^GMRVSAS0 S GMRVX(1)=$S(GMRVX(1)>0:" *",1:"")
 S GMRZZ="",GMRZZ(1)="" I $P($G(^GMR(120.5,GMRDA,5,0)),"^",4)>0 K GMRVARY S GMRVARY="" D CHAR^GMRVCHAR(GMRDA,.GMRVARY,GMRX) S GMRZZ=$$WRITECH^GMRVCHAR(GMRDA,.GMRVARY,9) S:GMRZZ'="" GMRZZ(1)=" ("_GMRZZ_")"
 I GMRVX="T",GMRVX(0)>0 S GMRVX(0)=GMRVX(0)_" F ("_$J(GMRVX(0)-32*5/9,0,1)_" C)"
 I GMRVX="WT",GMRVX(0)>0 S GMRVX(0)=GMRVX(0)_" lb ("_$J(GMRVX(0)/2.2,0,2)_" kg)"
 I GMRVX="HT",GMRVX(0)>0 S GMRVX(0)=$S(GMRVX(0)\12:GMRVX(0)\12_" ft ",1:"")_$S(GMRVX(0)#12:GMRVX(0)#12_" in",1:"")_" ("_$J(GMRVX(0)*2.54,0,2)_" cm)"
 I GMRVX="CG",GMRVX(0)>0 S GMRVX(0)=GMRVX(0)_" in ("_$J(+GMRVX(0)/.3937,0,2)_" cm)"
 I GMRVX="CVP",GMRVX(0)>0 S GMRVX(0)=GMRVX(0)_" cmH2O ("_$J(GMRVX(0)/1.36,0,1)_" mmHg)"
 I GMRVX="PO2",GMRVX(0)>0 D
 .N GMRVPO S GMRVPO=$P(GMRDAT,"^",10)
 .S GMRVX(0)="Pulse oximetry "_GMRVX(0)_"%"_$S(GMRVPO'="":" with supplemental O2 "_$S(GMRVPO["l/min":$P(GMRVPO," l/min")_"L/min",1:"")_$S(GMRVPO["l/min":$P(GMRVPO," l/min",2),1:GMRVPO),1:"")
 .Q
 I GMRX=$O(GMRARTY(0)) S Y=$P(GMRDAT,"^") W ! D DT^DIQ
 W !,?2,$S($P(GMRTY,"^",2)="PN":"PN (pain)",1:$P(GMRTY,"^",2)),":  ",$S($P(GMRDAT,U,8)'="":GMRVX(0)_GMRVX(1),1:"")
 I GMRTY="PN" D
 . I GMRVX(0)=0 W " No pain" Q
 . I GMRVX(0)=99 W " Unable to respond" Q
 . I GMRVX(0)=10 W " Worst imaginable to respond" Q
 W:GMRVX="PO2"&(GMRZZ'="") !,?8,"via " W " ",GMRZZ
 Q
RDSITE(X) ; THIS FUNCTION CONVERTS A VITAL DATA ENTRY IN X TO A SITE AND
 ; A READING.  IT RETURNS SITE^READING.
 N Y,Z,I,READ,SITE
 S Y=$TR(X,"0123456789.","99999999999")
 S Z=$L(X)+1,I=0 F  S I=$F(Y,"9",I) Q:I'>0  S Z=I
 S READ=$E(X,1,Z-1),SITE=$E(X,Z,$L(X))
 Q READ_"^"_SITE
