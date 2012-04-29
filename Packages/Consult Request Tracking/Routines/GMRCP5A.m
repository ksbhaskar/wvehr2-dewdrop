GMRCP5A ;SLC/DCM,RJS,MA - Print Consult form 513 (Gather Data - TIU Results) ;4/18/01  10:29
 ;;3.0;CONSULT/REQUEST TRACKING;**4,13,12,15,21,22,53**;Dec 27, 1997;Build 3
 ; Patch #21 added PRNTAUDT to this routine.
 ;
PRNT(GMRCIFN,TIUFLG,GMRCQUED,GMRCCPY,GMRCGUI,GMRCAUDT) ;
 ;
 ; Input Arguments:
 ;
 ;  GMRCIFN: IEN of the Consult/Request in file 123
 ;   TIUFLG: Called from TIU ?  1=yes 0=no
 ; GMRCQUED: Queued job ?  1=yes 0=no
 ;  GMRCCPY: Chart Copy ? C=Chart Copy  W=Working Copy  null=Not Applicable
 ;  GMRCGUI: Called from the GUI. (Only produce output in a formatted global.)
 ; GMRCAUDT:  Set to 1 in GMRCUTL1 if NW or DC consult.
 ; ZTIO:      Output device when job is tasked
 ;
 N GMRCSIG,GMRCSDT,GMRCCSIG,GMRCSIGT,GMRCADDS
 I '+$G(IOM) S IOM=80
 ;
 I GMRCGUI D  Q
 . D FORMAT(80)
 . D ASSMBL^GMRCP5C(GMRCGUI,80)
 . F GMRCX="GMRCTIU","RES","MCAR" K ^TMP("GMRCR",$J,GMRCX)
 . K ^TMP("GMRC",$J,"OUTPUT")
 . Q
 ;
 I 'TIUFLG,'GMRCQUED W @IOF I '$$CRT^GMRCP5C,$L($G(IO(0))),'(IO=IO(0)) U IO(0) W !,"PRINTING... "
 ;
 D FORMAT(IOM),ASSMBL^GMRCP5C(IOSL,IOM)
 U IO
 D PRINT^GMRCP5C(IOSL,IOM)
 ;
 I 'TIUFLG,'$$CRT^GMRCP5C U IO(0) D ^%ZISC
 ;
 I $G(GMRCQUED),$G(ZTSK) D KILL^%ZTLOAD
 ;
 F GMRCX="OUTPUT","SF513" K ^TMP("GMRC",$J,GMRCX)
 F GMRCX="GMRCTIU","RES","MCAR" K ^TMP("GMRCR",$J,GMRCX)
 ; If print device (ZTIO) do PRNTAUDT unless there is no GMRCAUDT
 ; GMRCAUDT=1 means print for NW or DC consult
 I $D(ZTIO),$D(GMRCAUDT) D PRNTAUDT(GMRCIFN,ZTIO,GMRCAUDT)
 Q
 ;
PRNTAUDT(GMRCIFN,ZTIO,GMRCAUDT) ; Update the last activity field in 123 and
 ; Processing Activity multiple
 ; Update the activity log to reflect "Printed To:" and the printer
 ; GMRCAUDT=1 indicates the consult is NW or Discontinued
 ; and it should update the audit trail.
 I $G(GMRCAUDT)'=1 K GMRCAUDT  Q
 N GMRCOM,GMRCORNP,GMRCFF,GMRCPA,GMRCAD,GMRCA,DA,DIE
 S GMRCA=22
 S GMRCO=GMRCIFN,GMRCDEV=ZTIO
 S DIE="^GMR(123,",DA=+GMRCO,DR="9////^S X=GMRCA"
 L +^GMR(123,GMRCO):5
 D ^DIE
 L -^GMR(123,GMRCO)
 ;Update activity other than HL7 original msg received
 D AUDIT^GMRCP
 KILL GMRCO,GMRCA,GMRCDEV
 Q
 ;
FORMAT(PAGEWID) ;
 ;
 N %I,CMT,COUNT,D0,DFN,DIC,DIQ2,DR,GLOBAL,GMRC400,GMRCADD,GMRCADDT,GMRCAGE,GMRCCSDT
 N GMRCCTIT,GMRCDFN,GMRCDOB,GMRCDVL,GMRCELIG,GMRCEQL,GMRCERR,GMRCFAC,GMRCFP
 N GMRCFTR,GMRCIPH,GMRCINO,GMRCIRL,GMRCLAST,GMRCMODE,GMRCND,GMRCNDX,GMRCNT,GMRCPG,GMRCPGR,GMRCPNM,GMRCPRNM
 N GMRCPTR,GMRCQSTR,GMRCQSTT,GMRCR0,GMRCR1,GMRCR2,GMRCRB,GMRCRD,GMRCRPT,GMRCSG,GMRCSGAD,GMRCSIGM
 N GMRCSN,GMRCSR,GMRCSVC,GMRCTO,GMRCUL,GMRCWARD,GMRCWLI,GMRCX,LN,MCFILE,MCPROC
 N ND,ND1,ND2,NDS,ORACTION,SEX,TAB,X,Y
 ;
 S GMRCFTR=13,GMRCFP=0,GMRCPG=0
 S GMRCRD=$G(^GMR(123,GMRCIFN,0)),(DFN,GMRCDFN)=$P(GMRCRD,U,2)
 Q:'(DFN)
 D ELIG^VADPT S GMRCELIG=$P(VAEL(6),U,2) K VAEL
 S GMRCDVL="",$P(GMRCDVL,"-",PAGEWID+1)=""
 S GMRCEQL="",$P(GMRCEQL,"=",PAGEWID+1)=""
 S GMRCUL="",$P(GMRCUL,"_",40)=""
 S DFN=GMRCDFN D DEM^GMRCU
 ;
 S GMRCFAC=+$P(GMRCRD,U,21)
 I 'GMRCFAC S GMRCFAC=+$G(DUZ(2))
 I 'GMRCFAC S GMRCFAC=+$$SITE^VASITE()
 I +GMRCFAC S GMRCFAC=$$GET1^DIQ(4,+GMRCFAC,.01)
 E  S GMRCFAC="" Q
 ;
 ; get inter-facility consult info
 I $P(GMRCRD,U,23) D
 .S GMRCINO=$P(GMRCRD,U,22)
 .S GMRCRD(12)=$G(^GMR(123,GMRCIFN,12))
 .S GMRCRD(13)=$G(^GMR(123,GMRCIFN,13))
 .S GMRCIRL=$S($P(GMRCRD(12),U,5)="P":"Requesting facility",$P(GMRCRD(12),U,5)="F":"Consulting facility",1:"")
 ;Commented out following line to allow TIU doc to print based on ASU
 ;rules.
 ;I $P(GMRCRD,U,12)=2!(TIUFLG) D
 D PRINT^GMRCTIUP(GMRCIFN,0,0) ;Removed dot structure
 ;
 K GMRCSG I $D(^TMP("GMRCR",$J,"RES")) D
 .;
 .S GMRCR0=0 F  Q:$D(GMRCSG)  S GMRCR0=$O(^TMP("GMRCR",$J,"RES",GMRCR0)) Q:'GMRCR0  D
 ..F GMRCV="GMRCSDT","GMRCSIG","GMRCSIGM","GMRCSIGT" S @GMRCV=$G(^TMP("GMRCR",$J,"RES",GMRCR0,"TEXT",GMRCV))
 ..Q:'$L($G(GMRCSIG))
 ..F GMRCV="GMRCSDT","GMRCSIG","GMRCSIGM","GMRCSIGT" S GMRCSG(GMRCV)=@GMRCV
 ;
 D INIT^GMRCP5B(.GMRCSG) ; Build Header, Footer, Request, and Primary Diagnosis Segments
 ;
 I $L($G(GMRCCPY)) D
 .D BLD("RES",1,1,0,$$CENTER($S(GMRCCPY="C":"C H A R T   C O P Y",1:"W O R K I N G   C O P Y")))
 I ($P(GMRCRD,U,19)="Y") D
 .D BLD("RES",1,1,0,$$CENTER("******* Significant Findings *******"))
 I ($P(GMRCRD,U,19)="N") D
 .D BLD("RES",1,1,0,$$CENTER("******* No Significant Findings *******"))
 I ($P(GMRCRD,U,19)="U") D
 .D BLD("RES",1,1,0,$$CENTER("******* Unknown Significant Findings *******"))
 ;
 I $P(GMRCRD,U,12)=1  D
 . D BLD("RES",1,2,0,$$CENTER("**** REQUEST CANCELLED    REQUEST CANCELLED ****"))
 I '$D(^TMP("GMRCR",$J,"RES")),'$D(^("MCAR")) D
 .I $L($G(GMRCRPT)) D BLD("RES",1,2,0,$$CENTER(" No Consultation Results for "_GMRCRPT_" available."))
 .I '$L($G(GMRCRPT)) D BLD("RES",1,2,0,$$CENTER(" No Consultation Results available."))
 ;
 I $D(^TMP("GMRCR",$J,"RES")) D
 .;
 .S (GMRCNT,GMRCR0)=0 F  S GMRCR0=$O(^TMP("GMRCR",$J,"RES",GMRCR0)) Q:'GMRCR0  D
 ..N GMRCCSDT,GMRCCSGM,GMRCCSIG,GMRCCTIT,GMRCRPT,GMRCSDT
 ..N GMRCSIG,GMRCSIGM,GMRCSIGT,GMRCV,GMRCENT,GMRCVIS,GMRCVLOC,GMRCNODT
 ..;
 ..F GMRCV="GMRCCSDT","GMRCCSGM","GMRCCSIG","GMRCCTIT","GMRCRPT","GMRCSDT","GMRCSIG","GMRCSIGM","GMRCSIGT","GMRCVIS","GMRCENT","GMRCVLOC","GMRCNODT" D
 ...S @GMRCV=$G(^TMP("GMRCR",$J,"RES",GMRCR0,"TEXT",GMRCV))
 ..;
 ..S GMRCNDX=$O(^TMP("GMRC",$J,"OUTPUT","RES"," "),-1)+1
 ..I $L($G(GMRCRPT)) D SUB("H","RES",GMRCNDX,"Consultation Results "_$S(GMRCR0=.5:"",1:"#"_GMRCR0_" ")_"for "_GMRCRPT_" continued.")
 ..I '$L($G(GMRCRPT)) D SUB("H","RES",GMRCNDX,"Consultation Results "_$S(GMRCR0=.5:"",1:"#"_GMRCR0_" ")_"continued.")
 ..D SUB("H","RES",GMRCNDX," ")
 ..I $L($G(GMRCSIG)) D
 ...D SUB("F","RES",GMRCNDX," ")
 ...I (GMRCSIGM="electronic") S GMRCX=" Results Signature: "_GMRCSIG_" /es/ "_$$EXDT($G(GMRCSDT))
 ...I '(GMRCSIGM="electronic") S GMRCX=" Results Signature: "_GMRCSIG_" /chart/ " S:$L($G(GMRCSDT)) GMRCX=GMRCX_$$EXDT(GMRCSDT)
 ...D SUB("F","RES",GMRCNDX,GMRCX)
 ...D:$L($G(GMRCSIGT)) SUB("F","RES",GMRCNDX,"                    "_GMRCSIGT)
 ..I $L($G(GMRCCSIG)) D
 ...D SUB("F","RES",GMRCNDX," ")
 ...I (GMRCCSGM="electronic") S GMRCX=" Results CoSignature: "_GMRCCSIG_" /es/ "_$$EXDT($G(GMRCCSDT))
 ...I '(GMRCCSGM="electronic") S GMRCX=" Results CoSignature: "_GMRCCSIG_" /chart/ " S:$L($G(GMRCCSDT)) GMRCX=GMRCX_$$EXDT(GMRCCSDT)
 ...D SUB("F","RES",GMRCNDX,GMRCX)
 ...D:$L($G(GMRCCTIT)) SUB("F","RES",GMRCNDX,"                      "_GMRCCTIT)
 ..;extra signers
 .. I $D(^TMP("GMRCR",$J,"RES",GMRCR0,"TEXT","GMRCXTRA")) D
 ... D SUB("F","RES",GMRCNDX," ")
 ... D SUB("F","RES",GMRCNDX," Receipt acknowledged by: ")
 ... N XTRA S XTRA=0 F  S XTRA=$O(^TMP("GMRCR",$J,"RES",GMRCR0,"TEXT","GMRCXTRA",XTRA)) Q:'XTRA  D
 .... D SUB("F","RES",GMRCNDX,^TMP("GMRCR",$J,"RES",GMRCR0,"TEXT","GMRCXTRA",XTRA,0))
 .... D SUB("F","RES",GMRCNDX,^TMP("GMRCR",$J,"RES",GMRCR0,"TEXT","GMRCXTRA",XTRA,1))
 ..;
 ..D BLD("RES",GMRCNDX,1,0," ")
 ..I $L($G(GMRCRPT)) D BLD("RES",GMRCNDX,1,0,$$CENTER("CONSULTATION NOTE "_$S(GMRCR0=.5:"",1:"#"_GMRCR0_" ")_"FOR "_GMRCRPT))
 ..I '$L($G(GMRCRPT)) D BLD("RES",GMRCNDX,1,0,$$CENTER("CONSULTATION NOTE "_$S(GMRCR0=.5:"",1:"#"_GMRCR0)))
 ..D BLD("RES",GMRCNDX,1,0," ")
 ..I $L($G(GMRCENT)) D
 ...S GMRCX="         Entry Date: "_$$EXDT($G(GMRCENT))
 ...D BLD("RES",GMRCNDX,1,0,GMRCX)
 ..I $L($G(GMRCNODT)) D
 ...Q:$$EXDT($G(GMRCNODT))=$$EXDT($G(GMRCENT))
 ...S GMRCX="Date/Time of result: "_$$EXDT($G(GMRCNODT))
 ...D BLD("RES",GMRCNDX,1,0,GMRCX)
 ..I $L($G(GMRCVIS)) D
 ...S GMRCX="              Visit: "_$$EXDT($G(GMRCVIS))
 ...I $L($G(GMRCVLOC)) S GMRCX=GMRCX_"   "_GMRCVLOC
 ...D BLD("RES",GMRCNDX,1,0,GMRCX)
 ..I $L($G(GMRCVLOC)) S GMRCX=GMRCVLOC
 ..D BLD("RES",GMRCNDX,1,0," ")
 ..I $D(^TMP("GMRCR",$J,"RES",GMRCR0,"TEXT",0,0)) D  I 1
 ...D BLD("RES",GMRCNDX,1,0,^TMP("GMRCR",$J,"RES",GMRCR0,"TEXT",0,0))
 ..E  I '$O(^TMP("GMRCR",$J,"RES",GMRCR0,"TEXT","")) D
 ...D BLD("RES",1,1,0,$$CENTER("CONSULTATION NOTE TEXT NOT AVAILABLE"))
 ..S GMRCR1=0 F  S GMRCR1=$O(^TMP("GMRCR",$J,"RES",GMRCR0,"TEXT",GMRCR1)) Q:'GMRCR1  D
 ...D BLD("RES",GMRCNDX,1,0,^TMP("GMRCR",$J,"RES",GMRCR0,"TEXT",GMRCR1,0))
 ..;
 ..;  GET ADDENDUMS TO THIS NOTE
 ..;
 ..I +$O(^TMP("GMRCR",$J,"RES",GMRCR0,"ADD",0)) D ADDEND^GMRCP5D(GMRCIFN,GMRCR0,GMRCNDX,GMRCRD,PAGEWID)
 ;
 D FORMAT^GMRCP5D(GMRCIFN,GMRCRD,PAGEWID) ;  GET SERVICE REPORTS AND COMMENTS
 ;
 Q
 ;
EXDT(X) ;EXTERNAL DATE FORMAT
 ;
 N DATE,TIME,HR,MN,PD,Y,%DT
 Q:'$L(X) ""
 I '(X?7N.1".".6N) S %DT="PTS" D ^%DT S X=Y
 Q $$FMTE^XLFDT(X,"5PMZ")
 ;
CENTER(X) ;
 ;
 N TEXT,COL
 S COL=35-($L(X)\2) Q:(COL<1) X
 S $E(TEXT,COL)=X
 Q TEXT
 ;
BLD(SUB,NDX,LINE,TAB,TEXT,RUNTIME) ;
 ;
 Q:'$L($G(SUB))
 N LINECNT
 ;
 F LINECNT=1:1:+LINE S ^TMP("GMRC",$J,"OUTPUT",SUB,NDX,$$LASTLN(SUB,NDX)+1,0)=""
 ;
 S $E(^TMP("GMRC",$J,"OUTPUT",SUB,NDX,$$LASTLN(SUB,NDX),0),TAB+1)=TEXT
 I $L($G(RUNTIME)) S ^TMP("GMRC",$J,"OUTPUT",SUB,NDX,$$LASTLN(SUB,NDX),1)=RUNTIME
 ;
 S GMRCLAST=SUB
 Q
 ;
SUB(ZONE,SUB,NDX,TEXT) ;
 ;
 N NEXT
 S NEXT=$O(^TMP("GMRC",$J,"OUTPUT",SUB,NDX,ZONE," "),-1)+1
 S ^TMP("GMRC",$J,"OUTPUT",SUB,NDX,ZONE,NEXT,0)=TEXT
 Q
 ;
LASTLN(SUB,NDX) ;
 Q +$O(^TMP("GMRC",$J,"OUTPUT",SUB,NDX," "),-1)
 ;
