ECX8131 ; COMPILED XREF FOR FILE #727.813 ; 08/31/12
 ; 
 S DIKZK=2
 S DIKZ(0)=$G(^ECX(727.813,DA,0))
 S X=$P(DIKZ(0),U,3)
 I X'="" K ^ECX(727.813,"AC",$E(X,1,30),DA)
END Q
