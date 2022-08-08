*** Settings ***
Library             SeleniumLibrary    screenshot_root_directory=${OUTPUT_DIR}/screenshot/${SUITE_NAME}
Resource            ../resources/login_func.resource
Resource            ../resources/search_func.resource
Resource            ../resources/contract_func.resource
Library             ../../../../customlib/excelUtility.py
Library             DataDriver    file=${testdata_input_dir}${/}enterprise_contract.xlsx   sheet_name=enterprise_contract
Suite Setup         Show Execution Env Details
Test Template       enterprise_contract


*** Test Cases ***
Enterprise contract creation with rate plan:${RATE_PLAN}

*** Keywords ***
enterprise_contract
    [Arguments]  ${ENT_CODE}	${RATE_PLAN}	${MSISDN}	${SIM}    ${BMP_FLAVOUR}  ${BMP_COMMITMENT}

    Launch Application
    Login with Admin User
    Search Enterprise account   ${ENT_CODE}
    Select Enterprise Rate plan and attributes  ${ENT_CODE}    ${RATE_PLAN}    ${BMP_FLAVOUR}
    ${ENT_SIM}  Run Keyword If  '${SIM}'=='${EMPTY}'    Select ENT SIM
    ...   ELSE  Set Variable  ${SIM}
    #${POS_DELAER_ID}  Select POS dealer id   ${ENT_SIM}
    ${ENT_MSISDN}  Run Keyword If  '${MSISDN}'=='${EMPTY}'    Select ENT MSISDN
    ...   ELSE  Set Variable  ${MSISDN}
    #${CONS_SIM}  ${CONS_MSISDN}   Select SIM and MSISDN
    Assign SIM and MSISDN  ${ENT_SIM}  ${ENT_MSISDN}    
    Confirm Enterprise Contract    ${BMP_COMMITMENT}

    ${CONTRACT_CODE}=   Get Contract code
    ${CONTRACT_STATUS}=   Get Contract Status
    Log To Console    Enterprise Contract code==>${CONTRACT_CODE},Status==>${CONTRACT_STATUS}
    Should Be Equal	${CONTRACT_STATUS}	Active	 Expected Status is Active but found  ${CONTRACT_STATUS}
    ## get error from gmd_detailed_response if status is not active
    ${EXEC_TIME}=    get_exec_time_stamp

    Logout Application
    #[Teardown]   Close Application
    Append Result To Outputexcel   ${testdata_output_dir}/enterprise_contract  enterprise_contract  ENT_CODE=${ENT_CODE},MSISDN=${ENT_MSISDN},SIM=${ENT_SIM},CONTRACT_CODE=${CONTRACT_CODE},RATE_PLAN=${RATE_PLAN},CONTRACT_STATUS=${CONTRACT_STATUS},EXEC_TIME=${EXEC_TIME}









