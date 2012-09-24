PXCACPT ;ISL/dee & LEA/Chylton,SCK - Validates & Translates data from the PCE Device Interface into PCE's PXK format for CPTs ;5/24/04 3:51pm
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**27,33,73,121,124,194**;Aug 12, 1996;Build 2
        Q
        ; Variables
        ;   PXCAPROC  Copy of a Procedure node of the PXCA array
        ;   PXCAPRV   Pointer to the provider (200)
        ;   PXCANUMB  Count of the number of CPTs and treatments
        ;   PXCAINDX  Count of the number of procedures for one provider
        ;   PXCAPNAR  Pointer to the provider narrative (9999999.27)
        ;   PXCATRT   Pointer to the Treatment file (9999999.17)
        ;
PROC(PXCA,PXCABULD,PXCAERRS,PXCAEVAL)   ;
        I '$D(PXCA("PROCEDURE")),'PXCAEVAL,$P($G(^PX(815,1,"DI")),"^",1),'$D(^AUPNVCPT("AD",+PXCAVSIT)) S PXCA("WARNING","PROCEDURE",0,0,0)="PROCEDURE data missing" Q
        N PXCAPROC,PXCAPRV,PXCANUMB,PXCAINDX,PXCAITEM,PXCALEN
        N PXCAPNAR,PXCANARC
        S PXCAPRV=""
        S PXCANUMB=1
        F  S PXCAPRV=$O(PXCA("PROCEDURE",PXCAPRV)) Q:PXCAPRV']""  D
        . I PXCAPRV>0 D
        .. I '$$ACTIVPRV^PXAPI(PXCAPRV,PXCADT) S PXCA("ERROR","PROCEDURE",PXCAPRV,0,0)="Provider is not active or valid^"_PXCAPRV
        . I '$T&PXCABULD!PXCAERRS D ANOTHPRV^PXCAPRV(PXCAPRV)
        . S PXCAINDX=0
        . F  S PXCAINDX=$O(PXCA("PROCEDURE",PXCAPRV,PXCAINDX)) Q:PXCAINDX']""  D
        .. N PXCATRT
        .. S PXCANUMB=PXCANUMB+1
        .. S PXCAPROC=$G(PXCA("PROCEDURE",PXCAPRV,PXCAINDX))
        .. I PXCAPROC="" S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,0)="PROCEDURE data missing" Q
        .. S PXCAITEM=$P(PXCAPROC,U,1)
        .. I PXCAITEM]"" D
        ... ;S D=$G(^ICPT(+PXCAITEM,0))
        ... S D=$$CPT^ICPTCOD(+PXCAITEM)
        ... I D<0 S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,1)="CPT code not in File 81^"_PXCAITEM
        ... E  I '(+$$CPTSCREN^PXBUTL(PXCAITEM,+PXCADT)) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,1)="CPT code is INACTIVE^"_PXCAITEM
        .. E  D
        ... S PXCATRT=$O(^AUTTTRT("B",+$P(PXCAPROC,"^",6),""))
        ... S:PXCATRT="" PXCATRT=$O(^AUTTTRT("B","OTHER",""))
        ... I 'PXCATRT S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,6)="Could not get pointer to treatment term^"_$P(PXCAPROC,"^",6)
        .. S PXCAITEM=$P(PXCAPROC,U,2)
        .. I PXCAITEM="" S PXCAITEM=1,$P(PXCAPROC,U,2)=PXCAITEM
        .. I PXCAITEM'>0 S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,2)="CPT Quantity must be > 0^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROC,U,3)
        .. I '(PXCAITEM=""!(PXCAITEM="P")!(PXCAITEM="S")) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,3)="Specification code must be P|S^"_PXCAITEM
        .. S PXCAITEM=+$P(PXCAPROC,U,5)
        .. I PXCAITEM D
        ... ; S D=$G(^ICD9(PXCAITEM,0))
        ... S D=$$ICDDX^ICDCODE(PXCAITEM,PXCADT)
        ... I D="" S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,5)="Associated Primary Diagnosis ICD9 Code not in File 81^"_PXCAITEM
        ... E  I '(+$$ICDDX^ICDCODE(PXCAITEM,+PXCADT)) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,1)="ICD code is INACTIVE^"_PXCAITEM
        .. S PXCAITEM=+$P(PXCAPROC,U,8)
        .. I PXCAITEM D
        ... ; S D=$G(^ICD9(PXCAITEM,0))
        ... S D=$$ICDDX^ICDCODE(PXCAITEM,PXCADT)
        ... I D="" S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,8)="Associated Diagnosis 2 ICD9 Code not in file 80^"_PXCAITEM
        ... E  I '(+$$ICDDX^ICDCODE(PXCAITEM,+PXCADT)) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,8)="Associated Diagnosis 2 ICD9 Code is INACTIVE^"_PXCAITEM
        .. S PXCAITEM=+$P(PXCAPROC,U,9)
        .. I PXCAITEM D
        ... ; S D=$G(^ICD9(PXCAITEM,0))
        ... S D=$$ICDDX^ICDCODE(PXCAITEM,PXCADT)
        ... I D="" S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,9)="Associated Diagnosis 3 ICD9 Code not in file 80^"_PXCAITEM
        ... E  I '(+$$ICDDX^ICDCODE(PXCAITEM,+PXCADT)) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,9)="Associated Diagnosis 3 ICD9 Code is INACTIVE^"_PXCAITEM
        .. S PXCAITEM=+$P(PXCAPROC,U,10)
        .. I PXCAITEM D
        ...  ; S D=$G(^ICD9(PXCAITEM,0))
        ... S D=$$ICDDX^ICDCODE(PXCAITEM,PXCADT)
        ... I D="" S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,10)="Associated Diagnosis 4 ICD9 Code not in file 80^"_PXCAITEM
        ... E  I '(+$$ICDDX^ICDCODE(PXCAITEM,+PXCADT)) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,10)="Associated Diagnosis 4 ICD9 Code is INACTIVE^"_PXCAITEM
        .. S PXCAITEM=+$P(PXCAPROC,U,11)
        .. I PXCAITEM D
        ... ; S D=$G(^ICD9(PXCAITEM,0))
        ... S D=$$ICDDX^ICDCODE(PXCAITEM,PXCADT)
        ... I D="" S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,11)="Associated Diagnosis 5 ICD9 Code not in file 80^"_PXCAITEM
        ... E  I '(+$$ICDDX^ICDCODE(PXCAITEM,+PXCADT)) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,11)="Associated Diagnosis 5 ICD9 Code is INACTIVE^"_PXCAITEM
        .. S PXCAITEM=+$P(PXCAPROC,U,12)
        .. I PXCAITEM D
        ... ; S D=$G(^ICD9(PXCAITEM,0))
        ... S D=$$ICDDX^ICDCODE(PXCAITEM,PXCADT)
        ... I D="" S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,12)="Associated Diagnosis 6 ICD9 Code not in file 80^"_PXCAITEM
        ... E  I '(+$$ICDDX^ICDCODE(PXCAITEM,+PXCADT)) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,12)="Associated Diagnosis 6 ICD9 Code is INACTIVE^"_PXCAITEM
        .. S PXCAITEM=+$P(PXCAPROC,U,13)
        .. I PXCAITEM D
        ... ; S D=$G(^ICD9(PXCAITEM,0))
        ... S D=$$ICDDX^ICDCODE(PXCAITEM,PXCADT)
        ... I D="" S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,13)="Associated Diagnosis 7 ICD9 Code not in file 80^"_PXCAITEM
        ... E  I '(+$$ICDDX^ICDCODE(PXCAITEM,+PXCADT)) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,13)="Associated Diagnosis 7 ICD9 Code is INACTIVE^"_PXCAITEM
        .. S PXCAITEM=+$P(PXCAPROC,U,14)
        .. I PXCAITEM D
        ... ; S D=$G(^ICD9(PXCAITEM,0))
        ... S D=$$ICDDX^ICDCODE(PXCAITEM,PXCADT)
        ... I D="" S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,14)="Associated Diagnosis 8 ICD9 Code not in file 80^"_PXCAITEM
        ... E  I '(+$$ICDDX^ICDCODE(PXCAITEM,+PXCADT)) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,14)="Associated Diagnosis 8 ICD9 Code is INACTIVE^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROC,U,6),PXCALEN=$L(PXCAITEM)
        .. I PXCALEN<2!(PXCALEN>80) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,6)="Provider's PROCEDURE term must be 2-80 Characters^"_PXCAITEM
        .. E  D
        ... S PXCAPNAR=+$$PROVNARR^PXAPI(PXCAITEM,$S($P(PXCAPROC,"^",1)="":9000010.15,1:9000010.18))
        ... I PXCAPNAR'>0 S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,6)="Could not get pointer to Provider's PROCEDURE term^"_$P(PXCAPROC,"^",6) Q:'PXCAERRS
        ... S $P(PXCAPROC,"^",6)=PXCAPNAR
        .. S PXCAITEM=$P(PXCAPROC,U,7),PXCALEN=$L(PXCAITEM)
        .. I PXCALEN>0 D
        ... I PXCALEN<2!(PXCALEN>80) S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,7)="Provider's PROCEDURE grouper must be 2-80 Characters^"_PXCAITEM
        ... E  D
        .... S PXCANARC=+$$PROVNARR^PXAPI(PXCAITEM,$S($P(PXCAPROC,"^",1)="":9000010.15,1:9000010.18))
        .... I PXCANARC'>0 S PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX,7)="Could not get pointer to Provider's PROCEDURE grouper^"_PXCAITEM
        .... E  S $P(PXCAPROC,"^",7)=PXCANARC
        .. I PXCABULD&'$D(PXCA("ERROR","PROCEDURE",PXCAPRV,PXCAINDX))!PXCAERRS D
        ... I $P(PXCAPROC,"^",1)]"" D
        .... D CPT^PXCACPT1(.PXCA,PXCAPROC,PXCANUMB,PXCAPRV,PXCAINDX,PXCAERRS)
        ... E  D TRT^PXCATRT(PXCAPROC,PXCANUMB,PXCAPRV,PXCAINDX,PXCAERRS,PXCATRT)
        Q
        ;
