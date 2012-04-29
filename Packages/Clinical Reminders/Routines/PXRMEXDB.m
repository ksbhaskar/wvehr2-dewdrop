PXRMEXDB        ;SLC/PKR,AGP - Build ListMan dialog display. ;06/02/2009
        ;;2.0;CLINICAL REMINDERS;**6,12**;Feb 04, 2005;Build 73
        ;
        ;======================================
BLDDISP(VIEW)   ;Build ListMan array. Information about the dialog is passed
        ;in ^TMP("PXRMEXTMP",$J) which is built by PXRMEXLB which is
        ;called by CDISP^PXRMEXLC.
        N DNAME,NLINE,NSEL
        S DNAME=$G(^TMP("PXRMEXTMP",$J,"PXRMDNAME")) Q:DNAME=""
        K ^TMP("PXRMEXLD",$J)
        S (NLINE,NSEL)=0
        ;Save reminder dialog
        D DLINE(DNAME,VIEW,.NLINE,DNAME,"","","")
        S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=""
        S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        ;Process components
        D DCMP(DNAME,VIEW,.NLINE,DNAME,"")
        ;Process replacement elements
        I $D(^TMP("PXRMEXTMP",$J,"DREPL",DNAME))>0 D DREPL(DNAME,VIEW,.NLINE)
        S ^TMP("PXRMEXLD",$J,"VALMCNT")=NLINE
        Q
        ;
        ;======================================
CHKREPL(DIALNAM,DLG)    ;
        N CNT,RESULT
        S (CNT,RESULT)=0
        F  S CNT=$O(^TMP("PXRMEXTMP",$J,"DREPL",DIALNAM,CNT)) Q:CNT'>0!(RESULT>0)  D
        .I DLG=$O(^TMP("PXRMEXTMP",$J,"DREPL",DIALNAM,CNT,"")) S RESULT=CNT Q
        Q RESULT
        ;
        ;======================================
DCMP(DIALNAM,VIEW,NLINE,DLG,LEV)        ;Save details of dialog components for display
        N DNAME,DREP,DSEQ,LAST,NUM
        S (DSEQ,LAST)=0
        F  S DSEQ=$O(^TMP("PXRMEXTMP",$J,"DMAP",DLG,DSEQ)) Q:'DSEQ  D
        .S DNAME=$P(^TMP("PXRMEXTMP",$J,"DMAP",DLG,DSEQ),U,1) Q:DNAME=""
        .;Check if this component has been replaced
        .S DREP=$G(PXRMNMCH(FILENUM,DNAME)) I DREP=DNAME S DREP=""
        .;Save line in workfile
        .S NUM=DSEQ
        .I +LEV>0,NUM>0,$E(LEV,$L(LEV))'="." S LEV=LEV_"."
        .D DLINE(DIALNAM,VIEW,.NLINE,DNAME,LEV,NUM,DREP) Q:DREP'=""
        .I $D(^TMP("PXRMEXTMP",$J,"DMAP",DNAME)) D DCMP(DIALNAM,VIEW,.NLINE,DNAME,LEV_DSEQ_".")
        .;Extra line feed
        .I LEV="" D
        ..S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=""
        ..S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        Q
        ;
        ;======================================
DLINE(DIALNAM,VIEW,NLINE,DNAME,LEV,DSEQ,DREP)   ;Update workfile
        N DEXIST,DTXT,DTYP,EXIST,FMTSTR,IND,ITEM,LEVSEQ,LINE,NOUT
        N SEP,TEMP,TEXTOUT,X
        S NSEL=NSEL+1,ITEM=NSEL,NLINE=NLINE+1
        S LEVSEQ=LEV_DSEQ,SEP=$E(LEV,$L(LEV))
        ;Determine type
        S DTYP=$G(^TMP("PXRMEXTMP",$J,"DTYP",DNAME))
        I $D(^TMP("PXRMEXDGH",$J,ITEM)) G EXF
        S TEMP=ITEM
        I (DTYP'["rs")&(DTYP'["prompt")&(DTYP'["forced") S TEMP=TEMP_"^"_LEVSEQ_" "_DNAME
        E  S TEMP=TEMP_"^"_DNAME
        ;Check for replacements
        I $D(^TMP("PXRMEXTMP",$J,"DREPL",DIALNAM)),$$CHKREPL(DIALNAM,DNAME) S TEMP=TEMP_"*"
        ;Add Type
        S TEMP=TEMP_"^"_DTYP
        ;Dialog component display
        S FMTSTR="4R3^52L1^10R1"
        D COLFMT^PXRMTEXT(FMTSTR,TEMP," ",.NOUT,.TEXTOUT)
        S ^TMP("PXRMEXDGH",$J,ITEM)=NOUT
        F IND=1:1:NOUT S ^TMP("PXRMEXDGH",$J,ITEM,IND)=TEXTOUT(IND)
        ;
        ;Exists flag
EXF     S DEXIST=$$EXISTS^PXRMEXIU(801.41,DNAME)
        S LINE=^TMP("PXRMEXDGH",$J,ITEM,1)
        I DEXIST S LINE=LINE_$J("",76-$L(LINE))_"X"
        S ^TMP("PXRMEXLD",$J,NLINE,0)=LINE
        ;
        ;Set up selection index
        S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        S TEMP=^TMP("PXRMEXTMP",$J,"DLOC",DNAME)
        ;Store the file number, 100 node start and stop line, 120 node indexes.
        S ^TMP("PXRMEXLD",$J,"SEL",NSEL)=801.41_U_TEMP_U_DEXIST_U_DNAME
        ;
        ;Display any additional lines.
        S NOUT=^TMP("PXRMEXDGH",$J,ITEM)
        I NOUT>1 F IND=2:1:NOUT S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=^TMP("PXRMEXDGH",$J,ITEM,IND)
        ;
        ;Insert additional text lines
        I VIEW=1,DREP="" D VIEW1(DNAME,.NLINE,NSEL,SEP)
        ;
        ;Insert finding items
        I VIEW=2,("element;group"[DTYP),"rs."'[DTYP,DREP="" D VIEW2(DNAME,.NLINE,NSEL)
        ;
        ;Usage screen
        I VIEW=4,DREP="" D VIEW4(.NLINE,NSEL,SEP)
        Q
        ;
        ;======================================
DREPL(DIALNAM,VIEW,NLINE)       ;Build replacement elements/groups for List Man display.
        N CNT,DLG,DNAME,DREP,LEV,PXRMEXOR,STR,TEMP
        S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=""
        S $P(STR,"-",31)=""
        S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=$J(STR_" REPLACEMENT ITEMS "_STR,79)
        S (CNT,LEV)=0,CNT=""
        F  S CNT=$O(^TMP("PXRMEXTMP",$J,"DREPL",DIALNAM,CNT),-1) Q:CNT'>0  D
        .S DLG=$O(^TMP("PXRMEXTMP",$J,"DREPL",DIALNAM,CNT,"")) Q:DLG=""
        .S DNAME=$P($G(^TMP("PXRMEXTMP",$J,"DREPL",DIALNAM,CNT,DLG)),U,1) Q:DNAME=""
        .I $D(PXRMEXOR(DNAME)) Q
        .S PXRMEXOR(DNAME)=""
        .;Check if this component has been replaced
        .S LEV=LEV+1
        .S DREP=$G(PXRMNMCH(FILENUM,DNAME)) I DREP=DNAME S DREP=""
        .;Save line in workfile
        .S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=""
        .S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        .D DLINE(DIALNAM,VIEW,.NLINE,DNAME,LEV,"",DREP)
        .I $D(^TMP("PXRMEXTMP",$J,"DMAP",DNAME)) D DCMP(DIALNAM,VIEW,.NLINE,DNAME,LEV)
        Q
        ;
        ;======================================
OTHER(NAME,LIST)        ;Check if used by other dialogs
        N DDATA,DIEN,DNAME,DTYP,IEN
        S IEN=$O(^PXRMD(801.41,"B",NAME,0)) Q:'IEN
        ;Check if used by other dialogs
        I '$D(^PXRMD(801.41,"AD",IEN)) Q
        ;Build list of dialogs using this component
        S DIEN=0
        F  S DIEN=$O(^PXRMD(801.41,"AD",IEN,DIEN)) Q:'DIEN  D
        .S DDATA=$G(^PXRMD(801.41,DIEN,0)) Q:DDATA=""
        .S DNAME=$P(DDATA,U),DTYP=$P(DDATA,U,4) Q:DNAME=""
        .;Include only dialogs that are not part of this reminder dialog
        .I $D(^TMP("PXRMEXTMP",$J,"DMAP",DNAME)) Q
        .S LIST(DNAME)=DTYP
        Q
        ;
        ;======================================
VIEW1(DNAME,NLINE,NSEL,SEP)     ;Build the text view.
        N DSUB,DTXT,FILENUM
        S DTXT=$G(^TMP("PXRMEXTMP",$J,"DTXT",DNAME))
        I (DTXT'=""),(DTXT'=DNAME) D
        . S NLINE=NLINE+1
        . S ^TMP("PXRMEXLD",$J,NLINE,0)=$J("",12+$L(SEP))_$E(DTXT,1,50)
        . S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        S DSUB=0,FILENUM=8927.1
        F  S DSUB=$O(^TMP("PXRMEXTMP",$J,"DTXT",DNAME,DSUB)) Q:'DSUB  D
        .S DTXT=$G(^TMP("PXRMEXTMP",$J,"DTXT",DNAME,DSUB)),NLINE=NLINE+1
        .S ^TMP("PXRMEXLD",$J,NLINE,0)=$J("",12+$L(SEP))_$E(DTXT,1,50)
        .S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        ;TIU template changes
        I $D(PXRMNMCH(FILENUM)),$D(^TMP("PXRMEXTMP",$J,"DTIU",DNAME)) D
        .N LINE,TNAM,TNNAM
        .S TNAM=""
        .F  S TNAM=$O(^TMP("PXRMEXTMP",$J,"DTIU",DNAME,TNAM)) Q:TNAM=""  D
        ..S TNNAM=$G(PXRMNMCH(FILENUM,TNAM)) Q:TNNAM=""
        ..S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=$J("",79)
        ..S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        ..S LINE=$J("",12+$L(SEP))_"(TIU template "_TNAM_" copied to "_TNNAM_")"
        ..S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=LINE
        ..S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        ..S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=""
        ..S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        Q
        ;
        ;======================================
VIEW2(DNAME,NLINE,NSEL) ;Build the finding view.
        N DSUB,EXISTS,FDATA,FILENUM,FLIT,FLONG,FMTSTR,FNAME,FOUND
        N FTAB,FTYP,IND,LINE,NL,OUTPUT,TEMP
        S FMTSTR="12R^60L4^1C"
        ;Findings and additional findings
        S DSUB=0,FOUND=0
        F  S DSUB=$O(^TMP("PXRMEXTMP",$J,"DFND",DNAME,DSUB)) Q:'DSUB  D
        .S FNAME=$G(^TMP("PXRMEXTMP",$J,"DFND",DNAME,DSUB)) Q:FNAME=""
        .S FDATA=$G(^TMP("PXRMEXFND",$J,FNAME))
        .S FILENUM=$P(FDATA,U),FTYP=$P(FDATA,U,2) Q:'FILENUM
        .;S EXIST=$$EXISTS^PXRMEXIU(FILENUM,FNAME),FOUND=1
        .S EXIST=$$EXISTS^PXRMEXIU(FILENUM,FNAME,"W"),FOUND=1
        .I FOUND D
        ..S TEMP=U_$S(DSUB>1:"Add. Finding: ",1:"Finding: ")
        ..S TEMP=TEMP_FNAME_" ("_FTYP_")"
        ..I EXIST S TEMP=TEMP_U_"X"
        .D COLFMT^PXRMTEXT(FMTSTR,TEMP," ",.NL,.OUTPUT)
        .F IND=1:1:NL D
        .. S NLINE=NLINE+1
        .. S ^TMP("PXRMEXLD",$J,NLINE,0)=OUTPUT(IND)
        .. S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        ;If no findings
        I 'FOUND D
        .S NLINE=NLINE+1
        .S ^TMP("PXRMEXLD",$J,NLINE,0)=$J("",12)_"Finding: *NONE*"
        .S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        Q
        ;
        ;======================================
VIEW4(DNAME,NLINE,NSEL,SEP)     ;Build the usage view.
        N DOTHER,DTXT,DTYPE,OTHER,TYPE
        D OTHER(DNAME,.DOTHER) Q:'$D(DOTHER)
        S OTHER=""
        F  S OTHER=$O(DOTHER(OTHER)) Q:OTHER=""  D
        .S TYPE=DOTHER(OTHER),NLINE=NLINE+1,DTYPE="REMINDER DIALOG"
        .I TYPE="G" S DTYPE="DIALOG GROUP"
        .I TYPE="E" S DTYPE="DIALOG ELEMENT"
        .S DTXT="USED BY: "_OTHER_" ("_DTYPE_")"
        .S ^TMP("PXRMEXLD",$J,NLINE,0)=$J("",12+$L(SEP))_DTXT
        .S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
        Q
        ;
