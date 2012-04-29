MPIFSEED ;BP/CMC-SEEDING OF A31s TO MPI AND SUB CLEANUP ;FEB 5, 2002
 ;;1.0; MASTER PATIENT INDEX VISTA ;**22,24,27**;30 Apr 99
 ;
 ;CHANGING SEEDING TO SEND X NUMBER OF MESSAGES EACH TIME BACK GROUND
 ; JOB XXX RUNS UNTIL ALL ARE SENT.  KEEPING TRACK OF WHERE WE ARE AT
 ; FOR THE NEXT JOB TO START AT
 ; SEND E-MAIL WHEN FINISH EACH GROUP AND A SITE COMPLETES SEEDING
 ; ALL PATIENTS.
 ;
 ; Intregration Agreement Utilized:
 ;
 ;   ^DPT("AICNL", ^DPT("AICN", ^DPT("AMPIMIS", ^DPT("ASCN2" - #2070
 ;   ^DPT( - #2070
 ;
 ; $O through Patient file (#2) Sending A31 message for any patients
 ; with an active National ICN.
 ;
EN ;
 I $D(^XTMP("MPIF_SEEDING"))&('$D(^XTMP("MPIF_SEEDING","STOPPED"))) Q
 ; ^ Seeding job is already running
 D START
 Q
QUEUE ;
 I $D(^XTMP("MPIF_SEEDING"))&('$D(^XTMP("MPIF_SEEDING","STOPPED"))) Q
 ; ^ Seeding job is already running
 S ZTRTN="START^MPIFSEED",ZTDESC="A31 SEEDING FOR SITE"
 D NOW^%DTC
 S ZTIO="",ZTDTH=%
 I $D(DUZ) S ZTSAVE("DUZ")=DUZ
 D ^%ZTLOAD
 D HOME^%ZIS K IO("Q")
 K ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN,ZTSAVE,ZTSK,%
 Q
 ;
START N ICN,DFN,SSN,CNT,XICN,SITE,ARRAY,ARR,SUB,A31,A31E,NODE,IEN,STOP,MANY
 N OICN,OA31E,OCNT,NODE,STICN
 I $D(ZTQUEUED) S ZTREQ="@"
 I $D(^XTMP("MPIF_SEEDING"))&('$D(^XTMP("MPIF_SEEDING","STOPPED"))) Q
 S (DFN,CNT,XICN,A31E)=0,ARR="ARRAY"
 D NOW^%DTC
 S ^XTMP("MPIF_SEEDING",0)=%+10_"^"_%_"^Seeding MPI w/A31s"
 S ^XTMP("MPIF_SEEDING","STARTED")=%
 I '$D(^DPT("AICN")) S ^XTMP("MPIF_SEEDING","STOPPED")=% Q
 ; ^ No ICNs
 ;GET LAST ICN COMPLETED
 S IEN=$O(^MPIF(984.8,"B","ONE","")),NODE=$G(^MPIF(984.8,IEN,0))
 I $P(NODE,"^",5)'="" S ^XTMP("MPIF_SEEDING","STOPPED")=% Q
 ; ^ SEEDING FINISHED
 S OICN=+$P(NODE,"^",8),OA31E=+$P(NODE,"^",7),OCNT=+$P(NODE,"^",6)
 S ICN=$P(NODE,"^",11),SITE=$P($$SITE^VASITE(),"^",3),STOP=0
 S STICN=+$P(NODE,"^",4) I STICN=0 S STICN=$O(^DPT("AICN","A"),-1)
 S MANY=$P(NODE,"^",9)
 I +MANY<1 S ^XTMP("MPIF_SEEDING","STOPPED")=% Q
 F  S ICN=$O(^DPT("AICN",ICN)) Q:ICN=""!(STOP)  D
 .I ICN=STICN!(ICN>STICN) S STOP=1
 .Q:$E(ICN,1,3)=SITE
 .; ^LOCAL ICN
 .S CNT=CNT+1
 .I '(CNT#10000) W:$E(IOST)="C" !,ICN S ^XTMP("MPIF_SEEDING","LAST")="CNT="_CNT_"^ICN="_ICN_"^SENT="_XICN
 .S DFN=$O(^DPT("AICN",ICN,""))
 .Q:+DFN<1
 .Q:'$D(^DPT(DFN,"MPI"))
 .I $P($G(^DPT(DFN,"MPI")),"^")=ICN S A31=$$A31^MPIFA31B(DFN) S:A31>0 XICN=XICN+1 S:+A31<1 ^XTMP("MPIF_SEEDING","A31 ERR",DFN)=A31,A31E=A31E+1
 .; ^ generate A31 message to MPI
 .I XICN=MANY S STOP=1,$P(NODE,"^",11)=ICN
DONE S ^XTMP("MPIF_SEEDING","TOTAL","PROCESSED")=CNT,$P(NODE,"^",6)=CNT+OCNT
 S ^XTMP("MPIF_SEEDING","TOTAL","A31 SENT")=XICN,$P(NODE,"^",8)=XICN+OICN
 S ^XTMP("MPIF_SEEDING","TOTAL","A31 ERR")=A31E,$P(NODE,"^",7)=A31E+OA31E
 D NOW^%DTC
 S ^XTMP("MPIF_SEEDING","STOPPED")=%
 K %
 I ICN=""!(ICN=STICN)!(ICN>STICN) S $P(NODE,"^",5)="SEEDING COMPLETED" D MAIL("D")
 S ^MPIF(984.8,IEN,0)=NODE
 I $P(NODE,"^",5)="" D MAIL("C")
 Q
 ;
MAIL(STAT) ;
 ;send bulletin that seeding round is complete or seeding has
 ;been completely finished
 ; STAT=
 ;"D" - completely finished
 ;"C" - round finished
 ;
 N MPIF,NODE,IEN,XMDUZ,XMSUB,XMY,XMTEXT,MSG
 S IEN=$O(^MPIF(984.8,"B","ONE",""))
 S NODE=$G(^MPIF(984.8,IEN,0))
 I STAT="D" S MSG="Seeding has been completed at site "_$P($$SITE^VASITE(),"^",2)_" (_"_$P($$SITE^VASITE(),"^",3)_")"
 I STAT="C" S MSG="Round of seeding has been completed at site "_$P($$SITE^VASITE(),"^",2)_" (_"_$P($$SITE^VASITE(),"^",3)_")"
 S MPIF(1,1)=MSG
 S MPIF(1,2)=""
 S MPIF(1,3)="Site stats for seeding (total to date): "
 S MPIF(1,4)="     AICN x-refs Processed:  "_$P(NODE,"^",6)
 S MPIF(1,5)="     A31s Sent:  "_$P(NODE,"^",8)
 S MPIF(1,6)="     A31 Errors: "_$P(NODE,"^",7)
 S XMDUZ="MPIF VISTA PACKAGE"
 S XMSUB="Seeding msg "_$P($$SITE^VASITE(),"^",2)_" ("_$P($$SITE^VASITE(),"^",3)_")"
 S XMY("G.CIRN DEV@FORUM.VA.GOV")="",XMTEXT="MPIF(1,"
 D ^XMD
 Q
 ;
SET(RETURN,NUMBER) ;
 ;
 N IEN,DIE,DA,DR
 S IEN=$O(^MPIF(984.8,"B","ONE","")),RETURN=0
 Q:IEN<1
 S DIE="^MPIF(984.8,",DA=IEN,DR="8////^S X=NUMBER"
 D ^DIE
 S NODE=$G(^MPIF(984.8,IEN,0))
 I $P(NODE,"^",9)=NUMBER S RETURN=1
 Q
 ;
STATS(RETURN) ;
 ;
 N IEN,CNT,TICN,LAST,LONE,SITE
 S SITE=$P($$SITE^VASITE(),"^",3),CNT=0
 S IEN=$O(^MPIF(984.8,"B","ONE","")),RETURN=0
 Q:IEN<1
 S NODE=$G(^MPIF(984.8,IEN,0)),RETURN=1
 I $P(NODE,"^",5)'="" S RETURN(1)=NODE Q
 ;^ QUIT IF COMPLETED SEEDING ALREADY
 S LAST=$P(NODE,"^",11) ;LAST ICN PROCESSED
 I +LAST<1 S LAST=0
 S LONE=$P(NODE,"^",4) ;LAST ICN TO BE PROCESSED
 F  S LAST=$O(^DPT("AICN",LAST)) Q:LAST>LONE  S CNT=CNT+1
 K DIC
 N X,Y,BK,SCH
 S DIC="^DIC(19,",X="MPIF SEEDING TASK" D ^DIC K DIC S BK=+Y
 I BK<0 S RETURN(2)="MPIF SEEDING TASK doesn't exist in OPTION file"
 I BK>0 S DIC="^DIC(19.2,",X="MPIF SEEDING TASK" D ^DIC K DIC S SCH=+Y
 I SCH<0 S RETURN(2)="MPIF SEEDING TASK isn't scheduled to run"
 I SCH>0 S SCH=$$GET1^DIQ(19.2,SCH_",",2),RETURN(2)="MPIF SEEDING TASK is scheduled to run at "_$$FMTE^XLFDT(SCH)
 S RETURN(1)=NODE,RETURN(3)=CNT
 Q
