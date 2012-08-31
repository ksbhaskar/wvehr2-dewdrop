LREPI3  ;DALOI/SED-EMERGING PATHOGENS HL7 SEGMENTS ;5/21/98
        ;;5.2;LAB SERVICE;**132,175,260,281,320,315**;Sep 27, 1994;Build 25
        ; Reference to ^DGPT supported by IA #418
        ; Reference to ^SC supported by IA #10040
        ; Reference to ^DIC(21 supported by IA #4280
        ; Reference to ^ICD9 supported by IA #10082
        ; Reference to ICN supported by IA #2701
        ; Reference to VAFHLPID supported by IA # 263
        ; Reference to VAFHLPV1 supporte by IA # 3018
        ; Reference to ^DIC(5 supported by IA # 10056
        ; Reference to $$HOMELESS supported by IA #1528
        ; Reference to VADPT suppoted by IA #10061
        ; Reference to ^AUPNVPOV supported by IA # 3094
        ; Reference to ^AUPNVSIT supported by IA #3530
        ; Reference to $$STA^XUAF4(IEN) supported by IA #2171
        ; Reference to $$PTR2CODE^DGUTL4 supported by IA #3799
NTE     ;TO BUILD THE NTE SEGMENT TO DEFINE THE EPI
        S LRDATA="NTE"_HLFS_LRNTE_HLFS_$P(^LAB(69.5,LRPATH,0),U,9)_LRCS_$P(^LAB(69.5,LRPATH,0),U,1)
        S LRCNT=LRCNT+1,^TMP("HLS",$J,LRCNT)=$$UP^XLFSTR(LRDATA)
        S ^TMP("LREPIREP",$J,LRCNT)=$$UP^XLFSTR(LRDATA)
        S LRMSGSZ=LRMSGSZ+$L(LRDATA)
        S LRNTE=LRNTE+1
        Q
DG1     ;BUILD THE DG1 FOR ICD9 CODES
        K ^TMP($J,"DG1")
        S IFN=+$G(^TMP($J,LRPROT,DFN,LRENDT,LRPATH,LRINVD,LRND))
DG11    Q:+IFN'>0
        Q:'$D(^DGPT(IFN))
        ;SEARCH FOR LEGIONAIRS HERE
        I $P($G(^DGPT(IFN,300)),U,3)=1 D
        .S ICD9=$O(^ICD9("BA","482.84 ",0)) Q:+ICD9'>0
        .S ^TMP($J,"DG1",ICD9)=$P($G(^DGPT(IFN,70)),"^",10)_"^"_$$HLDATE^HLFNC($P($G(^DGPT(IFN,0)),"^",2))
        I $D(^DGPT(IFN,70)) F LRI=10,11,16:1:24 D
        .S ICD9=$P(^DGPT(IFN,70),U,LRI) Q:+ICD9'>0
        .S ^TMP($J,"DG1",ICD9)=$P($G(^DGPT(IFN,70)),"^",10)_"^"_$$HLDATE^HLFNC($P($G(^DGPT(IFN,0)),"^",2))
        ;SEARCH SUB FIELDS
        S LRMV=0 F  S LRMV=$O(^DGPT(IFN,"M",LRMV)) Q:+LRMV'>0  D
        .;SEARCH FOR LEGIONAIRS HERE IN SUB FILE
        .I $P($G(^DGPT(IFN,"M",LRMV,300)),U,3)=1 D
        ..S ICD9=$O(^ICD9("BA","482.84 ",0)) Q:+ICD9'>0
        ..S ^TMP($J,"DG1",ICD9)=$P($G(^DGPT(IFN,70)),"^",10)_"^"_$$HLDATE^HLFNC($P($G(^DGPT(IFN,0)),"^",2))
        .I $D(^DGPT(IFN,"M",LRMV,0)) F LRI=5:1:9,11:1:15 D
        ..S ICD9=$P(^DGPT(IFN,"M",LRMV,0),U,LRI) Q:+ICD9'>0
        ..S ^TMP($J,"DG1",ICD9)=$P($G(^DGPT(IFN,70)),"^",10)_"^"_$$HLDATE^HLFNC($P($G(^DGPT(IFN,0)),"^",2))
        Q:'$D(^TMP($J,"DG1"))
BLD     S ICD9=0 F  S ICD9=$O(^TMP($J,"DG1",ICD9)) Q:+ICD9'>0  D
        .S:'$D(DGCNT) DGCNT=1
        .N LRTMP
        .S LRTMP=$$ICDDX^ICDCODE(ICD9,,,1)
        .K LRDATA
        .S LRDATA="DG1"_HLFS_DGCNT_HLFS_HLFS_$P(LRTMP,U,2)
        .S LRDATA=LRDATA_LRCS_$P(LRTMP,U,4)_LRCS_"I9"
        .I LRPROT=LRPROTX S LRDATA=LRDATA_HLFS_$P(^TMP($J,"DG1",ICD9),"^",2)_HLFS_HLFS_$S(ICD9=$P(^TMP($J,"DG1",ICD9),"^"):"PR",1:"")
        .S ^TMP("HL7",$J,DGCNT)=$$UP^XLFSTR(LRDATA),DGCNT=DGCNT+1
        K ^TMP($J,"DG1"),LRDATA,DGCNT,ICD9,LRMV
        Q
PID     ;TO BUILD PID SEGMENT
        K MSG
        S FLDS="1,2,3,5,7,8,10BT,19,22BT" S MSG=$$EN^VAFHLPID(DFN,FLDS,LRPID)
        ;MADE CHANGE FOR PID SEGMENTS TOO LONG;CKA;06/30/04
        D DEM^VADPT
        I $D(VAFPID(1)) D
        .S $P(MSG,HLFS,11)=VADM(12),MSG=MSG_VAFPID(1),$P(MSG,HLFS,23)=VADM(11)
        S ICN=$$GETICN^MPIF001(DFN)
        S:ICN<0 $P(MSG,HLFS,4)=$P(MSG,HLFS,4)_LRCS_""""""_LRCS_"VAMPI"
        S:ICN>0 $P(MSG,HLFS,4)=$P(MSG,HLFS,4)_LRCS_ICN_LRCS_"VAMPI"
        ;ADDITIONAL DATA ADDED HERE HOMELESSNESS
        S:$$HOMELESS^SOWKHIRM(DFN) $P(MSG,HLFS,12)="HOMELESS"
        ;NOW GET PERIOD OF SERVICE
        K VAEL D ELIG^VADPT
        S:$G(VAEL(2))'="" $P(MSG,HLFS,28)=$P($G(^DIC(21,+VAEL(2),0)),U,3)
        K VAEL
        ;GET ZIP IF THERE
        K VAPA D ADD^VADPT
        S $P(MSG,HLFS,12)=$P(MSG,HLFS,12)_LRCS_LRCS_LRCS_VAPA(5)_LRCS_$G(VAPA(6))_LRCS_LRCS_LRCS_LRCS
        I VAPA(7)'="",VAPA(5)'="" S CTY=$P(VAPA(7),U,2),CTYN=$P(VAPA(7),U) I CTYN'="" S CTYCD=$P($G(^DIC(5,$P(VAPA(5),U),1,CTYN,0)),U,3) D
        .S $P(MSG,HLFS,12)=$P(MSG,HLFS,12)_$G(CTYCD)_"^"_$G(CTY)
        K VAPA,CTY,CTYN,CTYCD,LRRACE
        I $P(MSG,HLFS,12)="~~~~~~~~" S $P(MSG,HLFS,12)=""
        S LRRACE=$$PTR2CODE^DGUTL4($P(VADM(8),U))
        I $L(MSG)>245 D
        .S $P(MSG,HLFS,11)=VADM(12),$P(MSG,HLFS,23)=VADM(11)
        S:$P(MSG,HLFS,11)="""""~""""~0005~""""~""""~CDC" $P(MSG,HLFS,11)=""
        S:$P(MSG,HLFS,23)="""""~""""~0189~""""~""""~CDC" $P(MSG,HLFS,23)=""
        S $P(MSG,HLFS,11)=LRRACE_"~"_$P(MSG,HLFS,11)
        I $P(MSG,HLFS,11)="~" S $P(MSG,HLFS,11)=""
        S LRPID=LRPID+1,LRCNT=LRCNT+1,^TMP("HLS",$J,LRCNT)=$$UP^XLFSTR(MSG)
        S ^TMP("LREPIREP",$J,LRCNT)=$$UP^XLFSTR(MSG)
        S LRMSGSZ=LRMSGSZ+$L(MSG)
        K FLDS,VAEL,ICN,VAFPID,VADM
        Q
PV1     ;TO BUILD PV1 SEGMENT
        K PTF,Y,C,LRDATA,MSG,LRPATLOC
        S LRDATA=""
        I $P(^TMP($J,LRPROT,DFN,LRENDT),U)="I" D
        .S FLDS="1,2,3,36,39,44,45" S LRDATA=$$IN^VAFHLPV1(DFN,LRENDT,FLDS,"","","","")
        I $P(LRDATA,HLFS)="" S $P(LRDATA,HLFS)="PV1"
        S $P(LRDATA,HLFS,2)=LRPV1
        S $P(LRDATA,HLFS,7)=""
        S $P(LRDATA,HLFS,3)=$P(^TMP($J,LRPROT,DFN,LRENDT),U)
        I $P(LRDATA,HLFS,3)="O" D
        .S LRPATLOC=$P(^TMP($J,LRPROT,DFN,LRENDT),U,2)
        .S LRFILE=$P(LRPATLOC,";",2)
        .S LRIFN=$P(LRPATLOC,";")
        .I LRFILE="SC(" D
        ..I $P($G(^SC(LRIFN,0)),U,4)'="" D
        ...S LRPATLOC=$$STA^XUAF4($P($G(^SC(LRIFN,0)),U,4))
        .I LRFILE="DIC(4" D
        ..I $$STA^XUAF4(LRIFN)'="" D
        ...S LRPATLOC=$$STA^XUAF4(LRIFN)
        .S $P(LRDATA,HLFS,39)=LRPATLOC
        .K LRPATLOC,LRFILE,LRIFN
        S:$P(^TMP($J,LRPROT,DFN,LRENDT),U,3)="UPDT" $P(LRDATA,HLFS,3)="U"
        S $P(LRDATA,HLFS,45)=$$HLDATE^HLFNC(LRENDT)
        S:$P(LRDATA,HLFS,46)="""""" $P(LRDATA,HLFS,46)=""
        ;MADE CHANGE FOR FUTURE DISCHARGE DATES;CKA 6/30/2004
        S:$P(LRDATA,HLFS,46)>LRRPE $P(LRDATA,HLFS,46)=""
        S PTF=$P(^TMP($J,LRPROT,DFN,LRENDT),U,2) I +PTF>0 D
        .Q:'$D(^DGPT(PTF,0))
        .Q:$P(^DGPT(PTF,0),U,6)'=3
        .Q:'$D(^DGPT(PTF,70))
        .I +$P(^DGPT(PTF,70),U)>0,+$P(^DGPT(PTF,70),U)<LRRPE S $P(LRDATA,HLFS,46)=$$HLDATE^HLFNC($P(^DGPT(PTF,70),U))
        .S (Y,LRDTY)=$P(^DGPT(PTF,70),U,3)
        .Q:+Y'>0
        .S Y=$$EXTERNAL^DILFD(45,72,,Y) ;removed direct reference to ^DD(45,72
        .;S C=$P(^DD(45,72,0),U,2) D Y^DIQ ;RLM
        .S $P(LRDATA,HLFS,37)=LRDTY_LRCS_Y_LRCS_"VA45"
        .S $P(LRDATA,HLFS,40)=$P(^DGPT(PTF,0),U,3)
        S LRCNT=LRCNT+1,^TMP("HLS",$J,LRCNT)=$$UP^XLFSTR(LRDATA),LRPV1=LRPV1+1
        S ^TMP("LREPIREP",$J,LRCNT)=$$UP^XLFSTR(LRDATA)
        S LRMSGSZ=LRMSGSZ+$L(LRDATA)
        I $P(LRDATA,HLFS,3)="O" D  D MOVE^LREPI2
        .S VIFN=0
        .F  S VIFN=$O(^AUPNVPOV("AA",DFN,9999999-$P(LRENDT,"."),VIFN)) Q:+VIFN'>0  D
        ..S LRVISIT=$P(^AUPNVSIT($P(^AUPNVPOV(VIFN,0),U,3),812),U,2)
        ..I LRVISIT'=26 S LRVISIT=0 Q
        ..S ICD9N=$P($G(^AUPNVPOV(VIFN,0)),U)
        ..Q:ICD9N=""
        ..N LRTMP
        ..S LRTMP=$$ICDDX^ICDCODE(ICD9N,,,1)
        ..S:'$D(DGCNT) DGCNT=1
        ..S LRDATA="DG1"_HLFS_DGCNT_HLFS_HLFS_$P(LRTMP,U,2)
        ..S LRDATA=LRDATA_LRCS_$P(LRTMP,U,4)_LRCS_"I9"
        ..S LRDATA=LRDATA_HLFS_$$HLDATE^HLFNC(LRENDT)_HLFS_HLFS_$S($P(^AUPNVPOV(VIFN,0),U,12)="P":"PR",1:"")
        ..S ^TMP("HL7",$J,DGCNT)=$$UP^XLFSTR(LRDATA)
        .. S DGCNT=DGCNT+1
        K DGCNT,VIFN,ICD9N,ICD9,LRDATA,LRVISIT
        Q:$G(PTF)'>0
        Q:'$D(^DGPT(PTF,0))
        Q:$P(^DGPT(PTF,0),U,6)'=3
        S IFN=PTF D DG11
        D MOVE^LREPI2
        K PTF,Y,C,LRDATA,LRDTY,IFN,ICD9,ICD9N,LROLLOC,VIFN
        Q
        ;
