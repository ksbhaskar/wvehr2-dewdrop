PSOQ0595        ;HINES/RMS - TIU OBJECT FOR REMOTE MEDS VIA RDI ; 30 Nov 2007  7:54 AM
        ;;7.0;OUTPATIENT PHARMACY;**294**;DEC 1997;Build 13
        ;
        ;Reference to CKP^GMTSUP supported by DBIA 4231
        ;References to ORRDI1 supported by DBIA 4659
RDI(DFN,TARGET) ;
        ;OBJECT METHOD IS: S X=$$RDI^PSOQ0595(DFN,"^TMP($J,""PSOQRDI"")")
        K @TARGET
        N PSOQHDR,PSOQRET,PSOQMED,PSOQLINE,PSOQQTY,PSOQSIG,PSOQSTAT,PSOQRDI,PSOQDOWN
        G:'$G(DFN) RDIOUT
        S PSOQHDR=$$HAVEHDR^ORRDI1 I '+$G(PSOQHDR) D  G RDIOUT
        . S @TARGET@(1,0)="Remote Data from HDR not available"
        D  G:$G(PSOQDOWN) RDIOUT
        . I $D(^XTMP("ORRDI","OUTAGE INFO","DOWN")) H $$GET^XPAR("ALL","ORRDI PING FREQ")/2
        . I $D(^XTMP("ORRDI","OUTAGE INFO","DOWN")) S PSOQDOWN=1 D
        .. S @TARGET@(1,0)="WARNING: Connection to Remote Data Currently Down"
        D  ;RDI/HDR CALL ENCAPSULATION
        . D SAVDEV^%ZISUTL("PSOQHFS")
        . S PSOQRET=$$GET^ORRDI1(DFN,"PSOO")
        . D USE^%ZISUTL("PSOQHFS")
        . D RMDEV^%ZISUTL("PSOQHFS")
        I PSOQRET=-1 D  G RDIOUT
        . S @TARGET@(1,0)="Connection to Remote Data Not Available"
        I '$D(^XTMP("ORRDI","PSOO",DFN)) D  G RDIOUT
        . S @TARGET@(1,0)="No Remote Data available for this patient"
OBJ     S PSOQLINE=3
        S PSOQMED=0 F  S PSOQMED=$O(^XTMP("ORRDI","PSOO",DFN,PSOQMED)) Q:'+PSOQMED  D
        . S PSOQSTAT=$G(^XTMP("ORRDI","PSOO",DFN,PSOQMED,5,0))
        . Q:"ACTIVE^SUSPENDED"'[PSOQSTAT
        . S @TARGET@(PSOQLINE,0)=$G(^XTMP("ORRDI","PSOO",DFN,PSOQMED,2,0)) D INC
        . S PSOQSIG=$G(^XTMP("ORRDI","PSOO",DFN,PSOQMED,14,0)) D  ;
        .. I $L(PSOQSIG)>60 D  D INC Q
        ... N WORDS,COUNT
        ... S WORDS=$L(PSOQSIG," ")
        ... S @TARGET@(PSOQLINE,0)="Sig: "
        ... F COUNT=1:1:WORDS D
        .... S @TARGET@(PSOQLINE,0)=$G(@TARGET@(PSOQLINE,0))_$P(PSOQSIG," ",COUNT)_" "
        .... I $L(@TARGET@(PSOQLINE,0))>60 D INC S @TARGET@(PSOQLINE,0)="     "
        .. S @TARGET@(PSOQLINE,0)="Sig: "_PSOQSIG D INC
        . S PSOQQTY=$G(^XTMP("ORRDI","PSOO",DFN,PSOQMED,6,0)) S @TARGET@(PSOQLINE,0)="Quantity: "_+$P(PSOQQTY,";")_"    Days Supply: "_$P($P(PSOQQTY,";",2),"D",2) D INC
        . S @TARGET@(PSOQLINE,0)=$G(^XTMP("ORRDI","PSOO",DFN,PSOQMED,10,0))_" refills remaining until "_$G(^XTMP("ORRDI","PSOO",DFN,PSOQMED,7,0)) D INC
        . S @TARGET@(PSOQLINE,0)="Last filled "_$G(^XTMP("ORRDI","PSOO",DFN,PSOQMED,9,0))_" at "_$G(^XTMP("ORRDI","PSOO",DFN,PSOQMED,1,0))_" ("_$S(PSOQSTAT["ACT":"Active",PSOQSTAT["SUSP":"Active/Suspended",1:"Status Unknown")_")" D INC
        . S @TARGET@(PSOQLINE,0)=" " D INC
        I PSOQLINE=3 D  G RDIOUT
        . S @TARGET@(1,0)="No Active Remote Medications for this patient"
        S @TARGET@(1,0)="Active Medications from Remote Data",@TARGET@(2,0)=" "
RDIOUT  Q "~@"_$NA(@TARGET)
INC     S PSOQLINE=$G(PSOQLINE)+1 Q
        ;-----------------------------
ENHS    ;ENTRY POINT OF REMOTE DATA MEDICATIONS AS A HEALTH SUMMARY
        N PSOQHS,PSOQWRT
        Q:'$G(DFN)
        S PSOQHS=$$RDI(DFN,"^TMP($J,""PSOQRDI"")")
        S PSOQWRT=0 F  S PSOQWRT=$O(^TMP($J,"PSOQRDI",PSOQWRT)) Q:'+PSOQWRT  D
        . D CKP^GMTSUP Q:$D(GMTSQIT)
        . W !,^TMP($J,"PSOQRDI",PSOQWRT,0)
        . D CKP^GMTSUP Q:$D(GMTSQIT)
        Q
