LBRYX16 ; COMPILED XREF FOR FILE #680.03 ; 09/19/10
 ;
 S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^LBRY(680,DA(1),3,DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^LBRY(680,DA(1),3,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^LBRY(680,DA(1),3,"B",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^LBRY(680,"C",$E(X,1,30),DA(1),DA)=""
 G:'$D(DIKLM) A Q:$D(DISET)
END Q
