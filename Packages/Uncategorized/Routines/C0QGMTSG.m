C0QGMTSG        ; SLC/DLT,KER - Allergies ; 01/06/2003
        ;;2.7;Health Summary;**9,28,49,58**;Oct 20, 1995;Build 12
        ;
        ; External References
        ;   DBIA 10096  ^%ZOSF("TEST"
        ;   DBIA 10035  ^DPT(
        ;   DBIA   905  ^GMR(120.8
        ;   DBIA  2056  $$GET1^DIQ (file #120.86 and #200)
        ;   DBIA 10011  ^DIWP
        ;   DBIA 10099  EN1^GMRADPT  **LOCAL changed to C0QGMRAD
        ;   DBIA 10060  ^VA(200,
        ;   DBIA  3449  ^GMR(120.86,
        ;
ALLRG   ; Allergies
        N X,GMTSALAS,GMTSALAD,GMTSALAW,GMTSALAT,GMTSAV,GMTSAFN,GMRAL,GMTSAL
        N GMTSALNM,GMTSCNT,GMTSEACT,GMTSLN,GMTSMECH,GMTSPRT,GMTSTY,CC,C,KK
        N ALLRG,TITLE,JJ K GMTSA S (SEQ,ALLRG)=0,TITLE="ALLERGY/ADVERSE REACTION (AR)"
        S X="C0QGMRAD" X ^%ZOSF("TEST")
        I $T D  Q:$D(GMTSQIT)
        . D GETALLRG D:ALLRG TITLE,ALLRGP D:'ALLRG&($L($G(GMTSALAS))) TITLE,NKA
        I 'ALLRG,'$L($G(GMTSALAS)) D
        . I $D(GMTSPNF)&('ALLRG) D CKP^GMTSUP Q:$D(GMTSQIT)  W "Unknown, please evaluate",!
        K ALL,CC,CCC,CD,DIWF,DIWL,DIWR,GMTSALF,GMTSALNM,GMTSNODE,GMTSPRT,I,II,JJ,KK,L,M,MX,N,Z,X,SEQ,GMTSA,ALLRG,TITLE,GMRA,GMRAL,GMTSEACT,GMTSMECH,GMTSTY,GMTSPFN,GMTSAL,GMTSCNT,GMTSLN,ODT
        Q
ALLRGP  ; Allergy Print
        S II="" F  S II=$O(GMTSAL(II)) Q:II']""  I $O(GMTSAL(II,""))]"" D
        . D CKP^GMTSUP Q:$D(GMTSQIT)  W !?2,$S(II="D":"Drug:",II="DF":"Drug/Food:",II="DFO":"Drug/Food/Other:",II="DO":"Drug/Other:",II="F":"Food:",II="FO":"Food/Other:",II="O":"Other:",1:II_":")
        . S JJ="" F  S JJ=$O(GMTSAL(II,JJ)) Q:JJ=""  D
        .. N WKK S KK=""  F  S KK=$O(GMTSAL(II,JJ,KK)) Q:KK=""  D
        ... S L=0 F  S L=$O(GMTSAL(II,JJ,KK,L)) Q:'L  D CKP^GMTSUP Q:$D(GMTSQIT)  D AUTOV W !?5,JJ_": " S:$L(KK)>30 WKK=KK,WKK=$$WRAP^GMTSORC(WKK,30) W ?24,$S($L(KK)>30:$P(WKK,"|"),1:KK) D
        .... I GMTSAV=1 W " (AV"
        .... E  W $S($P(GMTSAL(II,JJ,KK,L),U,5)=1:" (V",$P(GMTSAL(II,JJ,KK,L),U,5)=0:" (NV",1:"")
        .... W $S($P($G(^GMR(120.8,GMTSALNM,0)),U,6)="h":"/Historical)",$P($G(^(0)),U,6)="o":"/Observed)",1:")")
        .... I $L($P($G(WKK),"|",2)) D CKP^GMTSUP Q:$D(GMTSQIT)  W !,?24,$P(WKK,"|",2)
        .... S (M,MX,ALL)=0 F  S M=$O(GMTSAL(II,JJ,KK,L,"S",M)) Q:M=""  D  Q:$D(GMTSQIT)
        ..... I ALL=0 D CKP^GMTSUP Q:$D(GMTSQIT)  W !?27
        ..... S MX=MX+1
        ..... W:MX>1 ", "
        ..... S N=$P(GMTSAL(II,JJ,KK,L,"S",M),";")
        ..... S ALL=1 I (74)'>($X+$L(N)) D CKP^GMTSUP Q:$D(GMTSQIT)  W !,?27,N Q
        ..... S ALL=1 W N
        .... D SIGBLK($P(GMTSAFN,U,5))
        .... D CKP^GMTSUP Q:$D(GMTSQIT)  W !,?24,"Date/Time:  " S ODT=$P(GMTSAFN,U,4) S X=ODT D REGDTM4^GMTSU W X,!
        ....S CC="" F  S CC=$O(^GMR(120.8,GMTSALNM,26,"B",CC)) Q:CC=""  D CKP^GMTSUP Q:$D(GMTSQIT)  W !,?24,"Comments at: " S X=CC D REGDTM4^GMTSU S CD=X S CCC=0 F  S CCC=$O(^GMR(120.8,GMTSALNM,26,"B",CC,CCC)) Q:'CCC  D TEXT
        Q
NKA     ; No known allergies
        D CKP^GMTSUP Q:$D(GMTSQIT)  W:$L($G(GMTSALAS))!($L($G(GMTSALAD))) !
        D CKP^GMTSUP Q:$D(GMTSQIT)  W:$L($G(GMTSALAS)) ?22,$G(GMTSALAS),!
        D CKP^GMTSUP Q:$D(GMTSQIT)  W:$L($G(GMTSALAS))!($L($G(GMTSALAD)))!($L($G(GMTSALAW))) ?24,"Assessment date:   ",$G(GMTSALAD),!
        D CKP^GMTSUP Q:$D(GMTSQIT)  W:$L($G(GMTSALAW)) ?28,"Assessed by:   ",GMTSALAW,!
        D CKP^GMTSUP Q:$D(GMTSQIT)  W:$L($G(GMTSALAW))&($L($G(GMTSALAT))) ?34,"Title:   ",GMTSALAT,!
        Q
GETALLRG        ; Get Allergies
        S GMRA="0^0^111^1" D EN1^C0QGMRAD I GMRAL="" S ALLRG=0 Q
        I +($G(DFN))>0,+($G(GMRAL))=0 D ALLAS S ALLRG=0 Q
        I $D(GMRAL)>9 D
        . S I=0 F GMTSCNT=1:1 S I=$O(GMRAL(I)) Q:'I  D
        .. S GMTSTY=$P(GMRAL(I),U,7) Q:GMTSTY']""
        .. S GMTSEACT=$P(GMRAL(I),U,2) Q:GMTSEACT']""
        .. S GMTSMECH=$P($P(GMRAL(I),U,8),";")
        .. S:GMTSMECH']"" GMTSMECH="UNKNOWN"
        .. S GMTSAL(GMTSTY,GMTSMECH,GMTSEACT,GMTSCNT)=I_"^"_GMRAL(I)
        .. S JJ=0 F  S JJ=$O(GMRAL(I,"S",JJ)) Q:'JJ  S GMTSAL(GMTSTY,GMTSMECH,GMTSEACT,GMTSCNT,"S",JJ)=GMRAL(I,"S",JJ)
        .. S ALLRG=1
        Q
ALLAS   ; Allergy Assessment
        N X,GMTSALG1,GMTSALG2,GMTSALG3,GMTSAU S (GMTSALAS,GMTSALAD,GMTSALAW)="" S GMTSALAS="No known allergies"
        S GMTSALAD=$$GET1^DIQ(120.86,+($G(DFN)),3,"I",,"GMTSALG2") S:$D(GMTSALG2) GMTSALAD="" S:+GMTSALAD=0 GMTSALAD=""
        I +GMTSALAD>0 S X=GMTSALAD D REGDT4^GMTSU S GMTSALAD=X
        S GMTSAU=$$GET1^DIQ(120.86,+($G(DFN)),2,"I")
        S GMTSALAW=$$GET1^DIQ(200,(+GMTSAU_","),.01,"E",,"GMTSALG3")
        S GMTSALAT=$$GET1^DIQ(200,(+GMTSAU_","),20.3)
        S:$D(GMTSALG3) (GMTSALAW,GMTSALAT)=""
        Q
AUTOV   ; Autoverify
        S GMTSAV=0,GMTSALNM=$P(GMTSAL(II,JJ,KK,L),U),GMTSAFN=$G(^GMR(120.8,GMTSALNM,0))
        I $P(GMTSAFN,U,18)="",$P(GMTSAFN,U,16)=1 S GMTSAV=1
        Q
TITLE   ; Print title
        D CKP^GMTSUP Q:$D(GMTSQIT)
        I $D(GMTSPNF) W ?21,TITLE,!
        E  W ?21,"Title: ",TITLE,!
        Q
TEXT    ; Setup for print of allergy comments
        W ?31,CD D CKP^GMTSUP Q:$D(GMTSQIT)
        K ^UTILITY($J,"W") S GMTSLN=0 F  S GMTSLN=$O(^GMR(120.8,GMTSALNM,26,CCC,2,GMTSLN)) Q:'GMTSLN  S GMTSPRT=^GMR(120.8,GMTSALNM,26,CCC,2,GMTSLN,0) D FORMAT
        I $D(^UTILITY($J,"W")) F GMTSLN=1:1:^UTILITY($J,"W",DIWL) D LINE Q:$D(GMTSQIT)
        K ^UTILITY($J,"W")
        Q:'GMTSLN
        W ! Q
FORMAT  ; Formats each line
        S DIWL=3,DIWR=80,DIWF="C58",X=GMTSPRT D ^DIWP
        Q
LINE    ; Writes formatted lines of text
        D CKP^GMTSUP Q:$D(GMTSQIT)  W !,?24,^UTILITY($J,"W",DIWL,GMTSLN,0)
        Q
SIGBLK(GMTSALF) ; Signature block
        Q:+GMTSALF'>0  N GMTSSB,GMTSST,GMTSSN S GMTSSB=$$GET1^DIQ(200,(+GMTSALF_","),20.2),GMTSST=$$GET1^DIQ(200,(+GMTSALF_","),20.3),GMTSSN=$$GET1^DIQ(200,(+GMTSALF_","),.01)
        D CKP^GMTSUP Q:$D(GMTSQIT)  W !!,?24,"Originator: ",$S(GMTSSB'="":GMTSSB,1:GMTSSN)
        D CKP^GMTSUP Q:$D(GMTSQIT)  W:$L(GMTSST) !,?24,"Title:      ",GMTSST
        Q
