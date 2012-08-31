ECXSTOP ;ALB/DHE Stop Codes/Clinic Stops ; 6/16/09 11:41am
        ;;3.0;DSS EXTRACTS;**120**;Dec 22, 1997;Build 43
        ;
STOP(CODE,TYPE,CLIEN,DATE)      ;api to return stop code information
        ;
        ;input:
        ;   code: stop code IEN in #40.7
        ;   type: type REQUIRED (Stop Code, DSS Stop Code, Credit Stop Code, DSS Credit Stop Code)
        ;  clien: clinic IEN in #728.44 (optional)
        ;   date: date of action (default today) (optional)
        ;
        ;ecxerr(err) and warning(wrn) are existing arrays 
        ;make sure they exist!
        ;
        N XCODE,INACT,RTYPE,IEN
        Q:'CODE
        Q:(TYPE="")
        S CLIEN=$G(CLIEN)
        I $G(DATE)="" S DATE=DT
        S ERR=$G(ERR)+1,WRN=$G(WRN)+1
        K:ERR=1 ECXERR K:WRN=1 WARNING
        S IEN=$O(^DIC(40.7,"C",CODE,0)) I +IEN'>0 S ECXERR(ERR)=CODE_" is Invalid for "_TYPE S ERR=ERR+1 Q
        I '$D(^DIC(40.7,IEN,0)) S ECXERR(ERR)=CODE_" is Invalid for "_TYPE S ERR=ERR+1 Q
        I (+CODE'=CODE),($L(CODE)>3) S ECXERR(ERR)=CODE_" is an Invalid "_TYPE S ERR=ERR+1 Q
        S INACT=$P(^DIC(40.7,IEN,0),"^",3) I INACT,((DT>INACT)!(DT=INACT)) S ECXERR(ERR)=CODE_" is an Inactive "_TYPE S ERR=ERR+1
        S RTYPE=$P(^DIC(40.7,IEN,0),"^",6)
        I (TYPE="Stop Code"),(RTYPE'=("P"))&(RTYPE'=("E")) S ECXERR(ERR)=CODE_" This stop code can only be used in the secondary position." S ERR=ERR+1
        I TYPE="DSS Stop Code",(RTYPE'=("P"))&(RTYPE'=("E")) S ECXERR(ERR)=CODE_" This stop code can only be used in the secondary position." S ERR=ERR+1
        I TYPE="Credit Stop Code",(RTYPE'=("S"))&(RTYPE'=("E")) S ECXERR(ERR)=CODE_" This stop code can only be used in the primary position." S ERR=ERR+1
        I TYPE="DSS Credit Stop Code",(RTYPE'=("S"))&(RTYPE'=("E")) S ECXERR(ERR)=CODE_" This stop code can only be used in the primary position." S ERR=ERR+1
        ;I ($P(^DIC(40.7,IEN,0),"^",7)>DT) S WARNING(WRN)=CODE_" This "_TYPE_" has a Restriction Date in the future." S WRN=WRN+1
        I (TYPE="Stop Code"),$G(CLIEN),(CODE=$P(^ECX(728.44,CLIEN,0),"^",3)) S ECXERR(ERR)=CODE_" "_TYPE_" should not match Credit Stop Code." S ERR=ERR+1
        I (TYPE="DSS Stop Code"),$G(CLIEN),(CODE=$P(^ECX(728.44,CLIEN,0),"^",5)) S ECXERR(ERR)=CODE_" "_TYPE_" should not match DSS Credit Stop Code." S ERR=ERR+1
        ;WARNING  ; check for inactivations in future
        I INACT>DT S WARNING(WRN)=CODE_" This "_TYPE_" has a pending Inactive Date." S WRN=WRN+1
        Q
