IBXSC62 ; ;08/30/12
 S X=DG(DQ),DIC=DIE
 X ^DD(399,.19,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X=DIV S X=5 S DIH=$G(^DGCR(399,DIV(0),0)),DIV=X S $P(^(0),U,9)=DIV,DIH=399,DIG=.09 D ^DICR
 S X=DG(DQ),DIC=DIE
 S DGRVRCAL=1
 S X=DG(DQ),DIC=DIE
 D ALLID^IBCEP3(DA,.19,1)
 S X=DG(DQ),DIC=DIE
 D ATTREND^IBCU1(DA,"","")
