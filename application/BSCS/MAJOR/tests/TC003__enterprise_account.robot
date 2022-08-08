*** Settings ***
Library             SeleniumLibrary    screenshot_root_directory=${OUTPUT_DIR}/screenshot/${SUITE_NAME}
Resource            ../resources/login_func.resource
Resource            ../resources/search_func.resource
Resource            ../resources/account_func.resource
Library             ../../../../customlib/excelUtility.py
Library             DataDriver    file=${testdata_input_dir}/enterprise_account.xlsx   sheet_name=enterprise_account
Suite Setup         Show Execution Env Details
Test Template       enterprise_account

*** Test Cases ***
Enterprise account creation with ${L40_SEGMENT} having L40PR:${L40_PR}


*** Keywords ***
enterprise_account
    [Arguments]     ${ENT_CODE}  ${L20}  ${L20_PR}  ${L30}	${L30_PR}	${L40_PR}	${L10_SEGMENT} 	${L40_SEGMENT}	${FIRST_NAME}	${LAST_NAME}	${EMAIL}

    Launch Application
    Login with Admin User
    ${ent_l10_custcode}=   Run Keyword if    '${ENT_CODE}' == '${EMPTY}'       Create L10 account  ${L10_SEGMENT}  ${FIRST_NAME}	${LAST_NAME}	${EMAIL}
    Run Keyword if    '${ENT_CODE}' != '${EMPTY}'       Search Enterprise account    ${ENT_CODE}
    ${dot_count}=    get_char_count  .  ${ENT_CODE}
    ${ent_l10_custcode}=   set variable if   '${ENT_CODE}' != '${EMPTY}' and '${dot_count}' == '1'   ${ENT_CODE}  ${ent_l10_custcode}

    ${L20}=   set variable if   '${ENT_CODE}' != '${EMPTY}' and '${dot_count}' == '2'   NO  ${L20}
    ${ent_l20_custcode}=   Run Keyword if    '${L20}' == 'YES'                 Create L20 account  ${L20_PR}   ${L10_SEGMENT}  ${FIRST_NAME}	${LAST_NAME}  ${EMAIL}
    ${ent_l20_custcode}=   set variable if   '${ENT_CODE}' != '${EMPTY}' and '${dot_count}' == '2'   ${ENT_CODE}  ${ent_l20_custcode}

    ${current_custcode}=    set variable if
    ...                     '${ent_l20_custcode}' == 'None'   ${ent_l10_custcode}   ${ent_l20_custcode}


    ${ent_l30_custcode}=   Run Keyword if    '${L30}' == 'YES'                 Create L30 account  ${current_custcode}  ${L30_PR}   ${L10_SEGMENT}   ${FIRST_NAME} 	${LAST_NAME}   ${EMAIL}
    ${current_custcode}=    set variable if
    ...                     '${ent_l30_custcode}' == 'None'   ${current_custcode}   ${ent_l30_custcode}



    ${ent_l40_custcode}=   Create L40 account   ${current_custcode}  ${L40_PR}  ${L40_SEGMENT}   ${FIRST_NAME} 	${LAST_NAME}   ${EMAIL}
    ${EXEC_TIME}=    get_exec_time_stamp
    log to console   L40 account code=> ${ent_l40_custcode}
    Logout Application
    [Teardown]  Close Application
    Append Result To Outputexcel   ${testdata_output_dir}/enterprise_account  enterprise_account  ENT_L10_CODE=${ent_l10_custcode},ENT_L20_CODE=${ent_l20_custcode},ENT_L30_CODE=${ent_l30_custcode},ENT_L40_CODE=${ent_l40_custcode},L40_PR=${L40_PR},L40_SEGMENT=${L40_SEGMENT},EXEC_TIME=${EXEC_TIME}
    # Run below based on VPN flag=Yes/No
    update_result_to_inputexcel    ${testdata_input_dir}/enterprise_vpn_contract  enterprise_vpn_contract  ENT_CODE=${ent_l40_custcode}

