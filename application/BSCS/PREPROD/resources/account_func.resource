*** Settings ***
Library     SeleniumLibrary
Variables   ../objrepo/bscs_objects.py
Resource    common_func.resource
Library     ../../../../customlib/common.py
Library    Dialogs
*** Keywords ***

Navigate to Consumer account
    Click Link          ${link_customers}
    Click Link          ${link_create_customer}
    Title Should Be     Create customer


Enter consumer account information
    [Arguments]  ${CUST_TYPE}
    Select From List By Label    ${account_template}     Postpaid
    Click Button    ${btn_account_template_filter}
    Select From List By Label    ${segment}     ${CUST_TYPE}
    Click Button    ${btn_segment_filter}

Enter consumer customer details
    [Arguments]  ${TITLE}  ${FIRST_NAME}  ${LAST_NAME}  ${ID}  ${EID_NUM}    ${NATIONALITY}  ${EMAIL}  ${BILL_LANGUAGE}    ${PREF_DELIVERY_METHOD}
    Select From List By Label  ${cons_title}  ${TITLE}
    ${current_ts}=               Get Time Stamp
    ${id_doc_num}=               Get random num  1000000  9999990
    ${id_num}=                   Get random num  100000000000  999999999999
    Input Text    ${cons_firstname}    ${FIRST_NAME}_${current_ts}
    Input Text    ${cons_lastname}    ${LAST_NAME}_${current_ts}
    Select From List By Label  ${id_type}  ${ID}
    Click Button    ${btn_id_type_filter}
    ${eid_number}=   set variable if   '${EID_NUM}' != '${EMPTY}' and '${ID}' != 'Passport'   ${EID_NUM}  784${id_num}
    Run Keyword If    '${ID}'=='Passport'
    ...    Enter Passport info    P${id_doc_num}  ${id_doc_num}
    ...  ELSE
    ...    Enter EID info    ${eid_number}

    Input Text    ${id_expiry_date}    05/05/2025
    Select From List By Label  ${cons_nationality}  ${NATIONALITY}
    Click Button    ${btn_nationality_filter}
    Input Text    ${cons_birth_date}    05/05/1990
    input text    ${id_issue_date}    05/05/2020
    Select Radio button value    contactFormGender    F
    Select From List By Label  ${monthly_income}  AED 3000 - 4999
    Input Text    ${cons_alt_num}    +971554433222
    Input Text    ${cons_email}         ${EMAIL}
    Select Radio button value    DirectMarketingEITC    true
    Select From List By Label  ${bill_lang}  ${BILL_LANGUAGE}
    Enter Billing address    ${PREF_DELIVERY_METHOD}
    Click Button    ${btn_next}
    Wait until page contains element  ${btn_finish}
    Title Should Be  Confirm
    Click Button    ${btn_finish}

Enter Passport info
    [Arguments]  ${doc_num}  ${visa_num}
    Input Text    ${id_number}    ${doc_num}
    Select From List By Label  ${visa_type}  Resident Visa
    Input Text    ${visa_number}    ${visa_num}
    Input Text    ${visa_expiry_date}    05/05/2023

Enter EID info
    [Arguments]  ${doc_num}
    Input Text    ${id_number}    ${doc_num}

Confirm and Get Consumer code
    Wait Until Page Contains Element   ${custcode_msg}
    ${textmessage}=    Get Text    ${custcode_msg}
    ${cons_custcode}=  get_code  ${textmessage}
    Log To Console    Customer code==>${cons_custcode}
    Capture Page Screenshot
    [Return]   ${cons_custcode}

Enter Billing address
     [Arguments]    ${bill_delivery_method}
     Input Text  ${tower}  TOW01
     Input Text  ${street}  STR01
     Input Text  ${unit_num}  UN01
     Input Text  ${pobox}  112233
     Select From List By Label    ${city}     Abu Dhabi
     Select From List By Label    ${state}    Abu Dhabi
     #Select From List By Label    ${pref_bill_delivery}    Mail and E-mail Only
     Select From List By Label    ${pref_bill_delivery}    ${bill_delivery_method}
     Click Button    ${btn_next}
     sleep  1
     ${current_title}=   Get Title
     Run Keyword If    '${current_title}' == 'Create customer'   Click Button    ${btn_next}
     Title Should Be  Create contract


Navigate to Contacts
    Click Link          ${link_large_accounts}
    Click Link          ${link_create_large_account}
    Click Link          ${link_create_top_level}
    Title Should Be     Contacts


Create L10 account
    [Arguments]  ${L10_SEGMENT}  ${FIRST_NAME}	${LAST_NAME}	${EMAIL}
    Navigate to Contacts
    Enter contacts information  ${L10_SEGMENT}  ${FIRST_NAME}	${LAST_NAME}	${EMAIL}
    Enter additional information
    Confirm account
    ${ent_l10_custcode}   Get enterprise account code   DATree
    [Return]   ${ent_l10_custcode}

Create L20 account
    [Arguments]  ${PAYMENT_RESPONSIBLE}  ${L20_SEGMENT}  ${FIRST_NAME}	${LAST_NAME}   ${EMAIL}

    ${current_ts}=               Get Time Stamp
    ${count} =    Get element count     ${plus_create_large_account}
    Run Keyword if  ${count}==1  Click Link    ${link_create_large_account}
    Click Link    ${link_create_level_or_sub}
    Title Should Be    Type and position
    Select From List By Label    ${type_position}   Level
    Click Button    ${type_position_filter}
    Click Button    ${btn_next}
    Title Should Be    Contacts
    Input Text    ${ent_contactno}   0552222229
    Input Text    ${ent_alt_num}   +971554433222
    Input Text    ${ent_firstname}   ${FIRST_NAME}_${current_ts}
    Input Text    ${ent_lastname}    ${LAST_NAME}_${current_ts}
    Input Text    ${emailid}         ${EMAIL}
    Click Button    ${btn_next}
    #Title Should Be  Duplicate customer check
    #Click Button    ${btn_newcust}
    Title Should Be  Billing and payment information
    Select From List By Label    ${segment}     ${L20_SEGMENT}
    Click Button    ${btn_segment_filter}
    sleep  1
    Enter Billing and Payment Information  ${PAYMENT_RESPONSIBLE}
    Confirm account
    ${ent_l20_custcode}   Get enterprise account code   DATree
    [Return]   ${ent_l20_custcode}

Create L40 account
    [Arguments]  ${ent_custcode}  ${PAYMENT_RESPONSIBLE}  ${L40_SEGMENT}  ${FIRST_NAME} 	${LAST_NAME}  ${EMAIL}
    ${count} =    Get element count     ${plus_create_large_account}
    ${current_ts}=               Get Time Stamp

    Run Keyword if  ${count}==1  Click Link    ${link_create_large_account}
    Click Link    ${link_create_level_or_sub}
    Title Should Be    Type and position
    Select From List By Label    ${type_position}   Subscriber
    Click Button    ${type_position_filter}
    Click Element    ${tree_plus_imag}

    Select account code  DATree  ${ent_custcode}
    Click Button    ${btn_next}
    Title Should Be    Contacts
     
     Input Text    ${ent_contactno}   0552222229
     Input Text    ${ent_alt_num}   +971554433222
     Input Text    ${ent_firstname}   ${FIRST_NAME}_${current_ts}
     Input Text    ${ent_lastname}    ${LAST_NAME}_${current_ts}
     Input Text    ${emailid}         ${EMAIL}
     
     Select From List By Label    ${subscriber_segment}     ${L40_SEGMENT}
     Click Button    ${btn_segment_filter}
     sleep  1
	 
	 run keyword if    '${L40_SEGMENT}'=='Budget SME Account'    Provide L40 Document ID 
     run keyword if    '${L40_SEGMENT}'=='Budget SOHO Account'   Provide L40 Document ID
     run keyword if    '${L40_SEGMENT}'=='Powered SME Account'   Provide L40 Document ID
     run keyword if    '${L40_SEGMENT}'=='Business-MPR'          Provide L40 Document ID
     run keyword if    '${L40_SEGMENT}'=='Business-IPR'          Provide L40 Document ID	 
     
     run keyword if    '${L40_SEGMENT}'!='Business-MPR'    Input Text    ${ent_CNAP}         ${FIRST_NAME}_${current_ts}
	 
     #${id_num}=                   Get random num  100000000000  999999999999
     #run keyword if    '${L40_SEGMENT}'=='Business-MPR'    Select From List By Label   ${ent_id_type}   Emirates ID
     #run keyword if    '${L40_SEGMENT}'=='Business-MPR'    Input Text    ${id_doc_number}     784${id_num}
     #run keyword if    '${L40_SEGMENT}'=='Business-MPR'    Input Text    ${ent_dob}         10/10/1980
     #run keyword if    '${L40_SEGMENT}'!='Business-MPR'    Input Text    ${ent_CNAP}         ${FIRST_NAME}_${current_ts}

     Click Button    ${btn_next}
     sleep  1
     #Click Button    ${btn_next}

    #Title Should Be  Duplicate customer check
    #Click Button    ${btn_newcust}
    Title Should Be  Billing and payment information
    Enter Billing and Payment Information  ${PAYMENT_RESPONSIBLE}
    Confirm account
    ${ent_l40_custcode}   Get enterprise account code   DATree
    Capture Page Screenshot
    Log To Console    L40 Account : ${ent_l40_custcode}
    [Return]   ${ent_l40_custcode}


Create L30 account
    [Arguments]  ${ent_custcode}  ${PAYMENT_RESPONSIBLE}  ${L30_SEGMENT}   ${FIRST_NAME} 	${LAST_NAME}  ${EMAIL}
    ${count} =    Get element count     ${plus_create_large_account}
    ${current_ts}=               Get Time Stamp
    Run Keyword if  ${count}==1  Click Link    ${link_create_large_account}
    Click Link    ${link_create_level_or_sub}
    Title Should Be    Type and position
    Select From List By Label    ${type_position}   Level
    Click Button    ${type_position_filter}
    Click Element    ${tree_plus_imag}
    Select account code  DATree  ${ent_custcode}
    Click Button    ${btn_next}
    Title Should Be    Contacts
    Input Text    ${ent_contactno}   0552222229
    Input Text    ${ent_alt_num}   +971554433222
    Input Text    ${ent_firstname}   ${FIRST_NAME}_${current_ts}
    Input Text    ${ent_lastname}    ${LAST_NAME}_${current_ts}
    Input Text    ${emailid}         ${EMAIL}
    Click Button    ${btn_next}
    #Title Should Be  Duplicate customer check
    #Click Button    ${btn_newcust}
    Title Should Be  Billing and payment information
    Select From List By Label    ${segment}     ${L30_SEGMENT}
    Click Button    ${btn_segment_filter}
    sleep  1
    Enter Billing and Payment Information  ${PAYMENT_RESPONSIBLE}
    Confirm account
    ${ent_l30_custcode}   Get enterprise account code   DATree
    [Return]   ${ent_l30_custcode}

Enter contacts information
     [Arguments]    ${L10_SEGMENT}  ${FIRST_NAME}	${LAST_NAME}	${EMAIL}
     Select From List By Label    ${nationality}    United Arab Emirates
     Select From List By Label    ${ent_id_type}   Company registration no.
     Input Text    ${establish_expiry}    02/02/2025
     ${establish_num_value}=      Get random num  100000  999999
     ${id_doc_value}=             Get random num  500000  999999
     ${current_ts}=               Get Time Stamp
     Input Text    ${establish_number}   ${establish_num_value}
     Input Text    ${id_doc_number}   ${id_doc_value}
     Input Text    ${ent_org}     TEST_ORG
     Input Text    ${ent_firstname}   ${FIRST_NAME}_${current_ts}
     Input Text    ${ent_lastname}    ${LAST_NAME}_${current_ts}
     Input Text    ${ent_contactno}   0552222229
     Input Text    ${ent_alt_num}   +971554433222
     Input Text    ${emailid}         ${EMAIL}
     Input Text    ${pincode}   1111
     Select From List By Label    ${city}     Dubai
     Select From List By Label    ${state}    Abu Dhabi
     Click Button    ${btn_next}
     sleep  2
     Title Should Be  Billing and payment information
     Select From List By Label    ${segment}     ${L10_SEGMENT}
     Click Button    ${btn_segment_filter}
     sleep  1
     Run Keyword if  '${L10_SEGMENT}'=='Budget SME Account'  Select From List By Label  ${sales_channel}  Direct
     Select From List By Label    ${billcycle}    BC32
     Click Button    ${btn_next}
     sleep  2
     Click Button    ${btn_next}
     Title Should Be  Payment arrangement
     Click Button    ${btn_next}
     Title Should Be  Additional information

Enter Billing and Payment Information
     [Arguments]   ${PAYMENT_RESPONSIBLE}
     Run Keyword If    '${PAYMENT_RESPONSIBLE}' == 'YES'   Select Checkbox    ${chkbox_payment_resp}
     Click Button    ${btn_next}
     sleep  1
     Click Button    ${btn_next}
     Title Should Be  Payment arrangement
     Click Button    ${btn_next}
     Title Should Be  Additional information
     Click Button    ${btn_next}


Enter additional information
     #mgr1
    Select From List By Label  name:TEXT05  Du Corp
    Click Button  name:JSP_ACCOUNT_MANAGER_FILTER_BUTTON
    #mgr2
    Select From List By Label  name:TEXT07  Du Corp
    Select From List By Label  name:TEXT10  Direct
    #outletcode
    Select From List By Label  name:TEXT12  DU CORP
    #marketcode
    Input Text   name:DataField11  MKT001
    #salesagentcode
    Input Text   name:DataField13  SAK001
    ${count} =    Get element count     ${revenue_segment}
    Run Keyword if  ${count}==1  Select From List By Label    ${revenue_segment}    Du Corp
    #Run Keyword If  '${env}' == 'MAJOR'  Select From List By Label  name:revSegment  Du Corp
    Click Button    name:SuNextStepButton
    Title Should Be  Confirm

Confirm account
    Select From List By Label  name:CS_STATUS  Active
    Click Button  name:enableCustomerStatusSelection
    Select From List By Label  name:RS_CODE  activation
    Click Button  name:SuFinishButton
    Title Should Be  Large account overview


Get enterprise account code
    [Arguments]   ${tree-table}
    ${index} =     common_func.Scan Web Table  ${tree-table}    Customer code
    ${rowcnt}=     common_func.Find Row Number   ${tree-table}
    #${ent_l10_custcode}      Get Table Cell   class:${tree-table}    2    ${index}
    ${ent_custcode}          Get Table Cell   class:${tree-table}    ${rowcnt}    ${index}
    Capture Element Screenshot    class:${tree-table}

    #Click Link    link:${ent_custcode}
    #Sleep    1 seconds
    [Return]   ${ent_custcode}


Select account code
    [Arguments]   ${tree-table}  ${ent_custcode}
    ${dot_count}=  get_char_count  .  ${ent_custcode}
    Run Keyword if  ${dot_count}==3  Expand L20 Level  ${tree-table}  ${ent_custcode}
    ${rowcnt}=     common_func.Find Row Number   ${tree-table}
    ${rowcnt} =    Evaluate    ${rowcnt} + 1
    ${row} =    Set Variable    ${2}
    FOR    ${row}    IN RANGE    ${row}  ${rowcnt}
           ${curr_custcode}          Get Table Cell   class:${tree-table}    ${row}    2
           ${value} =    Evaluate   ${row} - 2
           Run Keyword If    '${curr_custcode}' == '${ent_custcode}'  click element   xpath://input[@name='TCB_Tree_Result'][@value='${value}']
           Exit For Loop If    '${curr_custcode}' == '${ent_custcode}'
    END

Expand L20 Level
    [Arguments]   ${tree-table}  ${in_custcode}
    @{datalist}=  get_account_level_code 	${in_custcode}
    ${rowcnt}=     common_func.Find Row Number   ${tree-table}
    ${rowcnt} =    Evaluate    ${rowcnt} + 1

    ${row} =    Set Variable    ${2}
    FOR    ${row}    IN RANGE    ${row}  ${rowcnt}
           ${curr_custcode}          Get Table Cell   class:${tree-table}    ${row}    2
           ${value} =    Evaluate    ${row} - 2
           Run Keyword If    '${curr_custcode}' == '${datalist}[1]'  click element   xpath://input[@name='TCB_Tree_Result'][@value='${value}']/../following-sibling::td//img[contains(@src,'treetable_plus')]

           Exit For Loop If    '${curr_custcode}' == '${datalist}[1]'
    END
    #click element   xpath://input[@name='TCB_Tree_Result'][@value='${value}']/../following-sibling::td//img[contains(@src,'treetable_plus')]


Provide L40 Document ID 
     ${id_num}=                   Get random num  100000000000  999999999999
     ${visa_num}=               Get random num  1000000  9999990
     Select From List By Label   ${ent_id_type}   Emirates ID
     Input Text    ${id_doc_number}     784${id_num}
     Input Text    ${ent_dob}         10/10/1980
     Input Text    ${visa_number}    ${visa_num}




