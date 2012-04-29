OCXDI01Y ;SLC/RJS,CLA - OCX PACKAGE DIAGNOSTIC ROUTINES ;SEP 7,1999 at 10:30
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;
 D DOT^OCXDIAG
 ;
 ;
 K REMOTE,LOCAL,OPCODE,REF
 F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
 .S ^TMP("OCXDIAG",$J,$O(^TMP("OCXDIAG",$J,"A"),-1)+1)=TEXT
 ;
 G ^OCXDI01Z
 ;
 Q
 ;
DATA ;
 ;
 ;;R^"863.3:","863.32:2",.01,"E"
 ;;D^OCXO HL7 SEGMENT ID
 ;;R^"863.3:","863.32:3",.01,"E"
 ;;D^OCXO VT-BAR PIECE NUMBER
 ;;R^"863.3:","863.32:4",.01,"E"
 ;;D^OCXO UP-ARROW PIECE NUMBER
 ;;R^"863.3:","863.32:4",1,"E"
 ;;D^1
 ;;R^"863.3:","863.32:5",.01,"E"
 ;;D^OCXO DATA DRIVE SOURCE
 ;;R^"863.3:","863.32:5",1,"E"
 ;;D^HL7
 ;;R^"863.3:","863.32:6",.01,"E"
 ;;D^OCXO FILE POINTER
 ;;EOR^
 ;;KEY^863.3:^PATIENT.LAB_SPECIMEN
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.LAB_SPECIMEN
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.04,"E"
 ;;D^HL7
 ;;R^"863.3:",.05,"E"
 ;;D^LAB SPECIMEN
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^OCXO VARIABLE NAME
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^OCXODATA("OBR",15)
 ;;R^"863.3:","863.32:2",.01,"E"
 ;;D^OCXO HL7 SEGMENT ID
 ;;R^"863.3:","863.32:3",.01,"E"
 ;;D^OCXO VT-BAR PIECE NUMBER
 ;;R^"863.3:","863.32:4",.01,"E"
 ;;D^OCXO UP-ARROW PIECE NUMBER
 ;;R^"863.3:","863.32:4",1,"E"
 ;;D^1
 ;;R^"863.3:","863.32:5",.01,"E"
 ;;D^OCXO DATA DRIVE SOURCE
 ;;R^"863.3:","863.32:5",1,"E"
 ;;D^HL7
 ;;R^"863.3:","863.32:6",.01,"E"
 ;;D^OCXO SEMI-COLON PIECE NUMBER
 ;;R^"863.3:","863.32:6",1,"E"
 ;;D^2
 ;;R^"863.3:","863.32:7",.01,"E"
 ;;D^OCXO FILE POINTER
 ;;R^"863.3:","863.32:7",1,"E"
 ;;D^62
 ;;EOR^
 ;;KEY^863.3:^PATIENT.HL7_LAB_LOCAL_TEST
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.HL7_LAB_LOCAL_TEST
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.04,"E"
 ;;D^HL7
 ;;R^"863.3:",.05,"E"
 ;;D^LAB TEST NAME
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^OCXO VARIABLE NAME
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^OCXODATA("OBX",3)
 ;;R^"863.3:","863.32:2",.01,"E"
 ;;D^OCXO HL7 SEGMENT ID
 ;;R^"863.3:","863.32:3",.01,"E"
 ;;D^OCXO VT-BAR PIECE NUMBER
 ;;R^"863.3:","863.32:4",.01,"E"
 ;;D^OCXO UP-ARROW PIECE NUMBER
 ;;R^"863.3:","863.32:4",1,"E"
 ;;D^5
 ;;R^"863.3:","863.32:5",.01,"E"
 ;;D^OCXO DATA DRIVE SOURCE
 ;;R^"863.3:","863.32:5",1,"E"
 ;;D^HL7
 ;;EOR^
 ;;KEY^863.3:^PATIENT.RADIOLOGY_PROCEDURE
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.RADIOLOGY_PROCEDURE
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.04,"E"
 ;;D^HL7
 ;;R^"863.3:",.05,"E"
 ;;D^RADIOLOGY PROCEDURE
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^OCXO VARIABLE NAME
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^OCXODATA("OBR",4)
 ;;R^"863.3:","863.32:2",.01,"E"
 ;;D^OCXO HL7 SEGMENT ID
 ;;R^"863.3:","863.32:3",.01,"E"
 ;;D^OCXO VT-BAR PIECE NUMBER
 ;;R^"863.3:","863.32:4",.01,"E"
 ;;D^OCXO UP-ARROW PIECE NUMBER
 ;;R^"863.3:","863.32:4",1,"E"
 ;;D^5
 ;;R^"863.3:","863.32:5",.01,"E"
 ;;D^OCXO DATA DRIVE SOURCE
 ;;R^"863.3:","863.32:5",1,"E"
 ;;D^HL7
 ;;EOR^
 ;;KEY^863.3:^PATIENT.ORDER_PRIORITY(ORC)
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.ORDER_PRIORITY(ORC)
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.04,"E"
 ;;D^HL7
 ;;R^"863.3:",.05,"E"
 ;;D^ORDER PRIORITY
 ;;R^"863.3:",.06,"E"
 ;;D^99
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^OCXO VARIABLE NAME
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^OCXODATA("ORC",7)
 ;;R^"863.3:","863.32:2",.01,"E"
 ;;D^OCXO HL7 SEGMENT ID
 ;;R^"863.3:","863.32:3",.01,"E"
 ;;D^OCXO VT-BAR PIECE NUMBER
 ;;R^"863.3:","863.32:4",.01,"E"
 ;;D^OCXO UP-ARROW PIECE NUMBER
 ;;R^"863.3:","863.32:4",1,"E"
 ;;D^6
 ;;R^"863.3:","863.32:5",.01,"E"
 ;;D^OCXO DATA DRIVE SOURCE
 ;;R^"863.3:","863.32:5",1,"E"
 ;;D^HL7
 ;;R^"863.3:","863.32:6",.01,"E"
 ;;D^OCXO SEMI-COLON PIECE NUMBER
 ;;EOR^
 ;;KEY^863.3:^PATIENT.HL7_ORDER_STATUS
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.HL7_ORDER_STATUS
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.04,"E"
 ;;D^HL7
 ;;R^"863.3:",.05,"E"
 ;;D^ORDER STATUS
 ;;R^"863.3:",.06,"E"
 ;;D^99
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^OCXO VARIABLE NAME
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^OCXODATA("ORC",5)
 ;;R^"863.3:","863.32:2",.01,"E"
 ;;D^OCXO HL7 SEGMENT ID
 ;;R^"863.3:","863.32:3",.01,"E"
 ;;D^OCXO VT-BAR PIECE NUMBER
 ;;R^"863.3:","863.32:4",.01,"E"
 ;;D^OCXO UP-ARROW PIECE NUMBER
 ;;R^"863.3:","863.32:4",1,"E"
 ;;D^1
 ;;R^"863.3:","863.32:5",.01,"E"
 ;;D^OCXO DATA DRIVE SOURCE
 ;;R^"863.3:","863.32:5",1,"E"
 ;;D^HL7
 ;;EOR^
 ;;KEY^863.3:^PATIENT.HL7_REQUEST_STATUS
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.HL7_REQUEST_STATUS
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.04,"E"
 ;;D^HL7
 ;;R^"863.3:",.05,"E"
 ;;D^REQUEST STATUS
 ;;R^"863.3:",.06,"E"
 ;;D^69
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^OCXO VARIABLE NAME
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^OCXODATA("OBR",25)
 ;;R^"863.3:","863.32:2",.01,"E"
 ;;D^OCXO HL7 SEGMENT ID
 ;;R^"863.3:","863.32:3",.01,"E"
 ;;D^OCXO VT-BAR PIECE NUMBER
 ;;R^"863.3:","863.32:4",.01,"E"
 ;;D^OCXO UP-ARROW PIECE NUMBER
 ;;R^"863.3:","863.32:4",1,"E"
 ;;D^1
 ;;R^"863.3:","863.32:5",.01,"E"
 ;;D^OCXO DATA DRIVE SOURCE
 ;;R^"863.3:","863.32:5",1,"E"
 ;;D^HL7
 ;;EOR^
 ;;KEY^863.3:^PATIENT.HL7_LOCAL_OI_TEXT
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.HL7_LOCAL_OI_TEXT
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.04,"E"
 ;;D^HL7
 ;1;
 ;
