PSO227PO ;BIR/SJA-Patch 227 Post Install routine ;11/25/05
 ;;7.0;OUTPATIENT PHARMACY;**227**;DEC 1997
 ;
 ; Reference to ^ORD(101 is supported by DBIA #872
 ; External reference to file 870 is supported by DBIA #1496
 ;
 N CNT,PSOA,PSODT,PSONODE,PSORESN,PSOPRTCL,PSOPRT,SDPRTCL
 ;Set AUTOSTART to Disabled for PSOTPBAAC Logical Link
 N DIE,DR,DIC,DA,X,Y
 K DIC S DIC(0)="X",DIC=870,X="PSOTPBAAC" D ^DIC K DIC
 I +Y>0 K DIE S DA=+Y,DIE=870,DR="4.5////"_0 D ^DIE K DA,DR,DIE
 ;
 D RESCH^XUTMOPT("PSO TPB HL7 EXTRACT","@","","@")
OUT D BMES^XPDUTL("...Placing TPB menu options out of order...")
 ;Disable TPB menu options
 S PSORESN="PLACED OUT OF ORDER BY PSO*7*227"
 D OUT^XPDMENU("PSO TPB HL7 EXTRACT",PSORESN)
 D OUT^XPDMENU("PSO TPB INSTITUTION LETTERS",PSORESN)
 D OUT^XPDMENU("PSO TPB LETTERS PRINTED REPORT",PSORESN)
 D OUT^XPDMENU("PSO TPB PATIENT ENTER/EDIT",PSORESN)
 D OUT^XPDMENU("PSO TPB PATIENT REPORT",PSORESN)
 D OUT^XPDMENU("PSO TPB PATIENT RX REPORT",PSORESN)
 D OUT^XPDMENU("PSO TPB PRINT LETTERS",PSORESN)
 D OUT^XPDMENU("PSO TPB RX ENTRY",PSORESN)
 ;
IACT D BMES^XPDUTL("...Inactivating all active TPB patients...")
 D NOW^%DTC S PSODT=$P(%,".")
 S (PSOA,CNT)=0 F  S PSOA=$O(^PS(52.91,PSOA)) Q:'PSOA  S PSONODE=$G(^(PSOA,0)) I '$P(PSONODE,"^",3)!($P(PSONODE,"^",3)>PSODT) D
 .S DA=PSOA,DIE="^PS(52.91,",DR="2///"_PSODT_";3///10" D ^DIE K DIE,DA,DR
 .S CNT=CNT+1 W:'(CNT#10) "."
 ;
PRTCL ;Unsubscribe the Pharmacy PSO TPB SD SUB protocol from the Scheduling protocol SDAM APPOINTMENT EVENTS
 S SDPRTCL=$O(^ORD(101,"B","SDAM APPOINTMENT EVENTS",0))
 S PSOPRTCL=$O(^ORD(101,"B","PSO TPB SD SUB",0))
 I 'SDPRTCL!'PSOPRTCL Q
 S PSOPRT=$O(^ORD(101,SDPRTCL,10,"B",PSOPRTCL,0)) I 'PSOPRT Q
 K DA,DIK S DA=PSOPRT,DA(1)=SDPRTCL,DIK="^ORD(101,"_DA(1)_",10," D ^DIK K DA,DIK
 Q
