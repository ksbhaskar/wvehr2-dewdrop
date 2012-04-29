DG53726A ;ALB/RMM Enable Audit Settings for Patient File; 08/02/2006
 ;;5.3;Registration;**726**;Aug 13, 1993;Build 4
 ;
 Q
 ;
EN ; This patch will turn AUDITING ON for the following fields:
 ;
 ;  .01     NAME
 ;  .02     SEX
 ;  .03     DATE OF BIRTH
 ;  .05     MARITAL STATUS
 ;  .08     RELIGIOUS PREFERENCE
 ;  .09     SOCIAL SECURITY NUMBER
 ;  .111    STREET ADDRESS [LINE 1]
 ;  .1112   ZIP+4
 ;  .112    STREET ADDRESS [LINE 2]
 ;  .113    STREET ADDRESS [LINE 3]
 ;  .114    CITY
 ;  .115    STATE
 ;  .117    COUNTY
 ;  .131    PHONE NUMBER [RESIDENCE]
 ;  .132    PHONE NUMBER [WORK]
 ;  .211    K-NAME OF PRIMARY NOK
 ;  .219    K-PHONE NUMBER
 ;  .2403   MOTHER'S MAIDEN NAME
 ;  .301    SERVICE CONNECTED?
 ;  .302    SERVICE CONNECTED PERCENTAGE
 ;  .31115  EMPLOYMENT STATUS
 ;  .313    CLAIM NUMBER
 ;  .323    PERIOD OF SERVICE
 ;  .351    DATE OF DEATH
 ;  391     TYPE
 ;  1901    VETERAN (Y/N)?
 ;  994     MULTIPLE BIRTH INDICATOR
 ;  991.01  INTEGRATION CONTROL NUMBER
 ;  991.02  ICN CHECKSUM
 ;  991.03  CIRN MASTER OF RECORD
 ;  991.04  LOCALLY ASSIGNED ICN
 ;  991.05  SUBSCRIPTION CONTROL NUMBER
 ;  991.06  CMOR ACTIVITY SCORE
 ;  991.07  SCORE CALCULATION DATE
 ;  .01     ICN HISTORY (SUB-FILE: 2.0992)
 ;
 N FLDNUM
 F FLDNUM=.01,.02,.03,.05,.08,.09,.111,.1112 D TURNON^DIAUTL(2,FLDNUM) W !,"Adding AUDIT to field #",FLDNUM
 F FLDNUM=.112,.113,.114,.115,.117,.131,.132 D TURNON^DIAUTL(2,FLDNUM) W !,"Adding AUDIT to field #",FLDNUM
 F FLDNUM=.211,.219,.2403,.301,.302,.31115,.313,.323 D TURNON^DIAUTL(2,FLDNUM) W !,"Adding AUDIT to field #",FLDNUM
 F FLDNUM=.351,391,1901,994,991.01,991.02 D TURNON^DIAUTL(2,FLDNUM) W !,"Adding AUDIT to field #",FLDNUM
 F FLDNUM=991.03,991.04,991.05,991.06,991.07 D TURNON^DIAUTL(2,FLDNUM) W !,"Adding AUDIT to field #",FLDNUM
 F FLDNUM=.01 D TURNON^DIAUTL(2.0992,FLDNUM) W !,"Adding AUDIT to sub-file 2.0992, field #",FLDNUM
 Q
