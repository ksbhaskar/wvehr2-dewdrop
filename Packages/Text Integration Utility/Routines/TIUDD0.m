TIUDD0 ; SLC/JER,AJB - Cross-references on 8925
 ;;1.0;TEXT INTEGRATION UTILITIES;**65,153**;Jun 20, 1997
SACLPT(FLD,X) ; SET Logic for ACLPT
 ;"ACLPT" On .01 CLASS, .02 PT, 1301 INV RDT
 N TIUD0,TIUD13
 S TIUD0=$G(^TIU(8925,+DA,0)),TIUD13=$G(^(13))
 I $S(FLD=.05:1,FLD=1501:1,FLD=1507:1,1:0) D  ;P65 add ACLPT to fld .05
 . I +$P(TIUD0,U),+$P(TIUD13,U),+$P(TIUD0,U,2),($P(TIUD0,U,5)'<6) S ^TIU(8925,"ACLPT",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=.01 D
 . I +$P(TIUD13,U),+$P(TIUD0,U,2),($P(TIUD0,U,5)'<6) S ^TIU(8925,"ACLPT",+$$CLINDOC^TIULC1(+X,+DA),+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=.02 D
 . I +$P(TIUD0,U),+$P(TIUD13,U),($P(TIUD0,U,5)'<6) S ^TIU(8925,"ACLPT",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+X,$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=1301 D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),($P(TIUD0,U,5)'<6) S ^TIU(8925,"ACLPT",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD0,U,2),$$INVDATE(+X),DA)=""
 Q
 ;
SACLAU(FLD,X) ; SET Logic for ACLAU
 ; "ACLAU" X-REF ON .01 CLASS, 1202 AUTHOR, .02 PT, & 1301 INV RDT:
 N TIUD0,TIUD13,TIUD12,TIUSIGFL
 S TIUD0=$G(^TIU(8925,+DA,0)),TIUD13=$G(^(13)),TIUD12=$G(^(12))
 I $P(TIUD0,U,5),+$P(TIUD0,U,5)<6 S TIUSIGFL=1
 I FLD=.05,$G(TIUSIGFL) D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD13,U),+$P(TIUD12,U,2) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD12,U,2),+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=1501,$G(TIUSIGFL) D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD13,U),+$P(TIUD12,U,2) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD12,U,2),+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=.01,$G(TIUSIGFL) D
 . I +$P(TIUD0,U,2),+$P(TIUD13,U),+$P(TIUD12,U,2) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+X,+DA),+$P(TIUD12,U,2),+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=1202,$G(TIUSIGFL) D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD13,U) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+X,+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=.02,$G(TIUSIGFL) D
 . I +$P(TIUD0,U),+$P(TIUD13,U),+$P(TIUD12,U,2) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD12,U,2),+X,$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=1301,$G(TIUSIGFL) D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD12,U,2) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD12,U,2),+$P(TIUD0,U,2),$$INVDATE(+X),DA)=""
 Q
 ;
SACLAU1(FLD,X) ; SET LOGIC FOR ACLAU - TRANSCRIPTIONIST (ENTERED BY)
 ; "ACLAU" X-REF ON .01 CLASS, 1302 ENTERED BY, .02 PT, & 1301 INV RDT:
 N TIUD0,TIUD12,TIUD13,TIUSIGFL
 S TIUD0=$G(^TIU(8925,+DA,0)),TIUD12=$G(^(12)),TIUD13=$G(^(13))
 I FLD'=1302,(+$P(TIUD13,U,2)'=0),(+$P(TIUD13,U,2)=+$P(TIUD12,U,2)) Q
 I FLD=1302,(+X'=0),(+X=+$P(TIUD12,U,2)) Q
 I $P(TIUD0,U,5),+$P(TIUD0,U,5)<6 S TIUSIGFL=1
 I FLD=.05,$G(TIUSIGFL) D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD13,U),+$P(TIUD13,U,2) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD13,U,2),+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=1501,$G(TIUSIGFL) D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD13,U),+$P(TIUD13,U,2) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD13,U,2),+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=.01,$G(TIUSIGFL) D
 . I +$P(TIUD0,U,2),+$P(TIUD13,U),+$P(TIUD13,U,2) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+X,+DA),+$P(TIUD13,U,2),+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=1302,$G(TIUSIGFL) D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD13,U) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+X,+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=.02,$G(TIUSIGFL) D
 . I +$P(TIUD0,U),+$P(TIUD13,U),+$P(TIUD13,U,2) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD13,U,2),+X,$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=1301,$G(TIUSIGFL) D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD13,U,2) S ^TIU(8925,"ACLAU",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD13,U,2),+$P(TIUD0,U,2),$$INVDATE(+X),DA)=""
 Q
 ;
SACLEC(FLD,X) ; SET Logic For ACLEC
 ; "ACLEC" On .01 CLASS, 1208 EC, .02 PT, 1301 INV RDT:
 N TIUD0,TIUD13,TIUD12,TIUCOSFL
 S TIUD0=$G(^TIU(8925,+DA,0)),TIUD13=$G(^(13)),TIUD12=$G(^(12))
 I $P(TIUD0,U,5),+$P(TIUD0,U,5)<7 S TIUCOSFL=1
 I $S(FLD=.05:1,FLD=1501:1,FLD=1507:1,1:0),$G(TIUCOSFL) D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD13,U),+$P(TIUD12,U,8) S ^TIU(8925,"ACLEC",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD12,U,8),+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=.01,$G(TIUCOSFL) D
 . I +$P(TIUD0,U,2),+$P(TIUD13,U),+$P(TIUD12,U,8) S ^TIU(8925,"ACLEC",+$$CLINDOC^TIULC1(+X,+DA),+$P(TIUD12,U,8),+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=1208,$G(TIUCOSFL) D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD13,U) S ^TIU(8925,"ACLEC",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+X,+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=.02,$G(TIUCOSFL) D
 . I +$P(TIUD0,U),+$P(TIUD13,U),+$P(TIUD12,U,8) S ^TIU(8925,"ACLEC",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD12,U,8),+X,$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=1301,$G(TIUCOSFL) D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD12,U,8) S ^TIU(8925,"ACLEC",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD12,U,8),+$P(TIUD0,U,2),$$INVDATE(+X),DA)=""
 Q
 ;
SACLSB(FLD,X) ; SET Logic for ACLSB
 ;"ACLSB" X-REF ON .01 CLASS, 1502 SIGNER, .02 PT, 1301 RDT:
 N TIUD0,TIUD13,TIUD15
 S TIUD0=$G(^TIU(8925,+DA,0)),TIUD13=$G(^(13)),TIUD15=$G(^(15))
 I FLD=.01 D
 . I +$P(TIUD0,U,2),+$P(TIUD13,U),+$P(TIUD15,U,2) S ^TIU(8925,"ACLSB",+$$CLINDOC^TIULC1(+X,+DA),+$P(TIUD15,U,2),+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=1502 D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD13,U) S ^TIU(8925,"ACLSB",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+X,+$P(TIUD0,U,2),$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=.02 D
 . I +$P(TIUD0,U),+$P(TIUD13,U),+$P(TIUD15,U,2) S ^TIU(8925,"ACLSB",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD15,U,2),+X,$$INVDATE($P(TIUD13,U)),DA)=""
 I FLD=1301 D
 . I +$P(TIUD0,U),+$P(TIUD0,U,2),+$P(TIUD15,U,2) S ^TIU(8925,"ACLSB",+$$CLINDOC^TIULC1(+$P(TIUD0,U),+DA),+$P(TIUD15,U,2),+$P(TIUD0,U,2),$$INVDATE(+X),DA)=""
 Q
 ;
SAPTLD(FLD,X) ; SET Logic for "APTLD"
 ; APTLD on fields .02 PT, .01 TITLE, "1211;.07;.13" VSTR, .03 VISIT
 N TIUD0,TIUD12
 S TIUD0=$G(^TIU(8925,+DA,0)),TIUD12=$G(^(12))
 I FLD=.02 D
 . I +TIUD0,+$P(TIUD0,U,7),$L($P(TIUD0,U,13)),+$P(TIUD12,U,11) D
 . . N TIUVS
 . . ; TIUVS="Hosp Loc;Visit/Adm Date/time;Visit Type"
 . . S TIUVS=$P(TIUD12,U,11)_";"_$P(TIUD0,U,7)_";"_$P(TIUD0,U,13)
 . . S ^TIU(8925,"APTLD",+X,+TIUD0,TIUVS,DA)=""
 . . I +$P(TIUD0,U,3) S ^TIU(8925,"AVSTRV",+X,TIUVS,+$P(TIUD0,U,3),DA)=""
 I FLD=.01 D
 . I +$P(TIUD0,U,2),+$P(TIUD0,U,7),$L($P(TIUD0,U,13)),+$P(TIUD12,U,11) D
 . . N TIUVS
 . . ; TIUVS="Hosp Loc;Visit/Adm Date/time;Visit Type"
 . . S TIUVS=$P(TIUD12,U,11)_";"_$P(TIUD0,U,7)_";"_$P(TIUD0,U,13)
 . . S ^TIU(8925,"APTLD",+$P(TIUD0,U,2),+X,TIUVS,DA)=""
 I FLD=1211 D
 . I +TIUD0,+$P(TIUD0,U,2),+$P(TIUD0,U,7),$L($P(TIUD0,U,13)) D
 . . N TIUVS
 . . ; TIUVS="Hosp Loc;Visit/Adm Date/time;Visit Type"
 . . S TIUVS=+X_";"_$P(TIUD0,U,7)_";"_$P(TIUD0,U,13)
 . . S ^TIU(8925,"APTLD",+$P(TIUD0,U,2),+TIUD0,TIUVS,DA)=""
 . . I +$P(TIUD0,U,3) S ^TIU(8925,"AVSTRV",+$P(TIUD0,U,2),TIUVS,+$P(TIUD0,U,3),DA)=""
 I FLD=.07 D
 . I +TIUD0,+$P(TIUD0,U,2),$L($P(TIUD0,U,13)),+$P(TIUD12,U,11) D
 . . N TIUVS
 . . ; TIUVS="Hosp Loc;Visit/Adm Date/time;Visit Type"
 . . S TIUVS=$P(TIUD12,U,11)_";"_+X_";"_$P(TIUD0,U,13)
 . . S ^TIU(8925,"APTLD",+$P(TIUD0,U,2),+TIUD0,TIUVS,DA)=""
 . . I +$P(TIUD0,U,3) S ^TIU(8925,"AVSTRV",+$P(TIUD0,U,2),TIUVS,+$P(TIUD0,U,3),DA)=""
 I FLD=.13 D
 . I +TIUD0,+$P(TIUD0,U,2),+$P(TIUD0,U,7),+$P(TIUD12,U,11) D
 . . N TIUVS
 . . ; TIUVS="Hosp Loc;Visit/Adm Date/time;Visit Type"
 . . S TIUVS=$P(TIUD12,U,11)_";"_$P(TIUD0,U,7)_";"_X
 . . S ^TIU(8925,"APTLD",+$P(TIUD0,U,2),+TIUD0,TIUVS,DA)=""
 . . I +$P(TIUD0,U,3) S ^TIU(8925,"AVSTRV",+$P(TIUD0,U,2),TIUVS,+$P(TIUD0,U,3),DA)=""
 ; SET V-String/Visit Map if Visit record exists
 I FLD=.03 D
 . I +$P(TIUD0,U,2),+$P(TIUD0,U,7),$L($P(TIUD0,U,13)),+$P(TIUD12,U,11) D
 . . N TIUVS
 . . ; TIUVS="Hosp Loc;Visit/Adm Date/time;Visit Type"
 . . S TIUVS=$P(TIUD12,U,11)_";"_$P(TIUD0,U,7)_";"_$P(TIUD0,U,13)
 . . S ^TIU(8925,"AVSTRV",+$P(TIUD0,U,2),TIUVS,+X,DA)=""
 Q
 ;
INVDATE(DATE) ; Inverts date
 Q 9999999-DATE
