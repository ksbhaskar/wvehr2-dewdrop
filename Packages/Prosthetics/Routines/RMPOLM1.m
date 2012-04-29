RMPOLM1 ;EDS/MDB - HOME OXYGEN LISTMAN CODE ;7/24/98
 ;;3.0;PROSTHETICS;**29,64**;Feb 09, 1996
 ;
 ; RVD - patch 64 - accept & unaccept all patient billing
 ;                   changed PIKSOM TO PIKALL
 Q
EN01 ; -- Edit Patient
 S RTN="EDIT^RMPOPED"
 D COMMON("PIKSOM") K DIR,RTN
 Q
COMMON(PIKRTN) ;
 D FULL^VALM1
 D @PIKRTN Q:$$QUIT  I Y="" S VALMBCK="R" Q
 S:PIKRTN="PIKONE" Y(0)=Y
 M LFNS=Y
 S RMJ=0
 F RMI=0:0 S RMI=RMI+RMJ,RMJ=1 Q:'$D(LFNS(RMI))  F RMZI=1:1 S RMZ=$P(LFNS(RMI),",",RMZI) Q:RMZ=""  D
 . S LFN=RMZ
 . S RMPODFN=$O(@VALMAR@("IDX",LFN,""))
 . D @RTN
 S VALMBCK="R"
 K LFNS,LFN,PIKRTN,RMI,RMJ,RMZ,RMZI
 Q
REDRAW ;
 D CLEAN^VALM10,INIT^RMPOLM,RE^VALM4 K DIR
 Q
EN02 ; -- Edit Billing Transactions
 S RTN="EDIT^RMPOBIL2"
 D COMMON("PIKSOM"),REDRAW K RTN
 Q
EN03 ; -- Accept Transactions
 S RTN="ACCEPT^RMPOBILU"
 D COMMON("PIKALL"),REDRAW K RTN
 Q
EN04 ; -- Unaccept Transactions
 S RTN="UNACCEPT^RMPOBILU"
 D COMMON("PIKALL"),REDRAW K RTN
 Q
EN09 ; -- QUIK EDIT
 S RTN="QUIK^RMPOBIL2"
 D COMMON("PIKSOM"),REDRAW K DIR,RTN
 Q
EN10 ; -- ADD BILLING PATIENT
 D FULL^VALM1 W @IOF D ADD^RMPOBILA H 2
 D REDRAW
 Q
EN11 ; -- DELETE BILLING PATIENT
 S RTN="DEL^RMPOBILA"
 D COMMON("PIKSOM"),REDRAW K DIR,RTN
 Q
EN06 ; -- Display 2319
 S RTN="2319^RMPOBILU"
 D COMMON("PIKONE") K DIR,RTN
 Q
EN07 ; -- Post Transactions
 ;
 K DFNS
 D FULL^VALM1
 D PIKSOM Q:$$QUIT  I Y="" S VALMBCK="R" Q
 S LFNS=Y
 F ZI=1:1:$L(LFNS,",")-1 D
 . S LFN=$P(LFNS,",",ZI)
 . S RMPODFN=$O(@VALMAR@("IDX",LFN,""))
 . S DFNS(RMPODFN)=""
 D POST^RMPOPST0
 D REDRAW
 S VALMBCK="R" K DIR,DFNS,RMPODFN,ZI,LFNS,LFN
 Q
EN08 ; -- Change View
 ;
 K DIR S DIR(0)="SO^A:Accepted;U:Unaccepted;B:Both"
 S DIR("B")="Both"
 S DIR("A")="Which Transactions would you like displayed?"
 D ^DIR Q:(Y="")!$$QUIT
 S DFLAG=Y D REDRAW K DIR
 Q
PIKONE ; ALLOW SELECTION OF 1 ENTRY FROM DISPLAYED ENTRIES
 K DIR S DIR(0)="NO^"_VALMBG_":"_VALMLST D ^DIR
 Q
PIKSOM ; ALLOW SELECTION FROM DISPLAYED ENTRIES
 K DIR S DIR(0)="LO^"_VALMBG_":"_VALMLST D ^DIR
 Q
PIKALL ; ALLOW SELECTION FROM ALL ENTRIES
 K DIR S DIR(0)="LO^1:"_VALMCNT D ^DIR
 Q
QUIT() S QUIT=$D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q QUIT
EQUIT() S QUIT=$D(DTOUT)!$D(Y) Q QUIT
 Q
