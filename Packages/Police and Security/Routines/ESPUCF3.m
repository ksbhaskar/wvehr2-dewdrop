ESPUCF3 ;DALISC/CKA - UNIFORM CRIME REPORT COUNT AND GET TOTALS- 3/99
 ;;1.0;POLICE & SECURITY;**27**;Mar 31, 1994
EN Q  ;CALLED FROM ESPUCF1
RAPE ;RAPE TOTALS
OFFR ; COUNT RAPE OFFENDER AND VICTIMS
 S ESPVIC=0
 F ESPX=1:1 S ESPVIC=$O(^ESP(912,ESPOFN,30,ESPVIC)) Q:ESPVIC'>0  D
 .  S ESPVICT=$P(^ESP(912,ESPOFN,30,ESPVIC,0),U,5) D
 ..  S ^(88)=^ESP(912.3,ESPIEN,1,ESPINS,88)+1
 ..  I ESPTYPE=38 S ^(89)=^ESP(912.3,ESPIEN,1,ESPINS,89)+1 QUIT
 ..  I ESPTYPE=39 S ^(90)=^ESP(912.3,ESPIEN,1,ESPINS,90)+1 QUIT
 .  I ESPVICT="E"!(ESPVICT="PO") S ^(96)=^ESP(912.3,ESPIEN,1,ESPINS,96)+1 QUIT
 .  I ESPVICT="O" S ^(97)=^ESP(912.3,ESPIEN,1,ESPINS,97)+1 QUIT
 .  I ESPVICT="P" S ^(98)=^ESP(912.3,ESPIEN,1,ESPINS,98)+1 QUIT
 .  I ESPVICT="V" S ^(99)=^ESP(912.3,ESPIEN,1,ESPINS,99)+1 QUIT
 I $D(^ESP(912,ESPOFN,30)) D OFFE
 QUIT
OFFE ;COUNT OFFENDERS FOR RAPE
 S ESPOF=0
 F ESPX=1:1 S ESPOF=$O(^ESP(912,ESPOFN,40,ESPOF)) Q:ESPOF'>0  D
 .  S ESPOFF=$P(^ESP(912,ESPOFN,40,ESPOF,0),U,11)
 .  I ESPOFF="E"!(ESPOFF="PO") S ^(91)=^ESP(912.3,ESPIEN,1,ESPINS,91)+1 QUIT
 .  I ESPOFF="O" S ^(92)=^ESP(912.3,ESPIEN,1,ESPINS,92)+1 QUIT
 .  I ESPOFF="P" S ^(93)=^ESP(912.3,ESPIEN,1,ESPINS,93)+1 QUIT
 .  I ESPOFF="V" S ^(95)=^ESP(912.3,ESPIEN,1,ESPINS,95)+1 QUIT
 .  S ^(94)=^ESP(912.3,ESPIEN,1,ESPINS,94)+1
 QUIT
ROBB ;ROBBERY TOTALS
 S ^(100)=^ESP(912.3,ESPIEN,1,ESPINS,100)+1
 I ESPTYPE=40 S ^(101)=^ESP(912.3,ESPIEN,1,ESPINS,101)+1 D ARMED,DOL QUIT
 I ESPTYPE=41 S ^(104)=^ESP(912.3,ESPIEN,1,ESPINS,104)+1 D STRONG,DOL QUIT
 I ESPTYPE=58 S ^(107)=^ESP(912.3,ESPIEN,1,ESPINS,107)+1 D DOL QUIT
 QUIT
ARMED ;ARMED ROBBERY TOTALS
 I ESPSUB=11 S ^(102)=^ESP(912.3,ESPIEN,1,ESPINS,102)+1 QUIT
 I ESPSUB=12 S ^(103)=^ESP(912.3,ESPIEN,1,ESPINS,103)+1 QUIT
 QUIT
STRONG ;STRONG ARMED ROBBERY TOTALS
 I ESPSUB=13 S ^(105)=^ESP(912.3,ESPIEN,1,ESPINS,105)+1 QUIT
 I ESPSUB=14 S ^(106)=^ESP(912.3,ESPIEN,1,ESPINS,106)+1 QUIT
 QUIT
DOL ;ADD DOLLAR TOTALS
 S ESPDOL=0
 F ESPX=1:1 S ESPDOL=$O(^ESP(912,ESPOFN,90,ESPDOL)) Q:ESPDOL'>0  D
 .  S ^ESP(912.3,ESPIEN,1,ESPINS,108)=^ESP(912.3,ESPIEN,1,ESPINS,108)+$P($G(^ESP(912,ESPOFN,90,ESPDOL,0)),U,3)
 .  S ^ESP(912.3,ESPIEN,1,ESPINS,109)=^ESP(912.3,ESPIEN,1,ESPINS,109)+$P($G(^ESP(912,ESPOFN,90,ESPDOL,0)),U,4)
 QUIT
