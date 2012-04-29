PXRMINDL        ; SLC/PKR - List building routines. ;01/27/2009
        ;;2.0;CLINICAL REMINDERS;**4,6,12**;Feb 04, 2005;Build 73
        ;================================================
EVALPL(FINDPA,ENODE,TERMARR,PLIST)      ;General patient list term evaluator.
        ;Return the list in ^TMP($J,PLIST)
        N ITEM,FILENUM,PFINDPA
        N SSFIND,TEMP,TFINDING,TFINDPA
        S FILENUM=$$GETFNUM^PXRMDATA(ENODE)
        I $G(^PXRMINDX(FILENUM,"DATE BUILT"))="" D  Q
        . D NOINDEX^PXRMERRH("TR",TERMARR("IEN"),FILENUM)
        S ITEM=""
        F  S ITEM=$O(TERMARR("E",ENODE,ITEM)) Q:ITEM=""  D
        . S TFINDING=""
        . F  S TFINDING=$O(TERMARR("E",ENODE,ITEM,TFINDING)) Q:+TFINDING=0  D
        .. K PFINDPA,TFINDPA
        .. M TFINDPA=TERMARR(20,TFINDING)
        ..;Set the finding parameters.
        .. D SPFINDPA^PXRMTERM(.FINDPA,.TFINDPA,.PFINDPA)
        .. D GPLIST(FILENUM,"IP",ITEM,.PFINDPA,PLIST)
        Q
        ;
        ;================================================
FPLIST(FILENUM,SNODE,ITEM,NOCC,BDT,EDT,PLIST)   ;Find patient list data for
        ;regular files. Return the list in ^TMP($J,PLIST).
        N DAS,DATE,DFN,DS,NFOUND
        K ^TMP($J,PLIST)
        I FILENUM=601.84 D SEVALPL^PXRMMH(ITEM,NOCC,BDT,EDT,PLIST) Q
        S DS=$S(EDT[".":EDT+.0000001,1:EDT+.240001)
        S DFN=0
        F  S DFN=$O(^PXRMINDX(FILENUM,SNODE,ITEM,DFN)) Q:DFN=""  D
        . S NFOUND=0
        . S DATE=DS
        . F  S DATE=+$O(^PXRMINDX(FILENUM,SNODE,ITEM,DFN,DATE),-1) Q:(DATE=0)!(DATE<BDT)!(NFOUND=NOCC)  D
        .. S DAS=""
        .. F  S DAS=$O(^PXRMINDX(FILENUM,SNODE,ITEM,DFN,DATE,DAS),-1) Q:DAS=""  D
        ... S NFOUND=NFOUND+1
        ... S ^TMP($J,PLIST,DFN,NFOUND)=DAS_U_DATE
        Q
        ;
        ;================================================
FPLISTSS(FILENUM,SNODE,ITEM,NGET,BDT,EDT,USESTRT,PLIST) ;Find patient list
        ;data for a finding with a start and stop date.
        ;Return the list in ^TMP($J,PLIST).
        N DAS,DFN,DONE,EDTT,NFOUND,OVERLAP,SDATE,START,STOP,TDATE,TIND,TLIST
        K ^TMP($J,PLIST)
        S EDTT=$S(EDT[".":EDT+.0000001,1:EDT+.240001)
        S DFN=0
        F  S DFN=$O(^PXRMINDX(FILENUM,SNODE,ITEM,DFN)) Q:DFN=""  D
        . S (DONE,NFOUND)=0
        . S START=EDTT
        . K TLIST
        . F  S START=+$O(^PXRMINDX(FILENUM,SNODE,ITEM,DFN,START),-1) Q:(START=0)!(DONE)  D
        .. S STOP=""
        .. F  S STOP=$O(^PXRMINDX(FILENUM,SNODE,ITEM,DFN,START,STOP),-1) Q:(STOP="")!(DONE)  D
        ... S SDATE=$S(USESTRT:START,STOP["U":$$NOW^PXRMDATE_"U",1:STOP)
        ... S OVERLAP=$$OVERLAP^PXRMINDX(START,SDATE,BDT,EDTT)
        ... I OVERLAP="O" D
        .... S DAS=$O(^PXRMINDX(FILENUM,SNODE,ITEM,DFN,START,STOP,""))
        .... S NFOUND=NFOUND+1,TLIST(SDATE,NFOUND)=DAS_U_START_U_SDATE
        ... I FILENUM="55NVA" Q
        ... I FILENUM=100 Q
        ... I OVERLAP="L" S DONE=1 Q
        .;Return up to NGET of the most recent entries.
        . S NFOUND=0,TDATE=""
        . F  S TDATE=$O(TLIST(TDATE)) Q:(TDATE="")!(NFOUND=NGET)  D
        .. S TIND=0
        .. F  S TIND=$O(TLIST(TDATE,TIND)) Q:(TIND="")!(NFOUND=NGET)  D
        ... S NFOUND=NFOUND+1,^TMP($J,PLIST,DFN,NFOUND)=TLIST(TDATE,TIND)
        Q
        ;
        ;================================================
GPLIST(FILENUM,SNODE,ITEM,PFINDPA,PLIST)        ;Add to the patient list
        ;for a regular file. Return the list in ^TMP($J,PLIST):
        ;^TMP($J,PLIST,T/F,DFN,ITEM,COUNT,FILENUM)=DAS^DATE^VALUE
        N BDT,CASESEN,COND,CONVAL,DAS,DATE,EDT,DFN,FIEVD,FLIST,GPLIST
        N ICOND,IND,INVFD,IPLIST,NOCC,NFOUND,NGET
        N SAVE,SSFIND,STATOK,STATUSA,TEMP,TGLIST,TPLIST
        N UCIFS,USESTRT,VALUE,VSLIST
        S TGLIST="GPLIST_PXRMINDL"
        ;Determine if this is a finding with a start and stop date.
        S SSFIND=$S(FILENUM=52:1,FILENUM[55:1,FILENUM=100:1,1:0)
        S USESTRT=$S(SSFIND:$P(PFINDPA(0),U,15),1:0)
        I FILENUM=100,USESTRT="" S USESTRT=1
        ;Set the finding search parameters.
        D SSPAR^PXRMUTIL(PFINDPA(0),.NOCC,.BDT,.EDT)
        S INVFD=$P(PFINDPA(0),U,16)
        D GETSTATI^PXRMSTAT(FILENUM,.PFINDPA,.STATUSA)
        D SCPAR^PXRMCOND(.PFINDPA,.CASESEN,.COND,.UCIFS,.ICOND,.VSLIST)
        ;Ignore any negative occurrence counts, date reversal not allowed
        ;in patient lists.
        S NOCC=$S(NOCC<0:-NOCC,1:NOCC)
        S NGET=$S(UCIFS:50,$D(STATUSA):50,1:NOCC)
        I SSFIND D FPLISTSS(FILENUM,SNODE,ITEM,NGET,BDT,EDT,USESTRT,TGLIST)
        I 'SSFIND D FPLIST(FILENUM,SNODE,ITEM,NGET,BDT,EDT,TGLIST)
        S DFN=""
        F  S DFN=$O(^TMP($J,TGLIST,DFN)) Q:DFN=""  D
        . K GPLIST
        . M GPLIST=^TMP($J,TGLIST,DFN)
        . S (IND,NFOUND)=0
        . K IPLIST
        . F  S IND=$O(GPLIST(IND)) Q:(IND="")!(NFOUND=NOCC)  D
        .. S TEMP=GPLIST(IND)
        .. S DAS=$P(TEMP,U,1)
        .. S DATE=$P(TEMP,U,2)
        ..;If this a Lab finding attach the item to the DAS.
        .. I PFINDPA(0)["LAB(60" S DAS=ITEM_"~"_DAS
        ..;If this is a Mental Health finding attach the scale to DAS.
        .. I PFINDPA(0)["YTT(601.71" S DAS=DAS_"S"_$P(PFINDPA(0),U,12)
        .. D GETDATA^PXRMDATA(FILENUM,DAS,.FIEVD)
        .. S VALUE=$G(FIEVD("VALUE"))
        .. I INVFD D GETDATA^PXRMVSIT(FIEVD("VISIT"),.FIEVD,0)
        .. S FIEVD("DATE")=DATE
        ..;If there is a status list make sure the finding has a status on
        ..;the list.
        .. S STATOK=$S($D(STATUSA):$$STATUSOK^PXRMINDX(.STATUSA,.FIEVD),1:1)
        .. I 'STATOK Q
        .. S CONVAL=$S(COND'="":$$COND^PXRMCOND(CASESEN,ICOND,VSLIST,.FIEVD),1:1)
        .. S SAVE=$S('UCIFS:1,(UCIFS&CONVAL):1,1:0)
        .. I SAVE D
        ... S NFOUND=NFOUND+1
        ... S IPLIST(CONVAL,DFN,ITEM,NFOUND,FILENUM)=TEMP_U_VALUE
        . M ^TMP($J,PLIST)=IPLIST
        K ^TMP($J,TGLIST)
        Q
        ;
