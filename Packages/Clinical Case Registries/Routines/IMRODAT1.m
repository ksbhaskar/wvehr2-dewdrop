IMRODAT1 ;HCIOFO-NCA,FT/FAI-DATA EXTRACTION (cont.) ; 03/09/02 15:03
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**15**;Feb 09, 1998
 Q
GETDAT ; Get Lab & Outpatient
LAB ; Get Lab Data
 S IMRLD=+$P(IMR101,"^",9),IMRLD1=+$P(IMR101,"^",10) ;piece 9=LAST LABORATORY DATE NOTED,piece 10=LAST MICROBIOLOGY DATE NOTED
 D CHK^IMRODLAB
 D ^IMRBDLB
 D ^IMRBKLOD
 S IMRLD=$S(IMRLAB>IMRLD:IMRLAB,1:IMRLD),IMRLD1=$S(IMRMI>IMRLD1:IMRMI,1:IMRLD1) S:'IMRLD IMRLD=""
 S $P(IMR101,"^",9,10)=IMRLD_"^"_IMRLD1,$P(IMR101,"^",13)=IMRLD,$P(IMR101,"^",17)=IMRLD1 K IMRLD,IMRLD1 ;piece 13=last limited lab date, piece 17=last limited micro date
OP ; Get Outpatient Activity Data
 S IMRLD=+$P(IMR101,"^",16) D OP^IMRODSCH S:'IMRLD IMRLD="" ;last OP date
 S $P(IMR101,"^",16)=$S(IMROP>IMRLD:IMROP,1:IMRLD) K IMRLD ;check latest scheduling date/time against last OP date
WRAP S:IMRT2="NEW"!(IMRNXT2<IMRFN) IMRNXT2=IMRFN ;IMRNXT2=last new case
 S ^IMR(158,IMRFN,101)=IMRDT_"^"_$P(IMR101,"^",2,99) ;IMRDT=LAST DATE DATA SURVEYED
 Q
SEND ; Send Message To National Registry
 N DIFROM K XMY
 S XMTEXT="^TMP($J,""IMRX"",",XMSUB="IMMUNOLOGY DATA. "_IMRSTN_" "_$E(IMRDTT,4,5)_"-"_$E(IMRDTT,6,7)_"-"_$E(IMRDTT,2,3)_" ("_IMRSET_")",XMDUZ=.5,XMY(IMRDOMN)="",XMY(DUZ)="" ;set up mail message variables
 D ^XMD ;send message if more than START,PA,DE & TIME segments
 K ^TMP($J),XMTEXT,XMDUZ,XMY,XMSUB,IMRGI
 S IMRFLAG=1
 S IMRSET=IMRSET+1
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="START"_"^"_IMRSTN_"^"_IMRDT_"^"_IMRSET_"^"_IMRCODE_"^"_$$VERSION^XPDUTL("IMR")_"^15" D SEGS^IMRODATA,LCHK^IMRODATA
 Q
