LBRYX52 ; COMPILED XREF FOR FILE #680.53 ; 09/19/10
 ;
 S DA(1)=DA S DA=0
A1 ;
 I $D(DIKILL) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^LBRY(680.5,DA(1),1,DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^LBRY(680.5,DA(1),1,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^LBRY(680.5,DA(1),1,"B",$E(X,1,30),DA)
 G:'$D(DIKLM) A Q:$D(DIKILL)
END Q
