XHDPDEF        ; SLC/JER - Parameter Definition Calls ; 25 Jul 2003  9:42 AM
 ;;1.0;HEALTHEVET DESKTOP;;Jul 15, 2003
LIST(XHDY,FROM,DIR,SIZE)        ; Get next SIZE definitions in DIR direction
 N XHDI,XHDCNT S XHDCNT=0,SIZE=$G(SIZE,44),DIR=$G(DIR,"+1")
 S XHDI=FROM ;$S(FROM="":FROM,1:$O(^XTV(8989.51,"B",FROM),-DIR))
 F  S XHDI=$O(^XTV(8989.51,"B",XHDI),DIR) Q:XHDI']""!(XHDCNT'<SIZE)  D
 . N XHDDA S XHDDA=0
 . F  S XHDDA=$O(^XTV(8989.51,"B",XHDI,XHDDA)) Q:+XHDDA'>0!(XHDCNT'<SIZE)  D
 . . S XHDCNT=XHDCNT+1,XHDY(XHDCNT)=XHDDA_U_$P($G(^XTV(8989.51,+XHDDA,0)),U,1,2)_U_$$ENTSTR(XHDDA)
 Q
GETALL(XHDY)    ; Gets all parameter definitions in ^TMP("XHDPDEF",$J)
 N XHDI,XHDCNT S XHDI="",XHDCNT=0 S XHDY=$NA(^TMP("XHDPDEF",$J))
 F  S XHDI=$O(^XTV(8989.51,"B",XHDI)) Q:XHDI']""  D
 . N XHDDA S XHDDA=0
 . F  S XHDDA=$O(^XTV(8989.51,"B",XHDI,XHDDA)) Q:+XHDDA'>0  D
 . . S XHDCNT=XHDCNT+1
 . . S @XHDY@(XHDCNT)=XHDDA_U_$P($G(^XTV(8989.51,XHDDA,0)),U,1,2)_U_$$ENTSTR(XHDDA)
 Q
ENTSTR(XHDDA)    ; Get applicable entities
 N XHDI,ENTSTR,ENTCNT S ENTSTR="",(ENTCNT,XHDI)=0
 F  S XHDI=$O(^XTV(8989.51,XHDDA,30,XHDI)) Q:XHDI'>0  D
 . N ENT0 S ENT0=$G(^XTV(8989.51,XHDDA,30,XHDI,0)) Q:+ENT0'>0
 . S ENTSTR=ENTSTR_$S(ENTCNT=0:"",1:";")_+ENT0_"|"_$$ENTFILE($P(ENT0,U,2))
 . S ENTCNT=ENTCNT+1
 Q ENTSTR
ENTFILE(ENTDA)  ; Resolve entity name
 Q $P($G(^XTV(8989.518,ENTDA,0)),U)
GETXML(XHDY,XHDDA)        ; Control Branching
 N XHDI,XHDJ,X S X="ONERROR^XHDPDEF",@^%ZOSF("TRAP")
 S XHDI=0,XHDJ=""
 S XHDY=$NA(^TMP("XHDPDEF",$J)) K @XHDY
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<?xml version=""1.0"" encoding=""UTF-8""?>"
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<getParameterDefinitionsCallResult>"
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<parameterDefinitionList>"
 I +$G(XHDDA) D
 . D GETDEF(XHDY,XHDDA,.XHDI)
 E  D
 . F  S XHDJ=$O(^XTV(8989.51,"B",XHDJ)) Q:XHDJ=""  D
 . . N XHDDA S XHDDA=0
 . . F  S XHDDA=$O(^XTV(8989.51,"B",XHDJ,XHDDA)) Q:+XHDDA'>0  D
 . . . D GETDEF(XHDY,XHDDA,.XHDI)
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="</parameterDefinitionList>"
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="</getParameterDefinitionsCallResult>"
 S XHDY=$NA(^TMP("XHDPDEF",$J,"XMLDOC"))
 M ^XTMP("XHDPDEF",$J,"XMLDOC")=@XHDY
 Q
FLDS() ; Get field string
 Q ".01:8"
GETDEF(XHDY,XHDDA,XHDI)       ; Loads Top-level Fields
 N XHDF,XHDDI S XHDF=0
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<parameterDefinition>"
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<id>"_XHDDA_"</id>"
 D GETS^DIQ(8989.51,XHDDA_",",$$FLDS,"E",XHDY)
 F  S XHDF=$O(@XHDY@(8989.51,XHDDA_",",XHDF)) Q:XHDF'>0  D
 . N TAG,VAL
 . S TAG=$TR($$FLDNAME(XHDF,8989.51)," /","")
 . S VAL=$G(@XHDY@(8989.51,XHDDA_",",XHDF,"E"))
 . I $S(XHDF=.03:1,XHDF=.06:1,1:0) S VAL=$S(VAL="Yes":"true",1:"false")
 . S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<"_TAG_">"_$$ESCAPE^XHDLXM(VAL)_"</"_TAG_">"
 K @XHDY@(8989.51)
 ;** get description **
 S XHDDI=0
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<description>"
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<![CDATA["
 F  S XHDDI=$O(^XTV(8989.51,XHDDA,20,XHDDI)) Q:+XHDDI'>0  D
 . S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)=$G(^XTV(8989.51,XHDDA,20,XHDDI,0))
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="]]>"
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="</description>"
 ;** get entities **
 D GETENTS(XHDY,XHDDA,.XHDI)
 ;** get keywords **
 D KEYWORDS(XHDY,XHDDA,.XHDI)
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="</parameterDefinition>"
 Q
FLDNAME(XHDFN,FILENUM)  ; Resolve field names
 Q $$MIXED($P($G(^DD(FILENUM,XHDFN,0)),U))
MIXED(X) ; Return Mixed Case X
 N XHDI,WORD,TMP
 S TMP="" F XHDI=1:1:$L(X," ") S WORD=$$LOW^XLFSTR($P(X," ",XHDI)),$E(WORD)=$S(XHDI=1:$E(WORD),1:$$UP^XLFSTR($E(WORD))),TMP=$S(TMP="":WORD,1:TMP_WORD)
 Q TMP
GETENTS(XHDY,XHDDA,XHDI)        ; Get allowable entities
 N XHDSDA S XHDSDA=0,FLDS=".01:.02"
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<entities>"
 F  S XHDSDA=$O(^XTV(8989.51,XHDDA,30,XHDSDA)) Q:+XHDSDA'>0  D
 . S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<entity>"
 . D GETS^DIQ(8989.513,XHDSDA_","_XHDDA_",",FLDS,"E",XHDY)
 . F  S XHDF=$O(@XHDY@(8989.513,XHDSDA_","_XHDDA_",",XHDF)) Q:XHDF'>0  D
 . . N TAG,VAL
 . . S TAG=$TR($$FLDNAME(XHDF,8989.513)," /","")
 . . S VAL=$G(@XHDY@(8989.513,XHDSDA_","_XHDDA_",",XHDF,"E"))
 . . S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<"_TAG_">"_$$ESCAPE^XHDLXM(VAL)_"</"_TAG_">"
 . K @XHDY@(8989.513)
 . S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="</entity>"
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="</entities>"
 Q
KEYWORDS(XHDY,XHDDA,XHDI)        ; Get Keywords
 N XHDSDA S XHDSDA=0,FLDS=".01"
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<keywords>"
 F  S XHDSDA=$O(^XTV(8989.51,XHDDA,4,XHDSDA)) Q:+XHDSDA'>0  D
 . D GETS^DIQ(8989.514,XHDSDA_","_XHDDA_",",FLDS,"E",XHDY)
 . F  S XHDF=$O(@XHDY@(8989.514,XHDSDA_","_XHDDA_",",XHDF)) Q:XHDF'>0  D
 . . N TAG,VAL
 . . S TAG=$TR($$FLDNAME(XHDF,8989.514)," /","")
 . . S VAL=$G(@XHDY@(8989.514,XHDSDA_","_XHDDA_",",XHDF,"E"))
 . . S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="<"_TAG_">"_$$ESCAPE^XHDLXM(VAL)_"</"_TAG_">"
 . K @XHDY@(8989.514)
 S XHDI=XHDI+1,@XHDY@("XMLDOC",XHDI)="</keywords>"
 Q
ONERROR ; Trap errors
 N XHDCI S XHDCI=4
 ; remove remnant of DIQ1 call result
 K @XHDCY@(8989.51),@XHDCY@(8989.513)
 ; remove partial configTree node
 F  S XHDCI=$O(@XHDCY@("XMLDOC",XHDCI)) Q:+XHDCI'>0  K @XHDCY@("XMLDOC",XHDCI)
 ; append error node to call result
 S XHDCI=4
 S XHDCI=XHDCI+1,@XHDCY@("XMLDOC",XHDCI)="<error>"
 S XHDCI=XHDCI+1,@XHDCY@("XMLDOC",XHDCI)="<![CDATA["_$$EC^%ZOSV_"]]>"
 S XHDCI=XHDCI+1,@XHDCY@("XMLDOC",XHDCI)="</error>"
 S XHDCI=XHDCI+1,@XHDCY@("XMLDOC",XHDCI)="</getConfigurationCallResult>"
 S XHDCY=$NA(^TMP("XHDPTREE",$J,"XMLDOC"))
 D ^%ZTER
 Q
