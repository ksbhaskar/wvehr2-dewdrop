LABITKU ;SLC/DLG - BECKMAN INTERLINK UPLOAD UNIDIRECTIONAL ; 5/9/89  2:36 PM ;
 ;;5.2;AUTOMATED LAB INSTRUMENTS;;Sep 27, 1994
 ;CROSS LINK BY ID OR IDE
LA1 S:$D(ZTQUEUED) ZTREQ="@"
 S LANM=$T(+0),TSK=$O(^LAB(62.4,"C",LANM,0)) Q:TSK<1
 Q:'$D(^LA(TSK,"I",0))
 K LATOP D ^LASET Q:'TSK  S X="TRAP^"_LANM,@^%ZOSF("TRAP")
LA2 K TV,Y S RMK="",TOUT=0,A=1 D IN G QUIT:TOUT,LA2:+$E(IN,2,3)'=1 D QC
 S TOUT=0,BAD=0 F A=2:1 D IN,QC G QUIT:TOUT Q:IN?.E1"[99]".E
 S V=$P(Y(1),",",3) D NUM S IDE=+V,V=$P(Y(1),",",6) D NUM S TRAY=+V,V=$P(Y(1),",",7) D NUM S (ID,CUP)=+V
 F J=2:1:A S CARD=+$E(Y(J),2,3) Q:CARD=99  S V=$P(Y(J),",",2) D NUM S TEST=V F I=0:0 S I=$O(TC(I)) Q:+I<1  I TC(I,4)=TEST S V=$P(Y(J),",",$S(CARD=3:3,1:4)) D NUM S:V]"" @TC(I,1)=+V
LA3 X LAGEN G LA2:'ISQN ;Can be changed by the cross-link code
 F I=0:0 S I=$O(TV(I)) Q:I<1  S:TV(I,1)]"" ^LAH(LWL,1,ISQN,I)=TV(I,1)
 I $D(RMK),$L(RMK) D RMK^LASET
 G LA2
QC ;QC TESTING HERE; S BAD=1 IF DONT STORE
 S Y(A)=IN Q
NUM S X="" F JJ=1:1:$L(V) S:$A(V,JJ)>32 X=X_$E(V,JJ)
 S V=X Q
IN S CNT=^LA(TSK,"I",0)+1 IF '$D(^(CNT)) S TOUT=TOUT+1 Q:TOUT>9  H 5 G IN
 S ^LA(TSK,"I",0)=CNT,IN=^(CNT),TOUT=0
 S:IN["~" CTRL=$P(IN,"~",2),IN=$P(IN,"~",1)
 Q
OUT S CNT=^LA(TSK,"O")+1,^("O")=CNT,^("O",CNT)=OUT
 LOCK ^LA("Q") S Q=^LA("Q")+1,^("Q")=Q,^("Q",Q)=TSK LOCK
 Q
QUIT LOCK ^LA(TSK) H 1 K ^LA(TSK),^LA("LOCK",TSK)
 Q
TRAP D ^LABERR S T=TSK D SET^LAB G @("LA2^"_LANM) ;ERROR TRAP
