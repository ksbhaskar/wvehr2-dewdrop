RTP32 ;MJK/TROY ISC;Detailed Non-fillable List ; 5/15/87  4:41 PM ;
 ;;v 2.0;Record Tracking;;10/22/91 
 S RTDTEND=RTDT,X="T-100",%DT="" D ^%DT K %DT S RTDTX=Y
 I '$D(RTPULL) F RTDTE=RTBEG:0 S RTDTE=$O(^RTV(194.2,"C",RTDTE)) Q:RTDTEND<$P(RTDTE,".")!('RTDTE)  F RTP=0:0 S RTP=$O(^RTV(194.2,"C",RTDTE,RTP)) Q:'RTP  I $D(^RTV(194.2,RTP,0)),$P(^(0),"^",10)=1 D RTQ
 I $D(RTPULL) S RTP=RTPULL D RTQ
 K RTP,RTDTE,RTDTEND,RTDTX Q
 ;
RTQ Q:'$D(^RTV(194.2,RTP,0))  S X=^(0) Q:$P(X,"^",6)="x"!($P(X,"^",15)'=+RTAPL)  S RTB=+$P(X,"^",5)
 F RTQ=0:0 S RTQ=$O(^RTV(190.1,"AP",RTP,RTQ)) Q:'RTQ  I $D(^RTV(190.1,RTQ,0)) S RTQ0=^(0) I $P(RTQ0,"^",6)="n",$P(RTQ0,"^",5)=RTB,$D(^RT(+RTQ0,0)),$P(^(0),"^")["DPT(" S RTE=$P(^(0),"^"),DFN=+^(0),RTDT=RTDTX D START^RTNQ3 S RTNONE=""
 K RTB,RTQ,RTE,DFN,RTDT Q
 ;
DATE ;get date from parameters
 S RTPCE=20 D WINDOW^RTRPT
 S X1=DT,X2=-1 D C^%DTC
 I X=RTWND S RTWND=""
 Q
 ;
BAR S RTIFN=RT S:$D(X) RTXSAV=X
 Q:'$D(^RT(RT,0))  S X=$P(^(0),U,3),T=5 Q:'$D(RTWND(X))  I $P(^(0),U,8)'<RTWND(X) Q
 D FMT^RTL1 I RTFMT S RTQSAV=RTQ,RTNUM=1 D PRT^RTL1
 S RTQ=RTQSAV S:$D(RTXSAV) X=RTXSAV
 K RTQSAV,RTXSAV,RTNUM Q
 ;
DEV ;select barcode device
 D DATE Q:'RTWND  Q:$D(RTIRE)
 S RTDEV=$P(RTFR,U,4) ;,IOP="HOME" D ^%ZIS K IOP
 S RTTASK=1 W !,"Select Barcode Printer ",!
 S RTDESC="Clinic List Labels ["_$P($P(RTAPL,U),";",2)_"]"
1 S RTVAR="RTDV^RTSORT^RTAPL^RTDT^RTLIST"_$S($D(RTPULL):"^RTPULL^RTPULL0",1:"")_"^RTTASK"_"^RTWND"
 I RTWND F JA=0:0 S JA=$O(RTWND(JA)) Q:'JA  S RTVAR=RTVAR_"^RTWND("_JA_")"
 K JA S RTPGM="START^RTP3" D ZIS^RTUTL
 Q
