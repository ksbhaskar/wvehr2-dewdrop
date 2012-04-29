IMRLABSV ; HCIOFO-FAI/ STORE CURRENT LAB VALUES; 06/02/00  04:45
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
START I $G(IMRTSTLR)="" W !!,?13,"** SORRY NO LABORATORY REFERENCE IN PLACE **" Q
 I '$D(^IMR(158.9,1,3,0)) W !!,?13,"SORRY, HIV COORDINATOR HAS NOT SET UP LAB LINKS" Q
 D KILL
 S (IMRTSTI,IMRTSTII)="",ILR=IMRTSTLR
 S LGN="" F  S LGN=$O(^IMR(158.95,"B",LGN)),LIG="" Q:LGN=""  S LIG=$O(^IMR(158.95,"B",LGN,LIG)) Q:LIG=""  D LOCAL,LOCAL2
 Q
LOCAL Q:LGN'="CD4"
 S IMRCD="" F  S IMRCD=$O(^IMR(158.9,1,3,"B",LIG,IMRCD)),IMS="" Q:IMRCD=""  F  S IMS=$O(^IMR(158.9,1,3,IMRCD,1,"B",IMS)),IMLM="" Q:IMS=""  F  S IMLM=$O(^IMR(158.9,1,3,IMRCD,1,"B",IMS,IMLM)) Q:IMLM=""  D LLT
 Q
LOCAL2 Q:LGN'="VIRAL LOAD"
 S IMRCD="" F  S IMRCD=$O(^IMR(158.9,1,3,"B",LIG,IMRCD)),IMS="" Q:IMRCD=""  F  S IMS=$O(^IMR(158.9,1,3,IMRCD,1,"B",IMS)),IMLM="" Q:IMS=""  F  S IMLM=$O(^IMR(158.9,1,3,IMRCD,1,"B",IMS,IMLM)) Q:IMLM=""  D LLT
 Q
LLT S IMLO="" F  S IMLO=$O(^IMR(158.9,1,3,IMRCD,1,IMLM,1,"B",IMLO)),TNN="" Q:IMLO=""  F  S TNN=$O(^IMR(158.9,1,3,IMRCD,1,IMLM,1,"B",IMLO,TNN)) Q:TNN=""  D LWK
 Q
LWK S IMWK=$P($G(^IMR(158.9,1,3,IMRCD,1,IMLM,1,TNN,0)),U,2),LNM=$P($G(^LAB(60,IMLO,0)),U,1),LLOC=$P($G(^LAB(60,IMLO,0)),U,5)
 I LLOC'="" S UNN=$P($G(^LAB(60,IMLO,1,0)),U,3),LDAT=$P(LLOC,";",2) S:UNN'="" UNS=$P($G(^LAB(60,IMLO,1,UNN,0)),U,7) D CHEMS Q
 I LLOC="" D PANEL Q
 Q
PANEL F PN=0:0 S PN=$O(^LAB(60,IMLO,2,PN)) Q:PN'>0  S LPN=$P($G(^LAB(60,IMLO,2,PN,0)),U,1),LNM=$P($G(^LAB(60,LPN,0)),U,1),LLOC=$P($G(^LAB(60,LPN,0)),U,5) D PAN2
 Q
PAN2 S UNN=$P($G(^LAB(60,LPN,1,0)),U,3)
 S:UNN'="" UNS=$P($G(^LAB(60,LPN,1,UNN,0)),U,7)
 S:LLOC'="" LDAT=$P(LLOC,";",2)
 D CHEMS
 Q
CHEMS S LDT="" F  S LDT=$O(^LR(ILR,"CH",LDT)),DNAM="" Q:LDT=""  F  S DNAM=$O(^LR(ILR,"CH",LDT,DNAM)),(LRES,DTRC)="" Q:DNAM=""  S LRES=$P($G(^LR(ILR,"CH",LDT,LDAT)),U,1),DTRC=$P($G(^LR(ILR,"CH",LDT,0)),U,1),Y=DTRC D DD^%DT S DTAA=Y D PLBS
 Q
PLBS S DTR1=$E(DTAA,1,3),DTR2=$E(DTAA,9,12),DTRD=DTR1_","_DTR2
 S LDO=$E(LDT,1,7)
 I LGN="CD4" Q:DNAM'=LDAT  D:UNS'["%" CHRG
 I LGN="CD4" Q:DNAM'=LDAT  D:UNS["%" CHPR
 I LGN="VIRAL LOAD" Q:DNAM'=LDAT  D STORE
 Q
CHRG ; Update CD4 Actual Levels. Called from IMREDIT
 Q:(LRES["CANC")!(LRES["canc")
 Q:(DTRC["CANC")!(DTRC["canc")
 S LCDD=$P($G(^IMR(158,IMRFN,102)),U,2)
 S:DTRC>LCDD $P(^IMR(158,IMRFN,102),U,2)=DTRC,$P(^IMR(158,IMRFN,102),U,1)=LRES
 ;last CD4 value and date ABOVE
 S PLOW=$P($G(^IMR(158,IMRFN,102)),U,5) ;get lowest CD4 value in File 158 for comparison
 S:LRES<PLOW $P(^IMR(158,IMRFN,102),U,5)=LRES,$P(^IMR(158,IMRFN,102),U,6)=DTRC
 D KILL
 Q
CHPR ; Update CD4 Percentage. Called from IMREDIT
 Q:(LRES["CANC")!(LRES["canc")
 Q:(DTRC["CANC")!(DTRC["canc")
 S LOWP=$P($G(^IMR(158,IMRFN,112)),U,9)
 Q:LRES<LOWP
 S $P(^IMR(158,IMRFN,112),U,9)=LRES,$P(^IMR(158,IMRFN,112),U,10)=DTRC
 D KILL
 Q
STORE ; Store viral load data in 113 nodes
 Q:(LRES["CANC")!(LRES["canc")
 Q:(DTRC["CANC")!(DTRC["canc")
 Q:$G(IMLO)=""  S IMRLTEST=IMLO
 I '$D(^IMR(158,IMRFN,113,"B",IMRLTEST)) D  ;add viral test results if that test not in field 113
 .K DA,DD,DO
 .S:'$D(^IMR(158,IMRFN,113,0)) DIC("P")=$P(^DD(158,122,0),U,2)
 .S X=IMRLTEST,DA(1)=IMRFN,DIC="^IMR(158,IMRFN,113,",DIC(0)="L"
 .D FILE^DICN
 .K DD,DO
 .Q:Y'>0
 .S DA=+Y
 .S DA(1)=IMRFN,DIE="^IMR(158,IMRFN,113,",DR="1////"_LRES_";2////"_DTRC_";3////"_LRES_";4////"_DTRC
 .D ^DIE
 .Q
 S IMRVLIEN=$O(^IMR(158,IMRFN,113,"B",IMRLTEST,0)) Q:'IMRVLIEN
 S IMRLNODE=$G(^IMR(158,IMRFN,113,IMRVLIEN,0)) Q:IMRLNODE=""
 I LRES>$P(IMRLNODE,U,2) S $P(IMRLNODE,U,2)=LRES,$P(IMRLNODE,U,3)=DTRC ;save the highest score and its date/time
 I DTRC>$P(IMRLNODE,U,5) S $P(IMRLNODE,U,4)=LRES,$P(IMRLNODE,U,5)=DTRC ;save most recent date/time and its value
 S ^IMR(158,IMRFN,113,IMRVLIEN,0)=IMRLNODE ;update global node
 D KILL
 Q
KILL ; kill variables
 K CDAR,CDP,D,D(0),D0,DA,D1,DN,HVR,ILR,IMDATE,IMRANS,IMRCD,IMRCD4,IMRCD4D,IMRCD4E,IMRCD4X,IMRCDX,IMRCDXD,IMRDFN,IMREDIT,IMRESULT,IMRLOOP,IMRPN,X,Y
 K IMRLNODE,IMRLTEST,IMRP103,IMRSTN,IMRTSTI,IMRTSTII,IMRVLIEN,IMRXCAT,IMS,IMWK,LCDD,LDO,LDT,LIG,LLOC,LNM,MDT,PLOW,RC,TNN,UNN,UNS
 Q
