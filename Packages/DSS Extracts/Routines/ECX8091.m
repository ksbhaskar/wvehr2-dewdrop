ECX8091 ; COMPILED XREF FOR FILE #727.809 ; 08/31/12
 ; 
 S DIKZK=2
 S DIKZ(0)=$G(^ECX(727.809,DA,0))
 S X=$P(DIKZ(0),U,3)
 I X'="" K ^ECX(727.809,"AC",$E(X,1,30),DA)
END Q
