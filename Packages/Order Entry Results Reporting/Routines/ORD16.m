ORD16 ; COMPILED XREF FOR FILE #101.07 ; 04/16/99
 ;
 S DA=0
A1 ;
 I $D(DIKILL) K DIKLM S:$D(DA(1)) DIKLM=1 G:$D(DA(1)) 1 S DA(1)=DA,DA=0 G @DIKM1
0 ;
A S DA=$O(^ORD(101,DA(1),101.07,DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^ORD(101,DA(1),101.07,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^ORD(101,DA(1),101.07,"B",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" I $L($P(^ORD(101,DA(1),0),"^",2)) K ^ORD(101,"S."_X,$P(^ORD(101,DA(1),0),"^",2),DA(1))
 G:'$D(DIKLM) A Q:$D(DIKILL)
END Q
