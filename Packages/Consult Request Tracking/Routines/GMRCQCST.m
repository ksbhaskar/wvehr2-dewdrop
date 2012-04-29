GMRCQCST ;SLC/DCM - Gather all consults for QC that do not have status of discontinued,complete, or expired ;5/21/98  10:53
 ;;3.0;CONSULT/REQUEST TRACKING;**1,22**;DEC 27, 1997
STS(SRV) ;;Set partial statistics into the ^TMP global for printing
 ;;SRV=Service being worked on
 ;;STS=OERR status of order (3=hold, 4=flagged, 5=pending, etc.)
 S GMRCTOTS=0
 I GMRCSVCP'="ALL SERVICES" S ^TMP("GMRCR",$J,"CP",GMRCCT,0)="",GMRCCT=GMRCCT+1
 F K=3,4,5,6,7,8,9,11,99 I $G(GMRCTOT(SRV,K))>0 D
 .S ^TMP("GMRCR",$J,"CP",GMRCCT,0)="Consults "_$S(K=3:"On Hold:    ",K=4:"Flagged:    ",K=5:"Pending:    ",K=6:"Active:     ",K=7:"Expired:    ",K=8:"Scheduled:  ",K=9:"Incomplete: ",K=11:"Unreleased: ",1:"No Status:  ")
 .S ^TMP("GMRCR",$J,"CP",GMRCCT,0)=^TMP("GMRCR",$J,"CP",GMRCCT,0)_$J(GMRCTOT(SRV,K),4,0),GMRCCT=GMRCCT+1,GMRCTOTS=GMRCTOTS+GMRCTOT(SRV,K)
 .Q
 S ^TMP("GMRCR",$J,"CP",GMRCCT,0)="Totals for Service:  "_$J(GMRCTOTS,4,0),GMRCCT=GMRCCT+1,^TMP("GMRCR",$J,"CP",GMRCCT,0)="",GMRCCT=GMRCCT+1
 Q
EN ;Use fileman to get service
 K GMRCQUT
 S DIC="^GMR(123.5,",DIC(0)="AEMQ",DIC("A")="Select Service/Specialty: "
 S DIC("S")="I $P(^(0),U,2)'=9",D="B^D"
 D MIX^DIC1 K DIC I Y<1!($D(DUOUT)) S GMRCQUT=1 K DIROUT,DUOUT,DTOUT Q
 S (GMRCSVCP,GMRCSVC)=$P(Y,"^",2),GMRCSVCN=+Y
EN1 ;Collect all consults for service chosen, excluding status discontinued
 K ^TMP("GMRCR",$J,"CP")
 S TAB="",$P(TAB," ",30)="",GMRCCT=1,GMRCSND=GMRCSVC,GMRCTOT=0,GMRCTOT(3)=0,GMRCTOT(4)=0,GMRCTOT(5)=0,GMRCTOT(6)=0,GMRCTOT(7)=0,GMRCTOT(8)=0,GMRCTOT(9)=0,GMRCTOT(11)=0,GMRCTOT(99)=0
 S GMRCSVTT=0
 I "ALL SERVICES"[GMRCSVC F  S GMRCSVC=$O(^GMR(123.5,"B",GMRCSVC)) Q:GMRCSVC=""  S GMRCSVCN=0,GMRCSVCN=$O(^GMR(123.5,"B",GMRCSVC,GMRCSVCN)) I $P(^GMR(123.5,GMRCSVCN,0),"^",2)'=9 D  D STS(GMRCSVCN)
 .S ^TMP("GMRCR",$J,"CP",GMRCCT,0)="SERVICE: "_$P(^GMR(123.5,GMRCSVCN,0),"^",1),GMRCCT=GMRCCT+1 D PROC(GMRCSVCN) S ^TMP("GMRCR",$J,"CP",GMRCCT,0)="",GMRCCT=GMRCCT+1
 .Q
 I "ALL SERVICES"'[GMRCSVC S ^TMP("GMRCR",$J,"CP",GMRCCT,0)="SERVICE: "_GMRCSVC,GMRCCT=GMRCCT+1 D PROC(GMRCSVCN),STS(GMRCSVCN) D KILL S GMRCCT=GMRCCT-1 Q
 S ^TMP("GMRCR",$J,"CP",GMRCCT,0)="",GMRCCT=GMRCCT+1
 S ^TMP("GMRCR",$J,"CP",GMRCCT,0)="SUMMARY STATISTICS (ALL SERVICES)",GMRCCT=GMRCCT+1 D
 .F I=3,4,5,6,7,8,9,11,99 I GMRCTOT(I)>0 S ^TMP("GMRCR",$J,"CP",GMRCCT,0)="Total Consults/Requests " D
 ..S ^TMP("GMRCR",$J,"CP",GMRCCT,0)=^TMP("GMRCR",$J,"CP",GMRCCT,0)_$S(I=3:"On Hold:     ",I=4:"Flagged:    ",I=5:"Pending:    ",I=6:"Active:     ",I=7:"Expired:    ",I=8:"Scheduled:  ",I=9:"Incomplete: ",I=11:"Unreleased: ",1:"No Status:  ")
 ..S ^TMP("GMRCR",$J,"CP",GMRCCT,0)=^TMP("GMRCR",$J,"CP",GMRCCT,0)_$J(GMRCTOT(I),4,0),GMRCCT=GMRCCT+1
 ..Q
 .Q
 S ^TMP("GMRCR",$J,"CP",GMRCCT,0)="Total Pending Resolution For All Services: "_GMRCTOT,GMRCCT=GMRCCT+1,^TMP("GMRCR",$J,"CP",GMRCCT,0)=""
 S GMRCCT=GMRCCT-1
 D KILL
 Q
PROC(GMRCSRV) ;Set status' info into the ^TMP global
 F I=3,4,5,6,7,8,9,11,99 S GMRCXDT=0,GMRCTOT(GMRCSRV,I)=0 F  S GMRCXDT=$O(^GMR(123,"AE",GMRCSRV,I,GMRCXDT)) Q:GMRCXDT=""  D
 .S GMRCPT=0 F  S GMRCPT=$O(^GMR(123,"AE",GMRCSRV,I,GMRCXDT,GMRCPT)) Q:GMRCPT=""  D  S GMRCTOT=GMRCTOT+1,GMRCTOT(I)=GMRCTOT(I)+1,GMRCTOT(GMRCSRV,I)=GMRCTOT(GMRCSRV,I)+1
 ..S X=9999999-GMRCXDT D REGDTM^GMRCU S GMRCDT=$P(X," ",1)
 ..S GMRCDLA=$P(X," ",1),GMRCD(0)=^GMR(123,GMRCPT,0) S GMRCPTN=$P(^DPT($P(GMRCD(0),"^",2),0),"^",1),GMRCPTN=$P(GMRCPTN,",",1)_","_$E($P(GMRCPTN,",",2),1)_".",GMRCPTSN="("_$E($P(^(0),"^",9),6,9)_")"
 ..S GMRCD=0,GMRCD=$O(^GMR(123,GMRCPT,40,"B",GMRCD)) I GMRCD]"" S GMRCDA="",GMRCDA=$O(^GMR(123,+GMRCPT,40,"B",GMRCD,GMRCDA)) I GMRCDA]"" S GMRCDA(0)=^GMR(123,GMRCPT,40,GMRCDA,0) D
 ...S GMRCDLA=$E($P($G(^GMR(123.1,$P(GMRCDA(0),"^",2),0)),"^"),1,20)
 ...Q
 ..S GMRCLOC=$P(GMRCD(0),"^",4) S:+GMRCLOC GMRCLOC=$P(^SC(GMRCLOC,0),"^",1)
 ..S STS=$S(I=1:"Discontinued",I=3:"Hold",I=4:"Flagged",I=5:"Pending",I=6:"Active",I=7:"Expired",I=11:"Unreleased",1:"No Status")
 ..S ^TMP("GMRCR",$J,"CP",GMRCCT,0)=STS_$E(TAB,1,10-$L(STS)+1)_GMRCDLA_$E(TAB,1,18-$L(GMRCDLA))_GMRCDT_" "_GMRCPTN_" "_GMRCPTSN_$E(TAB,1,10-$L(GMRCPTN)+5)_GMRCLOC,GMRCCT=GMRCCT+1
 ..Q
 .Q
 Q
KILL ;Kill all variables
 K I,K,Y,STS,TAB,GMRCT,GMRCD,GMRCDA,GMRCDT,GMRCPT,GMRCND,GMRCDLA,GMRCTM,GMRCBM,GMRCPTN,GMRCTOT,GMRCTOTS,GMRCPTSN,GMRCSND,GMRCSVC,GMRCSRV,GMRCSVCN,GMRCLOC,GMRCSVCN,GMRCXDT Q
 Q
