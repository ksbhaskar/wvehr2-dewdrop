PSOP288R        ;REPORT FOR PATCH PSO*7.0*288
        ;;7.0;OUTPATIENT PHARMACY;**288**;DEC 2007;Build 17
        ;External reference to File ^PS(55 supported by DBIA 2228
        ;External reference to File ^DPT supported by DBIA 10035
        ;External reference to File ^SC supported by DBIA 10040
        ;
        ;FIND ERRONEOUS RECORDS IN THE PHARMACY PATIENT FILE (#55) AND ALLOW THE USER TO CLEAN THEM UP
        ;
EN      W !!,"CREATING REPORT...",!
        S ZTRTN="QUEUE^PSOP288R",ZTDESC="Erroneous Non-VA Meds Records Report",ZTIO="" D ^%ZTLOAD K IO("Q")
        Q
QUEUE   N PSOPAT,PSONVA,PSONVA0,PSODRG,PSOI,PSOSPC,PSOPATDB,PSOTXT,PSOTEXT,XMY,XMTEXT,XMSUB,XMDUZ,PSOPATI,X,X1,X2,PSOLOC,PSODIV,PSODIVN
        S PSOSPC="",PSODIVN=""
        F PSOI=1:1:20 S $E(PSOSPC,PSOI)=" "
        K ^XTMP("PSOP288") S X1=DT,X2=+90 D C^%DTC S ^XTMP("PSOP288",0)=$G(X)_U_DT_"^Erroneous Pharmacy Pateint File (#55) Non-VA Meds records"
        S PSOPAT=0 F  S PSOPAT=$O(^PS(55,PSOPAT)) Q:'PSOPAT  D
        .S PSONVA=0 F  S PSONVA=$O(^PS(55,PSOPAT,"NVA",PSONVA)) Q:'PSONVA  D
        ..S PSONVA0=$G(^PS(55,PSOPAT,"NVA",PSONVA,0))
        ..I $P(PSONVA0,"^",10)]"",$P(PSONVA0,"^",11)]"" Q
        ..S PSOLOC=$P(PSONVA0,"^",12) I PSOLOC S PSODIV=$P(^SC(PSOLOC,0),"^",15) I PSODIV]"" S PSODIVN=$P($G(^DG(40.8,PSODIV,0)),"^")
        ..S:PSODIVN="" PSODIVN="UNKNOWN"
        ..S PSODRG=+PSONVA0
        ..S ^XTMP("PSOP288",PSODIVN,PSOPAT,PSONVA)=PSODRG_U_$P($G(^PS(50.7,PSODRG,0)),"^")
REP     ;CREATE REPORT - SEND TO USER
        S XMY(DUZ)=""
        S XMDUZ=.5,XMSUB="ERRONEOUS NON-VA MEDS RECORDS IN PHARMACY PATIENT FILE"
        ;
        S PSOTXT=1
        S PSOTEXT(PSOTXT)="REPORT OF ERRONEOUS PHARMACY PATIENT FILE (#55) NON-VA MEDS RECORDS"
        S PSODIVN=0 F  S PSODIVN=$O(^XTMP("PSOP288",PSODIVN)) Q:PSODIVN=""  D
        .S PSOTXT=PSOTXT+1
        .S PSOTEXT(PSOTXT)=""
        .S PSOTEXT(PSOTXT+1)="DIVISION: "_PSODIVN
        .S PSOTEXT(PSOTXT+2)=""
        .S PSOTXT=PSOTXT+2
        .S PSOTEXT(PSOTXT)="IEN - PATIENT NAME",PSOTXT=PSOTXT+1
        .S PSOTEXT(PSOTXT)=$E(PSOSPC,1,3)_"DRUG IEN - DRUG NAME",PSOTXT=PSOTXT+1
        .S PSOTEXT(PSOTXT)="",PSOTXT=PSOTXT+1
        .S PSOPAT=0 F  S PSOPAT=$O(^XTMP("PSOP288",PSODIVN,PSOPAT)) Q:'PSOPAT  D
        ..S PSOPATI=$G(^DPT(PSOPAT,0))
        ..S PSOTEXT(PSOTXT)=PSOPAT_" - "_$P(PSOPATI,U)
        ..S PSOTXT=PSOTXT+1
        ..S PSONVA=0 F  S PSONVA=$O(^XTMP("PSOP288",PSODIVN,PSOPAT,PSONVA)) Q:'PSONVA  D
        ...S PSONVA0=$G(^PS(55,PSOPAT,"NVA",PSONVA,0))
        ...S PSODRG=+PSONVA0
        ...S PSOTEXT(PSOTXT)=$E(PSOSPC,1,3)_$P(PSONVA0,U)_" - "_$P($G(^PS(50.7,PSODRG,0)),U)
        ...S PSOTXT=PSOTXT+1
        I PSOTXT=1 S PSOTEXT(PSOTXT+1)="",PSOTEXT(PSOTXT+2)="NO ERRONEOUS ENTRIES FOUND"
        S XMTEXT="PSOTEXT(" N DIFROM D ^XMD K XMDUZ,XMTEXT,XMSUB
        Q
