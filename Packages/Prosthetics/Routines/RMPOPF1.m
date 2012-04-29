RMPOPF1 ;HINES-FO/DDA - (CONT.)MAIN INTERFACE ROUTINE FOR PFSS AND HOME OXYGEN ;8/18/05
 ;;3.0;PROSTHETICS;**98**;Feb 09, 1996
 Q
CHARGE ; Called from RMPOPST3 via CHARGE^RMPOPF
 ;IMPORTANT VARIBLES PASSED IN FROM RMPOPST3
 ; D6I= FILE 660 IEN
 ; RMPOXITE= FILE 665.72 SITE (IEN)
 ; RMPODATE= FILE 665.72 BILLING MONTH mult IEN
 ; RMPOVDR= FILE 665.72 VENDOR mult IEN (DINUM to 440)
 ; DFN= FILE 665.72 PATIENT mult IEN (DINUM to 2)
 ; ITM= FILE 665.72 ITEM mult IEN
 ; TRXDT= Date TRX Built
 ; ITMD= Item multiple zero node
 ;
 ;Set variables
 S RMPRDFN=DFN
 S RMPRITEM=0
 S RMPRITEM=$O(^RMPR(665,DFN,"RMPOC","B",$P(ITMD,"^"),RMPRITEM))
 S RMPRPAR=$P($G(^RMPR(665,RMPRDFN,"RMPOC",RMPRITEM,"PFSS")),"^",2)
 S RMPRTYPE="CG"
 S RMPRFT1(4)=TRXDT
 S RMPRFT1(10)=$P(ITMD,"^",7)
 S RMPRFT1(13)=423
 S RMPRSTA=RMPOXITE
 D GETSITE^RMPRPF1
 S RMPRFT1(16)=RMPRHLOC
 S RMPRIEN=DFN D VALIDRX^RMPOPF K RMPRIEN
 S RMPRFT1(21)=$P($G(^RMPR(665,DFN,"RMPOB",RMPRRXI,"PFSS")),"^",2)
 S RMPRFT1(22)=$P(ITMD,"^",5)
 S RMPRHCPC=$P(ITMD,"^",2)
 S RMPRHCDT=TRXDT
 ; INSURE HCPCS IS CODE SET VERSIONED
 D PSASHCPC^RMPOPF
 S RMPRPR1(3)=RMPRVHC
 S RMPRPR1(4)=RMPRTHC
 S RMPRPR1(6)="O"
 ; INSURE ICD9 IS CODE SET VERSIONED
 S RMPRDRG=$P(ITMD,"^",9)
 S:RMPRDRG'="" RMPRDRG=$$STATCHK^ICDAPIU($P($G(^ICD9(RMPRDRG,0)),"^"),TRXDT)
 S:$P(RMPRDRG,"^")=1 RMPRDG1(1,3)=$P(RMPRDRG,"^",2),RMPRDG1(1,6)="F"
 S RMPRZCL=""
 S RMPRPROS(1)=RMPOVDR
 S RMPRUCID=$P($G(^RMPO(665.72,RMPOXITE,1,RMPODATE,1,RMPOVDR,"V",DFN,1,ITM,"PFSS")),"^",2)
 S:RMPRUCID'>0 RMPRUCID=$$GETCHGID^IBBAPI()
 S RMPRFLAG=$$CHARGE^IBBAPI(RMPRDFN,RMPRPAR,RMPRTYPE,RMPRUCID,.RMPRFT1,.RMPRPR1,.RMPRDG1,.RMPRZCL,"","",.RMPRPROS)
 Q:RMPRFLAG=0
 ;STORE RETURN INFO INTO 665.72
 S DA=ITM,DA(1)=DFN,DA(2)=RMPOVDR,DA(3)=RMPODATE,DA(4)=RMPOXITE
 S DIE="^RMPO(665.72,"_DA(4)_",1,"_DA(3)_",1,"_DA(2)_",""V"","_DA(1)_",1,"
 S DR="100///"_RMPRPAR_";101///"_RMPRUCID_";102///"_RMPRFT1(21)
 D ^DIE
 K DA,DIE,DR
 ;STORE RETURN INFO INTO 660
 S DA=D6I
 S DIE="^RMPR(660,"
 S DR="100///"_RMPRPAR_";101///"_RMPRUCID_";102///"_$P($G(^RMPR(660,D6I,1)),"^",4)_";103///"_$P($G(^RMPR(660,D6I,0)),"^",7)_";104///"_$P($G(^RMPR(660,D6I,0)),"^",16)_";106///@;107///@"
 D ^DIE
 K DA,DIE,DR
 ;
 K RMPRDFN,RMPRDG1,RMPRDRG,RMPRFLAG,RMPRFT1,RMPRHCPC,RMPRHLOC,RMPRITEM,RMPRPAR,RMPRPR1,RMPRPROS,RMPRRXDT,RMPRRXI,RMPRSTA,RMPRSTAT,RMPRTYPE,RMPRUCID
 Q
CHRGCRED ; Called when an previously charged item is deleted from 665.72
 ; Variables passed in via TaskMan
 ; RMPRSITE = 665.72 IEN - SITE
 ; RMPRBLDT = 665.723;1 - BILLING MONTH IEN
 ; RMPRVDR = 665.7231;1 - VENDOR IEN (DINUM 440)
 ; RMPRDFN = 665.72319;9 - PATIENT IEN (DINUM 200)
 ; RMPRITEM = 665.723191 - ITEM IEN
 ; RMPRPFSS = DATA FROM THE ITEM'S "PFSS" NODE
 ;
 ;Quit if item data still exists
 Q:$D(^RMPO(665.72,RMPRSITE,1,RMPRBLDT,1,RMPRVDR,"V",RMPRDFN,1,RMPRITEM,0))
 S RMPRFLAG=$$CHARGE^IBBAPI(RMPRDFN,$P(RMPRPFSS,"^",1),"CD",$P(RMPRPFSS,"^",2))
 K RMPRBLDT,RMPRDFN,RMPRFLAG,RMPRITEM,RMPRPFSS,RMPRSITE,RMPRVDR
 Q
