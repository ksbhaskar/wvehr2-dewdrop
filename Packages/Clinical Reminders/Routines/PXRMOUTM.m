PXRMOUTM        ; SLC/PKR - MyHealtheVet output. ;10/20/2009
        ;;2.0;CLINICAL REMINDERS;**4,6,17**;Feb 04, 2005;Build 102
        ;
        ;================================================
FOUT(INDENT,IFIEVAL,NLINES,TEXT)        ;Do output for individual findings
        ;in the FINDING array.
        I $D(IFIEVAL("TERM")) D MHVOUT^PXRMTERM(1,.IFIEVAL,.NFLINES,.TEXT) Q
        N FTYPE
        S FTYPE=$P(IFIEVAL("FINDING"),U,1)
        S FTYPE=$P(FTYPE,";",2)
        I FTYPE="AUTTEDT(" D MHVOUT^PXRMEDU(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="AUTTEXAM(" D MHVOUT^PXRMEXAM(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="AUTTHF(" D MHVOUT^PXRMHF(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="AUTTIMM(" D MHVOUT^PXRMIMM(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="AUTTSK(" D MHVOUT^PXRMSKIN(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="GMRD(120.51," D MHVOUT^PXRMVITL(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="LAB(60," D MHVOUT^PXRMLAB(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="ORD(101.43," D MHVOUT^PXRMORDR(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="PS(50.605," D MHVOUT^PXRMDRCL(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="PSDRUG(" D MHVOUT^PXRMDRUG(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="PS(55," D MHVOUT^PXRMDRUG(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="PS(55NVA," D MHVOUT^PXRMDRUG(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="PSRX(" D MHVOUT^PXRMDRUG(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="PSNDF(50.6," D MHVOUT^PXRMDGEN(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="PXD(811.2," D MHVOUT^PXRMTAX(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="PXRMD(802.4," D MHVOUT^PXRMFF(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="PXRMD(810.9," D MHVOUT^PXRMLOCF(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="PXRMD(811.4," D MHVOUT^PXRMCF(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="RAMIS(71," D MHVOUT^PXRMRAD(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        I FTYPE="YTT(601.71," D MHVOUT^PXRMMH(INDENT,.IFIEVAL,.NLINES,.TEXT) Q
        Q
        ;
        ;================================================
MHVC(DEFARR,PXRMPDEM,PCLOGIC,RESLOGIC,RESDATE,FIEVAL)   ;Prepare the
        ;MyHealtheVet combined output.
        N PNAME,RIEN
        S RIEN=DEFARR("IEN")
        S PNAME=$O(^TMP("PXRHM",$J,RIEN,""))
        S ^TMP("PXRMMHVC",$J,RIEN,"STATUS")=^TMP("PXRHM",$J,RIEN,PNAME)
        D MHVD(.DEFARR,.PXRMPDEM,PCLOGIC,RESLOGIC,RESDATE,.FIEVAL,0)
        M ^TMP("PXRMMHVC",$J,RIEN,"DETAIL")=^TMP("PXRHM",$J,RIEN,PNAME,"TXT")
        K ^TMP("PXRHM",$J,RIEN,PNAME,"TXT")
        D MHVS(.DEFARR,.PXRMPDEM,PCLOGIC,RESLOGIC,RESDATE,.FIEVAL,0)
        M ^TMP("PXRMMHVC",$J,RIEN,"SUMMARY")=^TMP("PXRHM",$J,RIEN,PNAME,"TXT")
        K ^TMP("PXRHM",$J,RIEN,PNAME)
        Q
        ;
        ;================================================
MHVD(DEFARR,PXRMPDEM,PCLOGIC,RESLOGIC,RESDATE,FIEVAL,WEB)       ;Prepare the
        ;MyHealtheVet detailed output.
        N IND,JND,FIDATA,FINDING,FLIST,FTYPE
        N HDR,NHDR,IFIEVAL,LIST,NFLINES,NTXT,NUM
        N TEXT
        S NTXT=0
        ;Output the AGE match/no match text.
        D AGE^PXRMFNFT(PXRMPDEM("DFN"),.DEFARR,.FIEVAL,.NTXT)
        ;Process the findings in the order: patient cohort, resolution,
        ;age, and informational.
        M FIDATA=FIEVAL
        F FTYPE="PCL","RES","AGE","INFO" D
        . S LIST=$S(FTYPE="PCL":DEFARR(32),FTYPE="RES":DEFARR(36),FTYPE="AGE":DEFARR(40),FTYPE="INFO":DEFARR(42))
        .;Output the general logic text.
        . I FTYPE="PCL" D LOGIC^PXRMFNFT(PXRMPDEM("DFN"),PCLOGIC,FTYPE,"D",.DEFARR,.NTXT)
        . I FTYPE="RES",$P(PCLOGIC,U,1) D LOGIC^PXRMFNFT(PXRMPDEM("DFN"),RESLOGIC,FTYPE,"D",.DEFARR,.NTXT)
        .;Process the findings for each type.
        . K TEXT
        . S (NHDR,NFLINES)=0
        . S NUM=+$P(LIST,U,1)
        . S FLIST=$P(LIST,U,2)
        . F IND=1:1:NUM D
        .. S FINDING=$P(FLIST,";",IND)
        ..;No output for age or sex findings.
        .. I (FINDING="AGE")!(FINDING="SEX") Q
        ..;Make sure each finding is processed only once.
        .. I '$D(FIDATA(FINDING)) Q
        .. K IFIEVAL
        .. I FIEVAL(FINDING) D
        ... M IFIEVAL=FIEVAL(FINDING)
        ...;Remove any false occurrences so they are not displayed.
        ... S JND=0
        ... F  S JND=+$O(IFIEVAL(JND)) Q:JND=0  K:'IFIEVAL(JND) IFIEVAL(JND)
        .. E  S IFIEVAL=0
        ..;Output the found/not found text for the finding.
        .. D FINDING^PXRMFNFT(3,PXRMPDEM("DFN"),FINDING,.IFIEVAL,.NFLINES,.TEXT)
        ..;If the finding is true output the finding information.
        .. I IFIEVAL D FOUT(1,.IFIEVAL,.NFLINES,.TEXT)
        ..;Make sure each finding is processed only once.
        .. K FIDATA(FINDING)
        .;
        .;If there was any text for this finding type create a header.
        .;Output the header and the finding text.
        . D COPYTXT^PXRMOUTU(.NTXT,NFLINES,.TEXT)
        I WEB D WEB(DEFARR("IEN"),.NTXT)
        Q
        ;
        ;================================================
MHVS(DEFARR,PXRMPDEM,PCLOGIC,RESLOGIC,RESDATE,FIEVAL,WEB)       ;Prepare the
        ;MyHealtheVet summary output.
        N NTXT
        S NTXT=0
        D LOGIC^PXRMFNFT(PXRMPDEM("DFN"),PCLOGIC,"PCL","S",.DEFARR,.NTXT)
        I $P(PCLOGIC,U,1) D LOGIC^PXRMFNFT(PXRMPDEM("DFN"),RESLOGIC,"RES","S",.DEFARR,.NTXT)
        I WEB D WEB(DEFARR("IEN"),.NTXT)
        Q
        ;
        ;================================================
WEB(RIEN,NTXT)  ;Output the web site information.
        N DES,IEN,IND,NL,TEXT,TITLE,URL
        I '$D(^PXD(811.9,RIEN,50)) Q
        S TEXT="\\ Please check these web sites for more information:\\"
        D ADDTXT^PXRMOUTU(1,PXRMRM,.NTXT,TEXT)
        S IEN=0
        F  S IEN=+$O(^PXD(811.9,RIEN,50,IEN)) Q:IEN=0  D
        . S TEXT=$G(^PXD(811.9,RIEN,50,IEN,0))
        . S URL=$P(TEXT,U,1)
        . I URL="" Q
        . S TITLE=$P(TEXT,U,2)
        . S DES=$D(^PXD(811.9,RIEN,50,IEN,1))
        . S TEXT(1)="Web Site: "_TITLE_"\\"
        . S TEXT(2)="URL: "_URL_$S('DES:"\\",1:"")
        . D ADDTXTA^PXRMOUTU(2,PXRMRM,.NTXT,2,.TEXT)
        .;If there is a description output it.
        . I 'DES Q
        . K TEXT
        . S (IND,NL)=0
        .  F  S IND=+$O(^PXD(811.9,RIEN,50,IEN,1,IND)) Q:IND=0  D
        .. S NL=NL+1
        .. S TEXT(NL)=^PXD(811.9,RIEN,50,IEN,1,IND,0)
        . S TEXT(NL)=TEXT(NL)_"\\"
        . D ADDTXTA^PXRMOUTU(3,PXRMRM,.NTXT,NL,.TEXT)
        Q
        ;
