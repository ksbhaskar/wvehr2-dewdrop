SDAMODO2        ;ALB/SCK - PROVIDER DIAGNOSTICS REPORT, SET-UP DATA ; 05 Oct 98  8:43 PM
        ;;5.3;Scheduling;**11,25,49,132,159,556**;Aug 13, 1993;Build 3
START   ;
        U IO
        K ^TMP("SDRPT",$J),SDT,SDOE,DOE
        S SDT=SDBEG F  S SDT=$O(^SCE("B",SDT)) Q:'SDT!(SDT>SDEND)  D
        . S SDOE=0 F  S SDOE=$O(^SCE("B",SDT,SDOE)) Q:'SDOE  D
        .. K SDPRX,SDOE0
        .. Q:'$D(^SCE(SDOE,0))  S SDOE0=$G(^SCE(SDOE,0))
        .. Q:'$P(SDOE0,U,7)
        .. Q:$P(SDOE0,U,6)  ;ignore "child" encounters
        .. I '$$OKDIV(+$P(SDOE0,U,11)) Q
        .. I '$$CHECK(SORT1,SDOE0,SDOE) Q
        .. I '$$CHECK(SORT2,SDOE0,SDOE) Q
        .. S SDPRX("DFN")=+$P(SDOE0,U,2)
        .. S SDPRX("OED")=$P(SDOE0,U)
        .. S SDPRX("CL NAME")=$S(+$P($G(SDOE0),U,4)>0:$P(^SC(+$P(SDOE0,U,4),0),U),1:"UNSPECIFIED")
        .. S SDPRX("DIV NAME")=+$P(SDOE0,U,11)
        .. S SDPRX("PRV")=$$PRV1($S($P($G(SDOE0),U,6)']"":SDOE,1:$P($G(SDOE0),U,6)))
        .. S SDPRX("DX")=$$DX1($S($P($G(SDOE0),U,6)']"":SDOE,1:$P($G(SDOE0),U,6)))
        .. S SDPRX("SCODE")=+$P(SDOE0,U,3)
        .. D BLD(.SDPRX,SORT1,SORT2)
        D REPORT^SDAMODO3
EXIT    ;
        K DOE,SDOE,SDT,OEDIV,DXD,PD,SD,OEN,SRT,VAR1,DFN,P1,XPR,XPX,XDN,XPT,XDX,DXCDE,SDPRX,VA,VAERR,SDOE0,ZTDESC,%ZIS,ZTSAVE,ZTRTN,ZTSK,ZTQUEUED
        Q
        ;
BLD(SDPRX,SORT1,SORT2)  ;
        N Y,SUB1,SUB2,PRV
        S Y=0
        S SUB1=$S(SORT1=1:$$PRSUB($P(SDPRX("PRV"),U)),SORT1=2:$P(SDPRX("DX"),U),SORT1=3:$$PTSUB(SDPRX("DFN")),SORT1=4:SDPRX("CL NAME"),SORT1=5:SDPRX("SCODE"))
        S SUB2=$S(SORT2=1:$$PRSUB($P(SDPRX("PRV"),U)),SORT2=2:$P(SDPRX("DX"),U),SORT2=3:$$PTSUB(SDPRX("DFN")),SORT2=4:SDPRX("CL NAME"),SORT2=5:SDPRX("SCODE"))
        F I=1:1 I '$D(^TMP("SDRPT",$J,SDPRX("DIV NAME"),SUB1,SUB2,SDPRX("OED"),I)) D  Q
        . S PRV=$P(SDPRX("PRV"),U),DXCDE=$P(SDPRX("DX"),U)
        . D BLDTMP ; build first line
        . I SORT1=1 D  Q
        .. F XX=2:1 S PRV=$P(SDPRX("PRV"),U,XX)  Q:PRV']""  D
        ... S SUB1=$$PRSUB($P(SDPRX("PRV"),U,XX)) D BLDTMP
        . I SORT1=2 D  Q
        .. F XX=2:1 S DXCDE=$P(SDPRX("DX"),U,XX) Q:DXCDE']""  D
        ... S SUB1=DXCDE D BLDTMP
        Q
        ;
BLDTMP  ;
        N X1
        S ^TMP("SDRPT",$J,SDPRX("DIV NAME"),SUB1,SUB2,SDPRX("OED"),I,0)=SDPRX("DFN")_"^"_$$PDATA(SDPRX("DFN"))_"^"_SDPRX("CL NAME")_"^"_SDPRX("SCODE")_"^"_PRV_"^"_DXCDE
        F X1=1:1 Q:'$P($G(SDPRX("PRV")),U,X1)  D
        . Q:$P($G(SDPRX("PRV")),U,X1)=PRV
        . S ^TMP("SDRPT",$J,SDPRX("DIV NAME"),SUB1,SUB2,SDPRX("OED"),I,"PRV",$P($G(SDPRX("PRV")),U,X1))=""
        I SORT1'=2 F X1=1:1 Q:$P($G(SDPRX("DX")),U,X1)=""  D
        . Q:$P($G(SDPRX("DX")),U,X1)=DXCDE
        . S ^TMP("SDRPT",$J,SDPRX("DIV NAME"),SUB1,SUB2,SDPRX("OED"),I,"DX",$P($G(SDPRX("DX")),U,X1))=""
        Q
        ;
PRSUB(PRX)      ;
        S XPR="UNKNOWN^0"
        I +PRX>0 S XPR=$E($P(^VA(200,+PRX,0),U),1,29-$L(+PRX))_"^"_PRX
        Q (XPR)
        ;
PTSUB(PDFN)     ;
        S XPT=$E($P(^DPT(+PDFN,0),U),1,29-$L(PDFN))_"^"_PDFN
        Q (XPT)
        ;
PDATA(DFN)      ;
        D PID^VADPT6
        Q (VA("PID"))
        ;
OKDIV(OEDIV)       ;   check for divisions
        N Y
        S Y=0
        I OEDIV>0,VAUTD!($D(VAUTD(OEDIV))) S Y=1
OKDIVQ  Q (Y)
        ;
CHECK(SRT,SDOE0,OEN)    ;
        N Y
        S Y=0
        I SRT=1 S Y=$$PRV(OEN) G CHECKQ
        I SRT=2 S Y=$$DX(OEN) G CHECKQ
        I SRT=3,$P($G(SDOE0),U,2),PATN!($D(PATN(+$P($G(SDOE0),U,2)))) S Y=1 G CHECKQ
        I SRT=4,$P($G(SDOE0),U,4),CLINIC!($D(CLINIC(+$P($G(SDOE0),U,4)))) S Y=1 G CHECKQ
        I SRT=5,$P($G(SDOE0),U,3),STOPC!($D(STOPC(+$P($G(SDOE0),U,3)))) S Y=1 G CHECKQ
CHECKQ  Q (Y)
        ;
PRV(OEN)        ; -- is there at least one provider from selected list
        N Y,SD,PD,SDVPRV,SDVPRVS
        S Y=0
        D GETPRV^SDOE(OEN,"SDVPRVS")
        S SDVPRV=0
        F  S SDVPRV=$O(SDVPRVS(SDVPRV)) Q:'SDVPRV  D  Q:Y
        . S PD=+SDVPRVS(SDVPRV)
        . I PROVDR!($D(PROVDR(PD))) S Y=1  Q
        Q Y
        ;
DX(OEN) ; -- is there at least one dx from selected list
        N Y,SD,DXD,SDVPOV,SDVPOVS
        S Y=0
        D GETDX^SDOE(OEN,"SDVPOVS")
        S SDVPOV=0
        F  S SDVPOV=$O(SDVPOVS(SDVPOV)) Q:'SDVPOV  D  Q:Y
        . S DXD=+SDVPOVS(SDVPOV)
        . I PDIAG!($D(PDIAG(DXD))) S Y=1 Q
        Q Y
        ;
PRV1(OEN)       ; -- get list of providers for encounter
        N PROV,SD,Y,XX,PIFN,PRX,QFLAG,SDVPRV,SDVPRVS
        S Y=0,PRX="",QFLAG=0
        D GETPRV^SDOE(OEN,"SDVPRVS")
        S SDVPRV=0
        F  S SDVPRV=$O(SDVPRVS(SDVPRV)) Q:'SDVPRV  D  Q:QFLAG
        . S PIFN=+SDVPRVS(SDVPRV)
        . IF $D(PROVDR),'PROVDR,'$D(PROVDR(PIFN)) Q
        . S PRX=PRX_$S($G(^VA(200,PIFN,0))]"":PIFN,1:"UNKNOWN")_"^"
        . S:$L(PRX)>250 QFLAG=1
        I PRX']"" S PRX="UNKNOWN"
        Q PRX
        ;
DX1(OEN)        ; -- get list of dxs for encounter
        N SD,Y,XX,XDX,XDN,QFLAG,SDVPOV,SDVPOVS,SDICD9
        S XX=0,XDN="",QFLAG=0
        D GETDX^SDOE(OEN,"SDVPOVS")
        S SDVPOV=0
        F  S SDVPOV=$O(SDVPOVS(SDVPOV)) Q:'SDVPOV  D  Q:QFLAG
        . S XX=+SDVPOVS(SDVPOV)
        . I $D(PDIAG),'PDIAG,'$D(PDIAG(XX)) Q
        . S SDICD9=$$ICDDX^ICDCODE(XX)
        . S XDN=XDN_$S($D(SDICD9):$P(SDICD9,U,2)_U,1:"NOT SPECIFIED^")
        . S:$L(XDN)>250 QFLAG=1
        S:XDN']"" XDN="NOT SPECIFIED"
        Q XDN
