DIK     ;SFISC/GFT,YJK,XAK-GATHER A FILE'S XREFS TO EXECUTE ;02/25/2009
        ;;22.0;VA FileMan;**41,109,160**;Mar 30, 1999;Build 21
        ;Per VHA Directive 2004-038, this routine should not be modified.
        Q:"(,"'[$E($RE(DIK))  Q:'$D(@(DIK_"DA)"))  Q:$P($G(^DD($$GLO^DILIBF(DIK),0,"DI")),U,2)["Y"&'$D(DIOVRD)&'$G(DIFROM)  Q:DA'>0
        N DIKJ,DIKS,DIKZ1,DIN,DH,DU,DV,DW,DIKDA,DIAU,DIKALLR
        D CHKS I $D(DIKZ1) N DIKIL S DIKIL=1 G @DIKGP
        S X=2 D DD G ^DIK1
        ;
DD1     D D,A Q
        ;
DD      D DIKJ N DIKCHK S DIKCHK=1,DV=0 D D,A
        I $G(DIK(0))["s" S DU=1 Q
E       S DV=$O(^DD(DH,"SB",DV))
        I DV>0 S DU=$O(^(DV,0)) G E:'$D(^DD(DV,.01,0)),E:$P(^(0),U,2)["W" S DW=$P($P(^DD(DH,DU,0),U,4),";") S:+DW'=DW DW=""""_DW_"""" S DV(DH,DU)=DW,DV(DH,DU,0)=DV,DU(DV)=DH D:$D(DIK0) CRT^DIKZ2 G E
        Q:$D(DIK0)
DH      S DH=$O(DU(DH)) G:DH>0 DH:$D(DV(DH)),E
        F DH=DH(1):0 S DH=$O(DU(DH)) Q:DH'>0  D D,A
DV      S DH=0 F  S DH=$O(DV(DH)) Q:'DH  S DU=0 F  S DU=$O(DV(DH,DU)) Q:'DU  I $G(DIKCHK),'$G(DIKCHK(DV(DH,DU,0))) S DV(DH,DU,"NOLOOP")=""
        S DU=1
        Q
        ;
DW      I $O(^UTILITY("DIK",DIKJ,DH,DV,0))="" K ^UTILITY("DIK",DIKJ,DH,DV)
D       S DV=$O(^DD(DH,"IX",DV)) Q:DV'>0  I '$D(^DD(DH,DV,0)) K ^DD(DH,"IX",DV) G D
        D 0
I       F DW=0:0 S DW=$O(^DD(DH,DV,1,DW)) Q:DW'>0  I $D(^(DW,X)),"Q"'[^(X),$D(^(0)) S %=^(0) D INX
        G DW
INX     I %["TRIGGER" S %=^(X),^UTILITY("DIK",DIKJ,DH,DV,DW)="D RCR",^(DW,0)=% Q
        I %["BULLETIN MESSAGE",$D(DIK(0)),DIK(0)["B" S %=$P("CREA^DELE",U,X)_"TE VALUE" W:$D(^(%)) !,"...('"_^(%)_"' BULLETIN WILL NOT BE TRIGGERED)..." Q
        I '$D(DIK0),X=2,$P(%,U),$P(%,U,2)]"",$P(%,U,3)="",+%=DH(1)&$G(DIKALLR)!$D(DU(+%)) D
        . S ^UTILITY("DIK",DIKJ,"KW",+%,$P(%,U,2))=DH_U_DV_U_DW
        . D CHK($G(DU(+%)),.DU,.DIKCHK)
        E  D
        . S ^UTILITY("DIK",DIKJ,DH,DV,DW)=^DD(DH,DV,1,DW,X)
        . D CHK(DH,.DU,.DIKCHK)
        Q
CHK(F,DU,DIKCHK)        ;Set CHK(f) for file F and its parents
        Q:$D(DIK0)!'$G(DIKCHK)
        F  Q:'F  Q:$D(DIKCHK(F))  S DIKCHK(F)=1,F=$G(DU(F))
        Q
A       F DV=0:0 S DV=$O(^DD(DH,"AUDIT",DV)) Q:DV'>0  D A1
        Q
A1      D 0 S ^UTILITY("DIK",DIKJ,DH,DV,99)="S DIIX="_(4-X)_" D:$G(DIK(0))'[""A"" AUDIT" D CHK(DH,.DU,.DIKCHK) Q
0       ;
        S DW=$P(^DD(DH,DV,0),U,4),^UTILITY("DIK",DIKJ,DH,DV)=$P(DW,";",1),DW=$P(DW,";",2)
        S ^UTILITY("DIK",DIKJ,DH,DV,0)=$S(DW:"S X=$P($G(^(X)),U,"_DW_")",1:"S X=$E($G(^(X)),"_+$E(DW,2,9)_","_$P(DW,",",2)_")"),DW=0 Q
        ;
IX      ;
        N DIKJ,DIKS,DIKZ1,DIN,DH,DU,DV,DW,DIKDA,DIKALLR
        D CHKS I $D(DIKZ1) N DIKKS S DIKKS=1 G @DIKGP
        S X=2,DIKNM=1 D DD,1^DIK1
IX1     ;
        N DIKJ,DIKS,DIKZ1,DIN,DH,DU,DV,DW,DIKDA,DIKSET,DIKALLR
        I '$D(DIKNM) D CHKS I $D(DIKZ1) N DIKST S DIKST=1 G @DIKGP
        S X=1,DIKSET=1 D DD,1^DIK1
        ;
        D INDEX^DIKC(DIK,.DA,"","",$E("K",$D(DIKNM)#2)_"S"_$E("RI",$D(DIFROM)#2+1)_$E("s",$G(DIK(0))["s"))
        G Q
        ;
IX2     ;
        Q:$D(@(DIK_"0)"))[0
        N DIKJ,DIKS,DIN,DH,DU,DV,DW,DIKDA,DIKALLR
        S X=2 D DD,1^DIK1
        D INDEX^DIKC(DIK,.DA,"","","K"_$E("RI",$D(DIFROM)#2+1)_$E("s",$G(DIK(0))["s"))
        G Q
        ;
IXALL   ;
        N DIKJ,DIKS,DIKZ1,DIN,DH,DU,DV,DW,DIKDA,DIKSET,DIKALLR
        D CHKS I $D(DIKZ1) N DIKSAT S DIKSAT=1,DA=0 G @DIKGP
        ;
        N DIKDASV,DIKSAVE
        M DIKDASV=DA S DIKDASV=0,DIKSAVE=DIK
        S (DA,DCNT)=0,X=1,DIKSET=1 D DD,CNT^DIK1
        ;
        D INDEX^DIKC(DIKSAVE,.DIKDASV,"","","S"_$E("RI",$D(DIFROM)#2+1)_$E("s",$G(DIK(0))["s"))
        G Q
        ;
IXALL2  ;
        Q:$D(@(DIK_"0)"))[0
        N DIKJ,DIKS,DIN,DH,DU,DV,DW,DIKDA,DIKDASV,DIKSAVE,DIKALLR
        M DIKDASV=DA S DIKDASV=0,DIKSAVE=DIK
        S DIKALLR=1,(DA,DCNT)=0,X=2 D DD,CNT^DIK1
        ;
        D INDEX^DIKC(DIKSAVE,.DIKDASV,"","","K"_$E("RI",$D(DIFROM)#2+1)_$E("s",$G(DIK(0))["s"))
        G Q
        ;
EN      ;
        N DIKCRFIL,DIKCDIK,DIKJ,DIKS,DIKZ1,DIN,DH,DU,DV,DW,DIKDA,DIKALLR
        D N G:'$D(DH)!'$D(DA) Q
        S DIKCRFIL=DH M DIKCDIK=DIK
        S DIKNM=1,X=2 D:$D(DIKNX) PR,1^DIK1
        ;
EN1     ;
        N DIKJ,DIKS,DIKZ1,DIN,DH,DU,DV,DW,DIKDA,DIKALLR
        D @$S('$D(DIKNM):"N",1:"DIKJ") G:'$D(DH)!'$D(DA) Q
        I '$D(DIKNM) N DIKCRFIL,DIKCDIK S DIKCRFIL=DH M DIKCDIK=DIK
        S X=1 D:$D(DIKNX) PR,1^DIK1
        I $D(^DD("IX","AC",DIKCRFIL)) M DIK=DIKCDIK D INDEX^DIKC(DIKCRFIL,.DA,$P(DIK(1),U),$P(DIK(1),U,2,999),$E("K",$D(DIKNM))_"S"_$E("RI",$D(DIFROM)#2+1))
        G Q
        ;
EN2     ;
        N DIKCRFIL,DIKCDIK,DIKJ,DIKS,DIKZ1,DIN,DH,DU,DV,DW,DIKDA,DIKALLR
        D N G:'$D(DH)!'$D(DA) Q
        S DIKCRFIL=DH M DIKCDIK=DIK
        S X=2 D:$D(DIKNX) PR,1^DIK1
        I $D(^DD("IX","AC",DIKCRFIL)) M DIK=DIKCDIK D INDEX^DIKC(DIKCRFIL,.DA,$P(DIK(1),U),$P(DIK(1),U,2,999),"K"_$E("RI",$D(DIFROM)#2+1))
        G Q
        ;
ENALL   ;
        N DIKJ,DIKS,DIKZ1,DIN,DH,DU,DV,DW,DIKDA,DIKXREF,DIKDASV,DIKSAVE,DHSAVE,DIKALLR
        D N G:'$D(DH) Q
        M DIKDASV=DA,DIKSAVE=DIK,DHSAVE=DH S DIKDASV=0
        S (DA,DCNT)=0,X=1 D PR,CNT^DIK1
        D:$D(^DD("IX","AC",DHSAVE)) INDEX^DIKC(DHSAVE,.DIKDASV,$P(DIKSAVE(1),U),$P(DIKSAVE(1),U,2,999),"S"_$E("RI",$D(DIFROM)#2+1))
        G Q
        ;
ENALL2  ;
        N DIKJ,DIKS,DIKZ1,DIN,DH,DU,DV,DW,DIKDA,DIKXREF,DIKDASV,DIKSAVE,DHSAVE,DIKALLR
        D N G:'$D(DH) Q
        M DIKDASV=DA,DIKSAVE=DIK,DHSAVE=DH S DIKDASV=0
        S DIKALLR=1,(DA,DCNT)=0,X=2 D PR,CNT^DIK1
        D:$D(^DD("IX","AC",DHSAVE)) INDEX^DIKC(DHSAVE,.DIKDASV,$P(DIKSAVE(1),U),$P(DIKSAVE(1),U,2,999),"K"_$E("RI",$D(DIFROM)#2+1))
        G Q
        ;
        ;
N       Q:'$D(DIK)!'$D(DIK(1))!'$D(@(DIK_"0)"))  D DIKJ S DIKND=$P(DIK(1),U)
        I '$D(^DD(DH,"IX",DIKND)) K:'$D(^DD("IX","F",DH,DIKND)) DH Q
        I $P(DIK(1),U,2)="" D
        . S %=0 F A1=1:1 S %=$O(^DD(DH,DIKND,1,%)) Q:'%  S DIKNX(A1)=%
        E  F A1=1:1 Q:$P(DIK(1),U,A1+1)=""  S DIKNX(A1)=$P(DIK(1),U,A1+1)
        K A1,% Q
        ;
PR      S DV=DIKND I '$D(^DD(DH,"IX",DV)),'$D(^DD(DH,"AUDIT",DV)) Q
        D 0 S DIKZ1=1 D CK K DIKZ1
        D:$D(^DD(DH,"AUDIT",DV)) A1 S DU=1 Q
        ;
CK      Q:'$D(DIKNX(DIKZ1))
        F DW=0:0 S DW=$O(^DD(DH,DV,1,DW)) Q:DW'>0  I $D(^(DW,0)),(DW=DIKNX(DIKZ1))!($P(^(0),U,2)=DIKNX(DIKZ1)),$D(^(X)),"Q"'[^(X) S %=^(0) D INX
        S DIKZ1=DIKZ1+1 G CK
        ;
FREE(X) N V S V=$G(^UTILITY("DIK",X)) I 'V Q 1
        Q $H-1>V
        ;
DIKJ    F DIKJ=$J:.01 I $$FREE(DIKJ) K ^UTILITY("DIK",DIKJ) S ^UTILITY("DIK",DIKJ)=$H Q
INT     K DIKS,DIN,DH,DU,DV,DW S U="^",DH=+$P(@(DIK_"0)"),U,2),DH(1)=DH Q
CHKS    ;
        I $D(@(DIK_"0)"))[0 S DIKZ1=1,DIKGP="Q^DIK1" Q
        S DIKZ1=+$P(^(0),"^",2) I DIKZ1,$D(^DD(DIKZ1,0,"DIK")),$$ROUEXIST^DILIBF(^("DIK")) S DIKGP="^"_^DD(DIKZ1,0,"DIK") Q
        K DIKZ1 Q
        ;
Q       K DIKND,DIKNX,DIKZ1,DIKNM,DIAU,DIG,DIH,DIV,DIW,%,DH Q
