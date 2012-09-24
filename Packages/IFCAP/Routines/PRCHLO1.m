PRCHLO1 ;WOIFO/RLL-EXTRACT ROUTINE (cont.)CLO REPORT SERVER ;5/22/09  14:10
        ;;5.1;IFCAP;**83,130**;Oct 20, 2000;Build 25
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ; DBIA 10093 - Read file 49 via FileMan.
        ; Continuation of PRCHLO1. This program builds the extracts for
        ; the Master PO Table and the associated multiples
POMAST  ; PoMaster Table
        Q
PODISCW ; Write PO Discount table data
        N GPOID,GPOND
        S GPOID=0,GPOND=""
        F  S GPOID=$O(^TMP($J,"PODISC",GPOID)) Q:GPOID=""  D
        . F  S GPOND=$O(^TMP($J,"PODISC",GPOID,GPOND)) Q:GPOND=""  D
        . . W $G(^TMP($J,"PODISC",GPOID,GPOND))
        . . W !
        . . Q
        . Q
        Q
GPOMAST ; get PO Master record
        S U="^"
        N N0,N1,N7,N12,N16,N23,PONUMB,STNUMB,PODAT,PPOKEY
        N PAPAB,PAPAB1,AGAPO,AGAPO1,PCHDR,PCHDR1,PCUSR,PCUSR1,POIDC,PRCVAL
        N VL1,VL6,VL7,VL8,VL9,VL10,VL11,VL12,VL13,VL14,VL15,VL16,VL17,VL18
        N VL19,VL20,VL21,VL22,VL23,VL24,VL25,VL26,VL27,VL28,VL29,VL30,VL31
        N VL32,VL33,VL34,VL35,VL36,VL37,VL38,VL39,VL40,VL41
        N GN0,GN0A,GN0B,GN1,GN1A,GN2,VN,VN1,VN2
        N VL6E,VL6E1,VL6E2,VL7E,VL7E1,VL7E2,VL8E,VL8E1,VL8E2,VL10E,VL10E1
        N VL10E2,VL21E,VL21E1,VL21E2,VL25E,VL25E1,VL25E2,VL35E,VL35E1,VL35E2
        N VL16E,VL16E1,VL16E2,VL18E,VL18E1,VL18E2,VL33E,VL33E1,VL33E2
        N VL34E,VL34E1,VL34E2,PC2237V,PC2237V1,EXDT,EXDT1,EXDT2
        S N0=$G(^PRC(442,POID,0))
        S N1=$G(^PRC(442,POID,1))
        S N7=$G(^PRC(442,POID,7))
        S N12=$G(^PRC(442,POID,12))
        S N16=$G(^PRC(442,POID,16))
        S N23=$G(^PRC(442,POID,23))
        S PONUMB=$P(N0,U,1),STNUMB=$P(PONUMB,"-",1)
        S EXDT=$P(N1,U,15)
        I EXDT="" S EXDT=POCRDAT  ; if PO Date "" use x-ref date value for PO
        S EXDT1=$P(EXDT,".",1)
        S EXDT2=$$FMTE^XLFDT(EXDT1)
        S PODAT=EXDT2  ; needed for key
        S PPOKEY=POID_U_PONUMB_U_PODAT_U_MNTHYR_U_STNUMB
        ;
        ; The 1st 5 values in PPOKEY above are included in each record
        ;
        S VL6E=$P(N0,U,12),VL6E1=$G(^PRCS(410,+VL6E,0)),VL6E2=$P(VL6E1,U,1)
        S VL6=VL6E2  ; Prim2237
        S VL7E=$P(N0,U,2),VL7E1=$G(^PRCD(442.5,+VL7E,0)),VL7E2=$P(VL7E1,U,1)
        S VL7=VL7E2  ; meth.of proc
        S VL8E=$P(N1,U,19),VL8E1=$G(^PRC(443.8,+VL8E,0)),VL8E2=$P(VL8E1,U,2)
        S VL8=VL8E2  ; locProcRsnCode
        S VL9=$P(N1,U,18)  ; exp/non-exp
        S VL10E=$P(N7,U,1),VL10E1=$G(^PRCD(442.3,+VL10E,0))
        S VL10E2=$P(VL10E1,U,1)
        S VL10=VL10E2  ; Supply status
        S VL11=$P(N7,U,2)  ; Sup Stat Order
        S VL12=$P(N7,U,4)  ;Fis Stat Order
        S VL13=$P(N0,U,3)  ;FCP
        S VL14=$P(N0,U,4)  ;Appropriation
        S VL15=$P(N0,U,5)  ;CostCenter
        S VL16E=$P(N0,U,6),VL16E1=$G(^PRCD(420.2,+VL16E,0))
        S VL16E2=$P(VL16E1,U,1)
        S VL16=VL16E2  ;SubAcct1
        S VL17=$P(N0,U,7)  ;SubAmt1
        S VL18E=$P(N0,U,8),VL18E1=$G(^PRCD(420.2,+VL18E,0))
        S VL18E2=$P(VL18E1,U,1)
        S VL18=VL18E2  ;SubAcct2
        S VL19=$P(N0,U,9)  ;SubAmt2
        ; set Node 0 of ^TMP
        S GN0=PPOKEY_U_VL6_U_VL7_U_VL8_U_VL9_U_VL10_U
        S GN0A=GN0_VL11_U_VL12_U_VL13_U_VL14_U_VL15_U
        S GN0B=GN0A_VL16_U_VL17_U_VL18_U_VL19_U
        S GN0B=GN0B_VL6E_U                     ;IEN OF PRIMARY 2237
        S GN0B=GN0B_VL7E_U                     ;IEN OF METHOD OF PROCESSING
        S GN0B=GN0B_VL10E_U                    ;IEN OF SUPPLY STATUS
        S GN0B=GN0B_VL16E_U                    ;IEN OF SUBACCOUNT1
        S GN0B=GN0B_VL18E_U                    ;IEN OF SUBACCOUNT2
        S ^TMP($J,"POMAST",POID,0)=GN0B  ; build and set node 0
        ; begin Node 1
        ; look up Vendor
        S VN=$P(N1,U,1),VN1=$G(^PRC(440,+VN,0)),VN2=$P(VN1,U,1)
        S VL20=VN2                                          ;Vendor Name
        S VL21E=$P(N1,U,2),VL21E1=$$GET1^DIQ(49,+VL21E_",",.01)
        S VL21E2=$P(VL21E1,U,1)
        S VL21=VL21E2  ; Req. Service
        S VL22=$P(N1,U,6)  ; Fob Point
        ; get ext. date
        S EXDT=$P(N0,U,20),EXDT1=$P(EXDT,".",1)
        S EXDT2=$$FMTE^XLFDT(EXDT1)
        S VL23=EXDT2  ; Org. Del. Date
        S VL24=$P(N0,U,11)  ; Est. Cost
        S VL25E=$P(N1,U,7),VL25E1=$G(^PRCD(420.8,+VL25E,0))
        S VL25E2=$P(VL25E1,U,2)
        S VL25=VL25E2  ; Source Code
        S VL26=$P(N0,U,13)  ; Est Shipping
        S VL27=$P(N0,U,18)  ; Shp Ln Itm #
        S VL28=$P(N0,U,14)  ; Ln Itm Cnt
        S PAPAB=$P(N1,U,10),PAPAB1=$G(^VA(200,+PAPAB,0))
        S VL29=$P(PAPAB1,U,1)  ; PaPpmAuthBuyer
        S VL8=$P($G(^VA(200,+PAPAB,5)),"^")      ;Service - PaPpmAuthBuyer
        S VL9=$S(VL8="":"",1:$$GET1^DIQ(49,+VL8_",",.01)) ;SVC ext - PaPpmAuthBuyer
        S AGAPO=$P(N12,U,4),AGAPO1=$G(^VA(200,+AGAPO,0))
        S VL30=$P(AGAPO1,U,1)  ; Agt Assgnd PO
        S VL6=$P($G(^VA(200,+AGAPO,5)),"^")      ;Service - Agt Assgnd PO
        S VL7=$S(VL6="":"",1:$$GET1^DIQ(49,+VL6_",",.01)) ;SVC ext - Agt Assgnd
        ; get external date
        S EXDT=$P(N12,U,5),EXDT1=$P(EXDT,".",1)
        S EXDT2=$$FMTE^XLFDT(EXDT1)
        S VL31=EXDT2  ; DatePoAssigned
        S VL32=$P(N16,U,0)  ;remarks
        S VL33E=$P(N23,U,3),VL33E1=$G(^PRC(442,+VL33E,0))
        S VL33E2=$P(VL33E1,U,1)
        S VL33=VL33E2  ; OldPoRec
        S VL34E=$P(N23,U,4),VL34E1=$G(^PRC(442,+VL34E,0))
        S VL34E2=$P(VL34E1,U,1)
        S VL34=$P(N23,U,4)  ; New PoRec
        S GN1=VL20_U_VL21_U_VL22_U_VL23_U_VL24_U_VL25_U_VL26_U_VL27_U
        S GN1A=GN1_VL28_U_VL29_U_VL30_U_VL31_U_VL32_U_VL33_U_VL34_U
        S GN1A=GN1A_VL8_U_VL9_U_AGAPO_U_VL6_U_VL7_U
        S ^TMP($J,"POMAST",POID,1)=GN1A
        ;
        ; build node 2
        S VL35E=$P(N23,U,14),VL35E1=$G(^PRC(440,+VL35E,0))
        S VL35E2=$P(VL35E1,U,1)
        S VL35=VL35E2  ; PcDo Vendor
        S PCUSR=$P(N23,U,17),PCUSR1=$G(^VA(200,+PCUSR,0))
        S VL36=$P(PCUSR1,U,1)  ; Pur Crd User
        S VL6=$P($G(^VA(200,+PCUSR,5)),"^")      ;Service - Pur Crd User
        S VL7=$S(VL6="":"",1:$$GET1^DIQ(49,+VL6_",",.01)) ;SVC ext - Pur Crd User
        S VL37=$P(N23,U,21)  ; Pur Cost
        S PCHDR=$P(N23,U,22),PCHDR1=$G(^VA(200,+PCHDR,0))
        S VL38=$P(PCHDR1,U,1)  ; Pur Card Hldr
        S VL8=$P($G(^VA(200,+PCHDR,5)),"^")      ;Service - Pur Crd Hldr
        S VL9=$S(VL8="":"",1:$$GET1^DIQ(49,+VL8_",",.01)) ;SVC ext - Pur Crd Hldr
        ; get ext. value for 2237
        S PC2237V=$P(N23,U,23),PC2237V1=$G(^PRCS(410,+PC2237V,0))
        S VL39=$P(PC2237V1,U,1)  ; Pcdo2237
        S VL40=$P(N0,U,15)  ; Total Amount
        S VL41=$P(N0,U,16)  ; Net amount
        ;
        S GN2=VL35_U_VL36_U_VL37_U_VL38_U_VL39_U_VL40_U_VL41_U
        S ^TMP($J,"POMAST",POID,2)=GN2_VL6_U_VL7_U_VL8_U_VL9_U
        S VL20=$P(N23,U,2) S:VL20'="" VL20=$E(VL20+17000000,1,4)      ;BBFY
        S VL21=$$FMTE^XLFDT($P($P(N23,U,5),".")) ;END DATE FOR SERVICE ORDER
        S VL19=$$GET1^DIQ(442,POID_",",30)       ;AUTO ACCRUE
        S VL22=$P(N23,U,7)                       ;SUBSTATION IEN
        S VL23=$P($G(^PRC(411,+VL22,0)),U,1)     ;SUBSTATION EXTERNAL
        S VL24=VN                                ;VENDOR IEN
        S VL25=$P($G(^PRC(440,+VN,3)),U,4)       ;VENDOR FMS CODE
        S VL26=$P($G(^PRC(440,+VN,3)),U,5)       ;VENDOR ALT-ADDR-IND
        S VL27=$P($G(^PRC(440,+VN,7)),U,12)      ;VENDOR D & B
        S VL28=$$GET1^DIQ(442,POID,21)           ;MONTH
        S VL29=$$GET1^DIQ(442,POID,22)           ;QUARTER
        S VL30=$$GET1^DIQ(442,POID,23)           ;LAST DIGIT OF FISCAL YEAR
        S GN1=VL20_U_VL21_U_VL19_U_VL22_U_VL23_U_VL24_U_VL25_U_VL26_U_VL27
        S ^TMP($J,"POMAST",POID,3)=GN1_U_VL28_U_VL29_U_VL30_U
        S N1=$G(^PRC(442,POID,8)) D
        . S VL20=$P(N1,U,1)                      ;ACTUAL 1358 BALANCE
        . S VL21=$P(N1,U,2)                      ;FISCAL 1358 BALANCE
        . S VL22=$P(N1,U,3)                      ;ESTIMATED 1358 BALANCE
        . S VL23=$$GET1^DIQ(442,POID_",",96.7)   ;BULLETIN SENT
        S VL24=$P($G(^PRC(442,POID,24)),U,3)     ;INTERFACE PACKAGE PREFIX
        S VL25=$P($G(^PRC(442,POID,18)),U,3)     ;DOCUMENT IDENTIFIER/COMMON #
        S VL26=$$GET1^DIQ(442,POID_",",116)      ;DO YOU WANT TO SEND THIS EDI?
        S GN1=VL20_U_VL21_U_VL22_U_VL23_U_VL24_U_VL25_U_VL26_U
        S ^TMP($J,"POMAST",POID,4)=GN1
        K PRCVAL,POIDC S POIDC=POID_","
        D GETS^DIQ(442,POIDC,"117:132","E","PRCVAL")
        S GN1=""
        F VL1=117:1:132 S GN1=GN1_$G(PRCVAL(442,POIDC,VL1,"E"))_U
        K PRCVAL,POIDC
        S GN1=GN1_$P($G(^PRC(442,POID,25)),U,17)_U   ; SEND TO FPDS?
        S $P(GN1,U,18,20)=PAPAB_U_$P(N23,U,17)_U_$P(N23,U,22)
        S $P(GN1,U,21)=$$GET^XPAR("SYS","PRCPLO REGIONAL ACQ CENTER",1,"Q")
        S ^TMP($J,"POMAST",POID,5)=GN1           ;NODE 25, TOTAL OF 17 FIELDS
        ;
        D PODISC^PRCHLO1A
        D POBOC^PRCHLO1A
        D POCMTS^PRCHLO1A
        D PORMKS^PRCHLO1A
        D PO2237^PRCHLO1A
        D POAMT^PRCHLO1A
        D POAMMD^PRCHLO1A
        D POPPTER^PRCHLO2A
        D POPART^PRCHLO2A
        D POOBL^PRCHLO2A
        D POPMET^PRCHLO2A
        D GPOITEM^PRCHLO2
        Q
PODISCH ; PO Discount Header File
        ; Header file for PO Discount Multiple
        W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
        W "DiscountIdNum^DiscountItem^PercentDollarAmount^"
        W "DiscountAmount^ItemCount^Contract^LineItem",!
        Q
