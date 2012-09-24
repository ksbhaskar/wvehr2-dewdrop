HLOPROC ;ALB/CJM- Generic HL7 Process - 10/4/94 1pm ;08/23/2010
        ;;1.6;HEALTH LEVEL SEVEN;**126,134,146,147**;Oct 13, 1995;Build 15
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
PROCESS ;queued entry point
        ;
        ;insure just one process manager
        I PROCNAME="PROCESS MANAGER" N RUNNING L +^HLTMP(PROCNAME):1 S RUNNING='$T D  Q:RUNNING
        .I 'RUNNING D
        ..D SETNM^%ZOSV($E("HLOmgr:"_$J,1,17))
        .E  D
        ..L +HL7("COUNTING PROCESSES"):20
        ..K:$D(ZTSK) ^HLTMP("HL7 QUEUED PROCESSES",ZTSK)
        ..S ^HLC("HL7 PROCESS COUNTS","RUNNING","PROCESS MANAGER")=1
        ..S ^HLC("HL7 PROCESS COUNTS","QUEUED","PROCESS MANAGER")=0
        ..L -HL7("COUNTING PROCESSES")
        ..S ZTREQ="@"
        ;
        ;invoke the framework process
        D HL7PROC(PROCNAME)
        ;
        I PROCNAME="PROCESS MANAGER" L -^HLTMP(PROCNAME)
        S ZTREQ="@"
        Q
        ;
HL7PROC(PROCNAME)       ;
        ;This is the generic HL7 process used by all processes started under the HL7 Process Manager
        ;Input:
        ;  PROCNAME - the name of a process found in the HL7 Process Registry
        ;  OUTPUT - none
        ;
        N PROCESS,HL7STOP,WORK
        ;
        S ^HL7TMP("HL7 PROCESS NAME",$J)=PROCNAME
        ;
        L +HL7("COUNTING PROCESSES"):20
        I $D(ZTQUEUED) D
        .K:$D(ZTSK) ^HLTMP("HL7 QUEUED PROCESSES",ZTSK)
        .I $$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","QUEUED",PROCNAME)),-1)<0,$$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","QUEUED",PROCNAME)))
        L +^HLTMP("HL7 RUNNING PROCESSES",$J):0
        I $$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","RUNNING",PROCNAME)))
        S ^HLTMP("HL7 RUNNING PROCESSES",$J)=$H_"^"_$G(ZTSK)_"^"_PROCNAME
        L -HL7("COUNTING PROCESSES")
        ;
        ;
        I $$GETPROC(PROCNAME,.PROCESS),'$$CHK4STOP(.PROCESS) D
        .S $P(^HLD(779.3,PROCESS("IEN"),0),"^",6)=$$NOW^XLFDT
        .;
        .;should this task be made persistent?
        .I PROCESS("PERSISTENT"),$G(ZTQUEUED),$$PSET^%ZTLOAD(ZTQUEUED)
        .;
        .S HL7STOP=0
        .F  D  Q:HL7STOP
        ..N $ETRAP,$ESTACK S $ETRAP="G ERROR^HLOPROC"
        ..N HL7TRIES,GOTWORK
        ..F HL7TRIES=1:1 D  Q:GOTWORK  Q:$G(HL7STOP)
        ...S GOTWORK=$$GETWORK(.PROCESS,.WORK)
        ...Q:GOTWORK
        ...;since there is no work, don't want another process starting
        ...S $P(^HLD(779.3,PROCESS("IEN"),0),"^",6)=$$NOW^XLFDT
        ...H PROCESS("HANG")
        ...S HL7STOP=$$CHK4STOP(.PROCESS,HL7TRIES)
        ..Q:$G(HL7STOP)
        ..I GOTWORK D DOWORK(.PROCESS,.WORK) S HL7TRIES=0
        ..S:'$G(HL7STOP) HL7STOP=$$CHK4STOP(.PROCESS,.HL7TRIES)
        ;
        S $P(^HLD(779.3,PROCESS("IEN"),0),"^",6)=$$NOW^XLFDT
        ;
END     ;
        S HL7STOP=1
        K ^HL7TMP("HL7 PROCESS NAME",$J)
        L +HL7("COUNTING PROCESSES"):20
        K ^HLTMP("HL7 RUNNING PROCESSES",$J)
        I $$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","RUNNING",PROCNAME)),-1)<0,$$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","RUNNING",PROCNAME)),1)
        L -^HLTMP("HL7 RUNNING PROCESSES",$J)
        L -HL7("COUNTING PROCESSES")
        K ^TMP("HL7 ERRORS",$J)
        ;
        Q
        ;
ERROR   ;error trap
        ;
        S $ETRAP="Q:$QUIT """" Q"
        ;
        ;quit back to the Taskman error trap on these errors
        I ($ECODE["TOOMANYFILES")!($ECODE["EDITED") D  Q:$QUIT "" Q
        .S:'$D(PROCNAME) PROCNAME=$G(^HL7TMP("HL7 PROCESS NAME",$J))
        .D END
        .G UNWIND^%ZTER
        ;
        ;don't log READ/WRITE errors unless logging is turned on, but do resume
        ;execution
        I '$G(^HLTMP("LOG ALL ERRORS")),($ECODE["READ")!($ECODE["NOTOPEN")!($ECODE["DEVNOTOPN")!($ECODE["WRITE")!($ECODE["OPENERR") D  Q:$QUIT "" Q
        .S $ECODE=""
        ;
        ;add to the process's count for the type of error
        N HOUR
        S HOUR=$E($$NOW^XLFDT,1,10)
        S ^TMP("HL7 ERRORS",$J,HOUR,$P($ECODE,",",2))=$G(^TMP("HL7 ERRORS",$J,HOUR,$P($ECODE,",",2)))+1
        ;
        ;a lot of errors of the same type may indicate an endless loop, so quit
        ;to Taskman error trap to be on the safe side.
        I $G(^TMP("HL7 ERRORS",$J,HOUR,$P($ECODE,",",2)))>30 D  Q:$QUIT "" Q
        .S:'$D(PROCNAME) PROCNAME=$G(^HL7TMP("HL7 PROCESS NAME",$J))
        .D END
        .G UNWIND^%ZTER
        ;
        ;can log error and continue processing
        D ^%ZTER
        S $ECODE=""
        Q:$QUIT "" Q
        ;
GETPROC(PROCNAME,PROCESS)       ;
        ;using PROCNAME to find the entry in the HL7 Process Registry, returns the entry as a subscripted array in .PROCESS
        ;
        ;Output: Function returns 0 on failure, 1 on success
        ;
        N IEN,NODE
        S IEN=$O(^HLD(779.3,"B",PROCNAME,0))
        Q:'IEN 0
        S PROCESS("NAME")=PROCNAME
        S PROCESS("IEN")=IEN
        S NODE=$G(^HLD(779.3,IEN,0))
        S PROCESS("MINIMUM")=+$P(NODE,"^",3)
        S PROCESS("MAXIMUM")=+$P(NODE,"^",4)
        S PROCESS("HANG")=+$P(NODE,"^",7)
        I 'PROCESS("HANG") S PROCESS("HANG")=1
        S PROCESS("GET WORK")=$P(NODE,"^",8,9)
        S PROCESS("DO WORK")=$P(NODE,"^",10,11)
        S PROCESS("MAX TRIES")=$P(NODE,"^",12)
        I 'PROCESS("MAX TRIES") S PROCESS("MAX TRIES")=999
        S PROCESS("PERSISTENT")=+$P(NODE,"^",13)
        S PROCESS("LINK")=$P(NODE,"^",14)
        Q 1
        ;
GETWORK(PROCESS,WORK)   ;
        N RETURN,XECUTE
        I PROCESS("LINK")]"" S WORK("LINK")=PROCESS("LINK")
        S XECUTE="S RETURN=$$"_PROCESS("GET WORK")_"(.WORK)"
        D
        .N PROCESS
        .X XECUTE
        Q RETURN
        ;
DOWORK(PROCESS,WORK)    ;
        N XECUTE
        M PARMS=WORK
        S XECUTE="D "_PROCESS("DO WORK")_"(.WORK)"
        D
        .N PROCESS,HL7TRIES,PARMS,PROCNAME
        .X XECUTE
        M WORK=PARMS
        Q
        ;
CHK4STOP(PROCESS,HL7TRIES)      ;
        ;Determines if the process should stop, returns 1 if yes, 0 if no
        ;
        Q:$$CHKSTOP 1
        Q:'$P($G(^HLD(779.3,PROCESS("IEN"),0)),"^",2) 1
        I $G(HL7TRIES)>(PROCESS("MAX TRIES")-1),PROCESS("MINIMUM")<$G(^HLC("HL7 PROCESS COUNTS","RUNNING",PROCESS("NAME"))) Q 1
        Q:$G(^HLC("HL7 PROCESS COUNTS","RUNNING",PROCESS("NAME")))>PROCESS("MAXIMUM") 1
        Q 0
        ;
CHKSTOP()       ;has HL7 been requested to stop?
        N RET
        ;** P146 START CJM
        ;Q '$P($G(^HLD(779.1,1,0)),"^",9)
        S RET='$P($G(^HLD(779.1,1,0)),"^",9)
ZB25    ;
        Q RET
        ;**P146 END CJM
