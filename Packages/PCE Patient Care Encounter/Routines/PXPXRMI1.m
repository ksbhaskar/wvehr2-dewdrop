PXPXRMI1        ; SLC/PKR,SCK - Build indexes for the V files. ;06/17/2003
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**119,194**;Aug 12, 1996;Build 2
        ;DBIA 4113 supports PXRMSXRM entry points. 
        ;DBIA 4114 supports setting and killing ^PXRMINDX
        ;===============================================================
VCPT    ;Build the indexes for V CPT.
        N CPT,DAS,DATE,DFN,DIFF,DONE,END,ENTRIES,ETEXT,GLOBAL,IND,NE,NERROR,PP
        N START,TEMP,TENP,TEXT,VISIT
        ;Don't leave any old stuff around.
        K ^PXRMINDX(9000010.18)
        S GLOBAL=$$GET1^DID(9000010.18,"","","GLOBAL NAME")
        S ENTRIES=$P(^AUPNVCPT(0),U,4)
        S TENP=ENTRIES/10
        S TENP=+$P(TENP,".",1)
        I TENP<1 S TENP=1
        D BMES^XPDUTL("Building indexes for V CPT")
        S TEXT="There are "_ENTRIES_" entries to process."
        D MES^XPDUTL(TEXT)
        S START=$H
        S (DAS,DONE,IND,NE,NERROR)=0
        F  S DAS=$O(^AUPNVCPT(DAS)) Q:DONE  D
        . I +DAS=0 S DONE=1 Q
        . I +DAS'=DAS D  Q
        .. S DONE=1
        .. S ETEXT="Bad ien: "_DAS_", cannot continue."
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S IND=IND+1
        . I IND#TENP=0 D
        .. S TEXT="Processing entry "_IND
        .. D MES^XPDUTL(TEXT)
        . I IND#10000=0 W "."
        . S TEMP=^AUPNVCPT(DAS,0)
        . S CPT=$P(TEMP,U,1)
        . I CPT="" D  Q
        .. S ETEXT=DAS_" missing CPT"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . ;I '$D(^ICPT(CPT)) D  Q
        . I $$CPT^ICPTCOD(CPT)<0 D  Q
        .. S ETEXT=DAS_" invalid CPT"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S DFN=$P(TEMP,U,2)
        . I DFN="" D  Q
        .. S ETEXT=DAS_" missing DFN"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S VISIT=$P(TEMP,U,3)
        . I VISIT="" D  Q
        .. S ETEXT=DAS_" missing visit"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . I '$D(^AUPNVSIT(VISIT)) D  Q
        .. S ETEXT=DAS_" invalid visit"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S DATE=$P(^AUPNVSIT(VISIT,0),U,1)
        . I DATE="" D  Q
        .. S ETEXT=DAS_" missing visit date"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S PP=$P(TEMP,U,7)
        . I PP="" S PP="U"
        . S NE=NE+1
        . S ^PXRMINDX(9000010.18,"IPP",CPT,PP,DFN,DATE,DAS)=""
        . S ^PXRMINDX(9000010.18,"PPI",DFN,PP,CPT,DATE,DAS)=""
        S END=$H
        S TEXT=NE_" V CPT results indexed."
        D MES^XPDUTL(TEXT)
        D DETIME^PXRMSXRM(START,END)
        ;If there were errors send a message.
        I NERROR>0 D ERRMSG^PXRMSXRM(NERROR,GLOBAL)
        ;Send a MailMan message with the results.
        D COMMSG^PXRMSXRM(GLOBAL,START,END,NE,NERROR)
        S ^PXRMINDX(9000010.18,"GLOBAL NAME")=GLOBAL
        S ^PXRMINDX(9000010.18,"BUILT BY")=DUZ
        S ^PXRMINDX(9000010.18,"DATE BUILT")=$$NOW^XLFDT
        Q
        ;
        ;===============================================================
VHF     ;Build the indexes for V HEALTH FACTORS.
        N CAT,DAS,DATE,DFN,DIFF,DONE,END,ENTRIES,ETEXT,GLOBAL,HF,IND,NE,NERROR
        N START,TEMP,TENP,TEXT,VISIT
        ;Don't leave any old stuff around.
        K ^PXRMINDX(9000010.23)
        S GLOBAL=$$GET1^DID(9000010.23,"","","GLOBAL NAME")
        S ENTRIES=$P(^AUPNVHF(0),U,4)
        S TENP=ENTRIES/10
        S TENP=+$P(TENP,".",1)
        I TENP<1 S TENP=1
        D BMES^XPDUTL("Building indexes for V HEALTH FACTORS")
        S TEXT="There are "_ENTRIES_" entries to process."
        D MES^XPDUTL(TEXT)
        S START=$H
        S (DAS,DONE,IND,NE,NERROR)=0
        F  S DAS=$O(^AUPNVHF(DAS)) Q:DONE  D
        . I +DAS=0 S DONE=1 Q
        . I +DAS'=DAS D  Q
        .. S DONE=1
        .. S ETEXT="Bad ien: "_DAS_", cannot continue."
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S IND=IND+1
        . I IND#TENP=0 D
        .. S TEXT="Processing entry "_IND
        .. D MES^XPDUTL(TEXT)
        . I IND#10000=0 W "."
        . S TEMP=^AUPNVHF(DAS,0)
        . S HF=$P(TEMP,U,1)
        . I HF="" D  Q
        .. S ETEXT=DAS_" missing HF"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . I '$D(^AUTTHF(HF)) D  Q
        .. S ETEXT=DAS_" invalid HF"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S DFN=$P(TEMP,U,2)
        . I DFN="" D  Q
        .. S ETEXT=DAS_" missing DFN"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S CAT=$P(^AUTTHF(HF,0),U,3)
        . I CAT="" D  Q
        .. S ETEXT=DAS_" HF "_HF_" missing category"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . I HF=CAT D  Q
        .. S ETEXT=DAS_" HF "_HF_" is a category"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S VISIT=$P(TEMP,U,3)
        . I VISIT="" D  Q
        .. S ETEXT=DAS_" missing visit"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . I '$D(^AUPNVSIT(VISIT)) D  Q
        .. S ETEXT=DAS_" invalid visit"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S DATE=$P(^AUPNVSIT(VISIT,0),U,1)
        . I DATE="" D  Q
        .. S ETEXT=DAS_" missing visit date"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S NE=NE+1
        . S ^PXRMINDX(9000010.23,"IP",HF,DFN,DATE,DAS)=""
        . S ^PXRMINDX(9000010.23,"PI",DFN,HF,DATE,DAS)=""
        S END=$H
        S TEXT=NE_" V HEALTH FACTOR results indexed."
        D MES^XPDUTL(TEXT)
        D DETIME^PXRMSXRM(START,END)
        ;If there were errors send a message.
        I NERROR>0 D ERRMSG^PXRMSXRM(NERROR,GLOBAL)
        ;Send a MailMan message with the results.
        D COMMSG^PXRMSXRM(GLOBAL,START,END,NE,NERROR)
        S ^PXRMINDX(9000010.23,"GLOBAL NAME")=GLOBAL
        S ^PXRMINDX(9000010.23,"BUILT BY")=DUZ
        S ^PXRMINDX(9000010.23,"DATE BUILT")=$$NOW^XLFDT
        Q
        ;
        ;===============================================================
VIMM    ;Build the indexes for V IMMUNIZATION.
        N DAS,DATE,DFN,DIFF,DONE,END,ENTRIES,ETEXT,GLOBAL,IMM,IND,NE,NERROR
        N START,TEMP,TENP,TEXT,VISIT
        ;Don't leave any old stuff around.
        K ^PXRMINDX(9000010.11)
        S GLOBAL=$$GET1^DID(9000010.11,"","","GLOBAL NAME")
        S ENTRIES=$P(^AUPNVIMM(0),U,4)
        S TENP=ENTRIES/10
        S TENP=+$P(TENP,".",1)
        I TENP<1 S TENP=1
        D BMES^XPDUTL("Building indexes for V IMMUNIZATION")
        S TEXT="There are "_ENTRIES_" entries to process."
        D MES^XPDUTL(TEXT)
        S START=$H
        S (DAS,DONE,IND,NE,NERROR)=0
        F  S DAS=$O(^AUPNVIMM(DAS)) Q:DONE  D
        . I +DAS=0 S DONE=1 Q
        . I +DAS'=DAS D  Q
        .. S DONE=1
        .. S ETEXT="Bad ien: "_DAS_", cannot continue."
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S IND=IND+1
        . I IND#TENP=0 D
        .. S TEXT="Processing entry "_IND
        .. D MES^XPDUTL(TEXT)
        . I IND#10000=0 W "."
        . S TEMP=^AUPNVIMM(DAS,0)
        . S IMM=$P(TEMP,U,1)
        . I IMM="" D  Q
        .. S ETEXT=DAS_" missing immunization"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . I '$D(^AUTTIMM(IMM)) D  Q
        .. S ETEXT=DAS_" invalid immunization"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S DFN=$P(TEMP,U,2)
        . I DFN="" D  Q
        .. S ETEXT=DAS_" missing DFN"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S VISIT=$P(TEMP,U,3)
        . I VISIT="" D  Q
        .. S ETEXT=DAS_" missing visit"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . I '$D(^AUPNVSIT(VISIT)) D  Q
        .. S ETEXT=DAS_" invalid visit"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S DATE=$P(^AUPNVSIT(VISIT,0),U,1)
        . I DATE="" D  Q
        .. S ETEXT=DAS_" missing visit date"
        .. D ADDERROR^PXRMSXRM(GLOBAL,ETEXT,.NERROR)
        . S NE=NE+1
        . S ^PXRMINDX(9000010.11,"IP",IMM,DFN,DATE,DAS)=""
        . S ^PXRMINDX(9000010.11,"PI",DFN,IMM,DATE,DAS)=""
        S END=$H
        S TEXT=NE_" V IMMUNIZATION results indexed."
        D MES^XPDUTL(TEXT)
        D DETIME^PXRMSXRM(START,END)
        ;If there were errors send a message.
        I NERROR>0 D ERRMSG^PXRMSXRM(NERROR,GLOBAL)
        ;Send a MailMan message with the results.
        D COMMSG^PXRMSXRM(GLOBAL,START,END,NE,NERROR)
        S ^PXRMINDX(9000010.11,"GLOBAL NAME")=GLOBAL
        S ^PXRMINDX(9000010.11,"BUILT BY")=DUZ
        S ^PXRMINDX(9000010.11,"DATE BUILT")=$$NOW^XLFDT
        Q
        ;
