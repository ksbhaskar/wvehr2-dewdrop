DGPTX52 ; ;09/19/10
 S X=DE(37),DIC=DIE
 K ^DGPT(DA(1),"M","AC",$E(X,1,30),DA)
 S X=DE(37),DIC=DIE
 X "N X S X=""DGRUDD01"" X ^%ZOSF(""TEST"") Q:'$T  N DG1 S DG1=+$P(^DGPT(DA(1),0),""^"",1) D:(DG1>0) ADGRU^DGRUDD01(DG1)"
