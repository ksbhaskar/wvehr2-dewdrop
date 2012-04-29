DICL ;SEA/TOAD,SF/TKW-VA FileMan: Lookup: Lister ;12/14/98  13:55
 ;;22.0;VA FileMan;;Mar 30, 1999
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
LIST(DIFILE,DIFIEN,DIFIELDS,DIFLAGS,DINUMBER,DIFROM,DIPART,DINDEX,DISCREEN,DIWRITE,DILIST,DIMSGA,DIC) ;
 ; ENTRY POINT--return a list of entries from a file
 ; (Note: DIC parameter only passed if called from ^DICQ)
 ;
IN ; Entry point from LIST^DIC
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 N DICLERR S DICLERR=$G(DIERR) K DIERR
 ;
INPUT ; Validate input parameters
 N DIERN,DIPE,DIDENT
 S DIFLAGS=$G(DIFLAGS)
 I DIFLAGS["I",DIFLAGS'["Q" S DIFLAGS=DIFLAGS_"Q"
 S DIFIELDS=$G(DIFIELDS)
 I DIFIELDS'["-IX" D
 . N DID S DID=";"_DIFIELDS_";"
 . I (DID["@"!(DIFLAGS["I")),DID'[";IX;",DID'[";IXE",DID'[";IXIE" Q
 . S DIDENT(-5)=1 Q
 S DINUMBER=$G(DINUMBER) I DINUMBER="" S DINUMBER="*"
 I '$D(DIPART(1)) S DIPART(1)=$G(DIPART)
 I '$D(DIFROM(1)) S DIFROM(1)=$G(DIFROM)
 I $O(DIFROM(1)) D
 . N E S E=9999 F  S E=$O(DIFROM(E),-1) Q:'E  Q:DIFROM(E)]""
 . I E N I F I=1:1:E I DIFROM(I)="" D BLD^DIALOG(202,"FROM values"),OUT Q
 . Q
 S DIFROM("IEN")=$G(DIFROM("IEN"))
 S DINDEX("WAY")=1 I DIFLAGS["B" S DINDEX("WAY")=-1
 S DINDEX=$G(DINDEX)
 I '$D(DISCREEN("S")) S DISCREEN("S")=$G(DISCREEN)
 S DIWRITE=$G(DIWRITE)
 ;
OUTPUT ; Establish output file name, starting output subscript no.
 I $G(DILIST)="" S DILIST="^TMP(""DILIST"",$J)"
 E  I DIFLAGS'["h" D  I $G(DIERR) D OUT Q
 . I DILIST'?.1"^"1U.7UN.ANP,DILIST'?.1"^%".7UN.ANP D  Q
 . . D BLD^DIALOG(202,"target array")
 . S DILIST=$NA(@DILIST@("DILIST"))
 . Q
 K @DILIST
 S DILIST("ORDER")=$S(DINDEX("WAY")=1:0,1:DINUMBER+1)
 I DINUMBER="*",DINDEX("WAY")=-1 D
 . S DINDEX("WAY")=1,DINDEX("WAY","REVERSE")=1
 . S DILIST("ORDER")=0
 . Q
 ;
FILE ; Validate file number and IENS.
 I DIFLAGS'["h" D FILE^DICUF(.DIFILE,.DIFIEN,DIFLAGS)
 I $G(DIERR) S DIFROM="",DIFROM("IEN")="" D OUT Q
 D SCREEN^DICUF(DIFLAGS,.DIFILE,.DISCREEN)
 ;
IXNAME ; Set default index name if null.
 I DINDEX'="#",DINDEX'?1U.UNP S DINDEX=$$DINDEX(DIFILE,DIFLAGS)
CHECKS ;
 I $TR(DIFLAGS,"BIKMPQSUfhu")'="" S DIERN=301,DIPE(1)=DIFLAGS D ERROUT Q
 S DIFLAGS=DIFLAGS_3
 I DINUMBER'="*",DINUMBER<1!(DINUMBER\1'=DINUMBER) D  Q
 . S DIERN=202,DIPE(1)="Number" D ERROUT
 ;
IXANDID ; Gather information about index and field data to be returned.
 N DIOUT S DIOUT=0
 D INDEX^DICUIX(.DIFILE,DIFLAGS,.DINDEX,.DIFROM,.DIPART,DINUMBER,.DISCREEN,DILIST,.DIOUT)
 I DIOUT!($G(DIERR)) D KTMPIX^DICL1 Q
 I $D(DISCREEN("V")) D VPDATA^DICUF(.DINDEX,.DISCREEN)
 I $O(DIFROM(DINDEX("#")+1))!(DINDEX'="#"&($O(DIPART(DINDEX("#"))))) D BLD^DIALOG(202,"Index"),KTMPIX^DICL1 Q
 D IDENTS^DICU1(DIFLAGS,.DIFILE,DIFIELDS,DIWRITE,.DIDENT,.DINDEX)
 I $G(DIERR) D KTMPIX^DICL1 Q
 ;
BRANCH ; Continue on to actual search.
 G PREP^DICL1
 ;
DINDEX(DIFILE,DIFLAGS) ; Set DINDEX to index name for KEY.
 N I,X S X=""
 I $G(DIFLAGS)["K" D
 . S I=$O(^DD("KEY","AP",DIFILE,"P",0)) Q:'I
 . S X=$P($G(^DD("IX",+$P($G(^DD("KEY",I,0)),U,4),0)),U,2) Q
 Q:X?1U.UNP X
 Q "B"
 ;
ERROUT D BLD^DIALOG(DIERN,.DIPE,.DIPE),OUT Q
 ;
OUT I DICLERR'=""!$G(DIERR) D
 . S DIERR=$G(DIERR)+DICLERR_U_($P($G(DIERR),U,2)+$P(DICLERR,U,2))
 I $G(DIMSGA)'="" D CALLOUT^DIEFU(DIMSGA)
 Q
 ;
 ; Possible messages returned
 ; 202   The input parameter that identifies the |1
 ; 301   The passed flag(s) '|1|' are unknown or in
 ;
