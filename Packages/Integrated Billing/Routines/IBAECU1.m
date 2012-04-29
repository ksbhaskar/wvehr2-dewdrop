IBAECU1 ;ALB/BGA-LONG TERM IDENTIFICATION UTILITIES ; 09-OCT-01
 ;;2.0;INTEGRATED BILLING;**164,171,176,332,364**;21-MAR-94;Build 7
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ; This is a utility program to support IBAECU calls
 ;
 ;
 ;
STDATE() ;  -- legislative start date for Long Term Care Billing
 ; Start Date is June 17,2002 when the LTC REG becomes Law
 ;
 Q 3020617  ;
 ;
 ;
 ;
STOP ; Listed below are stop codes and their associated LTC charge type
C190 ;;DG LTC OPT ADHC NEW
C319 ;;DG LTC OPT GEM NEW
 ;;DG LTC OPT RESPITE NEW
 ;;
 ;
 ;
SPEC ; Listed below are the treating specialties and their charge type
T31 ;;DG LTC INPT GEM NEW
T32 ;;DG LTC INPT GEM NEW
T33 ;;DG LTC INPT GEM NEW
T34 ;;DG LTC INPT GEM NEW
T35 ;;DG LTC INPT GEM NEW
T37 ;;DG LTC INPT DOM NEW
T42 ;;DG LTC INPT NHCU NEW
T43 ;;DG LTC INPT NHCU NEW
T44 ;;DG LTC INPT NHCU NEW
T45 ;;DG LTC INPT NHCU NEW
T46 ;;DG LTC INPT NHCU NEW
T47 ;;DG LTC INPT RESPITE NEW
T64 ;;DG LTC INPT NHCU NEW
T66 ;;DG LTC INPT NHCU NEW
T67 ;;DG LTC INPT NHCU NEW
T68 ;;DG LTC INPT NHCU NEW
T69 ;;DG LTC INPT NHCU NEW
T80 ;;DG LTC INPT NHCU NEW
T81 ;;DG LTC INPT NHCU NEW
T83 ;;DG LTC INPT RESPITE NEW
T85 ;;DG LTC INPT DOM NEW
T86 ;;DG LTC INPT DOM NEW
T87 ;;DG LTC INPT DOM NEW
T88 ;;DG LTC INPT DOM NEW
T95 ;;DG LTC INPT NHCU NEW
T96 ;;DG LTC INPT NHCU NEW
T100 ;;DG LTC INPT NHCU NEW
T101 ;;DG LTC INPT NHCU NEW
T102 ;;DG LTC INPT GEM NEW
 ;;
 ;
 ;
