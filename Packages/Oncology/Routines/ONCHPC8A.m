ONCHPC8A ;Hines OIFO/GWB - 2000 Hepatocellular Cancers PCE Study ;01/12/00
 ;;2.11;ONCOLOGY;**26**;Mar 07, 1995
 ;Print (continued)
III K LINE S $P(LINE,"-",29)="-"
 S TABLE="STAGE OF DISEASE AT DIAGNOSIS"
 I IOST'?1"C".E W ! I ($Y'<(LIN-4)) D HEAD^ONCHPC0
 W !?4,TABLE,!?4,LINE
 D P Q:EX=U
 W !,"23. SIZE OF TUMOR...............: ",$$GET1^DIQ(165.5,IE,29)
 D P Q:EX=U
 W !,"24. REGIONAL NODES EXAMINED.....: ",$$GET1^DIQ(165.5,IE,33)
 D P Q:EX=U
 W !,"25. REGIONAL NODES POSITIVE.....: ",$$GET1^DIQ(165.5,IE,32)
 D P Q:EX=U
 W !
 D P Q:EX=U
ACS W !,"26. AJCC CLINICAL STAGE (cTNM):"
 D P Q:EX=U
 W !,"     AJCC CLINICAL T............: ",$$GET1^DIQ(165.5,IE,37.1)
 D P Q:EX=U
 W !,"     AJCC CLINICAL N............: ",$$GET1^DIQ(165.5,IE,37.2)
 D P Q:EX=U
 W !,"     AJCC CLINICAL M............: ",$$GET1^DIQ(165.5,IE,37.3)
 D P Q:EX=U
 W !,"     AJCC CLINICAL STAGE GROUP..: ",$$GET1^DIQ(165.5,IE,38)
 D P Q:EX=U
APS W !
 D P Q:EX=U
 W !,"27. AJCC PATHOLOGIC STAGE (pTNM):"
 D P Q:EX=U
 W !,"     AJCC PATHOLOGIC T..........: ",$$GET1^DIQ(165.5,IE,85)
 D P Q:EX=U
 W !,"     AJCC PATHOLOGIC N..........: ",$$GET1^DIQ(165.5,IE,86)
 D P Q:EX=U
 W !,"     AJCC PATHOLOGIC M..........: ",$$GET1^DIQ(165.5,IE,87)
 D P Q:EX=U
 W !,"     AJCC PATHOLOGIC STAGE GROUP: ",$$GET1^DIQ(165.5,IE,88)
 D P Q:EX=U
 W !
 D P Q:EX=U
 W !,"28. STAGED BY:"
 D P Q:EX=U
 W !,"     CLINICALLY STAGED BY.......: ",$$GET1^DIQ(165.5,IE,19)
 D P Q:EX=U
 W !,"     PATHOLOGICALLY STAGED BY...: ",$$GET1^DIQ(165.5,IE,89)
 D P Q:EX=U
 I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCHPC0 G IV
 D P Q:EX=U
IV S TABLE="FIRST COURSE OF TREATMENT"
 I IOST'?1"C".E W ! I ($Y'<(LIN-4)) D HEAD^ONCHPC0
 K LINE S $P(LINE,"-",25)="-"
 W !?4,TABLE,!?4,LINE
 D P Q:EX=U
 S D0=ONCONUM D DFC^ONCOCOM S DOFCT=Y
 W !,"29. DATE OF FIRST COURSE OF"
 D P Q:EX=U
 W !,"     TREATMENT..................: ",DOFCT
 D P Q:EX=U
 W !,"30. DATE OF INPATIENT ADMISSION.: ",$$GET1^DIQ(165.5,IE,1)
 D P Q:EX=U
 W !,"31. DATE OF INPATIENT DISCHARGE.: ",$$GET1^DIQ(165.5,IE,1.1)
 D P Q:EX=U
 W !
 D P Q:EX=U
 W !?4,"SURGERY",!?4,"-------"
 D P Q:EX=U
 W !?4,"NON CANCER-DIRECTED SURGERY",!?4,"---------------------------"
 D P Q:EX=U
S W !,"32. DATE OF NON CANCER-DIRECTED"
 D P Q:EX=U
 W !,"     SURGERY....................: ",$$GET1^DIQ(165.5,IE,58.3)
 D P Q:EX=U
 S DESC=$$GET1^DIQ(165.5,IE,58.1) D DESC
NCDS W !,"33. NON CANCER-DIRECTED SURGERY.: ",DESC1 W:DESC2'="" !,?34,DESC2
 D P Q:EX=U
 W !?4,"CANCER-DIRECTED SURGERY",!?4,"-----------------------"
 D P Q:EX=U
 W !,"34. DATE OF CANCER-DIRECTED"
 D P Q:EX=U
 W !,"     SURGERY....................: ",$$GET1^DIQ(165.5,IE,50)
 D P Q:EX=U
SA W !,"35. SURGICAL APPROACH...........: ",$$GET1^DIQ(165.5,IE,74)
 D P Q:EX=U
CDS S DESC=$$GET1^DIQ(165.5,IE,58.2) D DESC
SPS W !,"36. SURGERY OF PRIMARY SITE.....: ",DESC1 W:DESC2'="" !,?34,DESC2
 D P Q:EX=U
 W !,"37. RADIO-FREQUENCY DESTRUCTION"
 D P Q:EX=U
 W !,"     OF TUMOR...................: ",$$GET1^DIQ(165.5,IE,1056)
 D P Q:EX=U
 W !,"38. ABLATION & RESECTION........: ",$$GET1^DIQ(165.5,IE,1057)
 D P Q:EX=U
 S DESC=$$GET1^DIQ(165.5,IE,59) D DESC
SM W !,"39. SURGICAL MARGINS............: ",DESC1 W:DESC2'="" !,?34,DESC2
 D P Q:EX=U
 W !,"40. DISTANCE OF TUMOR TO CLOSEST"
 D P Q:EX=U
 W !,"     MARGIN.....................: ",$$GET1^DIQ(165.5,IE,1058)
 D P Q:EX=U
 S DESC=$$GET1^DIQ(165.5,IE,139) D DESC
SORS W !,"41. SURGERY OF OTHER REGIONAL"
 D P Q:EX=U
 W !,"     SITE(S), DISTANT SITE(S),"
 D P Q:EX=U
 W !,"     OR DISTANT LYMPH NODE(S)...: ",DESC1 W:DESC2'="" !,?34,DESC2
 D P Q:EX=U
 W !
 D P Q:EX=U
STRPT W !,"42. SURGICAL TREATMENT OF RESIDUAL PRIMARY TUMOR:"
 D P Q:EX=U
 W !,"     ABLATION...................: ",$$GET1^DIQ(165.5,IE,1059)
 D P Q:EX=U
 W !,"     RESECTION..................: ",$$GET1^DIQ(165.5,IE,1060)
 D P Q:EX=U
 W !
 D P Q:EX=U
RR W !,"43. RECONSTRUCTION/RESTORATION-"
 D P Q:EX=U
 W !,"     FIRST COURSE...............: ",$$GET1^DIQ(165.5,IE,23)
 D P Q:EX=U
 I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCHPC0 W !?4,TABLE_" (continued)",!?4,LINE_"------------"
R W !?4,"RADIATION THERAPY",!?4,"-----------------"
 D P Q:EX=U
 W !,"44. DATE RADIATION STARTED......: ",$$GET1^DIQ(165.5,IE,51)
 D P Q:EX=U
 W !,"45. RADIATION THERAPY...........: ",$$GET1^DIQ(165.5,IE,51.2)
 D P Q:EX=U
 W !
 D P Q:EX=U
C W !?4,"CHEMOTHERAPY",!?4,"------------"
 D P Q:EX=U
 W !,"46. DATE CHEMOTHERAPY STARTED...: ",$$GET1^DIQ(165.5,IE,53)
 D P Q:EX=U
 W !,"47. CHEMOTHERAPY................: ",$$GET1^DIQ(165.5,IE,53.2)
 D P Q:EX=U
 W !
 D P Q:EX=U
TCAA W !,"48. TYPE OF CHEMOTHERAPEUTIC AGENTS ADMINISTERED:" D P Q:EX=U
 W !,"     CISPLATIN..................: ",$$GET1^DIQ(165.5,IE,1061)
 D P Q:EX=U
 W !,"     FUDR.......................: ",$$GET1^DIQ(165.5,IE,1062)
 D P Q:EX=U
 W !,"     5-FU.......................: ",$$GET1^DIQ(165.5,IE,1063)
 D P Q:EX=U
 W !,"     FU & LEUCOVERIN............: ",$$GET1^DIQ(165.5,IE,1064)
 D P Q:EX=U
 W !,"     IRINOTECAN (CPT-11)........: ",$$GET1^DIQ(165.5,IE,1065)
 D P Q:EX=U
 W !,"     MITOMYCIN C................: ",$$GET1^DIQ(165.5,IE,1066)
 D P Q:EX=U
 W !,"     OXALIPLATIN................: ",$$GET1^DIQ(165.5,IE,1067)
 D P Q:EX=U
 W !,"     GEMCITABINE................: ",$$GET1^DIQ(165.5,IE,1068)
 D P Q:EX=U
 W !
 D P Q:EX=U
 W !,"49. ROUTE CHEMOTHERAPY ADMIN....: ",$$GET1^DIQ(165.5,IE,1069)
 D P Q:EX=U
 W !,"50. CHEMOTHERAPY/SURGERY SEQ....: ",$$GET1^DIQ(165.5,IE,1070)
 D P Q:EX=U
 W !
 D P Q:EX=U
OT W !?4,"OTHER THERAPY",!?4,"-------------"
 D P Q:EX=U
 W !,"51. DATE OTHER TREATMENT STARTED: ",$$GET1^DIQ(165.5,IE,57)
 D P Q:EX=U
 W !,"52. OTHER TREATMENT.............: ",$$GET1^DIQ(165.5,IE,57.2)
 D P Q:EX=U
 W !,"53. ARTERIAL EMBOLIZATION.......: ",$$GET1^DIQ(165.5,IE,1071)
 D P Q:EX=U
 W !,"54. DEATH WITHIN 30 DAYS OF"
 D P Q:EX=U
 W !,"     START OF INITIAL COURSE OF"
 D P Q:EX=U
 W !,"     THERAPY....................: ",$$GET1^DIQ(165.5,IE,1072)
 I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCHPC0 G V
 D P Q:EX=U
V S TABLE="RECURRENCE"
 I IOST'?1"C".E W !
 W !?4,TABLE,!?4,"----------"
 D P Q:EX=U
 W !,"55. DATE OF FIRST RECURRENCE....: ",$$GET1^DIQ(165.5,IE,70)
 D P Q:EX=U
 S DESC=$$GET1^DIQ(165.5,IE,71) D DESC
TFR W !,"56. TYPE OF FIRST RECURRENCE....: ",DESC1 W:DESC2'="" !,?31,DESC2
 S END=1
 D P Q:EX=U
VI S TABLE="FOLLOW-UP"
 W !!?4,TABLE,!?4,"---------"
 D P Q:EX=U
 S DLC="" I $D(^ONCO(160,ONCOPA,"F","B")) S DLC=$O(^ONCO(160,ONCOPA,"F","B",""),-1)
 I DLC'="" S Y=DLC D DATEOT^ONCOPCE S DLC=Y
 W !,"57. DATE OF LAST CONTACT/DEATH..: ",DLC
 D P Q:EX=U
 W !,"58. VITAL STATUS................: ",$$GET1^DIQ(160,ONCOPA,15)
 D P Q:EX=U
 S CS="" I $D(^ONCO(165.5,IE,"TS","AA")) D
 .S CSDAT=$O(^ONCO(165.5,IE,"TS","AA",""))
 .S CSI=$O(^ONCO(165.5,IE,"TS","AA",CSDAT,""))
 .S CSPNT=$P(^ONCO(165.5,IE,"TS",CSI,0),U,2)
 .S CS=$P(^ONCO(164.42,CSPNT,0),U,1)
 W !,"59. CANCER STATUS...............: ",CS
 I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR
 Q
P ;Print
 I ($Y'<(LIN-1)) D  Q:EX=U  I $G(END)'=1 W !?4,TABLE_" (continued)",!?4,LINE_"------------"
 .I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR I 'Y S EX=U Q
 .D HEAD^ONCHPC0 Q
 Q
DESC S (DESC1,DESC2)="",LOS=$L(DESC) I LOS<46 S DESC1=DESC Q
 S NOP=$L($E(DESC,1,46)," ")
 S DESC1=$P(DESC," ",1,NOP-1),DESC2=$P(DESC," ",NOP,999)
 Q
