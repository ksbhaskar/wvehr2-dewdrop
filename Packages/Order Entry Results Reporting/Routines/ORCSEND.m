ORCSEND ;SLC/MKB-Release orders ; 11/8/2006
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**4,27,45,79,92,141,165,195,228,243,303,296**;Dec 17, 1997;Build 19
        ;
EN(ORIFN,ACTION,SIGSTS,RELSTS,NATURE,REASON,ORERR)      ; -- Release [actions on] orders
        N ORDA,ORNOW,SIGNREQD,SIGNED,SIGNER
        S SIGNREQD=+$P($G(^OR(100,+ORIFN,0)),U,16),ORERR=""
        S SIGNED=$S(SIGSTS=2:0,1:1),SIGNER=$S(SIGSTS=1:DUZ,SIGSTS=7:DUZ,1:"")
        S ORDA=+$P(ORIFN,";",2),ORIFN=+ORIFN,ORNOW=+$E($$NOW^XLFDT,1,12)
        S:"ES"[$G(ACTION) ACTION=$P($G(^OR(100,ORIFN,8,ORDA,0)),U,2)
        I SIGNREQD,ORDA,"^NW^RW^XX^RN^DC^HD^RL^"[(U_ACTION_U) D  ; sign/alert
        . I 'SIGNED D NOTIF^ORCSIGN Q
        . D:SIGSTS'="" SIGN^ORCSAVE2(ORIFN,SIGNER,ORNOW,SIGSTS,ORDA)
        . D:SIGSTS=4 CHART^ORCSIGN ; not used anymore
        I '$L(ACTION) S ORERR="1^Invalid order action" Q
        I $$READY(ORIFN,ORDA) D:$L($T(@ACTION)) @ACTION I 'ORERR,ACTION="NW" D
        . N OREVT S OREVT=+$P($G(^OR(100,ORIFN,0)),U,17) Q:OREVT<1
        . I '$$EVTORDER^OREVNTX(ORIFN) D SAVE^ORMEVNT1(ORIFN,OREVT,2,"ES")
        ; If order originated from the back door, send Dx and TxF back to ancil.
        I SIGNED,$P($G(^OR(100,+ORIFN,3)),U,11)="P" D BDOEDIT^ORWDBA7
        Q
        ;
EN1(ORDER,ORERR)        ; -- Delayed Release [from RELEASE^ORMEVNT]
        ;
        Q:$P($G(^OR(100,+ORDER,3)),U,3)'=10
        N ORPKG,ORA0,ORNOW,ORIFN,ORDA,ORNP,ORNATR,ORQUIT,ORDUZ,SIGSTS,RELSTS
        S ORPKG=$P($G(^OR(100,+ORDER,0)),U,14),ORA0=$G(^(8,1,0))
        S ORNOW=+$E($$NOW^XLFDT,1,12),ORIFN=+ORDER,ORDA=1,ORNP=$P(ORA0,U,3)
        S SIGSTS=$P(ORA0,U,4),ORNATR=$P($G(^ORD(100.02,+$P(ORA0,U,12),0)),U,2)
        S RELSTS=$S(SIGSTS'=2:1,"^V^P^"[(U_ORNATR_U):1,1:0)
        I RELSTS D
        . D STARTDT^ORCSAVE2(ORIFN),PKGSTUFF^ORCSEND1(ORPKG) Q:$G(ORQUIT)
        . S ORDUZ=$S(SIGSTS=0:$P(ORA0,U,7),SIGSTS=1:$P(ORA0,U,5),SIGSTS=2:$P(ORA0,U,17),SIGSTS=3:$P(ORA0,U,13),1:DUZ)
        . D EDO1^ORWPFSS1  ;PFSS Event Delayed Orders
        . D RELEASE^ORCSAVE2(ORIFN,ORDA,ORNOW,ORDUZ),NEW^ORMBLD(ORIFN)
        . I "^10^13^"[(U_$P($G(^OR(100,ORIFN,3)),U,3)_U) S ORERR=1 ;error
        I 'RELSTS!$G(ORERR),$P($G(^OR(100,ORIFN,3)),U,3)=10 D STATUS^ORCSAVE2(ORIFN,11) S $P(^OR(100,ORIFN,8,1,0),U,15)=11
        Q
        ;
EN2(ORIFN,SIGSTS,NATURE,ORERR)  ; -- Manual Release [from OREVNT1,SENDED^ORWDX]
        N ORDA,ORNOW,OREVT,ORA0,ORNP,SIGNREQD,SIGNED,RELSTS
        S ORDA=+$P(ORIFN,";",2),ORIFN=+ORIFN S:ORDA<1 ORDA=1
        S OREVT=+$P($G(^OR(100,ORIFN,0)),U,17),ORA0=$G(^(8,ORDA,0))
        S ORNP=$P(ORA0,U,3),SIGNREQD=($P(ORA0,U,4)'=3),(SIGNED,RELSTS)=1
        S ORNOW=+$E($$NOW^XLFDT,1,12),ORERR=""
        I $P(ORA0,U,4)=2 D  ;needs ES
        . N SIGNER S SIGNER=$S(SIGSTS=1:DUZ,1:"")
        . I SIGSTS=2 D NOTIF^ORCSIGN S SIGNED=0 Q  ;still unsigned
        . D:SIGSTS'="" SIGN^ORCSAVE2(ORIFN,SIGNER,ORNOW,SIGSTS,ORDA)
        D EDO2^ORWPFSS1  ;PFSS Event Delayed Orders
        D NW I 'ORERR D SAVE^ORMEVNT1(+ORIFN,OREVT,2,"MN")
        Q
        ;
NW      ; -- New order ORIFN
RW      ; -- Rewritten order ORIFN
XX      ; -- Changed order ORIFN
RN      ; -- Renewed order ORIFN
        N ORQUIT,STS,TYPE,OR0,OR3,CODE,ORIG,ORSAVE
        N IVDIEN,IVPKGM
        S IVPKGM=0
        S IVDIEN=$O(^ORD(101.41,"B","PSJI OR PAT FLUID OE",""))
        I SIGNREQD,'SIGNED,'RELSTS S ORERR=$$NEEDSIG,OREBUILD=1 Q
        S:'ORDA ORDA=1 S ORSAVE=ORIFN
        S OR0=$G(^OR(100,ORIFN,0)),OR3=$G(^(3)) D STARTDT^ORCSAVE2(ORIFN)
        S TYPE=$P(OR3,U,11),ORIG=+$P(OR3,U,5),CODE="NW"
        I TYPE=1,ORIG,$D(^OR(100,ORIG,4)) S CODE="XO",^OR(100,ORIG,6)=$O(^ORD(100.02,"C","C",0))_U_DUZ_U_ORNOW
        I $$GET1^DIQ(9.4,+$P(OR0,U,14)_",",1)="PSJ" S IVPKGM=1
        I IVPKGM=1,$P($P(OR0,U,5),";")=IVDIEN D PSJI^ORCSEND3 Q:$G(ORQUIT)
        I IVPKGM=0!($P($P(OR0,U,5),";")'=IVDIEN) D PKGSTUFF^ORCSEND1(+$P(OR0,U,14)) Q:$G(ORQUIT)
        D RELEASE^ORCSAVE2(ORIFN,ORDA,ORNOW,DUZ,$G(NATURE))
        D NEW^ORMBLD(ORIFN,CODE) S ORIFN=ORSAVE,STS=$P($G(^OR(100,ORIFN,3)),U,3)
        I (STS=1)!(STS=13) S ORERR="1^"_$$WHY(ORIFN,1) D:'SIGNED&SIGNREQD NOSIG K:ORIG ^OR(100,ORIG,6)
        I STS=11 S ORERR="1^ERROR"
        Q
        ;
DC      ; -- DC order ORIFN
        N PKG,CODE,ORCHLD,ORCHDA,STS,ORIDA,ORSAVE,OR3,OR6,DCNATURE
        I '$G(REASON),$G(NATURE)="D" S REASON=+$O(^ORD(100.03,"C","ORDUP",0))
        S:$G(REASON) $P(^OR(100,ORIFN,6),U,1,5)=$S($G(NATURE):NATURE,$L($G(NATURE)):$O(^ORD(100.02,"C",NATURE,0)),1:"")_"^^^"_+REASON_U_$P(^ORD(100.03,+REASON,0),U)
        I SIGNREQD,'SIGNED,'RELSTS S ORERR=$$NEEDSIG Q
        S $P(^OR(100,ORIFN,6),U,2,3)=$S($G(DGPMT):"",1:DUZ)_U_ORNOW,ORSAVE=ORIFN S:'$G(REASON) REASON=$P(^(6),U,4)
        S STS=$P($G(^OR(100,ORIFN,3)),U,3),PKG=$P($G(^(0)),U,14),PKG=$$NMSP^ORCD(PKG),CODE=$S(PKG="LR":"CA",(PKG="PS")&(STS=5):"CA",(PKG="FH")&(STS=8):"CA",1:"DC")
        D:ORDA RELEASE^ORCSAVE2(ORIFN,ORDA,ORNOW,DUZ,$G(NATURE))
DC1     I $O(^OR(100,ORIFN,2,0)) D  G DC2 ; DC children
        . S ORCHLD=0 F  S ORCHLD=$O(^OR(100,ORIFN,2,ORCHLD)) Q:ORCHLD'>0  I $$VALID^ORCACT0(ORCHLD,"DC") D  Q:$G(ORERR)
        . . S ORCHDA=$S(ORDA:$$ACTION^ORCSAVE("DC",ORCHLD,ORNP),1:0)
        . . D:ORCHDA SIGN^ORCSAVE2(ORCHLD,,,8,ORCHDA) ;Sig on Parent only
        . . D MSG^ORMBLD((ORCHLD_";"_ORCHDA),CODE,$G(REASON))
        . . I "^1^13^"'[(U_$P(^OR(100,ORCHLD,3),U,3)_U) S ORERR="1^"_$$WHY(ORCHLD,ORCHDA)
        . ;D:'$G(ORERR) STATUS^ORCSAVE2(ORIFN,1)
        . S:$G(ORERR) ^OR(100,ORIFN,8,ORDA,1)=$P(ORERR,U,2)
        D MSG^ORMBLD((ORIFN_";"_ORDA),CODE,$G(REASON))
DC2     S ORIFN=ORSAVE,OR3=$G(^OR(100,ORIFN,3)),STS=$P(OR3,U,3)
        S OR6=$G(^OR(100,ORIFN,6))
        I STS'=1,STS'=13,STS'=2 D  Q
        . S ORERR="1^"_$S(ORDA:$$WHY(ORIFN,ORDA),1:"Unable to discontinue")
        . I ORDA,'SIGNED&SIGNREQD D NOSIG ; sig no longer reqd
        . K ^OR(100,ORIFN,6)
        S DCNATURE=$S(+OR6:+OR6,1:$G(NATURE))
        S $P(^OR(100,ORIFN,3),U,7)=$S('$$ACTV^ORX1($G(DCNATURE)):0,ORDA:ORDA,1:$P(OR3,U,7))
        D CANCEL(ORIFN),SETALL^ORDD100(ORIFN)
        I $P(OR3,U,11)=2 D  ; dc a renewal
        . N ORIG,ORIG3,NATR S ORIG=$P(OR3,U,5),ORIG3=$G(^OR(100,ORIG,3)) Q:'ORIG
        . ;I CODE="CA",+$P(OR6,U,9)'>0 S $P(^OR(100,ORIG,3),U,6)="" Q  ;pend - remove fwd ptr
        . I +$P(OR6,U,9)'>0 S $P(^OR(100,ORIG,3),U,6)="" Q  ;pend - remove fwd ptr
        . Q:"^1^7^12^13^"[(U_$P(ORIG3,U,3)_U)  S NATR=$O(^ORD(100.02,"C","A",0))
        . S ^OR(100,ORIG,6)=NATR_U_DUZ_U_ORNOW_"^^Renewal cancelled"
        . D MSG^ORMBLD(ORIG,"DC") I "^1^13^"'[$P(^OR(100,ORIG,3),U,3) K ^(6) Q
        . S:'$$ACTV^ORX1(NATR) $P(^OR(100,ORIG,3),U,7)=0
        Q
        ;
CANCEL(IFN)     ; -- Cancel any outstanding actions for order IFN 
        N I S I=0
        F  S I=$O(^OR(100,IFN,8,I)) Q:I'>0  I $P(^(I,0),U,15)=11 S $P(^(0),U,15)=13 D:$P(^(0),U,4)=2 SIGN^ORCSAVE2(IFN,"","",5,I) ; cancelled, sig not reqd now
        Q
        ;
HD      ; -- Hold order ORIFN
        N STS,ORSAVE I 'ORDA S ORERR="1^Unable to hold" Q
        I SIGNREQD,'SIGNED,'RELSTS S ORERR=$$NEEDSIG Q
        D RELEASE^ORCSAVE2(ORIFN,ORDA,ORNOW,DUZ,$G(NATURE))
        S ORSAVE=ORIFN D MSG^ORMBLD((ORIFN_";"_ORDA),"HD") S ORIFN=ORSAVE
        S STS=$P($G(^OR(100,ORIFN,3)),U,3) I STS=3 S $P(^(3),U,7)=ORDA D SET^ORDD100(ORIFN,ORDA)
        I STS'=3 S ORERR="1^"_$$WHY(ORIFN,ORDA) D:'SIGNED&SIGNREQD NOSIG
        Q
        ;
RL      ; -- Release hold on order ORIFN
        N STS,ORSAVE,ORHD I 'ORDA S ORERR="1^Unable to release hold" Q
        I SIGNREQD,'SIGNED,'RELSTS S ORERR=$$NEEDSIG Q
        D RELEASE^ORCSAVE2(ORIFN,ORDA,ORNOW,DUZ,$G(NATURE))
        S ORSAVE=ORIFN D MSG^ORMBLD((ORIFN_";"_ORDA),"RL") S ORIFN=ORSAVE
        S STS=$P($G(^OR(100,ORIFN,3)),U,3),ORHD=+$P($G(^(3)),U,7)
        I STS'=3 S $P(^OR(100,ORIFN,3),U,7)=ORDA,$P(^(8,ORHD,2),U,1,2)=ORNOW_U_DUZ D SET^ORDD100(ORIFN,ORDA)
        I STS=3 S ORERR="1^"_$$WHY(ORIFN,ORDA) D:'SIGNED&SIGNREQD NOSIG
        Q
        ;
FL      ; -- Flag order ORIFN
        Q
        ;
UF      ; -- Unflag order ORIFN
        Q
        ;
CM      ; -- Add Ward comments to order ORIFN
        Q
        ;
VR      ; -- Verify order ORIFN
        I 'ORDA!(SIGSTS=2) S ORERR="1^Unable to verify" Q
        I "^N^C^R^"'[(U_$G(ORVER)_U) S ORERR="1^Unable to verify" Q
        D VERIFY^ORCSAVE2(ORIFN,ORDA,ORVER,DUZ,ORNOW)
        ; -- send HL7 msg to Pharmacy if Nurse-Verified, [Sts=pending]
        Q:ORVER'="N"  N ORSTS,ORPKG,ORX
        S ORX=$P($G(^OR(100,ORIFN,8,ORDA,0)),U,2) Q:ORX'="NW"&(ORX'="XX")
        S ORPKG=+$P($G(^OR(100,ORIFN,0)),U,14),ORSTS=$P($G(^(3)),U,3)
        ;I ORSTS=5!$L($T(ZV^ORMPS)),$$NMSP^ORCD(ORPKG)="PS" D VER^ORMBLDPS(ORIFN)
        I $$NMSP^ORCD(ORPKG)="PS" D VER^ORMBLDPS(ORIFN)
        Q
        ;
NEEDSIG()       ; -- Msg
        Q "1^This order requires a signature."
        ;
WHY(IFN,DA)     ; -- Return reason request was rejected
        N X S X=$G(^OR(100,IFN,8,DA,1))
        S:'$L(X) X="Unable to "_$S(ACTION="HD":"hold",ACTION="RL":"release hold",ACTION="DC":"discontinue",ACTION="XX":"change",ACTION="RN":"renew",1:"release")
        Q X
        ;
NOSIG   ; -- Mark order as Sig not Req'd due to cancel/reject
        D SIGN^ORCSAVE2(ORIFN,"","",5,ORDA) S SIGNREQD=0
        Q
        ;
READY(IFN,ACT)  ; -- Ready to release?
        N X,Y,OR0,OR3,ORA
        I ACTION="VR" S Y=1 G RQ ; no action to release
        I 'ACT,ACTION="DC" S Y=1 G RQ ; cancel a duplicate
        S Y=0,OR0=$G(^OR(100,IFN,0)),OR3=$G(^(3)),ORA=$G(^(8,ACT,0))
        I $P(ORA,U,15)=11 S Y=1 G RQ ; unreleased
        I $P(ORA,U,15)=10 D  G RQ ; delayed
        . I $G(^DPT(+ORVP,.105)),$$GET1^DIQ(9.4,+$P(OR0,U,14)_",",1)="PSO" S Y=1 Q
        . Q:'RELSTS  N ORIG S ORIG=+$P(OR3,U,5)
        . I 'SIGNED,$L($G(NATURE)) S $P(ORA,U,17)=DUZ,$P(ORA,U,12)=$S(NATURE:NATURE,1:+$O(^ORD(100.02,"C",NATURE,0))),^OR(100,IFN,8,ACT,0)=ORA
        . Q:$P(OR3,U,11)'=1!('ORIG)  ;dc original if signed edit
        . D STATUS^ORCSAVE2(ORIG,12)
        . S ^OR(100,ORIG,6)=+$O(^ORD(100.02,"C","C",0))_U_DUZ_U_ORNOW
        . S $P(^OR(100,ORIG,3),U,7)=0,$P(^(8,1,0),U,15)=12 D:$P($G(^(0)),U,4)=2 SIGN^ORCSAVE2(ORIG,,,5,1)
        I $P(OR3,U,3)=11,$P(ORA,U,2)="NW" S Y=1 ; Action Sts = "" (old)
RQ      I +$$SWSTAT^IBBAPI() D:Y=1 EN^ORWPFSS4(+IFN) ; Associate PFSS Account Reference with order, Patch OR*3.0*228 IA #4663
        Q Y
