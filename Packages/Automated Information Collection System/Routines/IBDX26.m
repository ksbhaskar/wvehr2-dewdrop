IBDX26 ; COMPILED XREF FOR FILE #357.22 ; 09/19/10
 ;
 S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^IBE(357.2,DA(1),2,DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^IBE(357.2,DA(1),2,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^IBE(357.2,DA(1),2,"B",$E(X,1,30),DA)=""
 G:'$D(DIKLM) A Q:$D(DISET)
END Q
