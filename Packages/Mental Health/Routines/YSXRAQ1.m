YSXRAQ1 ; COMPILED XREF FOR FILE #617 ; 09/19/10
 ;
 S DIKZK=2
 S DIKZ(0)=$G(^YSG("WAIT",DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^YSG("WAIT","B",$E(X,1,30),DA)
END G ^YSXRAQ2
