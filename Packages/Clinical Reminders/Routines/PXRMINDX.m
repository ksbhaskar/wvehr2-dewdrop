PXRMINDX        ; SLC/PKR - Routines for utilizing the index. ;02/22/2010
        ;;2.0;CLINICAL REMINDERS;**4,6,12,17**;Feb 04, 2005;Build 102
        ;Code for patient findings.
        ;================================================================
EVALFI(DFN,DEFARR,ENODE,FIEVAL) ;General finding evaluator.
        N BDT,EDT,FIEVT,FILENUM,FINDING,FINDPA,ITEM,NOINDEX
        S FILENUM=$$GETFNUM^PXRMDATA(ENODE)
        I $G(^PXRMINDX(FILENUM,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("D",PXRMITEM,FILENUM)
        . S NOINDEX=1
        E  S NOINDEX=0
        S ITEM=""
        F  S ITEM=$O(DEFARR("E",ENODE,ITEM)) Q:ITEM=""  D
        . S FINDING=""
        . F  S FINDING=$O(DEFARR("E",ENODE,ITEM,FINDING)) Q:+FINDING=0  D
        .. I NOINDEX S FIEVAL(FINDING)=0 Q
        .. K FINDPA
        .. M FINDPA=DEFARR(20,FINDING)
        .. K FIEVT
        .. D FIEVAL(FILENUM,"PI",DFN,ITEM,.FINDPA,.FIEVT)
        .. M FIEVAL(FINDING)=FIEVT
        .. S FIEVAL(FINDING,"FINDING")=$P(FINDPA(0),U,1)
        Q
        ;
        ;================================================================
EVALTERM(DFN,FINDPA,ENODE,TERMARR,TFIEVAL)      ;General term
        ;evaluator.
        N FIEVT,FILENUM,ITEM,NOINDEX,PFINDPA
        N TFINDING,TFINDPA
        S FILENUM=$$GETFNUM^PXRMDATA(ENODE)
        I $G(^PXRMINDX(FILENUM,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("TR",TERMARR("IEN"),FILENUM)
        . S NOINDEX=1
        E  S NOINDEX=0
        S ITEM=""
        F  S ITEM=$O(TERMARR("E",ENODE,ITEM)) Q:ITEM=""  D
        . S TFINDING=""
        . F  S TFINDING=$O(TERMARR("E",ENODE,ITEM,TFINDING)) Q:+TFINDING=0  D
        .. I NOINDEX S TFIEVAL(TFINDING)=0 Q
        .. K FIEVT,PFINDPA,TFINDPA
        .. M TFINDPA=TERMARR(20,TFINDING)
        ..;Set the finding parameters.
        .. D SPFINDPA^PXRMTERM(.FINDPA,.TFINDPA,.PFINDPA)
        .. D FIEVAL(FILENUM,"PI",DFN,ITEM,.PFINDPA,.FIEVT)
        .. M TFIEVAL(TFINDING)=FIEVT
        .. S TFIEVAL(TFINDING,"FINDING")=$P(TFINDPA(0),U,1)
        Q
        ;
        ;================================================================
FIEVAL(FILENUM,SNODE,DFN,ITEM,PFINDPA,FIEVAL)   ;
        ;Evaluate regular patient findings.
        N BDT,CASESEN,COND,CONVAL,DAS,DATE,EDT,FIEVD,FLIST,ICOND,IEN,IND,INVFD
        N NFOUND,NGET,NOCC,NP
        N SAVE,SDIR,SSFIND,STATOK,STATUSA,UCIFS,USESTRT,VSLIST
        ;Set the finding search parameters.
        D SSPAR^PXRMUTIL(PFINDPA(0),.NOCC,.BDT,.EDT)
        D SCPAR^PXRMCOND(.PFINDPA,.CASESEN,.COND,.UCIFS,.ICOND,.VSLIST)
        S SDIR=$S(NOCC<0:+1,1:-1)
        S NOCC=$S(NOCC<0:-NOCC,1:NOCC)
        S NGET=$S(UCIFS:50,1:NOCC)
        ;Determine if this is a finding with a start and stop date.
        S SSFIND=$S(FILENUM=52:1,FILENUM["55":1,FILENUM=100:1,1:0)
        S USESTRT=$S(SSFIND:$P(PFINDPA(0),U,15),1:0)
        I FILENUM=100,USESTRT="" S USESTRT=1
        ;Get the status list.
        D GETSTATI^PXRMSTAT(FILENUM,.PFINDPA,.STATUSA)
        I SSFIND D FPDATSS(FILENUM,SNODE,DFN,ITEM,NGET,SDIR,BDT,EDT,USESTRT,.NFOUND,.FLIST)
        I 'SSFIND D FPDAT(FILENUM,SNODE,DFN,ITEM,NGET,SDIR,BDT,EDT,.NFOUND,.FLIST)
        I NFOUND=0 S FIEVAL=0 Q
        S INVFD=$P(PFINDPA(0),U,16)
        S NP=0
        F IND=1:1:NFOUND Q:NP=NOCC  D
        . S DAS=$P(FLIST(IND),U,1)
        .;If this a Lab finding attach the item to the DAS.
        . I PFINDPA(0)["LAB(60" S DAS=ITEM_"~"_DAS
        .;If this is a Mental Health finding attach the scale to DAS.
        . I PFINDPA(0)["YTT(601.71" S DAS=DAS_"S"_$P(PFINDPA(0),U,12)
        . D GETDATA^PXRMDATA(FILENUM,DAS,.FIEVD)
        . I INVFD D GETDATA^PXRMVSIT(FIEVD("VISIT"),.FIEVD,0)
        . S FIEVD("DATE")=$P(FLIST(IND),U,2)
        .;If there is a status list make sure the finding has one on the list.
        . S STATOK=$S($D(STATUSA):$$STATUSOK(.STATUSA,.FIEVD),1:1)
        . I 'STATOK Q
        . S CONVAL=$S(COND'="":$$COND^PXRMCOND(CASESEN,ICOND,VSLIST,.FIEVD),1:1)
        . S SAVE=$S('UCIFS:1,(UCIFS&CONVAL):1,1:0)
        . I SAVE D
        .. S NP=NP+1
        .. S FIEVAL(NP)=CONVAL
        .. I COND'="" S FIEVAL(NP,"CONDITION")=CONVAL
        .. S FIEVAL(NP,"DAS")=$P(FLIST(IND),U,1)
        .. S FIEVAL(NP,"DATE")=FIEVD("DATE")
        .. M FIEVAL(NP)=FIEVD
        .. I $G(PXRMDEBG) M FIEVAL(NP,"CSUB")=FIEVD
        ;
        ;Save the finding result.
        D SFRES^PXRMUTIL(SDIR,NP,.FIEVAL)
        S FIEVAL("FILE NUMBER")=FILENUM
        Q
        ;
        ;================================================================
FPDAT(FILENUM,SNODE,DFN,ITEM,NGET,SDIR,BDT,EDT,NFOUND,FLIST)    ;Find patient
        ;data for regular files. FLIST is returned in date order, i.e.,
        ;FLIST(1) is the most recent SDIR=-1, oldest SDIR=+1.
        I FILENUM=601.84 D SEVALFI^PXRMMH(DFN,ITEM,NGET,SDIR,BDT,EDT,.NFOUND,.FLIST) Q
        N DAS,DATE,DONE,EDTT
        S EDTT=$S(EDT[".":EDT+.0000001,1:EDT+.240001)
        S (DONE,NFOUND)=0
        S DATE=$S(SDIR=+1:BDT-.000001,1:EDTT)
        F  S DATE=+$O(^PXRMINDX(FILENUM,SNODE,DFN,ITEM,DATE),SDIR) Q:(DATE=0)!(DONE)  D
        . I DATE<BDT,SDIR=-1 S DONE=1 Q
        . I DATE>EDTT,SDIR=1 S DONE=1 Q
        . S DAS=""
        . F  S DAS=$O(^PXRMINDX(FILENUM,SNODE,DFN,ITEM,DATE,DAS),-1) Q:DAS=""  D
        .. S NFOUND=NFOUND+1
        .. S FLIST(NFOUND)=DAS_U_DATE
        .. I NFOUND=NGET S DONE=1 Q
        Q
        ;
        ;================================================================
FPDATSS(FILENUM,SNODE,DFN,ITEM,NGET,SDIR,BDT,EDT,USESTRT,NFOUND,FLIST)  ;Find
        ;patient data for findings that have a start and stop date. FLIST
        ;is returned in date order, i.e., FLIST(1) is the most recent.
        N DAS,DONE,EDTT,OVERLAP,SDATE,START,STOP,TDATE,TIND,TLIST
        S EDTT=$S(EDT[".":EDT+.0000001,1:EDT+.240001)
        S (DONE,NFOUND)=0
        S START=$S(SDIR=+1:0,1:EDTT)
        F  S START=+$O(^PXRMINDX(FILENUM,SNODE,DFN,ITEM,START),SDIR) Q:(START=0)!(DONE)!(START>EDTT)  D
        . S STOP=""
        . F  S STOP=$O(^PXRMINDX(FILENUM,SNODE,DFN,ITEM,START,STOP),SDIR) Q:(STOP="")!(DONE)  D
        ..;Items that do not have a stop date are flagged by "U".
        .. S SDATE=$S(USESTRT:START,STOP["U":$$NOW^PXRMDATE_"U",1:STOP)
        .. S OVERLAP=$$OVERLAP(START,SDATE,BDT,EDT)
        .. I OVERLAP="O" D
        ... S DAS=$O(^PXRMINDX(FILENUM,SNODE,DFN,ITEM,START,STOP,""))
        ... S NFOUND=NFOUND+1,TLIST(SDATE,NFOUND)=DAS_U_SDATE
        ..;Some orders and non-VA meds may not have a Stop Date so we have
        ..;to check all entries.
        .. I FILENUM="55NVA" Q
        .. I FILENUM=100 Q
        .. I OVERLAP="L",SDIR=-1 S DONE=1 Q
        .. I OVERLAP="R",SDIR=1 S DONE=1 Q
        ;Return up to NGET of the most recent/oldest entries.
        S NFOUND=0,TDATE=""
        F  S TDATE=$O(TLIST(TDATE),SDIR) Q:(TDATE="")!(NFOUND=NGET)  D
        . S TIND=0
        . F  S TIND=$O(TLIST(TDATE,TIND)) Q:(TIND="")!(NFOUND=NGET)  D
        .. S NFOUND=NFOUND+1,FLIST(NFOUND)=TLIST(TDATE,TIND)
        Q
        ;
        ;================================================================
OVERLAP(START,STOP,BDT,EDT)     ;Determine if the date range defined by START and
        ;STOP overlaps with the date range defined by BDT and EDT. The return
        ;value "O" means they overlap, "L" means START, STOP is to the
        ;left of BDT, EDT and "R" means it is to the right.
        I EDT<START Q "R"
        I STOP<BDT Q "L"
        Q "O"
        ;
        ;================================================================
STATUSOK(STATUSA,FIEVD) ;Return true if the status in FIEVD matches one in
        ;the list in STATUSA.
        I '$D(FIEVD("STATUS")) Q 1
        N JND,OK
        S OK=0
        F JND=1:1:STATUSA(0) Q:OK  D
        . I STATUSA(JND)="*" S OK=1 Q
        . I STATUSA(JND)=FIEVD("STATUS") S OK=1 Q
        Q OK
        ;
