PSBSVHL7        ;BIRMINGHAM/TEJ - BCMA HL7 SERVER ;5/28/10 1:48pm
        ;;3.0;BAR CODE MED ADMIN;**3,42**;Mar 2004;Build 23
        ; Reference/IA
        ; $$HLDATE^HLFNC/10106
        ; $$HLNAME^HLFNC/10106
        ; INIT^HLFNC2/2161
        ; GENERATE^HLMA/2164
        ; File 50.7/2880
        ; File 52.6/436
        ; File 52.7/437
        ; File 200/10060
        ; DEM^VADPT/10061
        ;
        ; Description:
        ; This routine is to service BCMA HL7 messaging to other COTS and
        ; VISTA application.
        ; The entry point ("EN") is accessed via BCMA.  This routine
        ; basically consists of subroutines to generate HL7 messages
        ; per trigger events corresponding to BCMA transactions.  
        ; These trigger events are captured within the routine PSBML.
        ; PSBML passes the affected BCMA MEDICATION LOG File IEN and 
        ; a variable capturing the BCMA activity as the input.
        ;       Input  -        PSBIEN  Affected BCMA record(s)
        ;                       PSBHL7X  BCMA trigger event/transaction
        ;       Output -        HL7 broadcast to subscribing Applications 
        ;
EN(PSBIEN,PSBHL7X)      ; This is the entry point for all HL7 processing
1       ; set up environment for message
        N PSBHLFS,PSBHLCS
        D INIT^HLFNC2("PSB BCMA RASO17 SRV",.HL)
        I $G(HL) W:+HL'=16 !,"Error: "_$P(HL,2) Q  ; error occurred
        S PSBHLFS=$G(HL("FS")) I PSBHLFS="" S PSBHLFS="^"
        S PSBHLCS=$E(HL("ECH"),1)
        S PSBHLSCS=$E(HL("ECH"),4)
2       ; Add appropriate message txt to HLA array
        K HLA,HLEVN
        N PSBDFN,PSBHL7MS
        S PSBCNT=0
        I (PSBHL7X["MEDPASS")!(PSBHL7X["UPDATE STATUS") D MEDSTAT Q
        I (PSBHL7X["ADD COMMENT") D COMMENT Q
        I (PSBHL7X["PRN EFFECTI") D PRNEFFE Q
        Q
MEDSTAT ;MEDPASS and UPDATE trigger events 
        D PID,PV1,ORC,RXO
        D:$D(^PSB(53.79,PSBIEN,.3,0)) NTE
        D RXR,RXC,RXA,TRANS  Q
COMMENT ;ADD COMNMENT trigger event
        D PID,ORC,NTE,TRANS  Q
PRNEFFE ;PRN EFFECTIVENESS trigger event
        D PID,ORC,NTE,TRANS  Q
PID     ; PID segment -- use segment generator
        S PSBDFN=$P(^PSB(53.79,PSBIEN,0),U,1),DFN=PSBDFN D DEM^VADPT
        S PSBCNT=PSBCNT+1,$P(PSBHL7MS,PSBHLFS,3)=PSBDFN
        S $P(VADM(4),PSBHLCS)=VADM(4),$P(VADM(4),PSBHLCS,5)="AGE",$P(PSBHL7MS,PSBHLFS,4)=VADM(4)
        S $P(PSBHL7MS,PSBHLFS,5)=$$HLNAME^HLFNC(VADM(1),HL("ECH"))
        S $P(PSBHL7MS,PSBHLFS,7)=$$HLDATE^HLFNC(+VADM(3),"DT")
        S $P(PSBHL7MS,PSBHLFS,19)=$TR(VA("PID"),"-")  ;IHS/VA - use VA("PID")
        S $P(PSBHL7MS,PSBHLFS,8)=$P(VADM(5),"^")
        S HLA("HLS",PSBCNT)="PID"_PSBHLFS_PSBHL7MS
        Q
PV1     ; PV1 segment
        K PSBHL7MS,PSBHL7FD
        S PSBCNT=PSBCNT+1,HLA("HLS",PSBCNT)="PV1"_PSBHLFS
        S $P(PSBHL7MS,PSBHLFS,2)="U"
        ; Construct location field
        S $P(PSBHL7FD,PSBHLCS,1)=$$ESC($P(^PSB(53.79,PSBIEN,0),U,2))
        S $P(PSBHL7FD,PSBHLCS,4)=$$ESC($P(^PSB(53.79,PSBIEN,0),U,3))
        S $P(PSBHL7MS,PSBHLFS,3)=PSBHL7FD K PSBHL7FD
        ; Construct attending physician data
        S $P(PSBHL7FD,PSBHLCS,1)=$P(^PSB(53.79,PSBIEN,0),U,5)
        S $P(PSBHL7FD,PSBHLCS,2)=$$HLNAME^HLFNC($$GET1^DIQ(200,$P(PSBHL7FD,PSBHLCS,1)_",",.01),HL("ECH"))
        S $P(PSBHL7MS,PSBHLFS,7)=PSBHL7FD K PSBHL7FD
        S HLA("HLS",PSBCNT)=(HLA("HLS",PSBCNT))_PSBHL7MS
        Q
ORC     ; ORC segment
        K PSBHL7MS,PSBHL7FD
        S PSBCNT=PSBCNT+1,HLA("HLS",PSBCNT)="ORC"_PSBHLFS
        S $P(PSBHL7MS,PSBHLFS,1)="XX"
        S $P(PSBHL7MS,PSBHLFS,2)=PSBIEN_PSBHLCS_"PSB"_PSBHLCS_PSBIEN_PSBHLCS_"IEN"
        S $P(PSBHL7MS,PSBHLFS,3)=$P(^PSB(53.79,PSBIEN,.1),U)
        D PSJ1^PSBVT(PSBDFN,$P(PSBHL7MS,PSBHLFS,3))
        ; Construct quantity/time
        S $P(PSBHL7FD,PSBHLCS,1)=$P(^PSB(53.79,PSBIEN,.1),U,5)
        S $P(PSBHL7FD,PSBHLCS,2)=$$ESC(PSBSCH)
        S $P(PSBHL7FD,PSBHLCS,4)=$$HLDATE^HLFNC($P(^PSB(53.79,PSBIEN,.1),U,3),"TS")
        S $P(PSBHL7FD,PSBHLCS,10)=$$ESC(PSBSCHT)
        S $P(PSBHL7MS,PSBHLFS,7)=PSBHL7FD K PSBHL7FD
        ; Construct previous (parent) order data
        S:$D(PSBPONX) $P(PSBHL7FD,PSBHLCS,2)=PSBPONX
        S $P(PSBHL7MS,PSBHLFS,8)=$G(PSBHL7FD) K PSBHL7FD
        S $P(PSBHL7MS,PSBHLFS,9)=$$HLDATE^HLFNC($P(^PSB(53.79,PSBIEN,0),U,6),"TS")
        ; Construct entered by data
        S $P(PSBHL7FD,PSBHLCS,1)=$P(^PSB(53.79,PSBIEN,0),U,5)
        S $P(PSBHL7FD,PSBHLCS,2)=$$HLNAME^HLFNC($$GET1^DIQ(200,$P(PSBHL7FD,PSBHLCS,1)_",",.01),HL("ECH"))
        S $P(PSBHL7MS,PSBHLFS,10)=PSBHL7FD K PSBHL7FD
        S $P(PSBHL7MS,PSBHLFS,15)=$$HLDATE^HLFNC($P(^PSB(53.79,PSBIEN,0),U,4),"TS")
        ; Construct action by data
        S $P(PSBHL7FD,PSBHLCS,1)=$P(^PSB(53.79,PSBIEN,0),U,7)
        S $P(PSBHL7FD,PSBHLCS,2)=$$HLNAME^HLFNC($$GET1^DIQ(200,$P(PSBHL7FD,PSBHLCS,1)_",",.01),HL("ECH"))
        S $P(PSBHL7MS,PSBHLFS,19)=PSBHL7FD K PSBHL7FD
        S HLA("HLS",PSBCNT)=(HLA("HLS",PSBCNT))_PSBHL7MS
        Q
RXO     ; RXO segment
        K PSBHL7MS,PSBHL7FD
        S PSBCNT=PSBCNT+1,HLA("HLS",PSBCNT)="RXO"_PSBHLFS
        ; Construct rq give code data
        S $P(PSBHL7FD,PSBHLCS,1)=$P(^PSB(53.79,PSBIEN,0),U,8)
        S $P(PSBHL7FD,PSBHLCS,2)=$$GET1^DIQ(50.7,$P(PSBHL7FD,PSBHLCS,1)_",",.01)
        S $P(PSBHL7MS,PSBHLFS,1)=PSBHL7FD K PSBHL7FD
        S $P(PSBHL7MS,PSBHLFS,2)=$$ESC($P(^PSB(53.79,PSBIEN,.1),U,5))
        S $P(PSBHL7MS,PSBHLFS,10)=$$ESC($P(^PSB(53.79,PSBIEN,0),U,10))
        S $P(PSBHL7FD,PSBHLCS,2)=$$ESC($P(^PSB(53.79,PSBIEN,0),U,11))
        S $P(PSBHL7MS,PSBHLFS,21)=PSBHL7FD
        S HLA("HLS",PSBCNT)=(HLA("HLS",PSBCNT))_PSBHL7MS
        Q
NTE     ; NTE segment(s) - notes and comments
        K PSBHL7MS,PSBHL7FD
        S PSBCNT=PSBCNT+1,HLA("HLS",PSBCNT)="NTE"_PSBHLFS
        S $P(PSBHL7MS,PSBHLFS,2)="O"
        ; Construct comment and comment type
        D:($G(PSBSCHT)="P")&($D(^PSB(53.79,PSBIEN,.2)))&(PSBHL7X["PRN EFF")
        .S $P(PSBHL7MS,PSBHLFS,3)=$$ESC($P(^PSB(53.79,PSBIEN,.2),U,2))
        .S $P(PSBHL7FD,PSBHLCS,1)=$P(^PSB(53.79,PSBIEN,.2),U,3)
        .S $P(PSBHL7FD,PSBHLCS,2)=$$HLNAME^HLFNC($$GET1^DIQ(200,$P(PSBHL7FD,PSBHLCS,1)_",",.01),HL("ECH"))
        .S $P(PSBHL7FD,PSBHLCS,4)=$$HLDATE^HLFNC($P(^PSB(53.79,PSBIEN,.2),U,4),"TS")
        .S $P(PSBHL7FD,PSBHLCS,5)="Date Entered"
        .S $P(PSBHL7FD,PSBHLCS,7)=$P(^PSB(53.79,PSBIEN,.2),U,5)
        .S $P(PSBHL7FD,PSBHLCS,8)="PRN Minutes"
        .S $P(PSBHL7MS,PSBHLFS,4)=PSBHL7FD K PSBHL7FD
        D:$D(^PSB(53.79,PSBIEN,.3,0))&(PSBHL7X'["PRN EFF")
        .S PSBINDX="",PSBINDX=$O(^PSB(53.79,PSBIEN,.3,PSBINDX),-1)
        .S $P(PSBHL7MS,PSBHLFS,3)=PSBINDX_PSBHLCS_$$ESC($P(^PSB(53.79,PSBIEN,.3,PSBINDX,0),U))
        .S $P(PSBHL7FD,PSBHLCS,1)=$P(^PSB(53.79,PSBIEN,.3,PSBINDX,0),U,2)
        .S $P(PSBHL7FD,PSBHLCS,2)=$$HLNAME^HLFNC($$GET1^DIQ(200,$P(PSBHL7FD,PSBHLCS,1)_",",.01),HL("ECH"))
        .S $P(PSBHL7FD,PSBHLCS,4)=$$HLDATE^HLFNC($P(^PSB(53.79,PSBIEN,.3,PSBINDX,0),U,3),"TS")
        .S $P(PSBHL7FD,PSBHLCS,5)="Date Entered"
        .S $P(PSBHL7MS,PSBHLFS,4)=PSBHL7FD K PSBHL7FD
        S HLA("HLS",PSBCNT)=(HLA("HLS",PSBCNT))_PSBHL7MS
        Q
RXR     ; RXR segment
        K PSBHL7MS,PSBHL7FD
        S PSBCNT=PSBCNT+1,HLA("HLS",PSBCNT)="RXR"_PSBHLFS
        S:$D(PSBMRAB) $P(PSBHL7MS,PSBHLFS,1)=PSBMRAB
        S $P(PSBHL7MS,PSBHLFS,2)=$P($G(^PSB(53.79,PSBIEN,.1)),U,6)
        S HLA("HLS",PSBCNT)=(HLA("HLS",PSBCNT))_PSBHL7MS
        S:""=$TR(PSBHL7MS,PSBHLFS,"") PSBCNT=PSBCNT-1
        Q
RXC     ; RXC segment
        ; loop through .5,.6,and .7  send segments for each "component"
        K PSBSUBFD F PSBSUBFD=".5",".6",".7" D:$D(^PSB(53.79,PSBIEN,PSBSUBFD,1))
        .K PSBFILE S PSBFILE=$S(PSBSUBFD=".5":"^PSDRUG(",PSBSUBFD=".6":"^PS(52.6,",PSBSUBFD=".7":"^PS(52.7,")
        .K PSBRXTYP S PSBRXTYP=$S(PSBSUBFD=".5":"B",PSBSUBFD=".6":"A",PSBSUBFD=".7":"B")
        .S PSBSUBX=0 F  S PSBSUBX=$O(^PSB(53.79,PSBIEN,PSBSUBFD,PSBSUBX)) Q:+PSBSUBX=0  D
        ..K PSBHL7MS,PSBHL7FD S PSBCNT=PSBCNT+1,HLA("HLS",PSBCNT)="RXC"_PSBHLFS
        ..S $P(PSBHL7MS,PSBHLFS,1)=PSBRXTYP
        ..; Construct component code data
        ..S $P(PSBHL7FD,PSBHLCS,1)=$P(^PSB(53.79,PSBIEN,PSBSUBFD,PSBSUBX,0),U)
        ..S PSBFILE1=PSBFILE_$P(^PSB(53.79,PSBIEN,PSBSUBFD,PSBSUBX,0),U)_",0)"
        ..I $P(^PSB(53.79,PSBIEN,PSBSUBFD,PSBSUBX,0),U)]"" S $P(PSBHL7FD,PSBHLCS,2)=$P($G(@PSBFILE1),U) K PSBFILE1
        ..I $G(PSBHL7FD)]"" S $P(PSBHL7MS,PSBHLFS,2)=PSBHL7FD,PSBRXAX=PSBHL7FD,PSBRXA(PSBRXAX)="RXA ADMIN CODE" K PSBHL7FD
        ..S $P(PSBHL7MS,PSBHLFS,3)=$P(^PSB(53.79,PSBIEN,PSBSUBFD,PSBSUBX,0),U,2)
        ..S $P(PSBHL7MS,PSBHLFS,4)=$P(^PSB(53.79,PSBIEN,PSBSUBFD,PSBSUBX,0),U,4)
        ..I $G(PSBRXAX)]"" S PSBRXA(PSBRXAX)=$P(^PSB(53.79,PSBIEN,PSBSUBFD,PSBSUBX,0),U,3)_U_$P(PSBHL7MS,PSBHLFS,4)
        ..S HLA("HLS",PSBCNT)=(HLA("HLS",PSBCNT))_PSBHL7MS
        Q
RXA     ; RXA segment
        K PSBHL7MS,PSBHL7FD S PSBRXAX=""
        F PSBRX=1:1 S PSBRXAX=$O(PSBRXA(PSBRXAX)) Q:PSBRXAX=""  D
        .S PSBCNT=PSBCNT+1,HLA("HLS",PSBCNT)="RXA"_PSBHLFS
        .S $P(PSBHL7MS,PSBHLFS,1)=0
        .S $P(PSBHL7MS,PSBHLFS,2)=PSBRX
        .S $P(PSBHL7MS,PSBHLFS,3)=$$HLDATE^HLFNC($P(^PSB(53.79,PSBIEN,0),U,6),"TS")
        .S $P(PSBHL7MS,PSBHLFS,4)=" "
        .; Construct administered code data
        .S $P(PSBHL7MS,PSBHLFS,5)=PSBRXAX
        .S $P(PSBHL7MS,PSBHLFS,6)=$P(PSBRXA(PSBRXAX),U)
        .S $P(PSBHL7MS,PSBHLFS,7)=$P(PSBRXA(PSBRXAX),U,2)
        .D:$D(^PSB(53.79,PSBIEN,.9,1))
        ..S PSBINDX=$O(^PSB(53.79,PSBIEN,.9,"B"),-1)
        ..S:$D(PSBINDX) $P(PSBHL7MS,PSBHLFS,9)=PSBINDX_PSBHLCS_$$HLDATE^HLFNC($P(^PSB(53.79,PSBIEN,.9,PSBINDX,0),U),"TS")
        .; "PRN reason"
        .S:($G(PSBSCHT)="P")&($D(^PSB(53.79,PSBIEN,.2))) $P(PSBHL7FD,PSBHLCS,2)=$P(^PSB(53.79,PSBIEN,.2),U,1)
        .S $P(PSBHL7MS,PSBHLFS,18)=$G(PSBHL7FD) K PSBHL7FD
        .; Construct indication - "variance"
        .S $P(PSBHL7FD,PSBHLCS,2)=$P(^PSB(53.79,PSBIEN,.1),U,4)
        .S $P(PSBHL7MS,PSBHLFS,19)=PSBHL7FD K PSBHL7FD
        .S $P(PSBHL7MS,PSBHLFS,20)=$P(^PSB(53.79,PSBIEN,0),U,9)
        .S HLA("HLS",PSBCNT)=(HLA("HLS",PSBCNT))_PSBHL7MS
        K PSBRX,PSBRXA,PSBRXAX
        Q
ESC(PSBINF)     ; Escape message data
        S PSBINFO=PSBINF K PSBESC,PSBINFO1 F PSBESCX=1:1:4 D
        .S PSBCHR=$E(HL("ECH"),PSBESCX)
        .I ($L(PSBINFO,PSBCHR)-1)>0 S PSBINFO1=PSBINFO F PSBESCXX=1:1:$L(PSBINFO,PSBCHR)-1 D
        ..S PSBESC($F(PSBINFO1,PSBCHR)-1)=$E(HL("ECH"),3)_$E("SRET",PSBESCX)_$E(HL("ECH"),3)
        ..S PSBINFO1=$E(PSBINFO1,1,$F(PSBINFO1,PSBCHR)-2)_U_$E(PSBINFO1,$F(PSBINFO1,PSBCHR),250)
        S:$D(PSBINFO1) PSBINFO=PSBINFO1
        S (PSBCNT1,PSBESCX,PSBESCXX)=0 F  S PSBESCX=$O(PSBESC(PSBESCX)) Q:PSBESCX=""  D
        .S PSBESCXX=PSBESCX+PSBCNT1,PSBINFO=$E(PSBINFO,1,PSBESCXX-1)_$G(PSBESC(PSBESCX))_$E(PSBINFO,PSBESCXX+1,250),PSBCNT1=PSBCNT1+2
        Q PSBINFO
        ;
TRANS   ; CALL HL7 TO Transmit Message
        K PSBHL7MS,PSBHL7FD
        D:$D(HLA("HLS")) GENERATE^HLMA("PSB BCMA RASO17 SRV","LM",1,.PSBHL7T,"",.PSBHL7OP)
        I +$P(PSBHL7T,U,2) W !,"PSB(BCMA) HL7 MESSAGE HAS FAILED TRANSMISSION - could not generate"
        Q
        ;
