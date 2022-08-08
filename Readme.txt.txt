##Test Data Preparation using Robot framework##

***Usage*** 
1.BSCS application script
 run_bscs_suite.py [-h] [-env ENVIRONMENT] [-tag TAGS] RobotFile

2.DSP application script
 run_dsp_suite.py [-h] [-env ENVIRONMENT] [-tag TAGS] RobotFile

3.RobotFile means actual robot script file (.robot) present under below path:
  application/<APP_NAME>/<ENVIRONMENT>/tests

  - You can specify full robot filename or *regular expr* to identify name uniquely.
  - For example if robot file name=TC004__enterprise_vpn_contract ,then TC004* or  *vpn* suffice to trigger script.


** Change Log **


= 1.6 =29-Sep-2021
* UPDATED
   A.Folder - application/DSP/MAJOR/resources
   --- File:account_func.resource ,Keyword:Create L40 account 
       ---	Handled for Powered SME account

= 1.5 =29-Sep-2021
* UPDATED
   A.Folder - application/DSP/MAJOR/resources
   --- File:account_func.resource ,Keyword:Create L40 account 
       ---	Document ID is mandatory now for non-MPR and same is handled now.

= 1.4 =08-Sep-2021
* UPDATED
   A.Folder - application/DSP/MAJOR/resources
   --- File:account_func.resource ,Keyword:Create L40 account        

= 1.3 =31-Aug-2021
* UPDATED
   A.Folder - application/DSP/MAJOR/resources
   --- File:account_func.resource ,Keyword:Create L40 account 
       ---	mandatory CNAP field is added now.
   

= 1.2 =30-Aug-2021
* UPDATED
   A.Folder - application/DSP/MAJOR/objrepo and application/DSP/MAJOR/resources
   --- New objects and keyword added to support use case "register_authorized_signatory" 
   --- TC004 additional prepaid flow keyword added
   B.Folder - application/DSP/MAJOR/testdata
   --- Input sheet "register_AS" enhanced with additional columns ${MSISDN} and ${EMAIL}
   C.Folder - application/DSP/MAJOR/tests
   --- Script "register_authorized_signatory" enhanced to support mobile and email input and OTP validation

= 1.1 =24-Aug-2021
* UPDATED
   A.Folder - application/BSCS/MAJOR/testdata/input
    --- File : consumer_account.xlsx
        (1) New column ${EID_NUM} introduced to provide EID as per user
	(2) New column ${PREF_DELIVERY_METHOD} introduced to provide preferred delivery 
    --- File : consumer_contract.xlsx and enterprise_contract.xlsx
	(1) Modified columnname from ${IMSI} to ${SIM}
  
  B.Folder - application/BSCS/MAJOR/tests
    --- File : TC001__consumer_account.robot/TC002__consumer_contract.robot/TC005__enterprise_contract.robot
        (1) Modified script to support new/modified excel file parameter 
	


= 1.0 =23-Aug-2021
* BASELINE
  - BSCS and DSP test data creation script delivered.


