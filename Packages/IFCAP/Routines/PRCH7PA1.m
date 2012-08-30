PRCH7PA1        ;Hines IOFO/RVD - PROS IFCAP GUI ADD PO ;8/13/03  07:58
        ;;5.1;IFCAP;**68,122**;Oct 20, 2000;Build 1
        ;Per VHA Directive 10-93-142, this routine should not be modified.
        ;
        ;This routine will take the next Common Numbering Series and update
        ;file 442.6 for the next number.  It will also create an entry in
        ;file 442 (PO) to be used in obligation.
        ;Line label AD1 is to be used for MUMPS entry point.
        ;Line label ADDPO is an entry point for Remote Procedure Call.
        ;
        ; DUZ      - User
        ; PRCSITE  - Station Number IEN
        ; RMPRSITE - IEN of 669.9
        ; PRCHXXX  - IEN of 440.5 Purchase Card
        ; PRCHVEN  - IEN of 440 Vendor
        ; PRC4426  - Common Numbering Series
        ; RESULTS(0) = IEN of 442 ^ PO NUMBER
        Q
AD1(DUZ,PRCSITE,RMPRSITE,PRCHXXX,PRCHVEN,PRC4425)       G AD2
        ;
ADDPO(RESULTS,DUZ,PRCSITE,RMPRSITE,PRCHXXX,PRCHVEN,PRC4426)     ;create the next PAT number.
        ;
AD2     ;
        Q:'$D(PRCSITE)
EN1     ;
        I '$D(^PRC(411,PRCSITE,0)) S RESULTS(0)="^IFCAP Station Not Defined in file # 411." Q
        I PRC4426="" S RESULTS(0)="Common Numbering Series was not passed see your Supervisor." Q
        L +^PRC(442.6,PRC4426,0):1 I '$T S RESULTS(0)="^Unable to Access IFCAP file (#442.6), Try Later." Q
        D GETS^DIQ(442.6,PRC4426,".01;3;2;1","","PRCN")
        S PRCLO=$G(PRCN(442.6,PRC4426_",",1))
        S PRCNEXT=$G(PRCN(442.6,PRC4426_",",3))
        S PRCSTPO=$G(PRCN(442.6,PRC4426_",",.01))
        S PRCPO=$P(PRCSTPO,"-",2)
        S PRCUPBO=$G(PRCN(442.6,PRC4426_",",2))
        I PRCNEXT="" S RESULTS(0)="^The Common Numbering Series is Null."
        S PRCNEXT=PRCNEXT+1
        I PRCNEXT>PRCUPBO S RESULTS(0)="^The Common Numbering Series Exceeds the limit, please use a different Common Numbering Series." L -^PRC(442.6,PRC4426,0) Q
        ;calculate PO to be 6 places.
        D NUM
        S PRCNEXT=+PRCNEXT
        S DIE="^PRC(442.6,"
        S DA=PRC4426
        S DR="3////^S X=PRCNEXT"
        D ^DIE
        L -^PRC(442.6,PRC4426,0)
        K DIE,DA,DR
        ;
        I $D(^PRC(442,"B",PRCROBL)) S RESULTS(0)="^P.O. "_PRCROBL_" already exist, please use a different PO number." Q
        ;
PO      ;PO must be defined in PRCROBL.
        ;Create a PO entry in 442.
        S X=PRCROBL
        K DIC("S") S PRCHNEW="",DIC="^PRC(442,",DLAYGO=442,DIC(0)="L" D ^DIC
        I +(Y)'>0 S RESULTS(0)="^UNABLE to Create a Purchase Order, Please Try Later." Q
        S (DA,PRCHPO,PRC442)=+Y,%DT="T",X="NOW" D ^%DT S $P(^PRC(442,PRCHPO,12),U,4,5)=DUZ_U_Y
        S (X,Y)=1,PRCHX=X,DIE="^PRC(442,",DR=".5////1" D ^DIE K DIE,DR
        S $P(^PRC(442,PRCHPO,1),U,10)=DUZ
        S PRCA=PRCSITE_"^"_PRCHVEN
        S RESULTS(0)=PRCHPO_"^"_PRCROBL
        S PRCRI(420)=+PRCA,PRC("SITE")=$P(PRCA,"^"),PRCRI(440)=$P(PRCA,"^",2)
        S X="" S:$D(PRC("SITE")) PRC("PARAM")=^PRC(411,PRC("SITE"),0)
        S (PRCPROST,PRCHPC)=1
        S (PRCHN("SVC"),PRCHN("CC"),PRCHN("SC"),PRCHN("INV"))="",PRCHN("SFC")=+$P(^PRC(442,DA,0),U,19),PRCHN("FOB")=$S($D(^(1)):$P(^(1),U,6),1:""),PRCHN(12)=$S($D(^PRC(442,DA,12)):^(12),1:"")
        S PRCHPONO=$P(^PRC(442,DA,0),U,1),PRCHSTN=$P(PRCHPONO,"-") S PRCHIEN=DA
        S PRCX=$O(^PRC(411,PRC("SITE"),1,0)) S:$G(PRCX)]"" PRCY=$P($G(^PRC(411,PRC("SITE"),1,PRCX,0)),U) K PRCX
        S DA=PRCHPO
        D DOCID
        S PRC31=PRCSITE
        S DA=PRCHPO
        S DIE="^PRC(442,"
        S PRC48="S"
        S PRC54="N"
        S PRC5="SIMPLIFIED"
        S PRC1="T"
        S PRCHP=^PRC(440.5,PRCHXXX,0),PRCHFCP=$P(PRCHP,U,2),PRCHCC=$P(PRCHP,U,3),PRCHBOC1=$P(PRCHP,U,4),PRCHDLOC=$P(PRCHP,U,7),PRCHCD=$P(PRCHP,U),PRCHCDNO=PRCHXXX,PRCHHLDR=$P(PRCHP,U,8)
TST     S DR="16////^S X=DUZ;56////^S X=DUZ;.02///^S X=25;48///^S X=PRC48;63///^S X=1;54///^S X=PRC54;31////^S X=PRC31;S SUB=X" D ^DIE
        I $D(SUB) S PRCX=$O(^PRC(411,SUB,1,0)) S:$G(PRCX)]"" PRCY=$P($G(^PRC(411,SUB,1,PRCX,0)),U) K PRCX
        S DR="46////^S X=PRCHXXX;61////^S X=PRCHHLDR" D ^DIE
        S PRCHCDNO=$P($G(^PRC(442,DA,23)),U,8)
        S DR="55///^S X=PRCHCD;.1///^S X=PRC1;53////^S X=PRCHVEN;5////^S X=PRCHVEN" D ^DIE
        S TDATE=$$DATE^PRC0C($P($G(^PRC(442,DA,1)),"^",15),"I"),PRC("FY")=$E(TDATE,3,4)
        S PRCBBFY=$$BBFY^PRCSUT(PRCSITE,PRC("FY"),PRCHFCP,1),PRC("BBFY")=PRCBBFY
        S DR="1///^S X=PRCHFCP" D ^DIE
        S PRCHN("SFC")=$P(^PRC(442,DA,0),U,19)
        S DR="26///^S X=PRCBBFY;2///^S X=PRCHCC;5.4///^S X=PRC5"
        D ^DIE
        S PRCPROST=1.9
        L -^PRC(442,PRC442)
        K DIE,DA,DLAYGO,DR,PRCBBFY,PRCHCC,PRCHCD,PRCHCDNO,PRCHDLOC,PRCHFCP,PRCHHLDR,PRCHIEN,PRCHNEW,PRCHP,PRCHPONO,PRCHSTN,PRCHX,PRCLO,PRCN,PRCNEXT,PRCNEXT1
        K PRCPO,PRCY,PRX,PRZ,RMPRCIEN,RMPRFCP,X,PRCSTPO,PRCUPBO,PRC1,PRC442,PRC4426,PRC5,PRC54,PRC48,PRC31,SUB,TDATE,PRCROBL
        Q
        ;
NUM     ;check next number and set the PO to 6 places.
        ;
        S PRCX="",$P(PRCX,"0",6)="",PRCNEXT1=PRCX_PRCNEXT
        S PRCNEXT=$E(PRCNEXT1,$L(PRCNEXT)+$L(PRCPO),$L(PRCNEXT1))
        S PRCROBL=PRCSTPO_PRCNEXT
        Q
        ;
DOCID   S PRZ=$P($P(^PRC(442,PRCHPO,0),U,1),"-",2) Q:$L(PRZ)'=6  F I=1:1:6 S PRX=$E(PRZ,I,I) Q:+PRX=PRX
        I +PRX=PRX S $P(^PRC(442,PRCHPO,18),"^",3)=$S(I=1:$E(PRZ,2,6),1:$E(PRZ,1,I-1)_$E(PRZ,I+1,6))
        Q
