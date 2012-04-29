ORRDI1 ;SLC/JMH - RDI routines for API supporting CDS data; 3/24/05 2:31 [8/11/05 6:25am] ; 1/11/07 8:33am
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**232**;Dec 17, 1997;Build 19
 ;
GET(DFN,DOMAIN) ;API for packages to call in order to get data from HDR for
 ; check if in OUTAGE state and quit if so
 I $$DOWNXVAL^ORRDI2 D  Q -1
 .K ^XTMP("ORRDI",DOMAIN,DFN)
 .S ^XTMP("ORRDI",DOMAIN,DFN,0)="^^-1"
 ;  order checking purposes
 N I,ORCACHE,ORRET,ORRECDT
 ;check if data was just retrieved a short time ago and if so return
 S ORRECDT=$P($G(^XTMP("ORRDI",DOMAIN,DFN,0)),U)
 S ORCACHE=$$GET^XPAR("SYS","OR RDI CACHE TIME")
 I $$FMDIFF^XLFDT($$NOW^XLFDT,ORRECDT,2)<(60*ORCACHE),$P(^XTMP("ORRDI",DOMAIN,DFN,0),U,3)>-1 S ORRET=$P(^XTMP("ORRDI",DOMAIN,DFN,0),U,3)
 ;check if there has been an HDR down condition within last minute
 I $$FMDIFF^XLFDT($$NOW^XLFDT,$P($G(^XTMP("ORRDI","PSOO",DFN,0)),U),2)<60,$P($G(^XTMP("ORRDI","PSOO",DFN,0)),U,3)<0 S ORRET=$P($G(^XTMP("ORRDI","PSOO",DFN,0)),U,3)
 I $$FMDIFF^XLFDT($$NOW^XLFDT,$P($G(^XTMP("ORRDI","ART",DFN,0)),U),2)<60,$P($G(^XTMP("ORRDI","ART",DFN,0)),U,3)<0 S ORRET=$P($G(^XTMP("ORRDI","ART",DFN,0)),U,3)
 ;if data is not "fresh" then go get it
 I '$L($G(ORRET)) D
 .S ORRET=$$RETRIEVE(DFN,DOMAIN)
 .I ORRET>-1 S ^XTMP("ORRDI","OUTAGE INFO","FAILURES")=0
 .I ORRET'>-1 D
 ..Q:$P(ORRET,U,2)="PATIENT ICN NOT FOUND"
 ..S ^XTMP("ORRDI","OUTAGE INFO","FAILURES")=$$FAILXVAL^ORRDI2+1
 ..I $$FAILXVAL^ORRDI2'<$$FAILPVAL^ORRDI2 D
 ...S ^XTMP("ORRDI","OUTAGE INFO","DOWN")=1
 ...D SPAWN^ORRDI2
 S $P(^XTMP("ORRDI",DOMAIN,DFN,0),U,3)=ORRET
 I ORRET<1 D
 .N TEMP S TEMP=^XTMP("ORRDI",DOMAIN,DFN,0)
 .K ^XTMP("ORRDI",DOMAIN,DFN)
 .S ^XTMP("ORRDI",DOMAIN,DFN,0)=TEMP
 Q ORRET
HAVEHDR() ;call to check if this system has an HDR to perform order checks
 ;  against
 ;check parameter to see if there is an HDR and returns positive if so
 I $$GET^XPAR("SYS","OR RDI HAVE HDR") Q 1
 ;returns negative because the parameter indicates there is no HDR
 Q 0
RETRIEVE(DFN,DOMAIN) ;actually go get the data from CDS
 K ^XTMP("ORRDI",DOMAIN,DFN)
 N START,END,HLL,HLA,ORFS,ORCS,ORRS,ORES,ORSS
 N Y,ORRSLT,ICN,WHATOUT,HLNEXT,HLNODE,HLQUIT,ORHLP,RET,HL,HLDOM,HLDONE1,HLECH,HLFS,HLINSTN,HLMTIEN,HLPARAM,HLQ,STATUS,PRE
 S (ORFS,ORCS,ORRS,ORES,ORSS)=""
 ;S START=$$FMADD^XLFDT($P($$NOW^XLFDT,"."),-120),END=$$FMADD^XLFDT($P($$NOW^XLFDT,"."),485)
 ;set up what codes for specific domains
 I DOMAIN="ART" S WHATOUT="039OC_AL:ALLERGIES"
 I DOMAIN="PSOO" S WHATOUT="055OC_RXOP:PHARMACY ALL OUTPATIENT",START=$$FMADD^XLFDT($P($$NOW^XLFDT,"."),-30)
 ;get patient identifier (ICN)
 D SELECT^ORWPT(.Y,DFN)
 S ICN=$P($G(Y),U,14)
 I 'ICN Q -1_"^PATIENT ICN NOT FOUND"
 ;build HLA array with request HL7
 S HLA("HLS",1)="SPR^XWBDRPC845-569716_0^T^ZREMOTE RPC^@SPR.4.2~003RPC017ORWRP REPORT TEXT&006RPCVER0010&007XWBPCNT0017&007XWBESSO066321214321\F\\F\\F\657\F"
 S HLA("HLS",1,1)="\48102&007XWBDVER0011&006XWBSEC0043.14&002P10187369543;"_ICN_"&002P2"_WHATOUT_";1\S\RXOP;ORDV06;28;200&002P3000&002P4000&002P5000&002P600"_$L($G(START))_$G(START)_"&002P700"_$L($G(END))_$G(END)
 S HLA("HLS",2)="RDF^1^@DSP.3~TX~300"
 ;set HLL("LINKS") node to specify receiver location
 S HLL("LINKS",1)="ORRDI SUBSCRIBER^ORHDR"
 S ORHLP("OPEN TIMEOUT")=10
 S ORHLP("SUBSCRIBER")="^OR RDI SENDER^"_$P($$SITE^VASITE,U,3)_"^OR RDI RECEIVER^^^"
 ;call DIRECT^HLMA to send request
 D DIRECT^HLMA("ORRDI EVENT","LM",1,.ORRSLT,,.ORHLP)
 ;set time stamp of the data
 I $G(ORRSLT) S ^XTMP("ORRDI",DOMAIN,DFN,0)=$$NOW^XLFDT
 ;check if call failed
 I $P($G(ORRSLT),U,2) Q "-1"_U_$G(ORRSLT)
 ;get and parse the response HL7
 S ORFS=$G(HL("FS")),ORCS=$E($G(HL("ECH")),1),ORRS=$E($G(HL("ECH")),2),ORES=$E($G(HL("ECH")),3),ORSS=$E($G(HL("ECH")),4)
 N ORQUIT S ORQUIT=""
 F  X HLNEXT Q:HLQUIT'>0!(ORQUIT'="")  D
 .I $E(HLNODE,1,3)="MSA"&($P(HLNODE,ORFS,2)'="AA") S ORQUIT=$P(HLNODE,ORFS,2)
 .I $E(HLNODE,1,3)="ERR" S ORQUIT=$P(HLNODE,ORFS,2)
 .I $E(HLNODE,1,3)="RDT"&($P(HLNODE,ORFS,2)="S") D
 ..S ^XTMP("ORRDI",0)=$$FMADD^XLFDT($$NOW^XLFDT,2)_U_$$NOW^XLFDT
 ..I DOMAIN="ART" D ALPARSE(DFN,.HLNODE)
 ..I DOMAIN="PSOO" D PSPARSE(DFN,.HLNODE)
 I $L(ORQUIT) Q "-2"_U_ORQUIT
 S RET=$O(^XTMP("ORRDI",DOMAIN,DFN,""),-1)
 Q $G(RET)
ALPARSE(DFN,DATA) ;parse an individual ART record that comes from CDS
 I '$D(DATA(0)) S DATA(0)=DATA
 N Y,I,SEQ,TMPREACT,I,DCCOUNT,DICOUNT
 S SEQ=$O(^XTMP("ORRDI","ART",DFN,""),-1)+1
 D PIECEOUT^ORRDI2(.Y,.DATA,ORFS)
 Q:Y(4)="EE"
 ;Q:$$UP^XLFSTR($P(Y(5),ORCS,2))'["DRUG"
 ;save the originating facility
 S ^XTMP("ORRDI","ART",DFN,SEQ,"FACILITY",0)=Y(3)
 ;save reactant to the XTMP if it is coded
 S TMPREACT=$TR(Y(6),ORCS,ORFS)
 N CODING S CODING=$P(TMPREACT,ORFS,6)
 S:$E(CODING,1,4)="99VA" ^XTMP("ORRDI","ART",DFN,SEQ,"REACTANT",0)=$P(TMPREACT,ORFS,4,6)
 ;save drug classes to the XTMP (only coded values)
 S I=0,DCCOUNT=0 F I=1:1:$L(Y(9),ORRS) D
 . N TMP
 . S TMP=$TR($P(Y(9),ORRS,I),ORCS,ORFS)
 . ;check if drug class is coded
 . N CODING S CODING=$P(TMP,ORFS,3) Q:$E(CODING,1,9)'="99VHA_ERT"
 . S DCCOUNT=DCCOUNT+1
 . S $P(TMP,ORFS,6)="99VA"_$P($P(TMP,ORFS,6),"_",2)
 . S ^XTMP("ORRDI","ART",DFN,SEQ,"DRUG CLASSES",DCCOUNT)=$P(TMP,ORFS,4)_U_$P(TMP,ORFS,4)_U_$P(TMP,ORFS,6)_U_$P(TMP,ORFS,5)
 ;save drug ingredients to the XTMP (only coded values)
 S I=0,DICOUNT=0 F I=1:1:$L(Y(10),ORRS) D
 . N TMP
 . S TMP=$TR($P(Y(10),ORRS,I),ORCS,ORFS)
 . ;check if drug ingredient is coded
 . N CODING S CODING=$P(TMP,ORFS,6) Q:$E(CODING,1,4)'="99VA"
 . S DICOUNT=DICOUNT+1
 . S ^XTMP("ORRDI","ART",DFN,SEQ,"DRUG INGREDIENTS",DICOUNT)=$P(TMP,ORFS,4,6)
 S I="" F  S I=$O(^XTMP("ORRDI","ART",DFN,SEQ,"REACTANT",I)) Q:I=""  S ^XTMP("ORRDI","ART",DFN,SEQ,"REACTANT",I)=$$REMESC(^XTMP("ORRDI","ART",DFN,SEQ,"REACTANT",I))
 S I="" F  S I=$O(^XTMP("ORRDI","ART",DFN,SEQ,"DRUG INGREDIENTS",I)) Q:I=""  S ^XTMP("ORRDI","ART",DFN,SEQ,"DRUG INGREDIENTS",I)=$$REMESC(^XTMP("ORRDI","ART",DFN,SEQ,"DRUG INGREDIENTS",I))
 S I="" F  S I=$O(^XTMP("ORRDI","ART",DFN,SEQ,"DRUG CLASSES",I)) Q:I=""  S ^XTMP("ORRDI","ART",DFN,SEQ,"DRUG CLASSES",I)=$$REMESC(^XTMP("ORRDI","ART",DFN,SEQ,"DRUG CLASSES",I))
 Q
PSPARSE(DFN,DATA) ;parse an individual PSOO record from CDS
 I '$D(DATA(0)) S DATA(0)=DATA
 N Y,I,COUNT,MAP,PIECE,SEQ
 D PIECEOUT^ORRDI2(.Y,.DATA,ORFS)
 S SEQ=$O(^XTMP("ORRDI","PSOO",DFN,""),-1)+1
 S I="",COUNT=0,MAP="1,2,4,5,6,7,8,9,10,11,12,14"
 F I=18,4,6,7,8,10,11,12,13,14,15,16 S PIECE(I)=Y(I),COUNT=COUNT+1,^XTMP("ORRDI","PSOO",DFN,SEQ,$P(MAP,",",COUNT),0)=PIECE(I)
 S ^XTMP("ORRDI","PSOO",DFN,SEQ,1,0)=$P(^XTMP("ORRDI","PSOO",DFN,SEQ,1,0),ORCS,1)
 I '$L(^XTMP("ORRDI","PSOO",DFN,SEQ,1,0))!(Y(17)=200) S ^XTMP("ORRDI","PSOO",DFN,SEQ,1,0)=Y(3)
 S ^XTMP("ORRDI","PSOO",DFN,SEQ,6,0)=^XTMP("ORRDI","PSOO",DFN,SEQ,6,0)_";"_Y(9)
 S ^XTMP("ORRDI","PSOO",DFN,SEQ,5,0)=$P(^XTMP("ORRDI","PSOO",DFN,SEQ,5,0),ORCS,5)
 S ^XTMP("ORRDI","PSOO",DFN,SEQ,3,0)=$P($P(^XTMP("ORRDI","PSOO",DFN,SEQ,2,0),ORCS,4),".")
 S ^XTMP("ORRDI","PSOO",DFN,SEQ,2,0)=$P(^XTMP("ORRDI","PSOO",DFN,SEQ,2,0),ORCS,5)
 S ^XTMP("ORRDI","PSOO",DFN,SEQ,7,0)=$$DTCONV(^XTMP("ORRDI","PSOO",DFN,SEQ,7,0))
 S ^XTMP("ORRDI","PSOO",DFN,SEQ,8,0)=$$DTCONV(^XTMP("ORRDI","PSOO",DFN,SEQ,8,0))
 S ^XTMP("ORRDI","PSOO",DFN,SEQ,9,0)=$$DTCONV(^XTMP("ORRDI","PSOO",DFN,SEQ,9,0))
 S I="" F  S I=$O(^XTMP("ORRDI","PSOO",DFN,SEQ,I)) Q:I=""  S ^XTMP("ORRDI","PSOO",DFN,SEQ,I,0)=$$REMESC($G(^XTMP("ORRDI","PSOO",DFN,SEQ,I,0)))
 Q
DTCONV(DATE) ;convert date in hl7 format to mm/dd/yy
 Q $E(DATE,5,6)_"/"_$E(DATE,7,8)_"/"_$E(DATE,3,4)
 ;Q $E(DATE,1,6)_$E($P(DATE,"/",3),3,4)
REMESC(ORSTR) ;
 ; Remove Escape Characters from HL7 Message Text
 ; Escape Sequence codes:
 ;         F = field separator (ORFS)
 ;         S = component separator (ORCS)
 ;         R = repetition separator (ORRS)
 ;         E = escape character (ORES)
 ;         T = subcomponent separator (ORSS)
 N ORCHR,ORREP,I1,I2,J1,J2,K,VALUE
 F ORCHR="F","S","R","E","T" S ORREP(ORES_ORCHR_ORES)=$S(ORCHR="F":ORFS,ORCHR="S":ORCS,ORCHR="R":ORRS,ORCHR="E":ORES,ORCHR="T":ORSS)
 S ORSTR=$$REPLACE^XLFSTR(ORSTR,.ORREP)
 F  S I1=$P(ORSTR,ORES_"X") Q:$L(I1)=$L(ORSTR)  D
 .S I2=$P(ORSTR,ORES_"X",2,99)
 .S J1=$P(I2,ORES) Q:'$L(J1)
 .S J2=$P(I2,ORES,2,99)
 .S VALUE=$$BASE^XLFUTL($$UP^XLFSTR(J1),16,10)
 .S K=$S(VALUE>255:"?",VALUE<32!(VALUE>127&(VALUE<160)):"",1:$C(VALUE))
 .S ORSTR=I1_K_J2
 Q ORSTR
