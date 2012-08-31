MPIFBT3 ;SLC/ARS-BATCH RESPONSE FROM MPI ;FEB 4, 1997
        ;;1.0; MASTER PATIENT INDEX VISTA ;**1,3,10,17,21,24,28,31,33,35,43,52**;30 Apr 99;Build 7
        ;
        ; Integration Agreements Utilized:
        ;  ^DPT("AICN", ^DPT("AICNL", ^DPT("AMPIMIS" - #2070
        ;  EXC^RGHLLOG - #2796
        ;  FILE^VAFCTFU - #2988
        ;  NAME^VAFCPID2 - #3492
        ;
MULT(CNTR,ACK5,SEP,MPIMSG,PATID)        ;multiple RDT segments
        N NEXTTF,MPITMP S CNTR=$O(^XTMP($J,"MPIF","MPIIN",CNTR)),NEXTTF=$P(ACK5,SEP,8)
        S MPITMP=$O(^XTMP($J,"MPIF","MPIIN",CNTR)) Q:MPITMP'>0
        S ACK5=^XTMP($J,"MPIF","MPIIN",MPITMP) K NEXTTF,MPITMP
        I $P(ACK5,SEP)="RDT" D MULT(.CNTR,ACK5,SEP,MPIMSG,PATID) ; ^ add to treating facility list.  If not RDT continue on processing next msh
        Q
VFYRDT(ACK4,SEP,CNTR,PATID,SITE,MPIMSG) ;Here is the meat
        N MPIY,IEN,MPICMOR,MPICOMP S DGSENFLG=""
        S MPICOMP=$E(HL("ECH"),1)
        D RDT^MPIFSA3(.CNTR,.HL,.ACK4)
        D FINDHM(PATID,SEP,.MPIY,MPIMSG,CNTR)
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        N MPINUM,MPICKG,MPIIT,DR,DIE,X,MPIIPPF,MPIPPF,RESLT
        S MPINUM=$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",6),MPICKG=$P(MPINUM,"V",2),MPINUM=$P(MPINUM,"V",1)
        ;check if ICN already in use in Patient file
        I $D(^DPT("AICN",MPINUM)) D
        .Q:PATID=$O(^DPT("AICN",MPINUM,""))   ; same patient
        .S ^XTMP($J,"MPIF","MSHERR")="ICN already in use"
        .N DFN2 S DFN2=$O(^DPT("AICN",MPINUM,""))
        .D TWODFNS^MPIF002(DFN2,PATID,MPINUM)
        .;**52 need to trigger A28 add as if not found
        .S MPIFRPC=1 D A28^MPIFQ3(PATID) K MPIFRPC
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        S DIE="^DPT(",DA=$P(MPIY,"^",1),MPIIT=$P(MPIY,"^",1),DR="991.01////^S X=MPINUM;991.02////^S X=MPICKG" D ^DIE K DR,DIE,DA
        S IEN=$P(MPIY,"^") ; check if need to kill Local/MISSING ICN field
        I $D(^DPT("AMPIMIS",IEN)) K ^DPT("AMPIMIS",IEN)
        I $D(^DPT("AICNL",1,IEN)) D
        .S DIE="^DPT(",DA=IEN,DR="991.04///@" D ^DIE K DR,DIE,DA
        S MPIIPPF=""
        S MPIPPF=$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",5),MPICMOR=$$LKUP^XUAF4(MPIPPF)
        I MPICMOR'="" S MPIIPPF=$$CHANGE^MPIF001(MPIIT,MPICMOR)
        I +MPIIPPF<0 D EXC^RGHLLOG(211,"Around line number "_(CNTR*2)_"  CMOR= "_MPIPPF_" DFN= "_MPIIT_"  MESSAGE# "_MPIMSG,MPIIT)
        Q:+MPIIPPF<0
        I $D(^TMP("MPIFVQQ",$J,CNTR,"TF")) D
        . N MPINTFI,MPINTF,TFSTRG,TFIEN
        . S MPINTFI=0,MPINTF="",TFIEN="",TFSTRG=""
        . F  S MPINTFI=$O(^TMP("MPIFVQQ",$J,CNTR,"TF",MPINTFI)) Q:'MPINTFI  D
        .. S MPINTF=^TMP("MPIFVQQ",$J,CNTR,"TF",MPINTFI)
        .. S TFIEN=$$IEN^XUAF4($P(MPINTF,MPICOMP,1))
        .. Q:'TFIEN
        .. S TFSTRG=TFIEN_"^"_$$FMDATE^HLFNC($P(MPINTF,MPICOMP,2))_"^"_$P(MPINTF,MPICOMP,3)
        .. D FILE^VAFCTFU(PATID,TFSTRG,1)
        S RESLT=$$A24^MPIFA24B(PATID)
        I +RESLT<0 D EXC^RGHLLOG(208,"Problem building A24 (ADD TF) for DFN= "_PATID,PATID)
        K RESLT N RESLT
        S RESLT=$$A31^MPIFA31B(PATID)
        I +RESLT<0 D EXC^RGHLLOG(208,"Problem building A31 for DFN= "_PATID,PATID)
        K ^TMP("MPIFVQQ",$J)
        Q
FINDHM(PATID,SEP,MPIY,MPIMSG,CNTR)      ;LOOKUP
        N DIC,X,Y,NM,YTMP,MPIN,EXACT
        Q:'$D(^TMP("MPIFVQQ",$J,CNTR,"DATA"))
        ;added I to DIC(0) allow processing of sensitive patients when DUZ=0
        S DGSENFLG="",DIC="^DPT(",DIC(0)="OISZ",X="`"_PATID D ^DIC K DIC
        S YTMP=Y
        I YTMP=-1 S ^XTMP($J,"MPIF","MSHERR")="LOOKUP FAILED" D EXC^RGHLLOG(210,"SSN = "_$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",3)_"  MESSAGE# "_MPIMSG_" around line number "_(CNTR*2),PATID)
        Q:YTMP=-1
        S NM=$P(Y(0),"^"),YTMP=$G(Y(0)),MPIY=Y ; check if ICN already populated
        N ICN S ICN=$$GETICN^MPIF001(PATID)
        I +ICN'=-1,$E(+ICN,1,3)'=$P($$SITE^VASITE,"^",3) S ^XTMP($J,"MPIF","MSHERR")="Patient "_PATID_" Already has an ICN"
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        S Y(0)=$G(YTMP)
        ;**43 ONLY EXACT MATCHES BEING RETURNED NO LONGER MAKE THESE CHECKES IN VISTA
        ;Q:$P(Y(0),"^",9)["P"&($P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",3)="")
        ;I $P(Y(0),"^",9)'=$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",3) D
        ;.S ^XTMP($J,"MPIF","MSHERR")="SSN MISMATCH"
        ;.D EXC^RGHLLOG(213,"SSN on File = "_$P(Y(0),"^",9)_" SSN in Message = "_$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",3)_"    MESSAGE # "_MPIMSG_" around line number "_(CNTR*2),PATID)
        ;.N LICN S LICN=$$ICNLC^MPIF001(PATID) ; create local ICN
        ;Q:$D(^XTMP($J,"MPIF","MSHERR"))
        ;D NAME^VAFCPID2(0,.NM,0) ; reformat name in DG 149 fashion for comparison
        ;S MPIN=$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",2)_","_$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",7)
        ;I $P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",10)'="" S MPIN=MPIN_" "_$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",10)
        ;I $P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",15)'="" S MPIN=MPIN_" "_$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",15)
        ;I $P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",14)'="" S MPIN=MPIN_" "_$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",14)
        ;D NAME^VAFCPID2(0,.MPIN,0)
        ; check if Last and First Match--yes-- then check if middle name vs initial
        ;I $P(NM,",")=$P(MPIN,",")&($P($P(MPIN,",",2)," ")=$P($P(NM,",",2)," ")) D
        ;.N MPIMID,NMMN S MPIMID=$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",10)
        ;.S NMMN=$P($P(NM,",",2)," ",2)
        ;.I $L(NMMN)>1&($L(MPIMID)=1),($E(NMMN,1)=MPIMID) S EXACT=1
        ;.I $L(MPIMID)>1&($L(NMMN)=1),($E(MPIMID,1)=NMMN) S EXACT=1
        ;I NM'=MPIN,'$D(EXACT) D
        ;.S ^XTMP($J,"MPIF","MSHERR")="NAME MISMATCH"
        ;.D EXC^RGHLLOG(214,"Name on File = "_$P(Y(0),"^")_"  Name in Message = "_MPIN_"  MESSAGE# "_MPIMSG_" around line number "_(CNTR*2),PATID)
        ;.N LICN S LICN=$$ICNLC^MPIF001(PATID) ;create local ICN
        ;check to see if SEX on MPI and local site match - no exception
        ;I $P($G(^DPT(PATID,0)),"^",2)'=$P($G(^TMP("MPIFVQQ",$J,CNTR,"DATA")),"^",11) D
        ;.S ^XTMP($J,"MPIF","MSHERR")="SEX MISMATCH"
        ;.D EXC^RGHLLOG(209,"PT on MPI "_MPIN_" has gender as "_$P($G(^TMP("MPIFVQQ",$J,CNTR,"DATA")),"^",10)_" While the Patient DFN= "_PATID_" has "_$P($G(^DPT(PATID,0)),"^",2)_" msg # "_MPIMSG_" about line number "_(CNTR*2),PATID)
        ;.N LICN S LICN=$$ICNLC^MPIF001(PATID) ;create local ICN
        ;
        ;check to see if MPI has Date of Death or if VistA has DOD
        ;N MPIDTH,VISTDTH K %DT
        ;I $P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",9)'="" S X=$P(^TMP("MPIFVQQ",$J,CNTR,"DATA"),"^",9) D ^%DT S MPIDTH=Y
        ;I $D(^DPT(PATID,.35)),$P($G(^DPT(PATID,.35)),"^")'="" S VISTDTH=$P($G(^DPT(PATID,.35)),"^")\1
        ;I $D(MPIDTH)&$D(VISTDTH),MPIDTH'=VISTDTH D
        ;.N Y S Y=MPIDTH D DD^%DT S MPIDTH=Y,Y=VISTDTH D DD^%DT S VISTDTH=Y
        ;.D EXC^RGHLLOG(217,"Around line "_(CNTR*2)_" VISTA DOD= "_VISTDTH_" MPI DOD= "_MPIDTH_"  DFN= "_PATID_"  MESSAGE# "_MPIMSG,PATID)
        ; ^ BOTH HAVE DOD BUT THEY DON'T MATCH
        ;I '$D(MPIDTH)&($D(VISTDTH)) D
        ;.N Y S Y=VISTDTH D DD^%DT S VISTDTH=Y
        ;.D EXC^RGHLLOG(216,"Around line "_(CNTR*2)_" VISTA DOD= "_VISTDTH_"  DFN= "_PATID_"  MESSAGE# "_MPIMSG,PATID)
        ; ^ VISTA HAS DOD BUT MPI DOESN'T
        ;I $D(MPIDTH)&('$D(VISTDTH)) D
        ;.N Y S Y=MPIDTH D DD^%DT S MPIDTH=Y
        ;.D EXC^RGHLLOG(215,"Around line "_(CNTR*2)_" MPI DOD= "_MPIDTH_"  DFN= "_PATID_"  MESSAGE# "_MPIMSG,PATID)
        ; ^ MPI HAS DOD BUT VISTA DOESN'T
        Q
