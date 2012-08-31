LRBEECPT        ;DALOI/JAH - Edit CPT associated with CIDC; 3/29/05
        ;;5.2;LAB SERVICES;**291,315**;Sep 27, 1994;Build 25
        ;
        ; To be able to provide a clean claim to the billing application, there
        ; needs be an association between the test, the specimen, and the 
        ; CPT/HCPCS codes. This routine is designed to allow the user to define
        ; this associaton.
        ;
        ; Reference to EN^DDIOL supported by IA #10142
        ; Reference to ^DIC supported by IA #10006
        ; Reference to $$GET1^DIQ supported by IA #2056
        ; Reference to ^DIR supported by IA #10026
        ; Reference to  $$CPT^ICPTCOD Supported by DBIA #1995-A
        ;
STRT    ; Start the routine
        N DIC,DIR,X,Y,LRBEY,LRBEQUIT,LRBEPNL
        N LRBEAR,LRBEAR2,LRBEARP,LRBETST,LRBETSTN,LRBEMSG
        S LRBEQUIT=0
        F  D  Q:LRBEQUIT
        .D TST S:Y<1 LRBEQUIT=1 Q:LRBEQUIT 
        .D EN^DDIOL("","","!")
        .S DIR(0)="E" D ^DIR S:Y<1 LRBEQUIT=1
        .D EN^DDIOL("","","!")
        .D KLL
        Q
TST     ; Ask the user for the test to work on.
        S DIC="^LAB(60,",DIC(0)="AEMQZ" D ^DIC
        I Y=-1 K DIC Q  ;quit if look-up fails
        S LRBEPNL=0
        I $P(Y(0),"^",5)="" S LRBEPNL=1  ;Selected test is a panel
        S LRBEY=Y D WORK(LRBEY) Q:LRBEQUIT
        Q
WORK(LRBEY)     ; Start getting the CPT/HCPCS Codes
        S LRBETST=$P(LRBEY,U,1),LRBETSTN=$P(LRBEY,U,2)
        S LRBEAR2("TEST",LRBETST)=LRBEY
        W ! D SPEC(LRBETST) Q:LRBEQUIT
        W ! D DEFH(LRBETST,LRBETSTN) Q:LRBEQUIT
        W ! D DEFC(LRBETST,LRBETSTN) Q:LRBEQUIT
        I LRBEPNL D  Q:LRBEQUIT
        .W ! D AAMA^LRBEECP1(LRBETST,LRBETSTN)
        D DISCPT(.LRBEAR2) Q:LRBEQUIT
        Q
SPEC(LRBETST)   ; Get the Specimen and CPT of the Test
        N A,LRBEAX,LRBESP,LRBESPI,LRBESPE,LRBECPT,LRBEFIL,LRBEFLD,LRBEDT,LRBEMSG
        N LRBEQT,LRBEXMSG,LRBEDCPT,LRX,LRBEDESC
        D SAR(LRBETST,.LRX)
        S A="" F  S A=$O(LRX(60.196,A)) Q:A=""!(LRBEQUIT)  D
        .S LRBESP=$O(LRX(60.196,A,""),-1)
        .S LRBESPI=$P(A,",",1)
        .S LRBESPE=$P($G(LRX(60.196,A,LRBESP)),"^",1)
        .S LRBEDCPT=$P($G(LRX(60.196,A,LRBESP)),"^",2)
        .S LRBEQT=0 F  D  Q:LRBEQT!(LRBEQUIT)
        ..S LRBEMSG="Enter a CPT for a "_LRBESPE_" specimen: "
        ..S LRBECPT=$$ACPT(LRBEMSG,LRBEDCPT) Q:LRBEQUIT
        ..I LRBEDCPT="",LRBECPT="@" D WMSG("","ND") Q
        ..I LRBECPT=LRBEDCPT S LRBEQT=1 Q:LRBEQT
        ..S:LRBECPT="" LRBEQT=1 Q:LRBEQT
        ..I $P(LRBECPT,U,1)="@" D  Q
        ...S LRBEDESC=$P($$CPT^ICPTCOD(LRBEDCPT),U,3)
        ...S LRBECPT=LRBECPT_"^"_LRBEDCPT_"^"_LRBEDESC_"^"
        ...S LRBECPT=LRBECPT_LRBESP_","_LRBESPI_","_LRBETST_","
        ...S LRBEAR2("TEST",LRBETST,"00-SPECIMEN",LRBESPI)=LRBECPT,LRBEQT=1
        ...S $P(LRBEAR2("TEST",LRBETST,"00-SPECIMEN",LRBESPI,"S"),U,1)=LRBESPE
        ..S LRBEDT=$$ADAT("TODAY") Q:LRBEQUIT
        ..S LRBEAX=$$GCPT(LRBECPT,LRBEDT) Q:LRBEQUIT
        ..I +LRBEAX=-1 D WMSG($P(LRBEAX,U,2),"IV") Q
        ..I $P(LRBEAX,U,7)'=1 D WMSG("INACTIVE","IA") Q
        ..D WMSG($P(LRBEAX,U,3),"V")
        ..S $P(LRBEAR2("TEST",LRBETST,"00-SPECIMEN",LRBESPI),U,1)=LRBEAX,LRBEQT=1
        ..S LRBEAX=LRBESPE_"^"_LRBEDT
        ..S $P(LRBEAR2("TEST",LRBETST,"00-SPECIMEN",LRBESPI,"S"),U,1)=LRBESPE
        ..S $P(LRBEAR2("TEST",LRBETST,"00-SPECIMEN",LRBESPI,"D"),U,1)=LRBEDT
        Q
DEFH(LRBETST,LRBETSTN)   ; Get the Default HCPCS
        N LRBEAX,LRBEQT
        S LRBEQT=0 F  D  Q:LRBEQT!(LRBEQUIT)
        .S LRBEAX=$$DHCPCS(LRBETST,LRBETSTN)
        .S:LRBEAX="" LRBEQT=1 Q:LRBEQT!(LRBEQUIT)
        .I +LRBEAX=-3 D WMSG("","ND") Q
        .I $P(LRBEAX,U,1)="@" D  Q
        ..S LRBEAR2("TEST",LRBETST,"01-DEFAULT HCPCS")=LRBEAX,LRBEQT=1
        .I +LRBEAX=-2 S LRBEQT=1 Q:LRBEQT
        .I +LRBEAX=-1 D WMSG($P(LRBEAX,U,2),"IV") Q
        .I $P(LRBEAX,U,7)'=1 D WMSG("INACTIVE","IA") Q
        .D WMSG($P(LRBEAX,U,3),"V")
        .S LRBEAR2("TEST",LRBETST,"01-DEFAULT HCPCS")=LRBEAX,LRBEQT=1
        Q
DHCPCS(LRBETST,LRBETSTN)          ; Get the Default HCPCS code of the Test
        N LRBECPT,LRBEDCPT,LRBEDT,LRBEMSG,LRBEFIL,LRBEFLD,LRBEQT,LRBEDESC
        S LRBEMSG="Enter a HCPCS code for "_LRBETSTN_": "
        S LRBEFIL=60,LRBEFLD=507
        S LRBEDCPT=$$GET1^DIQ(LRBEFIL,LRBETST_",",LRBEFLD)
        S LRBECPT=$$ACPT(LRBEMSG,LRBEDCPT) Q:LRBEQUIT LRBEQUIT
        I LRBECPT="" Q LRBECPT
        I LRBEDCPT="",LRBECPT="@" Q -3
        I LRBECPT="@" D  Q LRBECPT
        .S LRBEDESC=$P($$CPT^ICPTCOD(LRBEDCPT),U,3)
        .S LRBECPT=LRBECPT_"^"_LRBEDCPT_"^"_LRBEDESC
        I LRBECPT=LRBEDCPT Q -2
        S LRBEDT=$$ADAT("TODAY") Q:LRBEQUIT LRBEQUIT
        S $P(LRBEAR2("TEST",LRBETST,"01-DEFAULT HCPCS","D"),U,1)=LRBEDT
        Q $$GCPT(LRBECPT,LRBEDT)
DEFC(LRBETST,LRBETSTN)  ; Get the Default CPT
        N LRBEAX,LRBEQT
        S LRBEQT=0 F  D  Q:LRBEQT!(LRBEQUIT)
        .S LRBEAX=$$DCPT(LRBETST,LRBETSTN)
        .S:LRBEAX="" LRBEQT=1 Q:LRBEQT!(LRBEQUIT)
        .I +LRBEAX=-3 D WMSG("","ND") Q
        .I $P(LRBEAX,U,1)="@" D  Q
        ..S LRBEAR2("TEST",LRBETST,"02-DEFAULT CPT")=LRBEAX,LRBEQT=1
        .I +LRBEAX=-2 S LRBEQT=1 Q:LRBEQT
        .I +LRBEAX=-1 D WMSG($P(LRBEAX,U,2),"IV") Q
        .I $P(LRBEAX,U,7)'=1 D WMSG("INACTIVE","IA") Q
        .D WMSG($P(LRBEAX,U,3),"V")
        .S LRBEAR2("TEST",LRBETST,"02-DEFAULT CPT")=LRBEAX,LRBEQT=1
        Q
DCPT(LRBETST,LRBETSTN)    ; Get the Default CPT code of the Test
        N LRBECPT,LRBEDCPT,LRBEDT,LRBEMSG,LRBEFIL,LRBEFLD,LRBEQT,LRBEDESC
        S LRBEMSG="Enter a Default CPT code for "_LRBETSTN_": "
        S LRBEFIL=60,LRBEFLD=506
        S LRBEDCPT=$$GET1^DIQ(LRBEFIL,LRBETST_",",LRBEFLD)
        S LRBECPT=$$RCPT(LRBEMSG,LRBEDCPT) Q:LRBEQUIT LRBEQUIT
        I LRBECPT="" Q LRBECPT
        I LRBEDCPT="",LRBECPT="@" Q -3
        I LRBECPT="@" D  Q LRBECPT
        .S LRBEDESC=$P($$CPT^ICPTCOD(LRBEDCPT),U,3)
        .S LRBECPT=LRBECPT_"^"_LRBEDCPT_"^"_LRBEDESC
        I LRBECPT=LRBEDCPT Q -2
        S LRBEDT=$$ADAT("TODAY") Q:LRBEQUIT LRBEQUIT
        S $P(LRBEAR2("TEST",LRBETST,"02-DEFAULT CPT","D"),U,1)=LRBEDT
        Q $$GCPT(LRBECPT,LRBEDT)
ACPT(LRBEMSG,DCPT)      ; Ask for CPT/HCPCS Code
        N X,Y,DIR,DUOUT,DTOUT,DIRUT
        S DIR("B")=DCPT
        S DIR("A")=LRBEMSG,DIR(0)="FAUO^3:10" D ^DIR
        I $D(DTOUT)!($D(DUOUT))!(X[U) S LRBEQUIT=1 Q LRBEQUIT
        I Y?1A.4N Q Y
        I X="@" Q X
        S:Y<1 Y=""
        Q Y
ADAT(LRBEMSG)   ; Ask for date
        N X,Y,DIR,DUOUT,DTOUT,DIRUT
        D NOW^%DTC
        S DIR(0)="DAO^"_X_"::E",DIR("B")=LRBEMSG
        S DIR("A")="Enter Date to be Checked: "
        D ^DIR I $D(DTOUT)!($D(DUOUT)) S Y=-1,LRBEQUIT=1
        Q Y_"."_$P(%,".",2)
RCPT(LRBEMSG,DCPT)      ; Ask for Required default CPT/HCPCS Code
        N X,Y,DIR,DUOUT,DTOUT,DIRUT
        S DIR("B")=DCPT
        S DIR("A")=LRBEMSG,DIR(0)="FAUO^3:10" D ^DIR
        I $D(DTOUT)!($D(DUOUT))!(X[U) S LRBEQUIT=1 Q LRBEQUIT
        I X="@" Q X
        S:Y<1 Y=""
        Q Y
GCPT(CPT,TDAT)  ; Get the CPT/HCPCS Code
        Q $$CPT^ICPTCOD(CPT,TDAT)
DISCPT(LRBEAR2)   ; Display the CPT code in File #60
        N LRBEAX,LRBEALO,LRBEBX,DIR,LRBEQT,X,Y
        S LRBEQT=0 D EN^DDIOL("","","!!")
        S LRBEAX="" F  S LRBEAX=$O(LRBEAR2("TEST",LRBEAX)) Q:LRBEAX=""!(LRBEQT)  D
        .I $D(LRBEAR2("TEST",LRBEAX))'=11 S LRBEQT=1 Q:LRBEQT
        .S LRBEALO=1
        .D EN^DDIOL("TEST:","","")
        .D EN^DDIOL($E($P(LRBEAR2("TEST",LRBEAX),U,2),1,30),"","?10")
        .S LRBEBX="" F  S LRBEBX=$O(LRBEAR2("TEST",LRBEAX,"00-SPECIMEN",LRBEBX)) Q:LRBEBX=""  D
        ..S X=$G(LRBEAR2("TEST",LRBEAX,"00-SPECIMEN",LRBEBX)) Q:X=""
        ..S Y=$G(LRBEAR2("TEST",LRBEAX,"00-SPECIMEN",LRBEBX,"S"))
        ..D:LRBEALO 
        ...D EN^DDIOL("SPECIMEN:","","!"),EN^DDIOL("","","!")
        ..D EN^DDIOL($E(Y,1,15),"","?3")
        ..D EN^DDIOL($E($P(X,U,3),1,35),"","?20")
        ..D EN^DDIOL($S($P(X,U,1)="@":$P(X,U,2)_" (DELETE)",1:$P(X,U,1)),"","?60")
        ..D EN^DDIOL("","","!") S LRBEALO=0
        .S X=$G(LRBEAR2("TEST",LRBEAX,"01-DEFAULT HCPCS"))
        .D:X'=""
        ..D EN^DDIOL("HCPCS:","","")
        ..D EN^DDIOL($E($P(X,U,3),1,35),"","?20")
        ..D EN^DDIOL($S($P(X,U,1)="@":$P(X,U,2)_" (DELETE)",1:$P(X,U,1)),"","?60")
        ..D EN^DDIOL("","","!")
        .S X=$G(LRBEAR2("TEST",LRBEAX,"02-DEFAULT CPT"))
        .D:X'=""
        ..D EN^DDIOL("Default CPT:","","")
        ..D EN^DDIOL($E($P(X,U,3),1,35),"","?20")
        ..D EN^DDIOL($S($P(X,U,1)="@":$P(X,U,2)_" (DELETE)",1:$P(X,U,1)),"","?60")
        ..D EN^DDIOL("","","!")
        .S X=$G(LRBEAR2("TEST",LRBEAX,"03-AMA FLAG"))
        .D:X'=""
        ..D EN^DDIOL("Panel CPT(S) AMA compliant or otherwise billable?:","","")
        ..D EN^DDIOL($S(X=1:"YES",1:"NO"),"","?60")
        ..D EN^DDIOL("","","!")
        Q:LRBEQT
        S DIR("A")="Is this correct",DIR(0)="Y",DIR("B")="YES" D ^DIR
        I Y D SCPT(.LRBEAR2)
        Q
SCPT(LRBEAR2)   ; Set the CPT code in File #60
        N LRBEAX,LRBEBX,LRBEFIL1,LRBEFIL2,LRERR,LRFDA,LRBESEQ,LRBEX,LRBEXX
        N LRBEXIEN,LRBEDEL
        S LRBEFIL1=60,LRBEFIL2=60.196
        S LRBEAX="" F  S LRBEAX=$O(LRBEAR2("TEST",LRBEAX)) Q:LRBEAX=""  D
        .S LRBEX=$G(LRBEAR2("TEST",LRBEAX,"01-DEFAULT HCPCS"))
        .S:LRBEX'="" LRFDA(99,LRBEFIL1,LRBEAX_",",507)=$P(LRBEX,U,1)
        .S LRBEX=$G(LRBEAR2("TEST",LRBEAX,"02-DEFAULT CPT"))
        .S:LRBEX'="" LRFDA(99,LRBEFIL1,LRBEAX_",",506)=$P(LRBEX,U,1)
        .S LRBEX=$G(LRBEAR2("TEST",LRBEAX,"03-AMA FLAG"))
        .S:LRBEX'="" LRFDA(99,LRBEFIL1,LRBEAX_",",508)=$P(LRBEX,U)
        .S LRBEBX=""
        .F  S LRBEBX=$O(LRBEAR2("TEST",LRBEAX,"00-SPECIMEN",LRBEBX)) Q:LRBEBX=""  D
        ..S LRBEX=$G(LRBEAR2("TEST",LRBEAX,"00-SPECIMEN",LRBEBX))
        ..S LRBEDEL=$S($P(LRBEX,U)="@":1,1:0)
        ..I LRBEDEL D
        ...S LRBEXIEN=$P(LRBEX,U,4),LRFDAIEN=""
        ..I 'LRBEDEL D
        ...S LRBESEQ=$O(^LAB(60,LRBEAX,1,LRBEBX,3,"A"),-1)+1
        ...S LRBETNUM=$G(LRBETNUM)+1
        ...S LRBEXIEN="+"_LRBETNUM_","_LRBEBX_","_LRBEAX_","
        ...S LRFDAIEN(LRBETNUM)=LRBESEQ
        ...S LRBEXX=$G(LRBEAR2("TEST",LRBEAX,"00-SPECIMEN",LRBEBX,"D"))
        ..S LRFDA(99,LRBEFIL2,LRBEXIEN,.01)=$P(LRBEX,U,1)
        ..S:'LRBEDEL LRFDA(99,LRBEFIL2,LRBEXIEN,1)=$P(LRBEXX,U,1)
        D UPDATE^DIE("","LRFDA(99)","LRFDAIEN","LRERR")
        Q
SAR(LRBETST,LRBEAR2)    ; Setup Array for Specimen
        N A,B,LRBEAR,LRBETNAM,LRBETNUM,LRBETCPT
        D GETS^DIQ(60,LRBETST_",","100*","","LRBEAR")
        S A="" F  S A=$O(LRBEAR(60.01,A)) Q:A=""  D
        .S LRBETNUM=1,LRBETCPT="",LRBETNAM=$P(LRBEAR(60.01,A,.01),U,1)
        .S B="" F  S B=$O(LRBEAR(60.196,B)) Q:B=""  D
        ..Q:A'=$P(B,",",2,4)
        ..S LRBETNUM=$P(B,",",1),LRBETCPT=$G(LRBEAR(60.196,B,.01))
        .S LRBEAR2(60.196,$P(A,",",1),LRBETNUM)=LRBETNAM_"^"_LRBETCPT
        Q
WMSG(LRBEDESC,LRBEFLG)  ; Write Message
        N LRBEXMSG
        S:LRBEFLG="ND" LRBEXMSG="NOTHING TO DELETE"
        S:LRBEFLG="IV" LRBEXMSG="INVALID CPT: "_LRBEDESC
        S:LRBEFLG="IA" LRBEXMSG="INACTIVE CPT: NOT ACTIVE FOR THIS DATE"
        S:LRBEFLG="V" LRBEXMSG="VALID CPT: "_LRBEDESC
        D EN^DDIOL(LRBEXMSG,"","!?$X+5")
        Q
KLL     ; Kill all variable
        K LRBEAX,DIC,DIR,LRBEQT,X,Y
        K LRBEAR,LRBEAR2,LRBEARP,LRBETST,LRBETSTN,LRBEMSG
        Q
