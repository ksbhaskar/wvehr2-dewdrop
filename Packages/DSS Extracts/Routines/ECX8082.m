ECX8082 ; COMPILED XREF FOR FILE #727.808 ; 08/31/12
 ; 
 S DIKZK=1
 S DIKZ(0)=$G(^ECX(727.808,DA,0))
 S X=$P(DIKZ(0),U,3)
 I X'="" S ^ECX(727.808,"AC",$E(X,1,30),DA)=""
END Q
