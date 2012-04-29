ORPR03 ; slc/dcm - While you were printing ; 07 Dec 99  01:43PM
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**11,69**;Dec 17, 1997
C1 ; Chart Copy Print
 N ORIFN,OACTION,ORX,ORHEAD,ORFOOT,OROFMT,ORFMT,ORIOF,ORBOT,ORIOSL,ORXPND,ORFIRST1
 N ORAGE,ORDOB,ORL,ORNP,ORPNM,ORPV,ORSEX,ORSSN,ORTS,ORWARD
 U IO
 D PAT(+ORVP)
 S ORXPND=$$GET^XPAR("ALL","ORPF EXPAND CONTINUOUS ORDERS",1,"I")
 S ORHEAD=$$GET^XPAR("ALL","ORPF CHART COPY HEADER",1,"I")
 S ORFOOT=$$GET^XPAR("ALL","ORPF CHART COPY FOOTER",1,"I")
 S OROFMT=$$GET^XPAR("ALL","ORPF CHART COPY FORMAT",1,"I")
 S ORIOSL=IOSL
 I ORFOOT,$D(^ORD(100.23,ORFOOT,0)) S ORBOT=$P(^(0),"^",2),ORIOSL=IOSL-ORBOT
 I ORHEAD D PRINT^ORPR00(ORHEAD,1,0,1)
 S ORIOF=IOF,IOF="!!",ORFIRST1=1
 I OROFMT S ORFMT=OROFMT,ORCI=0 F  S ORCI=$O(@ARAY@(ORCI)) Q:ORCI<1  S ORIFN=+@ARAY@(ORCI),OACTION=$P(@ARAY@(ORCI),";",2) D  S ORFIRST1=0 Q:$G(OREND)
 . I '$L($G(^OR(100,ORIFN,0))) D EN^ORERR("CHARTCOPY PRINT WITH INVALID ORIFN:"_ORIFN) Q
 . D CHT1^ORPR04
 . I 'OACTION D EN^ORERR("NO ACTION DEFINED FOR CHARTCOPY PRINT ORIFN:"_ORIFN) Q
 . I '$D(^OR(100,ORIFN,8,OACTION)) D EN^ORERR("ACTION NODE ^(8) NOT SET FOR ORIFN:DA:"_ORIFN_":"_OACTION) Q
 . I '$D(ORRACT) S:'$P($G(^OR(100,ORIFN,8,OACTION,7)),"^") $P(^(7),"^",1,4)=1_"^"_$$NOW^XLFDT_"^"_DUZ_"^"_IO ;ORRACT is around if this is a reprint.
 I ORFOOT,'$G(OREND) S:IOF?1"!"."!" $P(IOF,"!",$S(ORIOSL>200:200,ORIOSL-$Y>1:ORIOSL-$Y,1:2))="" D PRINT^ORPR00(ORFOOT,1)
 S IOF=ORIOF
 W @IOF
 I '$G(TASK) D ^%ZISC I $D(ZTSK) D KILL^%ZTLOAD K ZTSK
 Q
W1 ;Work Copy Print
 N ORIFN,OACTION,ORX,ORHEAD,ORFOOT,OROFMT,ORFMT,ORIOF,ORBOT,ORIOSL,ORXPND,ORFIRST1
 N ORAGE,ORDOB,ORL,ORNP,ORPNM,ORPV,ORSEX,ORSSN,ORTS,ORWARD
 U IO
 D PAT(+ORVP)
 S ORXPND=$$GET^XPAR("ALL","ORPF EXPAND CONTINUOUS ORDERS",1,"I")
 S ORHEAD=$$GET^XPAR("ALL","ORPF WORK COPY HEADER",1,"I")
 S ORFOOT=$$GET^XPAR("ALL","ORPF WORK COPY FOOTER",1,"I")
 S OROFMT=$$GET^XPAR("ALL","ORPF WORK COPY FORMAT",1,"I")
 S ORIOSL=IOSL
 I ORFOOT,$D(^ORD(100.23,ORFOOT,0)) S ORBOT=$P(^(0),"^",2),ORIOSL=IOSL-ORBOT
 I ORHEAD D PRINT^ORPR00(ORHEAD,1,0,1)
 S ORIOF=IOF,IOF="!!",ORFIRST1=1
 I OROFMT S ORFMT=OROFMT,ORCI=0 F  S ORCI=$O(@ARAY@(ORCI)) Q:ORCI<1  D  Q:$G(OREND)
 . S ORIFN=+@ARAY@(ORCI),OACTION=$P(@ARAY@(ORCI),";",2)
 . D WRK^ORPR08
 . S ORFIRST1=0
 I ORFOOT,'$G(OREND) S:IOF?1"!"."!" $P(IOF,"!",$S(ORIOSL>200:200,ORIOSL-$Y>1:ORIOSL-$Y,1:2))="" D PRINT^ORPR00(ORFOOT,1)
 S IOF=ORIOF
 I '$G(TASK) D ^%ZISC I $D(ZTSK) D KILL^%ZTLOAD K ZTSK
 Q
L1 ; Label Print
 N ORIFN,OACTION,ORX,ORX5,ORHEAD,ORFOOT,OROFMT,ORFMT,ORIOF,ORBOT,ORIOSL,ORXPND,ORPK,SORT,SORT1,ORCI,X3,SFIELD,ORFIRST1
 N ORAGE,ORDOB,ORL,ORNP,ORPNM,ORPV,ORSEX,ORSSN,ORTS,ORWARD
 U IO
 S ORTKG=0,ORIOF=IOF,ORIOSL=IOSL,ORFIRST1=1
 D PAT(+ORVP)
 F  S ORTKG=$O(@ARAY@(ORTKG)) Q:ORTKG<1  I $$GET^XPAR("SYS","ORPF WARD LABEL FORMAT",ORTKG,"I") S ORCI="" D
 . S SFIELD=$$GET^XPAR("SYS","ORPF LABEL SORT FIELD",ORTKG,"I")
 . K ^TMP("ORBEFORE",$J),^TMP("ORAFTER",$J)
 . M ^TMP("ORBEFORE",$J)=@ARAY@(ORTKG)
 . D ARAY^ORPR06(ORVP,ORTKG,"START",SFIELD)
 . S SORT=""
 . F  S SORT=$O(^TMP("ORAFTER",$J,SORT)) Q:SORT=""  D
 .. S SORT1=""
 .. F  S SORT1=$O(^TMP("ORAFTER",$J,SORT,SORT1)) Q:SORT1=""  D
 ... S ORCI=""
 ... F  S ORCI=$O(^TMP("ORAFTER",$J,SORT,SORT1,ORCI)) Q:ORCI=""  D  Q:$G(OREND)
 .... S ORIFN=+ORCI,OACTION=$P(ORCI,";",2),X3=$P($G(^OR(100,ORIFN,3)),"^",3)
 .... I X3,X3'=11 D LBL1^ORPR01(1,$G(ORTIMES))
 I $D(ZTSK),'$G(TASK) D ^%ZISC,KILL^%ZTLOAD K ZTSK
 K ^TMP("ORBEFORE",$J),^TMP("ORAFTER",$J)
 Q
R1 ; Requisition Print
 N ORIFN,OACTION,ORX,ORX5,ORHEAD,ORFOOT,OROFMT,ORFMT,ORIOF,ORBOT,ORIOSL,ORTKG,ORXPND,ORPK,SORT,SORT1,ORGE,ORCI,X3,SFIELD,ORFIRST1
 N ORAGE,ORDOB,ORL,ORNP,ORPNM,ORPV,ORSEX,ORSSN,ORTS,ORWARD
 U IO
 S ORTKG=0,ORIOF=IOF,ORIOSL=IOSL
 D PAT(+ORVP)
 F  S ORTKG=$O(@ARAY@(ORTKG)) Q:ORTKG<1  I $$GET^XPAR("SYS","ORPF WARD REQUISITION FORMAT",ORTKG,"I") S ORCI="",IOF=ORIOF D
 . S SFIELD=$$GET^XPAR("SYS","ORPF REQUISITION SORT FIELD",ORTKG,"I")
 . S ORHEAD=$$GET^XPAR("SYS","ORPF WARD REQUISITION HEADER",ORTKG,"I")
 . S ORFOOT=$$GET^XPAR("SYS","ORPF WARD REQUISITION FOOTER",ORTKG,"I")
 . K ^TMP("ORBEFORE",$J),^TMP("ORAFTER",$J)
 . M ^TMP("ORBEFORE",$J)=@ARAY@(ORTKG)
 . D ARAY^ORPR06(ORVP,ORTKG,"START",SFIELD)
 . S SORT="",ORGE=0 F  S SORT=$O(^TMP("ORAFTER",$J,SORT)) Q:SORT=""  D
 .. S ORGE=1 ;ORGE used to control form feeds and indicate screened transactions
 .. I ORFOOT,$D(^ORD(100.23,ORFOOT,0)) S ORBOT=$P(^(0),"^",2),ORIOSL=IOSL-ORBOT
 .. I +ORHEAD D PRINT^ORPR00(ORHEAD,1)
 .. S ORIOF=IOF,IOF="!!",ORFIRST1=1
 .. S SORT1="" F  S SORT1=$O(^TMP("ORAFTER",$J,SORT,SORT1)) Q:SORT1=""  D
 ... I 'ORGE W @ORIOF S ORGE=1 I +ORHEAD D PRINT^ORPR00(ORHEAD,1)
 ... S ORCI=""
 ... F  S ORCI=$O(^TMP("ORAFTER",$J,SORT,SORT1,ORCI)) Q:ORCI=""  D  Q:$G(OREND)
 .... S ORFIRST1=0,ORGE=0,ORIFN=+ORCI,OACTION=$P(ORCI,";",2),X3=$P($G(^OR(100,ORIFN,3)),"^",3)
 .... I X3,X3'=11 D REQ1^ORPR01(1,"S ORGE=1")
 ... I ORFOOT,'$G(OREND) S:IOF?1"!"."!" $P(IOF,"!",$S(ORIOSL>200:200,ORIOSL-$Y>1:ORIOSL-$Y,1:2))="" D PRINT^ORPR00(ORFOOT,1)
 ... S IOF=ORIOF
 .. I 'ORFOOT,'ORGE,$O(^TMP("ORAFTER",$J,SORT)) W @ORIOF
 I '$G(TASK) D ^%ZISC I $D(ZTSK) D KILL^%ZTLOAD K ZTSK
 S IOF=ORIOF
 K ^TMP("ORBEFORE",$J),^TMP("ORAFTER",$J)
 Q
SVCOPY(ORDEFIO,SARAY) ; Print Service Copies
 ;SARAY(PKG,ORIFN)=Device ptr^# of copies  (used by Consults service copies)
 N ORDEF,ORSCI,ORSCPY,ORIC,ORNM,ZTREQ
 I $D(ZTQUEUED) S ZTREQ="@"
 I $D(ARAY) F ORTKG=0:0 S ORTKG=$O(@ARAY@(ORTKG)) Q:ORTKG<1  S ORNM=$P($G(^DIC(9.4,ORTKG,0)),"^") D
 . I $D(SARAY(ORTKG))>9 S ORSCI=0 D
 .. F  S ORSCI=$O(SARAY(ORTKG,ORSCI)) Q:ORSCI'>0  D
 ... N ARAY
 ... S ORDEF=$S($G(ORDEFIO):"",1:$P($G(SARAY(ORTKG,ORSCI)),U)),ARAY(ORTKG,ORSCI)=""
 ... S ORSCPY=$S(+$P($G(SARAY(ORTKG,ORSCI)),U,2):+$P($G(SARAY(ORTKG,ORSCI)),U,2),1:1)
 ... F ORIC=1:1:ORSCPY S X=$$DEVICE^ORPR02(+$G(ORDEFIO)_"^"_ORNM_" SERVICE COPIES",ORDEF,"S1^ORPR03")
 . Q:'$$GET^XPAR("SYS","ORPF SERVICE COPY FORMAT",ORTKG,"I")
 . I $D(SARAY(ORTKG))'>9 D
 .. S X=$S($G(ORDEFIO):"",1:$$GET^XPAR(+LOC_";SC("_"^DIV^SYS","ORPF SERVICE COPY DEFLT DEVICE",ORTKG,"I"))
 .. I $L(X) S X=$$DEVICE^ORPR02("0^"_ORNM_" SERVICE COPIES",X,"S1^ORPR03") Q
 .. E  I $G(ORDEFIO) S X=$$DEVICE^ORPR02("1^"_ORNM_" SERVICE COPIES",,"S1^ORPR03") Q
 Q
S1 ; Service Copy Print Routine
 N ORIFN,OACTION,ORX,ORNUM,ORHEAD,ORFOOT,OROFMT,ORFMT,ORIOF,ORBOT,ORIOSL,ORSNUM,ORFIRST1
 N ORAGE,ORDOB,ORL,ORNP,ORPNM,ORPV,ORSEX,ORSSN,ORTS,ORWARD
 U IO
 D PAT(+ORVP)
 S OROFMT=$$GET^XPAR("SYS","ORPF SERVICE COPY FORMAT",ORTKG,"I")
 S ORHEAD=$$GET^XPAR("SYS","ORPF SERVICE COPY HEADER",ORTKG,"I")
 S ORFOOT=$$GET^XPAR("SYS","ORPF SERVICE COPY FOOTER",ORTKG,"I")
 S ORIOSL=IOSL
 I ORFOOT,$D(^ORD(100.23,ORFOOT,0)) S ORBOT=$P(^(0),"^",2),ORIOSL=IOSL-ORBOT
 I ORHEAD D PRINT^ORPR00(ORHEAD,1,0,1)
 S ORIOF=IOF,IOF="!",ORFIRST1=1
 I OROFMT S ORFMT=OROFMT,ORCI="" F  S ORCI=$O(@ARAY@(ORTKG,ORCI)) Q:ORCI=""  S ORIFN=+ORCI,OACTION=$P(ORCI,";",2) D CHT1^ORPR04 S ORFIRST1=0 Q:$G(OREND)
 I ORFOOT,'$G(OREND) S:IOF?1"!"."!" $P(IOF,"!",$S(ORIOSL>200:200,ORIOSL-$Y>1:ORIOSL-$Y,1:1))="" S:IOF="" IOF=ORIOF D PRINT^ORPR00(ORFOOT,1,0)
 S IOF=ORIOF
 I '$G(TASK) D ^%ZISC I $D(ZTSK) D KILL^%ZTLOAD K ZTSK
 Q
PAT(Y) ;Get patient variables
 ;Y=DFN or ORVP
 N VA,VA200,VAIN,VADM,VAROOT,VAERR,VAINDT
 Q:'$G(Y)
 S DFN=+Y,VA200=1
 D OERR^VADPT
 S ORPNM=VADM(1),ORSSN=VA("PID"),ORDOB=$P(VADM(3),"^",2),ORAGE=VADM(4),ORSEX=$P(VADM(5),"^"),ORTS=+VAIN(3),ORTS=$S($G(ORTS):ORTS,1:""),ORNP=+VAIN(2),ORWARD=VAIN(4),ORPV=""
 I '$D(ORL),$P(ORWARD,"^")?1N.N S ORL(1)=VAIN(5),(ORL,ORL(0),ORL(2))="",X=+ORWARD I $D(^DIC(42,+X,44)) S X=$P(^(44),"^") I X,$D(^SC(X,0)) S ORL=X_";SC(",ORL(0)=$S($L($P(^(0),"^",2)):$P(^(0),"^",2),1:$E($P(^(0),"^"),1,4)),ORL(2)=ORL
 Q
