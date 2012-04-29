IB20P342 ;DALOI/SS - IB ECME EVNT REPORT ;01/03/2006
 ;;2.0;INTEGRATED BILLING;**342**;21-MAR-94;Build 18
 ;; Per VHA Directive 10-93-142, this routine should not be modified.
 ;;
 Q
 ;
 ;move data from ^XTMP("IBNCPDP-..." to file #366.14
EN ;
 N IBDT,IBRECNO,IBDATE,IBIBDTYP,IBRET,IBTYPE,IBDTIEN,IBCALVAL
 N IBMSG1,IBMSG2
 I +$O(^IBCNR(366.14,0)) D  Q
 . D ERRMSG("Conversion of IB ECME EVNT REPORT data will not be done in this site")
 . D ERRMSG("since data have been already converted in the past.")
 . ;send e-mail about post-install completion
 . S IBMSG1="The conversion of data from the ^XTMP global array into the IB NCPDP"
 . S IBMSG2="EVENT LOG file has been skipped as the data has already been converted."
 . D SNDMAIL("IB*2.0*342 installation has been completed",IBMSG1,IBMSG2)
 S IBDT="IBNCPDP-"
 F  S IBDT=$O(^XTMP(IBDT)) Q:IBDT'["IBNCPDP-"  D
 . S IBRECNO=0
 . S IBDATE=+$P(IBDT,"-",2)
 . D BMES^XPDUTL("Add date: "_IBDATE)
 . S IBDTIEN=$$ADDDATE^IBNCPLOG(IBDATE)
 . I +IBDTIEN=0 D ERRMSG("Cannot create a DATE entry for "_IBDATE)
 . F  S IBRECNO=$O(^XTMP(IBDT,IBRECNO)) Q:+IBRECNO=0  D
 . . ;create node and .01 for events multiple
 . . I '$D(^XTMP(IBDT,IBRECNO,"CALL")) D ERRMSG(" there is no CALL node in ^XTMP") Q
 . . ;Add event (CALL) = ^XTMP(IBDT,IBRECNO,"CALL")
 . . S IBCALVAL=$G(^XTMP(IBDT,IBRECNO,"CALL"))
 . . I $$ADDEVENT(IBDATE,IBRECNO,IBCALVAL)<0 D ERRMSG(" EVENT entry wasn't created for "_IBCALVAL) Q
 . . ;quit if was not created
 . . S IBTYPE=""
 . . ;Loop through fields...
 . . F  S IBTYPE=$O(^XTMP(IBDT,IBRECNO,IBTYPE)) Q:IBTYPE=""  D
 . . . I IBTYPE="CALL" Q  ;was already created
 . . . ;fields general fields (other than IBD)
 . . . I IBTYPE="DEVICE" Q  ;we do not use DEVICE in new file
 . . . I IBTYPE'="IBD" S IBRET=$$GENFLDS(IBDT,IBRECNO,IBTYPE,IBDATE) D:+IBRET=0  Q
 . . . . D ERRMSG(" >"_IBTYPE_":"_$P(IBRET,U,2))
 . . . ;if IBD fields
 . . . S IBIBDTYP=""
 . . . F  S IBIBDTYP=$O(^XTMP(IBDT,IBRECNO,IBTYPE,IBIBDTYP)) Q:IBIBDTYP=""  D
 . . . . ; if Insurance
 . . . . I IBIBDTYP="INS" S IBRET=$$INS(IBDT,IBRECNO,IBDATE) D:+IBRET=0  Q
 . . . . . D ERRMSG(" >>INSURANCE node was not populated")
 . . . . ; other IBD fields
 . . . . S IBRET=$$IBD(IBDT,IBRECNO,IBIBDTYP,IBDATE)
 . . . . D:+IBRET=0 ERRMSG(" >>IBD field "_IBIBDTYP_" was not populated")
 ;send e-mail about conversion completion
 S IBMSG1="The conversion of data from the ^XTMP global array into the IB NCPDP"
 S IBMSG2="EVENT LOG file has successfully completed."
 D SNDMAIL("IB*2.0*342 installation has been completed",IBMSG1,IBMSG2)
 Q
 ;process the fields common for all messages
GENFLDS(IBDT,IBRECNO,IBTYPE,IBDATE) ;
 N IBVAL,IBFLDNO,IBDTIEN,IBRETV
 S IBRETV=0
 S IBVAL=$G(^XTMP(IBDT,IBRECNO,IBTYPE))
 S IBDTIEN=+$O(^IBCNR(366.14,"B",IBDATE,0))
 Q:+IBDTIEN=0 0
 I IBTYPE="CALL" S IBFLDNO=".01" G EDITFLD
 I IBTYPE="DFN" S IBFLDNO=".03" G EDITFLD
 I IBTYPE="JOB" S IBFLDNO=".04" G EDITFLD
 I IBTYPE="TIME" S IBFLDNO=".05" G EDITFLD
 I IBTYPE="USER" S IBFLDNO=".06" G EDITFLD
 I IBTYPE="RESULT" D
 . S IBRETV=+$$FILLFLDS^IBNCPUT1(366.141,".07",IBRECNO_","_IBDTIEN,+IBVAL)
 . S IBRETV=+$$FILLFLDS^IBNCPUT1(366.141,".08",IBRECNO_","_IBDTIEN,$P(IBVAL,U,2))
 Q IBRETV
EDITFLD ;
 Q +$$FILLFLDS^IBNCPUT1(366.141,IBFLDNO,IBRECNO_","_IBDTIEN,IBVAL)
 ;---------
 ;store IBD array data
 ;input:
 ;IBDT -date node as it is in ^XTMP global, i.e. "IBNCPDP-3060214"
 ;IBRECNO -ien in [EVENTS] multiple
 ;IBIBDTYP -type subscript in IBD array (BILL, PAID, RESPONSE, etc)
 ;IBDATE -date
 ;Output:
 ;0 -failure
 ;1^record number - success
 ;
IBD(IBDT,IBRECNO,IBIBDTYP,IBDATE) ;
 N IBVAL,IBFLDNO,IBDTIEN
 S IBVAL=$G(^XTMP(IBDT,IBRECNO,"IBD",IBIBDTYP))
 S IBDTIEN=$O(^IBCNR(366.14,"B",IBDATE,0))
 Q:+IBDTIEN=0 0
 I IBIBDTYP="AUTH #" S IBFLDNO=".11" G EDITIBD
 I IBIBDTYP="BCID" S IBFLDNO=".12" G EDITIBD
 I IBIBDTYP="CLAIMID" S IBFLDNO=".13" G EDITIBD
 I IBIBDTYP="DFN" S IBFLDNO=".14" G EDITIBD
 I IBIBDTYP="DIVISION" S IBFLDNO=".15" G EDITIBD
 I IBIBDTYP="RESPONSE" S IBFLDNO=".16" G EDITIBD
 I IBIBDTYP="REVERSAL REASON" S IBFLDNO=".17" G EDITIBD
 I IBIBDTYP="RTS-DEL" S IBFLDNO=".18" G EDITIBD
 I IBIBDTYP="STATUS" S IBFLDNO=".19" G EDITIBD
 I IBIBDTYP="RX NO" S IBFLDNO=".202" G EDITIBD
 I IBIBDTYP="FILL NUMBER" S IBFLDNO=".203" G EDITIBD
 I IBIBDTYP="DRUG" S IBFLDNO=".204" G EDITIBD
 I IBIBDTYP="NDC" S IBFLDNO=".205" G EDITIBD
 I IBIBDTYP="FILL DATE" S IBFLDNO=".206" G EDITIBD
 I IBIBDTYP="RELEASE DATE" S IBFLDNO=".207" G EDITIBD
 I IBIBDTYP="QTY" S IBFLDNO=".208" G EDITIBD
 I IBIBDTYP="DAYS SUPPLY" S IBFLDNO=".209" G EDITIBD
 I IBIBDTYP="DEA" S IBFLDNO=".21" G EDITIBD
 I IBIBDTYP="FILLED BY" S IBFLDNO=".211" G EDITIBD
 I IBIBDTYP="AO" S IBFLDNO=".401" G EDITIBD
 I IBIBDTYP="CV" S IBFLDNO=".402" G EDITIBD
 I IBIBDTYP="EC" S IBFLDNO=".403" G EDITIBD
 I IBIBDTYP="IR" S IBFLDNO=".404" G EDITIBD
 I IBIBDTYP="MST" S IBFLDNO=".405" G EDITIBD
 I IBIBDTYP="HNC" S IBFLDNO=".406" G EDITIBD
 I IBIBDTYP="SC" S IBFLDNO=".407" G EDITIBD
 I IBIBDTYP="BILL" S IBFLDNO=".301" G EDITIBD
 I IBIBDTYP="BILLED" S IBFLDNO=".302" G EDITIBD
 I IBIBDTYP="PLAN" S IBFLDNO=".303" G EDITIBD
 I IBIBDTYP="COST" S IBFLDNO=".304" G EDITIBD
 I IBIBDTYP="PAID" S IBFLDNO=".305" G EDITIBD
 I IBIBDTYP="CLOSE COMMENT" S IBFLDNO=".306" G EDITIBD
 I IBIBDTYP="CLOSE REASON" S IBFLDNO=".307" G EDITIBD
 I IBIBDTYP="DROP TO PAPER" S IBFLDNO=".308" G EDITIBD
 I IBIBDTYP="RELEASE COPAY" S IBFLDNO=".309" G EDITIBD
 I IBIBDTYP="USER" S IBFLDNO=".31" G EDITIBD
 I IBIBDTYP="PRESCRIPTION" S IBFLDNO=".201" G EDITIBD
 I IBIBDTYP="IEN" S IBFLDNO=".212" G EDITIBD
 Q 0
EDITIBD ;
 Q +$$FILLFLDS^IBNCPUT1(366.141,IBFLDNO,IBRECNO_","_IBDTIEN,IBVAL)
 ;------
 ;
 ; IBD("INS",n,1) = insurance array to bill in n order
 ;                  file 355.3 ien (group)^bin^pcn^payer sheet B1^group id^
 ;                  cardholder id^patient relationship code^
 ;                  cardholder first name^cardholder last name^
 ;                  home plan state^Payer Sheet B2^Payer Sheet B3^
 ;                  Software/Vendor Cert ID^Ins Name^
 ;                  (see RX^IBNCPDP1 for details)
 ;
 ;    ("INS",n,2) = dispensing fee^basis of cost determination^
 ;                  awp or tort rate or cost^gross amount due^
 ;                  administrative fee
 ;
 ;    ("INS",n,3) = group name^insurance phone number^plan ID ;
 ;
INS(IBDT,IBRECNO,IBDATE) ;
 N IBSET1,IBSET2,IBSET3,IBFLDNO,IBDTIEN,IBINSNO,RECNO,IBVAL
 S IBDTIEN=$O(^IBCNR(366.14,"B",IBDATE,0))
 Q:+IBDTIEN=0 0
 S IBINSNO=0
 F  S IBINSNO=$O(^XTMP(IBDT,IBRECNO,"IBD","INS",IBINSNO)) Q:+IBINSNO=0  D
 . S IBSET1=$G(^XTMP(IBDT,IBRECNO,"IBD","INS",IBINSNO,1))
 . S IBSET2=$G(^XTMP(IBDT,IBRECNO,"IBD","INS",IBINSNO,2))
 . S IBSET3=$G(^XTMP(IBDT,IBRECNO,"IBD","INS",IBINSNO,3))
 . ;INS  IBINSNO
 . ;  1  IBSET1
 . ;  2  IBSET2
 . ;  3  IBSET3
 . S RECNO=$$ADDINS^IBNCPLOG(IBDTIEN,IBRECNO)
 . I +RECNO=0 D ERRMSG(" >INSURANCE node was not created") Q
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.02,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,1))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.03,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,2))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.04,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,3))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.05,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,4))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.06,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,5))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.07,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,6))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.08,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,7))
 . ;
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.101,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,8))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.102,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,9))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.103,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,10))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.104,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,11))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.105,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,12))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.106,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,13))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.107,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET1,U,14))
 . ;
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.201,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET2,U,1))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.202,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET2,U,2))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.203,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET2,U,3))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.204,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET2,U,4))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.205,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET2,U,5))
 . ;
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.301,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET3,U,1))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.302,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET3,U,2))
 . I +$$FILLFLDS^IBNCPUT1(366.1412,.303,RECNO_","_IBRECNO_","_IBDTIEN,$P(IBSET3,U,3))
 Q RECNO
 ;
 ;create EVENT entry in #366.14
 ;IBDATE date in FM format
 ;EVNTRECN event recno required
 ;EVNTTYPE event type (value for .01)
 ;returns ien for the event
ADDEVENT(IBDATE,EVNTRECN,EVNTTYPE) ;
 N IBIEN,IBX
 S IBIEN=+$O(^IBCNR(366.14,"B",IBDATE,0))
 I IBIEN=0 Q -1
 Q $$INSITEM^IBNCPUT1(366.141,IBIEN,$$EXT2INT^IBNCPUT1(EVNTTYPE),EVNTRECN)
 ;
DELDATE(IBIEN) ;
 N IBPDA,ERRARR
 S IBPDA(366.14,IBIEN_",",.01)="@"
 D FILE^DIE("","IBPDA","ERRARR")
 I $D(ERRARR) Q "0^"_ERRARR("DIERR",1,"TEXT",1)
 Q 1
 ;
 ;display error message
 ;IBERRMSG - error message text
ERRMSG(IBERRMSG) ;
 D BMES^XPDUTL(IBERRMSG)
 Q
 ;
 ;send mail to the user
SNDMAIL(IBSUBJ,IBMESS1,IBMESS2) ;
 N DIFROM ;IMPORTANT - if you send e-mail from post-install !!!
 N TMPARR,XMDUZ,XMSUB,XMTEXT,XMY
 S TMPARR(1)=""
 S TMPARR(2)=IBMESS1
 S TMPARR(3)=IBMESS2
 S TMPARR(4)=""
 S XMSUB=IBSUBJ
 S XMDUZ="INTEGRATED BILLING PACKAGE"
 S XMTEXT="TMPARR("
 S XMY(DUZ)=""
 D ^XMD
 Q
 ;
 ;IB20P342
