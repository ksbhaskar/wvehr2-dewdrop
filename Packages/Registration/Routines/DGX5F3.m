DGX5F3 ; ;08/30/12
 S X=DG(DQ),DIC=DIE
 S ^DGPT(DA(1),"M","AC",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 X "N X S X=""DGRUDD01"" X ^%ZOSF(""TEST"") Q:'$T  N DG1 S DG1=+$P(^DGPT(DA(1),0),""^"",1) D:(DG1>0) ADGRU^DGRUDD01(DG1)"
