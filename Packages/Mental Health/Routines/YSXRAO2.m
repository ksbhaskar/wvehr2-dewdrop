YSXRAO2 ; COMPILED XREF FOR FILE #615.8 ; 09/19/10
 ;
 S DIKZK=1
 S DIKZ(0)=$G(^YSR(615.8,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^YSR(615.8,"B",$E(X,1,30),DA)=""
END Q
