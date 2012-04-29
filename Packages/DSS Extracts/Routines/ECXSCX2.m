ECXSCX2 ;ALB/ESD  DSS Clinic Extract Utilities (continued) ; 6/5/2007
        ;;3.0;DSS EXTRACTS;**39,46,49,71,84,92,105**;Dec 22, 1997;Build 70
        ;
        ;
INTPAT  ;initialize patient variables
        S (ECXSSN,ECXPNM,ECPTPR,ECCLAS,ECPTNPI,ECASPR,ECCLAS2,ECASNPI,ECXZIP)=""
        S (ECPTTM,ECXVET,ECXRACE,ECXENRL,ECXMPI,ECXSEX)=""
        S (ECXDOB,ECXELIG,ECXPST,ECXPLOC,ECXRST,ECXAST,ECXMST,ECXSTATE)=""
        S (ECXCNTY,ECXATYP,ECXPVST,ECXMTST,ECXEST,ECXECE,ECXHNC)=""
        Q
        ;
PAT1(ECXDFN,ECXDATE,ECXERR)         ;get patient demographic data
        N ECXPAT,K,OK,X
        S ECXERR=0
        S OK=$$PAT^ECXUTL3(ECXDFN,$P(ECXDATE,"."),"1;2;3;4;5",.ECXPAT)
        I 'OK S ECXERR=1 Q
        S ECXSSN=ECXPAT("SSN"),ECXPNM=ECXPAT("NAME"),ECXMPI=ECXPAT("MPI")
        S ECXSEX=ECXPAT("SEX"),ECXDOB=ECXPAT("DOB"),ECXELIG=ECXPAT("ELIG")
        S ECXVET=ECXPAT("VET"),ECXSVC=ECXPAT("SC%"),ECXRACE=ECXPAT("RACE")
        S ECXPST=ECXPAT("POW STAT"),ECXPLOC=ECXPAT("POW LOC")
        S ECXRST=ECXPAT("IR STAT"),ECXAST=ECXPAT("AO STAT")
        S ECXMST=ECXPAT("MST STAT"),ECXSTATE=ECXPAT("STATE")
        S ECXCNTY=ECXPAT("COUNTY"),ECXZIP=ECXPAT("ZIP")
        S ECXENRL=ECXPAT("ENROLL LOC"),ECXMTST=ECXPAT("MEANS")
        ; changes for 2001
        S ECXPOS=ECXPAT("POS"),ECXPHI=ECXPAT("PHI")
        ;- Agent Orange location
        S ECXAOL=ECXPAT("AOL")
        ;OEF/OIF data
        S ECXOEF=ECXPAT("ECXOEF")
        S ECXOEFDT=ECXPAT("ECXOEFDT")
        I $$ENROLLM^ECXUTL2(ECXDFN)
        ; - Head and Neck Cancer Indicator
        S ECXHNCI=$$HNCI^ECXUTL4(ECXDFN)
        ; - Race and Ethnicity
        S ECXETH=ECXPAT("ETHNIC")
        S ECXRC1=ECXPAT("RACE1")
        ; - Environmental Contaminants
        S ECXEST=ECXPAT("EC STAT")
        ;get emergency response indicator (FEMA)
        S ECXERI=ECXPAT("ERI")
        Q
        ;
PAT2(ECXDFN,ECXDATE)       ;get date specific patient data
        N K,X
        ;get primary care data
        S X=$$PRIMARY^ECXUTL2(ECXDFN,$P(ECXDATE,"."))
        S ECPTTM=$P(X,U),ECPTPR=$P(X,U,2),ECCLAS=$P(X,U,3),ECPTNPI=$P(X,U,4)
        S ECASPR=$P(X,U,5),ECCLAS2=$P(X,U,6),ECASNPI=$P(X,U,7)
        ;get inpatient data
        S X=$$INP^ECXUTL2(ECXDFN,ECXDATE),ECXA=$P(X,U),ECXTS=$P(X,U,3)
        S ECXDOM=$P(X,U,10),ECXADMDT=$P(X,U,4)
        ;- set national patient record flag if exist
        D NPRF^ECXUTL5
        Q
        ;
FILE2(ECXFILE,EC7,ECODE)        ;file record
        N DA,DIK,X S X=""
        F  S X=$O(ECODE(X)) Q:X=""  S ^ECX(ECXFILE,EC7,X)=ECODE(X)
        S DA=EC7,DIK="^ECX("_ECXFILE_"," D IX1^DIK K DIK,DA
        I $D(ZTQUEUED),$$S^%ZTLOAD S QFLG=1
        Q
        ;
CBOC(MDIV)      ;Determine whether patient's facility was CBOC
        N LOCARR,DIC,DR,DIQ,DA,INST,FTYP
        S DIC=40.8,DA=MDIV,DR=".07",DIQ(0)="I",DIQ="LOCARR" D EN^DIQ1
        S INST=$G(LOCARR(40.8,MDIV,.07,"I")) I INST="" Q ""
        K LOCARR S DIC=4,DA=INST,DR="13",DIQ(0)="I",DIQ="LOCARR" D EN^DIQ1
        S FTYP=$G(LOCARR(4,INST,13,"I")) I FTYP="" Q ""
        K LOCARR S DIC=4.1,DA=FTYP,DR=".01",DIQ(0)="I",DIQ="LOCARR" D EN^DIQ1
        Q $S($G(LOCARR(4.1,FTYP,.01,"I"))="CBOC":"Y",1:"")
