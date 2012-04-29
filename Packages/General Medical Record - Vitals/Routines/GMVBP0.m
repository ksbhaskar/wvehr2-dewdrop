GMVBP0 ;HIOFO/YH,FT-KYOCERA B/P GRAPH - STORE DATA IN ^TMP($J) ;11/6/01  14:34
 ;;5.0;GEN. MED. REC. - VITALS;;Oct 31, 2002
 ;
 ; This routine uses the following IAs:
 ; <None>
 ;
EN1 ;
 N GAPICAL,GRADIAL,GBRACHI S GAPICAL=$O(^GMRD(120.52,"B","APICAL",0)),GRADIAL=$O(^GMRD(120.52,"B","RADIAL",0)),GBRACHI=$O(^GMRD(120.52,"B","BRACHIAL",0))
 K ^TMP($J,"GMR"),^TMP($J,"GMRK"),^TMP($J,"GDT"),^TMP($J,"GMRVG"),^TMP($J,"GTNM") F GI=1:1:200 S ^TMP($J,"GMRK","G"_GI)=""
 S GMROUT=0,(^TMP($J,"GMRK","G82M"),^TMP($J,"GMRK","G210M"),^TMP($J,"GMRK","G226M"))=0.6
 S GSTART1=(9999999-GMRFIN)-.0001,GEND1=9999999-GMRSTRT
 F GTYPE="B","P" D SETT
 U IO D ^GMVBP1
Q1 D Q1^GMVGR0
 Q
SETT ;
 S GTYPE(1)=$S(GTYPE="B":"BLOOD PRESSURE",GTYPE="P":"PULSE",1:"") Q:GTYPE(1)
 S GTYP=$O(^GMRD(120.51,"B",GTYPE(1),0)) Q:GTYP'>0
 F GX=GSTART1:0 S GX=$O(^GMR(120.5,"AA",DFN,GTYP,GX)) Q:GX>GEND1!(GX'>0)  F GEN=0:0 S GEN=$O(^GMR(120.5,"AA",DFN,GTYP,GX,GEN)) Q:GEN'>0  I '$D(^GMR(120.5,GEN,2)) D BLDARR
 Q
BLDARR ;
 S GDATA=$G(^GMR(120.5,GEN,0)) Q:GDATA=""
 S GMRVX(0)=$P(GDATA,"^",8) Q:GMRVX(0)=""
 S GMRVX=GTYPE,GMRVX(1)=0
 D:GMRVX(0)>0!(GMRVX(0)="0") EN1^GMVSAS0
 K GMRVARY S GMRVARY="" I $P($G(^GMR(120.5,GEN,5,0)),"^",4)>0 D CHAR^GMVCHAR(GEN,.GMRVARY,GTYP)
 K GG S GG="" I $O(GMRVARY(0)) D
 . S GG(1)=0 F  S GG(1)=$O(GMRVARY(GG(1))) Q:GG(1)'>0  S GG(2)=0 F  S GG(2)=$O(GMRVARY(GG(1),GG(2))) Q:GG(2)'>0  S GG(3)="" F  S GG(3)=$O(GMRVARY(GG(1),GG(2),GG(3))) Q:GG(3)=""  S GG=GG_$S(GG="":"",1:";")_GG(3)
 S GDATA(1)=GG_"^"_$S($G(GMRVX(1))>0:1,1:"")_"^"
 I GTYPE="P" D  Q
 . I '$D(^GMR(120.5,GEN,5,"B")) S ^TMP($J,"GMRVG",GTYPE,9999999-GX,GMRVX(0))=GDATA(1) Q
 . I $D(^GMR(120.5,GEN,5,"B",GBRACHI)) S ^TMP($J,"GMRVG",GTYPE,9999999-GX,GMRVX(0))=GDATA(1) Q
 . I $D(^GMR(120.5,GEN,5,"B",GAPICAL)) S ^TMP($J,"GMRVG",GTYPE,9999999-GX,GMRVX(0))=GDATA(1) Q
 . I $D(^GMR(120.5,GEN,5,"B",GRADIAL)) S ^TMP($J,"GMRVG",GTYPE,9999999-GX,GMRVX(0))=GDATA(1) Q
 I GMRVX(0)>0 S ^TMP($J,"GMRVG","S",9999999-GX,$P(GMRVX(0),"/"))=$S($P(GMRVX(0),"/")<$P(^GMRD(120.57,1,1),"^",7)&($P(GMRVX(0),"/")>$P(^(1),"^",9)):"",1:"^1^")
 I $P($G(GMRVX(0)),"/",3)'="" D
 . S ^TMP($J,"GMRVG","B",9999999-GX,$P(GMRVX(0),"/",1,2))=GDATA(1) S ^TMP($J,"GMRVG","C",9999999-GX,"/"_$P(GMRVX(0),"/",3))=GDATA(1)
 . S ^TMP($J,"GMRVG","D",9999999-GX,$P(GMRVX(0),"/",3))=$S($P(GMRVX(0),"/",3)<$P(^GMRD(120.57,1,1),"^",8)&($P(GMRVX(0),"/",3)>$P(^(1),"^",10)):"",1:"^1^")
 I $P($G(GMRVX(0)),"/",3)="" D
 . S ^TMP($J,"GMRVG",GTYPE,9999999-GX,GMRVX(0))=GDATA(1)
 . S:$P(GMRVX(0),"/",2)>0 ^TMP($J,"GMRVG","D",9999999-GX,$P(GMRVX(0),"/",2))=$S($P(GMRVX(0),"/",2)<$P(^GMRD(120.57,1,1),"^",8)&($P(GMRVX(0),"/",2)>$P(^(1),"^",10)):"",1:"^1^")
 S GDIAS=$S($D(^TMP($J,"GMRVG","D",9999999-GX)):$O(^TMP($J,"GMRVG","D",9999999-GX,0)),1:0)
 S GSYS=$S($D(^TMP($J,"GMRVG","S",9999999-GX)):$O(^TMP($J,"GMRVG","S",9999999-GX,0)),1:0)
 I GDIAS,GSYS S GMAP=$J(GDIAS+((GSYS-GDIAS)/3),0,0),^TMP($J,"GMRVG","M",9999999-GX,GMAP)=""
 K GSYS,GDIAS Q
