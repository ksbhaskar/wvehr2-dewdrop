PXAIPOVV        ;ISL/JVS,SCK - VALADATE DIAGNOSIS ;6/6/96  07:40
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**121,194**;Aug 12, 1996;Build 2
        ;
VAL     ;--VALIDATE ENOUGH DATA
        ;----Missing a pointer to PROCEDURE(CPT) name
        I $G(PXAA("DIAGNOSIS"))']"" D  Q:$G(STOP)
        .S STOP=1 ;--USED TO STOP DO LOOP
        .S PXAERRF=1 ;--FLAG INDICATES THERE IS AN ERR
        .S PXADI("DIALOG")=8390001.001
        .S PXAERR(9)="DIAGNOSIS"
        .S PXAERR(11)=$G(PXAA("DIAGNOSIS"))
        .S PXAERR(12)="You are missing a pointer to the DIAGNOSIS FILE#80 that represents the diagnosises name"
        ;
        ;----NOT a pointer to PROCEDURE CPT FILE#80
        I $$ICDDX^ICDCODE($G(PXAA("DIAGNOSIS")))'>0,$G(PXAA("DELETE"))'=1 D  Q:$G(STOP)
        .S STOP=1
        .S PXAERRF=1
        .S PXADI("DIALOG")=8390001.001
        .S PXAERR(9)="DIAGNOSIS"
        .S PXAERR(11)=$G(PXAA("DIAGNOSIS"))
        .S PXAERR(12)=PXAERR(11)_" is NOT a pointer value to the CPT FILE #80"
        ;
        ;----not a valid ICD9 code
        I $P($$ICDDX^ICDCODE(PXAA("DIAGNOSIS"),+^AUPNVSIT(PXAVISIT,0)),"^",10)'=1 D  Q:$G(STOP)
        .S STOP=1
        .S PXAERRF=1
        .S PXADI("DIALOG")=8390001.001
        .S PXAERR(9)="DIAGNOSIS"
        .S PXAERR(11)=$G(PXAA("DIAGNOSIS"))
        .S PXAERR(12)=PXAERR(11)_" is NOT an valid ICD9 code"
        ;
        ;
        Q
