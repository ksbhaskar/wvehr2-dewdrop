DGENUPLA        ;ALB/CKN,TDM,PJR,RGL,EG,TMK,CKN,TDM - PROCESS INCOMING (Z11 EVENT TYPE) HL7 MESSAGES ; 6/8/07 10:35am
        ;;5.3;REGISTRATION;**397,379,497,451,564,672,659,583,653,688**;Aug 13,1993;Build 29
        ;
        ;***************************************************************
        ; This routine was created because DGENUPL2 had reached it's
        ; maximum size, therefore no new code could not be added.  All
        ; code that existed in the ZEL and OBX tags of DGENUPL2 has
        ; been moved to the ZEL,ZPD and OBX tags of DGENUPLA.  A line of code
        ; was placed in ZEL^DGENUPL2 to call ZEL^DGENUPLA.  A line of
        ; code was placed in OBX^DGENUPL2 to call OBX^DGENUPLA.
        ; Any routine that calls ZEL,ZPD or OBX^DGENUPL2 will not
        ; be affected by this change.
        ;***************************************************************
        ;
        ;***************************************************************
        ;The following procedures parse particular segment types.
        ;Input:SEG(),MSGID
        ;Output:DGPAT(),DGELG(),DGENR(),DGNTR(),DGMST(),ERROR
        ;***************************************************************
        ;
        ;
ZEL(COUNT)      ;
        N CODE,SEQ
        S CODE=$$CONVERT^DGENUPL1(SEG(2),"ELIGIBILITY",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"ELIGIBILITY CODE "_SEG(2)_" NOT FOUND IN ELIGIBILTIY CODE FILE",.ERRCOUNT)
        I COUNT=1 D
        .S DGELG("ELIG","CODE")=CODE
        .S DGELG("DISRET")=$$CONVERT^DGENUPL1(SEG(5),"1/0",.ERROR)
        .I ERROR D  Q
        ..D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 5",.ERRCOUNT)
        .S DGELG("CLAIMNUM")=$$CONVERT^DGENUPL1(SEG(6))
        .S DGELG("CLAIMLOC")=$$SITECNV(SEG(7))
        .;
        .S DGPAT("VETERAN")=$$CONVERT^DGENUPL1(SEG(8),"Y/N",.ERROR)
        .I ERROR D  Q
        ..D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 8",.ERRCOUNT)
        .S DGELG("ELIGSTA")=$$CONVERT^DGENUPL1(SEG(10))
        .S DGELG("ELIGSTADATE")=$$CONVERT^DGENUPL1(SEG(11),"DATE",.ERROR)
        .I ERROR D  Q
        ..D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 11",.ERRCOUNT)
        .S DGELG("ELIGVERIF")=$$CONVERT^DGENUPL1(SEG(13))
        .S DGELG("A&A")=$$CONVERT^DGENUPL1(SEG(14),"Y/N",.ERROR)
        .I ERROR D  Q
        ..D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 14",.ERRCOUNT)
        .S DGELG("HB")=$$CONVERT^DGENUPL1(SEG(15),"Y/N",.ERROR)
        .I ERROR D  Q
        ..D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 15",.ERRCOUNT)
        .S DGELG("VAPEN")=$$CONVERT^DGENUPL1(SEG(16),"Y/N",.ERROR)
        .I ERROR D  Q
        ..D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 16",.ERRCOUNT)
        .S DGELG("VADISAB")=$$CONVERT^DGENUPL1(SEG(17),"Y/N",.ERROR)
        .I ERROR D  Q
        ..D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 17",.ERRCOUNT)
        .S DGELG("AO")=$$CONVERT^DGENUPL1(SEG(18),"Y/N",.ERROR)
        .N AOERR S AOERR=ERROR            ;  See SEG(29) below.
        .I ERROR D  Q
        ..D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 18",.ERRCOUNT)
        .S (DGPAT("IR"),DGELG("IR"))=$$CONVERT^DGENUPL1(SEG(19),"Y/N",.ERROR)
        .I ERROR D  Q
        ..D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 19",.ERRCOUNT)
        .S DGELG("EC")=$$CONVERT^DGENUPL1(SEG(20),"Y/N",.ERROR)
        .I ERROR D  Q
        ..D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 20",.ERRCOUNT)
        .S (DGPAT("RADEXPM"),DGELG("RADEXPM"))=$$CONVERT^DGENUPL1($G(SEG(22)))
        .S ERROR=$S(DGELG("RADEXPM")="":0,",2,3,4,5,6,7,"[(","_DGELG("RADEXPM")_","):0,DGELG("RADEXPM")="@":0,1:1)
        .I ERROR D  Q
        ..D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 22",.ERRCOUNT)
        .;
        .S DGELG("VACKAMT")=$$CONVERT^DGENUPL1(SEG(21))
        .;
        .;Parse MST data into DGMST array from sequences 23, 24, 25 of ZEL segment
        . F SEQ=23,24,25 S:SEG(SEQ)=HLQ SEG(SEQ)=""
        . S DGMST("MSTSTAT")=$$CONVERT^DGENUPL1(SEG(23))
        . S DGMST("MSTDT")=$$CONVERT^DGENUPL1(SEG(24),"TS",.ERROR)
        . I ERROR D  Q
        . . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 24",.ERRCOUNT)
        . S DGMST("MSTST")=$$CONVERT^DGENUPL1(SEG(25),"INSTITUTION",.ERROR)
        . I ERROR D  Q
        . . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 25",.ERRCOUNT)
        .;
        . S DGELG("AOEXPLOC")=$$CONVERT^DGENUPL1(SEG(29))
        .; Logic enhanced during SQA of patch 451.  AOERR from SEG(18) above.
        . I 'AOERR,DGELG("AO")'="Y",DGELG("AOEXPLOC")="" S DGELG("AOEXPLOC")="@"
        . S DGELG("UEYEAR")=$$CONVERT^DGENUPL1(SEG(34),"DATE",.ERROR)
        . I ERROR D  Q
        . . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 34",.ERRCOUNT)
        . S DGELG("UESITE")=$$CONVERT^DGENUPL1(SEG(35),"INSTITUTION",.ERROR)
        . I ERROR D  Q
        . . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 35",.ERRCOUNT)
        . S DGELG("CVELEDT")=$$CONVERT^DGENUPL1(SEG(38),"DATE",.ERROR)
        . I ERROR D  Q
        . . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 38",.ERRCOUNT)
        . I $G(DGELG("DISLOD"))="" S DGELG("DISLOD")=$$CONVERT^DGENUPL1(SEG(39),"1/0",.ERROR) ;Discharge due to Disability - DG*5.3*653
        . I ERROR D  Q
        . . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 39",.ERRCOUNT)
        . S DGELG("SHAD")=$$CONVERT^DGENUPL1(SEG(40),"1/0",.ERROR) ;Proj 112/SHAD - DG*5.3*653
        . I ERROR D  Q
        . . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEL SEGMENT, SEQ 40 - SHAD Indicator",.ERRCOUNT)
        ;
        I COUNT>1 D
        .S DGELG("ELIG","CODE",CODE)=""
        Q
        ;
OBX     ;
        N OBXPCE,OBXVAL,OBXTBL,I,CS,SS,RS
        I $G(HLECH)'="~|\&" N HLECH S HLECH="~|\&"
        I $G(HLFS)="" N HLFS S HLFS="^"
        S CS=$E(HLECH,1),SS=$E(HLECH,4),RS=$E(HLECH,2)
        I $G(SEG(3))=("38.1"_$E(HLECH)_"SECURITY LOG") D
        . N LEVEL
        . S LEVEL=$P(SEG(5),$E(HLECH))
        . S DGSEC("LEVEL")=$$CONVERT^DGENUPL1(LEVEL,"1/0",.ERROR)
        . I ERROR D  Q
        . . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, OBX SEGMENT, SEQ 5",.ERRCOUNT)
        . S DGSEC("DATETIME")=$$CONVERT^DGENUPL1(SEG(14),"TS",.ERROR)
        . I ERROR D  Q
        . . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, OBX SEGMENT, SEQ 14, Patient Sensitivity Date/Time",.ERRCOUNT) ;DG*5.3*653
        . S DGSEC("SOURCE")=$$CONVERT^DGENUPL1(SEG(16))
        ;
        I $G(SEG(3))=("VISTA"_CS_"28.11") D
        . S OBXTBL(1)="NTR^Y",OBXTBL(2)="AVI^Y",OBXTBL(3)="SUB^Y"
        . S OBXTBL(4)="HNC^Y",OBXTBL(5)="NTR^N",OBXTBL(6)="AVI^N"
        . S OBXTBL(7)="SUB^N",OBXTBL(8)="HNC^N",OBXTBL(9)="NTR^U"
        . F I=1:1:$L($G(SEG(5)),RS) D
        . . S OBXPCE=$P($G(SEG(5)),RS,I),OBXVAL=$P($G(OBXPCE),CS)
        . . S DGNTR($P($G(OBXTBL(OBXVAL)),"^"))=$P($G(OBXTBL(OBXVAL)),"^",2)
        . I $G(SEG(12))'="" S DGNTR("HDT")=$$CONVERT^DGENUPL1(SEG(12),"TS",.ERROR)
        . S DGNTR("VDT")=$$CONVERT^DGENUPL1(SEG(14),"TS",.ERROR)
        . S DGNTR("VSIT")=$$CONVERT^DGENUPL1(SEG(15),"INSTITUTION",.ERROR)
        . S DGNTR("HSIT")=$P($P($G(SEG(16)),CS,14),SS,2)
        . I DGNTR("HSIT")'="" S DGNTR("HSIT")=$$CONVERT^DGENUPL1($G(DGNTR("HSIT")),"INSTITUTION",.ERROR)
        . S DGNTR("VER")=$$CONVERT^DGENUPL1($P($G(SEG(17)),CS))
        Q
        ;
ZIO     ;New segment - DG*5.3*653
        S DGPAT("APPREQ")=$$CONVERT^DGENUPL1(SEG(5),"1/0",.ERROR)
        I ERROR D  Q
        . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZIO SEGMENT, SEQ 5, APPOINTMENT REQUEST ON 1010EZ",.ERRCOUNT)
        S DGPAT("APPREQDT")=$$CONVERT^DGENUPL1(SEG(6),"DATE",.ERROR)
        I ERROR D  Q
        . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZIO SEGMENT, SEQ 6, APPOINTMENT REQUEST DATE",.ERRCOUNT)
        Q
        ;
ZPD     ;
        S DGELG("RATEINC")=$$CONVERT^DGENUPL1(SEG(8))
        S DGPAT("DEATH")=$$CONVERT^DGENUPL1(SEG(9),"TS",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZPD SEGMENT, SEQ 9",.ERRCOUNT)
        S DGELG("MEDICAID")=$$CONVERT^DGENUPL1(SEG(12))
        S DGELG("MEDASKDT")=$$CONVERT^DGENUPL1(SEG(13),"TS",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZPD SEGMENT, SEQ 13",.ERRCOUNT)
        S DGELG("POW")=$$CONVERT^DGENUPL1(SEG(17))
        ;DG*5.3*688
        S DGPAT("AG/ALLY")=$$CONVERT^DGENUPL1(SEG(35),"AGENCY",.ERROR)
        I ERROR D
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZPD SEGMENT, SEQ 35",.ERRCOUNT)
        S DGPAT("EMGRES")=$$CONVERT^DGENUPL1(SEG(40)) ;DG*5.3*677
        Q
        ;
SITECNV(STRING) ; Convert claim folder loc (site # or site # and name) to
        ; ptr to file 4
        N SITE
        S SITE=""
        I STRING'="" D
        . N SUB,START,END
        . ; Find site ien if only site # is returned
        . I $O(^DIC(4,"D",STRING,0)) S SITE=$O(^DIC(4,"D",STRING,0)) Q
        . ; Check if name is concatenated onto site # to find site ien
        . S SUB=""
        . F  S SUB=$O(^DIC(4,"D",SUB)) Q:SUB=""  I $E(SUB,1,3)=$E(STRING,1,3),$$CHK(SUB,STRING) S SITE=$O(^DIC(4,"D",SUB,0)) Q
        ; SITE is the pointer to file 4 or null for site not found
        Q SITE
        ;
CHK(SUB,STRING) ;
        N IEN,X,STN,RET
        I SUB=STRING Q 1
        S RET=0
        S IEN=+$O(^DIC(4,"D",SUB,""))
        I IEN D
        . S X=$P($G(^DIC(4,IEN,0)),U),STN=$P($G(^(99)),U)
        . ; assume institution file names will be the same on HEC and VistA
        . I STN=SUB,X'="",$E($P(STRING,SUB,2,999),1,40)=X S RET=1
        Q RET
        ;
