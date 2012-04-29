PSSP130  ;BIR/RJS-REINDEX "VAC" X-REFERENCE ON DRUG FILE (#50)
        ;;1.0; PHARMACY DATA MANAGEMENT;**130**;9/30/97;Build 6
        ;;Reference to $$SETSTR^VALM1 is covered by DBIA #10116
        ;;Reference to $$TRIM^XLFSTR is covered by DBIA #10104
        ;;Reference to ^XMD is covered by DBIA #10070
        ;;
SYN     ;Remove the un wanted spaces from the Pharmacy Orderable Items synonym
        N X
        S PSSIEN=0 F  S PSSIEN=$O(^PS(50.7,PSSIEN)) Q:'PSSIEN  D
        .S PSSSYN=0 F  S PSSSYN=$O(^PS(50.7,PSSIEN,2,PSSSYN)) Q:'PSSSYN  D
        ..S PSSNM=$G(^PS(50.7,PSSIEN,2,PSSSYN,0))
        ..S PSSLEN=$L(PSSNM) S PSSNAM=$$TRIM^XLFSTR(PSSNM,," ")
        ..I $L(PSSNAM)<$L(PSSNM) S ^TMP($J,"PSSP130-1",PSSIEN,PSSSYN)=PSSNAM
        S PSSIEN=0
        S XMSUB="PSS*1*130 Pharmacy Orderable Item Synonym Repair Report"
        S ^TMP($J,"PSSP130",1)="PSS*1*130 Pharmacy Orderable Item Synonym Repair"
        S ^TMP($J,"PSSP130",2)="The following Orderable Items contained leading/trailing spaces"
        S ^TMP($J,"PSSP130",3)=""
        I '$D(^TMP($J,"PSSP130-1")) S ^TMP($J,"PSSP130",4)="No multiple indexs found.",^TMP($J,"PSSP130",5)="",PSSCNT=5 D MAIL G VAC
        S X="" D TXT("ORDERABLE ITEM",1),TXT("IEN",40),TXT("SYNONYM",48)
        S ^TMP($J,"PSSP130",4)=X,^TMP($J,"PSSP130",5)="",PSSCNT=5
        S PSSIEN=0 F  S PSSIEN=$O(^TMP($J,"PSSP130-1",PSSIEN)) Q:'PSSIEN  D
        .S PSSSYN=0 F  S PSSSYN=$O(^TMP($J,"PSSP130-1",PSSIEN,PSSSYN)) Q:'PSSSYN  D
        ..N DIE,DA,DR
        ..S PSSNM=$G(^TMP($J,"PSSP130-1",PSSIEN,PSSSYN)),DA(1)=PSSIEN,DA=PSSSYN
        ..S DIE="^PS(50.7,"_DA(1)_","_2_",",DR=".01////^S X=PSSNM" D ^DIE
        ..S X="" D TXT($P(^PS(50.7,PSSIEN,0),"^"),1),TXT(PSSIEN,40),TXT(PSSNM,48)
        ..S PSSCNT=PSSCNT+1,^TMP($J,"PSSP130",PSSCNT)=X
        S PSSCNT=PSSCNT+1,^TMP($J,"PSSP130",PSSCNT)=""
        D MAIL
        ;
VAC     ; Re_index VAC cross-reference.
        S PSSVAC=""
        F  S PSSVAC=$O(^PSDRUG("VAC",PSSVAC)) Q:'PSSVAC  D
        .S PSSIEN=""
        .F  S PSSIEN=$O(^PSDRUG("VAC",PSSVAC,PSSIEN)) Q:'PSSIEN  S ^TMP($J,"PSSP130-1",PSSIEN,PSSVAC)=$P(^PS(50.605,PSSVAC,0),"^",1)
        S PSSIEN=""
        F  S PSSIEN=$O(^TMP($J,"PSSP130-1",PSSIEN)) Q:'PSSIEN  D
        .S PSSCNT=0,PSSVAC=""
        .F  S PSSVAC=$O(^TMP($J,"PSSP130-1",PSSIEN,PSSVAC)) Q:'PSSVAC  S PSSCNT=PSSCNT+1,^TMP($J,"PSSP130-1",PSSIEN)=PSSCNT
        S PSSIEN=""
        F  S PSSIEN=$O(^TMP($J,"PSSP130-1",PSSIEN)) Q:'PSSIEN  K:$G(^TMP($J,"PSSP130-1",PSSIEN))<2 ^TMP($J,"PSSP130-1",PSSIEN)
        F  S PSSIEN=$O(^TMP($J,"PSSP130-1",PSSIEN)) Q:'PSSIEN  D
        .S PSSVAC=""
        .F  S PSSVAC=$O(^TMP($J,"PSSP130-1",PSSIEN,PSSVAC)) Q:'PSSVAC  D
        ..K:$D(^PSDRUG("VAC",PSSVAC,PSSIEN)) ^PSDRUG("VAC",PSSVAC,PSSIEN)
        .S DA=PSSIEN,DIK="^PSDRUG(",DIK(1)="25"
        .D EN^DIK K DA,DIK
        S XMSUB="PSS*1*130 Re-index the Drugs VAC report"
        S ^TMP($J,"PSSP130",1)="PSS*1*130 Re-index - VAC - Drugs to VA Drug Class"
        S ^TMP($J,"PSSP130",2)="The following Drug(s) had multiple VAC indexs"
        S ^TMP($J,"PSSP130",3)=""
        I '$D(^TMP($J,"PSSP130-1")) S ^TMP($J,"PSSP130",4)="No multiple indexs found.",^TMP($J,"PSSP130",5)="",PSSCNT=5 G MAIL
        S X="" D TXT("-- VA Drug Class --",50)
        S ^TMP($J,"PSSP130",4)=X
        S X="" D TXT("Drug Name",1),TXT("DRG#",40),TXT("Multiple",48),TXT("Re-indexed",61)
        S ^TMP($J,"PSSP130",5)=X
        S PSSIEN="",PSSCNT=5
        F  S PSSIEN=$O(^TMP($J,"PSSP130-1",PSSIEN)) Q:'PSSIEN  D
        .S X="" D TXT($P(^PSDRUG(PSSIEN,0),"^",1),1),TXT(PSSIEN,40)
        .S PSSVAC="",PSSFLG=0
        .F  S PSSVAC=$O(^PSDRUG("VAC",PSSVAC)) Q:'PSSVAC  D
        ..S:$D(^PSDRUG("VAC",PSSVAC,PSSIEN)) ^TMP($J,"PSSP130-1",PSSIEN)=$P(^PS(50.605,PSSVAC,0),"^",1)
        .S PSSVACO="" F  S PSSVACO=$O(^TMP($J,"PSSP130-1",PSSIEN,PSSVACO)) Q:'PSSVACO  D
        ..D TXT($G(^TMP($J,"PSSP130-1",PSSIEN,PSSVACO)),50) D:'PSSFLG TXT($G(^TMP($J,"PSSP130-1",PSSIEN)),64)
        ..S PSSFLG=1,PSSCNT=PSSCNT+1,^TMP($J,"PSSP130",PSSCNT)=X,X=""
        .S PSSCNT=PSSCNT+1,^TMP($J,"PSSP130",PSSCNT)=""
MAIL    N DIFROM
        S PSSCNT=PSSCNT+1,^TMP($J,"PSSP130",PSSCNT)="***** End Of Report *****"
        S XMTEXT="^TMP($J,""PSSP130"",",XMDUZ="PSS*1*130 Post Install"
        S XMY(DUZ)=""
        D ^XMD
EXIT    ; CLEAN UP
        K ^TMP($J),PSSCNT,PSSFLG,PSSIEN,PSSVAC,PSSVACO,XMDUZ,XMSUB,XMTEXT,XMY,PSSSYN,PSSNM,PSSLEN,PSSNAM
        Q
TXT(VAL,COL)    S:'$D(X) X="" S X=$$SETSTR^VALM1(VAL,X,COL,$L(VAL))
        Q
