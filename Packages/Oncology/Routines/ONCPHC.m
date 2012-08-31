ONCPHC  ;Hines OIFO/GWB - OTHER CANCER (165.5,148) ;05/31/02
        ;;2.11;ONCOLOGY;**33,36,50**;Mar 07, 1995;Build 29
        ;
PHCDEF  ;OTHER CANCER (165.5,148) defaults
        S SEQNO=+$P(^ONCO(165.5,D0,0),U,6)
        S PHCDEF="No"
        S PHCDEF(1)="NOT APPLICABLE"
        S PHCDEF(2)="NOT APPLICABLE"
        S PHCDEF(3)="NOT APPLICABLE"
        S PHCDEF(4)="NOT APPLICABLE"
        S PRIM=0,PRIMCNT=0
        F  S PRIM=$O(^ONCO(165.5,"C",ONCOD0,PRIM)) Q:PRIM'>0  D
        .I PRIM=D0 Q
        .S PHSEQNO=+$P(^ONCO(165.5,PRIM,0),U,6)
        .I (PHSEQNO>SEQNO)!(PHSEQNO=SEQNO) Q
        .S PRIMCNT=PRIMCNT+1
        .S PHC=$P(^ONCO(165.5,PRIM,0),U,1)
        .S PHCDEF(PRIMCNT)=$P(^ONCO(164.2,PHC,0),U,1)
        .S PHCDEF="Yes"
        S:PHCDEF(1)'="" DIE("PTRIX",165.5,148.1,164.2)="B"
        S:PHCDEF(2)'="" DIE("PTRIX",165.5,148.2,164.2)="B"
        S:PHCDEF(3)'="" DIE("PTRIX",165.5,148.3,164.2)="B"
        S:PHCDEF(4)'="" DIE("PTRIX",165.5,148.4,164.2)="B"
        K SEQNO,PRIM,PRIMCNT,PHSEQNO,PHC Q
        ;
PHCDSP  ;OTHER CANCER (165.5,148) display
        N HDL
        S HDL=$L("Patient Identification"),TAB=(80-HDL)\2,TAB=TAB-1
        W @IOF,DASHES
        W !,?1,PATNAM,?TAB,"Patient Identification",?SITTAB,SITEGP
        W !,?1,SSN,?TOPTAB,TOPNAM," ",TOPCOD
        W !,DASHES
        W !," OTHER CANCER"
        W !," ------------"
        N DI,DIC,DR,DA,DIQ,ONC
        S DIC="^ONCO(165.5,"
        S DR="148:148.4"
        S DA=D0,DIQ="ONC" D EN^DIQ1
        S X=ONC(165.5,D0,148) D UCASE S ONC(165.5,D0,148)=X
        W !," Other Cancer...................: ",ONC(165.5,D0,148)
        W !," Cancer #1......................: ",ONC(165.5,D0,148.1)
        W !," Cancer #2......................: ",ONC(165.5,D0,148.2)
        W !," Cancer #3......................: ",ONC(165.5,D0,148.3)
        W !," Cancer #4......................: ",ONC(165.5,D0,148.4)
        W !,DASHES
        Q
        ;
UCASE   S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        Q
