LRAPWE1 ;AVAMC/REG - STUFF EM SCANNED GRIDS ;4/22/93  10:03
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 F LR=0:0 S LR=$O(LR(LR)) Q:'LR  S LRX=LR(LR),A=$P(LRX,"^"),E=$P(LRX,"^",2),B=$P(LRX,"^",3) D GS,PM
 Q
GS S LRT=LRW(1),LRK=$P(LRX,"^",5),LRZ=$P(LRX,"^",7)-$P(LRX,"^",10) S:LRZ<0 LRZ=0 I LRZ D STF S X=LRZ+$P(LRX,"^",10),$P(^LR(LRDFN,LRSS,LRI,.1,A,E,B,1,LRW,0),"^",13)=X
 Q
PM S LRT=LRW(2),LRK=$P(LRX,"^",9),LRZ=$P(LRX,"^",8)-$P(LRX,"^",11) S:LRZ<0 LRZ=0 I LRZ D STF S X=LRZ+$P(LRX,"^",11),$P(^LR(LRDFN,LRSS,LRI,.1,A,E,B,1,LRW,0),"^",12)=X
 Q
 ;
STF S:'$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,0)) ^(0)="^68.04PA^^"
 I '$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,0)) S ^(0)=LRT_"^50^^"_DUZ_"^"_LRK,X=^LRO(68,LRAA,1,LRAD,1,LRAN,4,0),^(0)=$P(X,"^",1,2)_"^"_LRT_"^"_($P(X,"^",4)+1)
 S:'$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,1,0)) ^(0)="^68.14P^^"
 F C=0:0 S C=$O(^LAB(60,LRT,9,C)) Q:'C  S C(3)=$P(^(C,0),"^",3) S:'C(3) C(3)=1 S A(1)=C(3)*LRZ D CAP
 S ^LRO(68,"AA",LRAA_"|"_LRAD_"|"_LRAN_"|"_LRT)="" Q
 ;
CAP I '$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,1,C,0)) S ^(0)=C_"^"_A(1)_"^0^0^^"_LRK_"^"_DUZ_"^"_DUZ(2)_"^"_LRAA_"^"_LRAA_"^"_LRAA,X=^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,1,0),^(0)=$P(X,"^",1,2)_"^"_C_"^"_($P(X,"^",4)+1) Q
 S X=^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,1,C,0),$P(X,"^",2)=$S($P(X,"^",3):A(1),1:$P(X,"^",2)+A(1)),$P(X,"^",3)=0,$P(X,"^",6)=LRK,^(0)=X Q
 ;
EM S J=0,X="GRID EM" D X^LRUWK S LRW=LRT K LRT
 S X="EM SCAN AND PHOTO" D X^LRUWK S LRW(1)=LRT K LRT
 S X="EM PRINT/ENLARGEMENT" D X^LRUWK S LRW(2)=LRT K LRT
 Q
