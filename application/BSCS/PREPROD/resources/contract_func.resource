*** Settings ***
Library     SeleniumLibrary
Variables   ../objrepo/bscs_objects.py
Resource    common_func.resource
Resource    db_func.resource
Library     ../../../../customlib/common.py



*** Keywords ***

Navigate to VPN Owner contract
    [Arguments]     ${ENT_CODE}
    Click Link      link:${ENT_CODE}
    Click Button    ${btn_create_contract}
    Click Link      ${link_VPN_owner_contract}
    Title should be  Select rate plan and services

Enter VPN contract attributes
    [Arguments]   ${ENT_CODE}
    Click Button    ${btn_rateplan_filter}
    Select From List By Label  ${service_pkg}  IN VPN SP
    Click Button    ${btn_servicepkg_filter}
    Click Link      ${link_vpn_admin}
    Click Link      ${link_vpn_rating}
    Select From List By Label  ${vpn_rating}  Apply 100% Employee Discount
    Click Button    ${btn_suok}
    Click Button    ${btn_close}
    Click Button    ${btn_assign}
    @{data}=  get_vpn_details   ${ENT_CODE}
    ${account_vpn_name}=  Set Variable  ${data}[0]
    ${account_vpn_public_num}=  Set Variable  ${data}[1]
    Input Text      ${vpn_name}    ${account_vpn_name}
    Click Button    ${btn_vpn_search}
    Click Button    ${btn_suok}
    Title should be   Assign VPN public number
    #DB activity start
    DB CONNECT
    Create VPN Entry in database  ${account_vpn_name}  ${account_vpn_public_num}
    Validate record in directory number table  ${account_vpn_public_num}
    DB DISCONNECT
    #DB activity end
    Input Text    ${vpn_public_number}   ${account_vpn_public_num}
    Click Button  ${btn_vpn_search}
    Click Button  ${btn_suok}
    Click Button    ${btn_next}
    Title should be   Define contract attributes
    Select From List By Label  ${vpn_status}  Active
    Click Button  ${btn_status_filter}
    Select From List By Label  ${reason}  activation
    Click Button  ${btn_finish}

Get Contract code
    Wait Until Page Contains Element   ${contractcode_msg}
    ${textmessage}=    Get Text    ${contractcode_msg}
    ${contract_code}=  get_code  ${textmessage}
    [Return]   ${contract_code}

Get Contract Status
    FOR	 ${var}  IN RANGE  1  12
        ${current_status}      Get Table Cell   ${contract_table_search}    4    2
        Exit For Loop If	'${current_status}' == 'Active'
        #Log To Console    ${current_status}
        ${var}=  Evaluate    ${var} + ${1}
        sleep  2
        Click Link   ${link_contract_overview}
        # if application error click again - - to be added
        ${count} =    Get element count     ${contractcode_msg}
        Run Keyword if  ${count}==0   Click Link   ${link_contract_overview}
        sleep  2

    END
    Capture Page Screenshot
    [Return]   ${current_status}

Confirm Contract
    Select Checkbox     ${chkbox_accnt_owner}
    Click Button        ${btn_next}
    Title Should Be    Confirm
    Select From List By Label  name:CO_STATUS  Active
    Click Button  name:JSP_ENABLE_SELECTION_BUTTON
    Select From List By Label  name:REASON  activation
    Click Button  ${btn_finish}

Confirm Enterprise Contract
    [Arguments]    ${bmp_commit_value}
    ${count} =    Get element count     ${bmp_commitment_val}
    Run Keyword if  ${count}==1    Select From List By Label    ${bmp_commitment_val}    ${bmp_commit_value}
    Click Button        ${btn_next}
    Title Should Be    Confirm
    Select From List By Label  name:CO_STATUS  Active
    Click Button  name:JSP_ENABLE_SELECTION_BUTTON
    Select From List By Label  name:REASON  activation
    Input Text    ${activity_number}    ACTN0005
    Click Button  ${btn_finish}

Get enterprise contract code
    [Arguments]   ${tree-table}
    ${index} =     common_func.Scan Web Table  ${tree-table}    Customer code
    ${rowcnt}=     common_func.Find Row Number   ${tree-table}
    #${ent_l10_custcode}      Get Table Cell   class:${tree-table}    2    ${index}
    ${ent_custcode}          Get Table Cell   class:${tree-table}    ${rowcnt}    ${index}
    Capture Element Screenshot    class:${tree-table}
    #Click Link    link:${ent_custcode}
    #Sleep    1 seconds
    [Return]   ${ent_custcode}

Select Rate plan and attributes
    [Arguments]   ${RP_VALUE}
    Click Link          ${link_contracts}
    Click Link          ${link_create_contract}
    Title Should Be     Create contract
    Select From List By Label  ${rateplan_template}  ${RP_VALUE}
    Click Button        ${btn_rp_template_filter}
    Wait Until Page Contains Element    ${btn_sim_search}    timeout=30sec
    ${count} =    Get element count     ${link_implicit_fup}
    Run Keyword if  ${count}==1    Set implicit FUP and BC number

    ${count} =    Get element count     ${link_preferred_num}
    Run Keyword if  ${count}==1   Set preferred number details

Select Enterprise Rate plan and attributes
    [Arguments]   ${ENT_CODE}    ${rateplan}    ${bmp_flavour}
    Click Link          link:${ENT_CODE}
    Click Link          ${link_contracts}
    Click Link          ${link_create_contract}
    Title Should Be     Create contract
    Select From List By Label  ${rateplan_template}  ${rateplan}
    Click Button        ${btn_rp_template_filter}
    Wait Until Page Contains Element    ${btn_sim_search}    timeout=30sec
    ${count} =    Get element count     ${link_implicit_fup}
    Run Keyword if  ${count}==1    Set implicit FUP and BC number
    Click Link          ${link_bcp}
    Click Link          ${link_vpn_number}
    Click Button        ${btn_suok}
    Click Button        ${btn_close}
    ${count} =    Get element count     ${link_plan_flavour}
    Run Keyword if  ${count}==1   Set bmpflavour details    ${bmp_flavour}
    Input Text      ${sales_agentcode}    SA001


Assign SIM and MSISDN
    [Arguments]   ${IN_SIM}  ${IN_MSISDN}    
    Click Button        ${btn_sim_search}
    Input Text    ${sim_input}    ${IN_SIM}
    #Input Text    ${pos_input}    ${IN_POS_DEALER_ID}
    Click Button    ${btn_input_search}
    Click Button        ${btn_suok}
    Click Button        ${btn_msisdn_search}
    Title Should Be     Assign directory number
    Input Text    ${msisdn_input}    ${IN_MSISDN}
    Click Button        ${btn_input_search}
    Input Text    ${btn_msisdn_input_inner}    ${IN_MSISDN}
    Click Button    ${btn_input_search}
    Click Button        ${btn_suok}
    Click Button        ${btn_suok}
    Select From List By Label  ${main_dir_num}  ${IN_MSISDN}
    Click Button        ${btn_set_dir_num}
    #Select Checkbox     ${chkbox_accnt_owner}
    #Click Button        ${btn_next}

Set preferred number details
    Click Link    ${link_preferred_num}
    Click Link    ${link_national_num1}
    Input Text    ${national_num}    Null
    Click Button        ${btn_suok}
    Click Link    ${link_national_num2}
    Input Text    ${national_num}    Null
    Click Button        ${btn_suok}
    Click Link    ${link_national_num3}
    Input Text    ${national_num}    Null
    Click Button        ${btn_suok}
    Click Button        ${btn_close}

Set implicit FUP and BC number
    Click Link          ${link_implicit_fup}
    Click Link          ${link_implicit_quota}
    Click Button        ${btn_suok}
    Click Link          ${link_implicit_bc_number}
    Click Button        ${btn_suok}
    Click Button        ${btn_close}

Set bmpflavour details
    [Arguments]    ${flavour}
    Click Link    ${link_plan_flavour}
    Click Link    ${link_flavour}
    Select From List By Label    ${flavour_list}    ${flavour}
    Click Button        ${btn_suok}
    Click Button        ${btn_close}

Select SIM and MSISDN
    DB CONNECT
    ${simvalue}=  Get Consumer SIM from database
    ${msisdnvalue}=  Get Consumer MSISDN from database
    DB DISCONNECT
    [Return]  ${simvalue}  ${msisdnvalue}

select MSISDN
    DB CONNECT
    ${msisdnvalue}=  Get Consumer MSISDN from database
    DB DISCONNECT
    [Return]  ${msisdnvalue}

Select SIM
    DB CONNECT
    ${simvalue}=  Get Consumer SIM from database
    DB DISCONNECT
    [Return]  ${simvalue}

Select SIM with POS dealer id
    DB CONNECT
    ${simvalue}    Get Consumer SIM with POS dealer id from database
    DB DISCONNECT
    [Return]  ${simvalue}

Select ENT SIM with POS dealer id
    DB CONNECT
    ${simvalue}    Get Enterprise SIM with POS dealer id from database
    DB DISCONNECT
    [Return]  ${simvalue}

Select POS dealer id
    [Arguments]    ${simvalue}
    DB CONNECT
    ${posvalue}    Get POS dealer id   ${simvalue}
    DB DISCONNECT
    [Return]  ${posvalue}


select ENT MSISDN
    DB CONNECT
    ${msisdnvalue}=  Get Enterprise MSISDN from database
    DB DISCONNECT
    [Return]  ${msisdnvalue}

Select ENT SIM
    DB CONNECT
    ${simvalue}=  Get Enterprise SIM from database
    DB DISCONNECT
    [Return]  ${simvalue}

