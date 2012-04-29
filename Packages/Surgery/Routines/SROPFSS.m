SROPFSS ;BIR/SJA - Surgery/IBB GETACCOUNT API ;01/13/05  9:31 AM
 ;;3.0; Surgery ;**144**;24 Jun 93
 ;
 ; Reference to $$GETACCT^IBBAPI is supported by DBIA #4664
 ; Reference to ^DIC(40.7 is supported by DBIA #557
 ; Reference to ^DG(40.8 is supported by DBIA #2817
 ;
SERR(SRCASE,SRY) ; entry point for routine SROERR & SROERR0.
 I 'SRCASE!('+$$SWSTAT^IBBAPI())!($P($G(^SRF(SRCASE,"NON")),"^")="Y") K ^TMP("SRPFSS",$J) Q
 S SROP=SRCASE,SROPER="" D ^SROP1
 N SRCARFN,SRAPLR,SRDFN,SRDG1,SRDIV,SRGETACC,SRII,SRNODE0,SRPR1,SRPV1,SRPV2,SRRARFN,SRLSS,SRLSSC,SRSURG,SRTMP,SRTP,SRX
 S SRTP="",SRGETACC=$P($G(^SRF(SRCASE,"PFSS")),"^"),SRTMP=$D(^TMP("SRPFSS",$J)) D
 .I SRY="SROERR0" D
 ..I SROPER["(REQUESTED)",SRTMP S SRTP=$S(SRGETACC&$D(SRSCHST):"A11",SRGETACC:"A08",'SRGETACC:"A04",1:"") Q
 ..I SROPER["(SCHEDULED)"!(SROPER["(NOT COMPLETE)")!(SROPER["(COMPLETED)"),SRTMP S SRTP=$S('SRGETACC:"A04",1:"A08") Q
 ..I SROPER["(CANCELLED)",SRGETACC S SRTP="A11" Q
 .I SRY="SROERR" D
 ..I SROPER["(SCHEDULED)" S SRTP=$S('SRGETACC:"A04",1:"A08") Q
 ..I SROPER["(REQUESTED)" S SRTP=$S(SRGETACC:"A08",'SRGETACC:"A04",1:"") Q
 ..I SROPER["NOT COMPLETE",'SRGETACC,SRTMP S SRTP="A04" Q  ;New case
 ;;;I SRY["DEL"!(SROPER["CANCELLED")!(SROPER["ABORTED") S SRTP="A11" ;cancel
ST K ^TMP("SRPFSS",$J) I SRTP']"" Q
 S SRNODE0=$G(^SRF(SRCASE,0))
 S SRDFN=$S($D(DFN):DFN,1:$P(SRNODE0,"^")) ;Patient ID (DFN)
 S SRRARFN=$S((SRTP="A11"!(SRTP="A08")):SRGETACC,1:"") ;Account Reference Number
 S SRLSSC=+$P(SRNODE0,"^",4),SRLSS=$G(^SRO(137.45,SRLSSC,0))
 S SRPV1(2)=$S($P(SRNODE0,"^",12)="I":"I",1:"O") ;Patient Class; I(npatient) or O(utpatient)
 S SRPV1(3)=$S($P(SRNODE0,"^",21)]"":$P(SRNODE0,"^",21),1:$P(SRLSS,"^",5)) ;Patient Location
 S SRPV1(7)=$P($G(^SRF(SRCASE,.1)),"^",13) ;Attending Surgeon
 S (SRPR1(11),SRPV1(17))=$P($G(^SRF(SRCASE,.1)),"^",4) ;Surgeon
 S SRPV1(18)=$O(^DIC(40.7,"C",429,0))
 S (SRPV1(44),SRPV2(8))=$P(SRNODE0,"^",9) ;Admit Date/Time
 S SRPR1(4)=$E($P(^SRF(SRCASE,"OP"),"^"),1,60) ;Principal Procedure (free text)
 S SRSURG(1)=SRCASE
 S SRSURG(2)=$P(SRLSS,"^",2)
 S SRDG1(1,4)=$E($P($G(^SRF(SRCASE,33)),"^"),1,40) ;Principal Pre-Op Diagnosis
 S SRII=$P($G(^SRF(SRCASE,8)),"^"),SRDIV=$O(^DG(40.8,"AD",SRII,0)) ;Medical Center Division/Facility
 S SRAPLR=$S(SRTP="A04":"ACCT;SROPFSS",1:"")
 ;
ACCT ; Call IBB GETACCOUNT API to get a new Account Reference Number
 S SRCARFN=+$$GETACCT^IBBAPI(SRDFN,SRRARFN,SRTP,SRAPLR,.SRPV1,.SRPV2,.SRPR1,.SRDG1,"",SRDIV,"",.SRSURG)
 I $G(SRCARFN) S $P(^SRF(SRCASE,"PFSS"),"^")=SRCARFN
EXIT K SRCARFN
 Q
