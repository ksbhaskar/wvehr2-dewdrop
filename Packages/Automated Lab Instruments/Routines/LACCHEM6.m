LACCHEM6 ;SLC/RWF - CENTRIFICHEM 600 ;7/20/90  07:43 ;
 ;;5.2;AUTOMATED LAB INSTRUMENTS;;Sep 27, 1994
 ;CROSS LINK BY ID OR CUP
LA1 S:$D(ZTQUEUED) ZTREQ="@"
 S LANM=$T(+0),TSK=$O(^LAB(62.4,"C",LANM,0)) Q:TSK<1
 Q:'$D(^LA(TSK,"I",0))
 K LATOP D ^LASET Q:'TSK  S X="TRAP^"_LANM,@^%ZOSF("TRAP"),TRAY=1
LA2 K TV S TOUT=0 D IN G QUIT:TOUT,LA2:$E(IN,1,4)'="TEST" S TEST=$E(IN,6,7)
 F III=0:0 S III=$O(TC(III)) Q:III<1  I TEST=TC(III,4) D LA2A Q
 G LA2
LA2A F II=0:0 S TOUT=0 D IN G QUIT:TOUT I IN["CUV VALUE FL" Q
 S TOUT=0 D IN G QUIT:TOUT
 F II=0:0 S TOUT=0 D IN G QUIT:TOUT Q:'$L(IN)  D QC I 'BAD S (ID,IDE,CUP)=+$E(IN,1,2),V=+$E(IN,4,8) S @TC(III,1)=$J(V,0,+TC(III,3)) D LA3
 Q
LA3 X LAGEN Q:'ISQN
 F I=0:0 S I=$O(TV(I)) Q:I<1  S:TV(I,1)]"" ^LAH(LWL,1,ISQN,I)=TV(I,1)
 K TV Q
QC ;QC TESTING HERE; S BAD=1 IF DONT STORE
 S V=$E(IN,9,12) D NUM S BAD=$S($L(V):1,1:0) Q
NUM S X="" F JJ=1:1:$L(V) S:$A(V,JJ)>32 X=X_$E(V,JJ)
 S V=X Q
IN S CNT=^LA(TSK,"I",0)+1 IF '$D(^(CNT)) S TOUT=TOUT+1 Q:TOUT>9  H 5 G IN
 S ^LA(TSK,"I",0)=CNT,IN=^(CNT),TOUT=0
 S:IN["~" CTRL=$P(IN,"~",2),IN=$P(IN,"~",1)
 Q
QUIT LOCK ^LA(TSK) H 1 K ^LA(TSK),^LA("LOCK",TSK),^TMP($J),^TMP("LA",$J)
 Q
TRAP D ^LABERR S T=TSK D SET^LAB G @("LA2^"_LANM) ;ERROR TRAP
