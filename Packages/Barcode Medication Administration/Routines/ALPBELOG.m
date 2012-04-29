ALPBELOG ;OIFO-DALLAS MW,SED,KC - BCBU LOG PROCESSOR ;01/01/03
 ;;3.0;BAR CODE MED ADMIN;**8**;Mar 2004
 ;
 ; This utility processes error log entries from the
 ; ERROR LOG section of the BCMA BACKUP PARAMETERS file
 ;
EN ; -- main entry point for ALPB ERROR LOG
 D EN^VALM("PSB ERROR LOG")
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Listing of data update filing errors (Error Log is in file 53.71)"
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("ALPBELOG",$J)
 S ALPBPARM=+$O(^ALPB(53.71,0))
 I ALPBPARM'>0 D  Q
 .S ^TMP("ALPBELOG",$J,1,0)="BCMA BACKUP PARAMETERS FILE IS NOT SET UP CORRECTLY."
 .K ALPBPARM
 .S VALMCNT=1
 I $O(^ALPB(53.71,"C",""))="" D  Q
 .S ^TMP("ALPBELOG",$J,1,0)="There are no errors in the log."
 .S VALMCNT=1
 ;
 S ALPBLINE=0
 S ALPBIEN=""
 F  S ALPBIEN=$O(^ALPB(53.71,"C",ALPBIEN)) Q:ALPBIEN=""  D
 .I ALPBIEN>0 D CLEAN^ALPBUTL1(ALPBIEN)
 .I ALPBIEN>0&('$D(^ALPB(53.7,ALPBIEN,0))) Q
 .S ALPBPDAT=$G(^ALPB(53.7,ALPBIEN,0))
 .I ALPBPDAT="" S ALPBPDAT="SYSTEM/FILER ERROR^"
 .S ALPBLINE=ALPBLINE+1
 .S ALPBDATA(ALPBLINE,0)=" "_$P(ALPBPDAT,U)
 .I $P(ALPBPDAT,U,2)'="" S ALPBDATA(ALPBLINE,0)=ALPBDATA(ALPBLINE,0)_$P(ALPBPDAT,U,2)
 .S ALPBX=0
 .F  S ALPBX=$O(^ALPB(53.71,"C",ALPBIEN,ALPBX)) Q:'ALPBX  D
 ..S ALPBEIEN=0
 ..F  S ALPBEIEN=$O(^ALPB(53.71,"C",ALPBIEN,ALPBX,ALPBEIEN)) Q:'ALPBEIEN  D
 ...;
 ...M ALPBEDAT=^ALPB(53.71,ALPBPARM,1,ALPBEIEN)
 ...S ALPBLINE=ALPBLINE+1
 ...S ALPBDATA(ALPBLINE,0)="     Log Ref#: "_ALPBEIEN
 ...S ALPBLINE=ALPBLINE+1
 ...S ALPBDATA(ALPBLINE,0)="     Log Date: "_$$FDATE^ALPBUTL($P(ALPBEDAT(0),U))
 ...S ALPBLINE=ALPBLINE+1
 ...S ALPBDATA(ALPBLINE,0)=" Order Number: "_$P($G(^ALPB(53.7,ALPBIEN,2,+$P(ALPBEDAT(0),U,3),0),"<undefined>"),U)
 ...S ALPBLINE=ALPBLINE+1
 ...S ALPBDATA(ALPBLINE,0)="  HL7 Msg IEN: "_$P(ALPBEDAT(0),U,4)
 ...I $G(^HL(772,+$P(ALPBEDAT(0),U,4),0))="" S ALPBDATA(ALPBLINE,0)=ALPBDATA(ALPBLINE,0)_" <--no longer in file 772"
 ...S ALPBLINE=ALPBLINE+1
 ...S ALPBDATA(ALPBLINE,0)="  HL7 Segment: "_$P(ALPBEDAT(0),U,5)
 ...S ALPBLINE=ALPBLINE+1
 ...S ALPBDATA(ALPBLINE,0)=" Segment Data: "
 ...I $D(ALPBEDAT(1)) D
 ....I $L(ALPBEDAT(1))<66 S ALPBDATA(ALPBLINE,0)=ALPBDATA(ALPBLINE,0)_ALPBEDAT(1)
 ....I $L(ALPBEDAT(1))>65&($L(ALPBEDAT(1))<131) D
 .....S ALPBDATA(ALPBLINE,0)=ALPBDATA(ALPBLINE,0)_$E(ALPBEDAT(1),1,65)
 .....S ALPBLINE=ALPBLINE+1
 .....S ALPBDATA(ALPBLINE,0)=$$PAD^ALPBUTL($G(ALPBDATA(ALPBLINE,0)),16)_$E(ALPBEDAT(1),66,130)
 .....I $L(ALPBEDAT(1))>130 D
 ......S ALPBLINE=ALPBLINE+1
 ......S ALPBDATA(ALPBLINE,0)=$$PAD^ALPBUTL($G(ALPBDATA(ALPBLINE,0)),16)_$E(ALPBEDAT(1),130,180)
 ...S ALPBY=0
 ...F  S ALPBY=$O(ALPBEDAT(2,ALPBY)) Q:'ALPBY  D
 ....S ALPBLINE=ALPBLINE+1
 ....S ALPBDATA(ALPBLINE,0)="   Error Code: "_$P(ALPBEDAT(2,ALPBY,0),U)
 ....S ALPBZ=0
 ....F  S ALPBZ=$O(ALPBEDAT(2,ALPBY,1,ALPBZ)) Q:'ALPBZ  D
 .....S ALPBLINE=ALPBLINE+1
 .....S $P(ALPBDATA(ALPBLINE,0)," ",16)=ALPBEDAT(2,ALPBY,1,ALPBZ,0)
 ....K ALPBZ
 ...K ALPBY
 ...S ALPBLINE=ALPBLINE+1
 ...S ALPBDATA(ALPBLINE,0)=""
 ...M ^TMP("ALPBELOG",$J)=ALPBDATA
 ...K ALPBDATA,ALPBEDAT
 ..K ALPBEIEN,ALPBPDAT
 .K ALPBX
 S VALMCNT=ALPBLINE
 K ALPBIEN,ALPBLINE
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("ALPBELOG",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
DELONE ; select and delete a log entry...
 N ALPBPARM,DIR,DIRUT,DTOUT,X,Y
 S ALPBPARM=+$O(^ALPB(53.71,0))
 I ALPBPARM'>0 Q
 S DIR(0)="FAO^1:9999999^K:'$D(^ALPB(53.71,ALPBPARM,1,+X)) X"
 S DIR("A")="Select Log's REF# TO DELETE: "
 S DIR("?")="Select a Log entry by the 'Log Ref#' NUMBER shown in the display"
 D ^DIR K DIR
 I $D(DIRUT) Q
 I +Y>0 D DELERR^ALPBUTL2(+Y)
 D INIT
 Q
 ;
DELALL ; purge all errors from the log...
 N ALPBPARM,ALPBX,DIR,DIRUT,DTOUT,X,Y
 S ALPBPARM=+$O(^ALPB(53.71,0))
 I ALPBPARM'>0 Q
 S DIR(0)="YA"
 S DIR("A")="Are you SURE you wish to purge all Error Log entries? "
 S DIR("B")="NO"
 D ^DIR K DIR
 I $D(DIRUT)!(Y'=1) K DIRUT,DTOUT,X,Y Q
 S ALPBX=0
 F  S ALPBX=$O(^ALPB(53.71,ALPBPARM,1,ALPBX)) Q:'ALPBX  D DELERR^ALPBUTL2(ALPBX)
 D INIT
 Q
