SPNLXMD ;ISCSF/RAH - LOAD Records INTO Mail AND Send ;1/12/96  10:27
V ;;2.0;Spinal Cord Dysfunction;**2**;01/02/1997
 ;
EN1(SPNLTEXT,SPNLSUB,SPNLXMY,SPNLERR)   ; Entry point.
 D INIT
 S SPNLERR=0,SPNLLN=0,SPNLV=0,SPNLSSN="",SPNLNX=0,SPNLTX=0,SPNLLMT=0,SPNLEX=""
 D EDITCK I SPNLERR D CLR Q
 D REFORM I SPNLERR D CLR Q
 D LOADIT
 D CLR
 Q
EDITCK ; Verify proper data set up when called.
 I '$D(SPNLTEXT) S SPNLERR="1^SPNLTEXT NOT DEFINED" W:'$D(ZTQUEUED) !!,"GLOBAL LOCATION REQUIRED!!!" Q
 I '$D(SPNLSUB) S SPNLERR="2^SPNLSUB NOT DEFINED" W:'$D(ZTQUEUED) !!,"MESSAGE SUBJECT REQUIRED!!!" Q
 I '$D(SPNLXMY) S SPNLERR="3^SPNLXMY NOT DEFINED" W:'$D(ZTQUEUED) !!,"MESSAGE DESTINATION REQUIRED!!!" Q
 S:'$D(DUZ) SPNLDUZ=".5"
 Q
REFORM ;
 S SPNLX=1
 F  S SPNLSSN=$O(^TMP("SPNX",SPNLJ,SPNLSDT,SPNLFAC,SPNLSSN)) Q:SPNLSSN=""  D
 .S SPNLEX=.9 I $D(^TMP("SPNX",SPNLJ,SPNLSDT,SPNLFAC,SPNLSSN))#10 S SPNLTXT="^TMP(""SPNX"",SPNLJ,SPNLSDT,SPNLFAC,SPNLSSN)" D GLB2MAIL
 .F  S SPNLEX=$O(^TMP("SPNX",SPNLJ,SPNLSDT,SPNLFAC,SPNLSSN,SPNLEX)) Q:SPNLEX=""  D
 ..S SPNLNX=0
 ..F  S SPNLNX=$O(^TMP("SPNX",SPNLJ,SPNLSDT,SPNLFAC,SPNLSSN,SPNLEX,SPNLNX)) Q:SPNLNX'>0  D
 ...S SPNLTXT="^TMP(""SPNX"",SPNLJ,SPNLSDT,SPNLFAC,SPNLSSN,SPNLEX,SPNLNX)" D GLB2MAIL
 S SPNLTEXT(2)=SPNLTEXT_"""MAIL"""_",SPNLNX)",SPNLTEXT(1)=SPNLTEXT_"""XMD"""_",SPNLLN)"
 I '$D(@(SPNLTEXT_"""MAIL"",1)")) S SPNLERR="4^NO RECORD CHANGES TO TRANSMIT" Q
 Q
GLB2MAIL ;
 S SPNLMN=@(SPNLTXT),SPNLMM=SPNLFAC_";"_SPNLSSN_";"_SPNLEX_";"_SPNLNX_"$"_SPNLMN
 S ^TMP("SPNX",SPNLJ,"MAIL",SPNLX)="D$ "_SPNLMM,SPNLX=SPNLX+1
 Q
LOADIT ;
 S SPNLLN=2,MAXRECS=SPNXRECS+2
 F  S SPNLNX=$O(@(SPNLTEXT(2))) Q:SPNLNX=""  D  Q:SPNLERR
 . S SPNLLN=SPNLLN+1
 . I SPNLLN>MAXRECS D SENDMSG S SPNLLN=3
 . S @SPNLTEXT(1)=@SPNLTEXT(2)
 D SENDMSG
 K MAXRECS
 Q
SENDMSG ;
 S SPNLLN=2 S @SPNLTEXT(1)="F$ "_^TMP("SPNX",SPNLJ,SPNLSDT,SPNLFAC)
 S SPNLLN=1 S @SPNLTEXT(1)="H$ "_SPNLHDR
 S SPNLV=SPNLV+1,XMSUB=SPNLSUB,XMDUZ=SPNLDUZ
 ;S XMY(DUZ)=""
 S XMY(SPNLXMY)=""
 S XMTEXT=SPNLTEXT_"""XMD""," D ^XMD I '$D(XMZ) S SPNLERR="5^TRANSMIT ERROR" W:'$D(ZTQUEUED) !,"TRANSMISSION ERR" G XIT1
 S SPNLXMZ=XMZ
 K @(SPNLTEXT_"""XMD"")")
XIT1 ;
 Q
CLR ;
 K SPNLEX,SPNLII,SPNLJ,SPNLLMT,SPNLMM,SPNLMN,SPNLSSN,SPNLTX,SPNLTXT
 K SPNLTY,SPNLX,SPNLXMZ,SPNLDUZ,SPNLLN,SPNLNX,SPNLV
 K XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 Q
INIT ;
 K XMSUB,XMTEXT,XMY,XMZ
 S SPNLJ=$J
 I DUZ'="" S SPNLDUZ=DUZ
 E  S SPNLDUZ=.5
 Q
