VBECA3B ;DALOI/RLM-API interfaces for CPRS ;9/20/00  12:44
        ;;1.0;VBECS;;Apr 14, 2005;Build 35
        ;
        ; Note: This routine supports data exchange with an FDA registered
        ; medical device. As such, it may not be changed in any way without
        ; prior written approval from the medical device manufacturer.
        ; 
        ; Integration Agreements:
        ; 
        QUIT
        ;
CPRS    ;
        K VBECBBD D CR,SPC,TRX
        K VBECA,VBECB,VBECI
        Q
CR      ;Component Request
        K ^TMP("BBD",$J,"COMPONENT REQUEST")
        S VBECA="" F  S VBECA=$O(^TMP("VBDATA",$J,"COMPONENT REQUEST",VBECA)) Q:VBECA=""  D
         . S ^TMP("BBD",$J,"COMPONENT REQUEST",VBECA)=""
         . F VBECI=.01,.04,.03,.05,.09,.08 S ^TMP("BBD",$J,"COMPONENT REQUEST",VBECA)=^TMP("BBD",$J,"COMPONENT REQUEST",VBECA)_$G(^TMP("VBDATA",$J,"COMPONENT REQUEST",VBECA,VBECI))_"^"
        K VBECA,VBECB,VBECI
        Q
SPC     ;Specimen
        K ^TMP("BBD",$J,"SPECIMEN")
        S VBECA="" F  S VBECA=$O(^TMP("VBDATA",$J,"SPECIMEN",VBECA)) Q:VBECA=""  D
         . Q:$G(^TMP("VBDATA",$J,"SPECIMEN",VBECA,"63.01,.03"))=""
         . S ^TMP("BBD",$J,"SPECIMEN",VBECA)=""
         . F VBECI=2.91,10.3,11.3 I $G(^TMP("VBDATA",$J,"SPECIMEN",VBECA,"63.01,"_VBECI))]"" S ^TMP("BBD",$J,"SPECIMEN",VBECA,VBECI)=$G(^TMP("VBDATA",$J,"SPECIMEN",VBECA,"63.01,"_VBECI))
         . F VBECI="63.012,.01","63.46,.01","63.46,.02","63.48,.01","63.199,.01" S VBECB=0 D
         . . F  S VBECB=$O(^TMP("VBDATA",$J,"SPECIMEN",VBECA,VBECI,VBECB)) Q:VBECB=""  S ^TMP("BBD",$J,"SPECIMEN",VBECA,VBECI,VBECB)=$G(^TMP("VBDATA",$J,"SPECIMEN",VBECA,VBECI,VBECB))
         . F VBECI=.03,.01,10,2.9,2.1,2.4,2.6,2.9,11,6 D
         . . S VBDTA=$G(^TMP("VBDATA",$J,"SPECIMEN",VBECA,"63.01,"_VBECI))
         . . I VBECI=10,VBDTA="NOT DONE" S VBDTA="ND"
         . . I VBECI=11,VBDTA="NOT DONE" S VBDTA="ND"
         . . I (VBECI=2.1)!(VBECI=2.4)!(VBECI=2.6) S VBDTA=$S(VBDTA="N":"Neg",1:VBDTA)
         . . I (VBECI=2.9)!(VBECI=6)!(VBECI=11) S VBDTA=$S(VBDTA?1"N".E:"Neg",VBDTA?1"P".E:"Pos",1:VBDTA)
         . . S ^TMP("BBD",$J,"SPECIMEN",VBECA)=^TMP("BBD",$J,"SPECIMEN",VBECA)_VBDTA_"^"
         . . ;S ^TMP("BBD",$J,"SPECIMEN",VBECA)=^TMP("BBD",$J,"SPECIMEN",VBECA)_$G(^TMP("VBDATA",$J,"SPECIMEN",VBECA,"63.01,"_VBECI))_"^"
        K VBECA,VBECB,VBECI
        Q
TRX     ;Units assigned/crossmatched
        K ^TMP("BBD",$J,"CROSSMATCH")
        S VBECA="" F  S VBECA=$O(^TMP("VBDATA",$J,"CROSSMATCH",VBECA)) Q:VBECA=""  F VBECI=.01,.04,.07,.08,.06,.16,3 S ^TMP("BBD",$J,"CROSSMATCH",VBECA)=$G(^TMP("BBD",$J,"CROSSMATCH",VBECA))_$G(^TMP("VBDATA",$J,"CROSSMATCH",VBECA,VBECI))_"^"
        K VBECA,VBECB,VBECI
        Q
ZEOR    ;VBECA3B
