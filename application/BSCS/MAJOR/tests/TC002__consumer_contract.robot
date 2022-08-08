*** Settings ***
Library             SeleniumLibrary    screenshot_root_directory=${OUTPUT_DIR}/screenshot/${SUITE_NAME}
Resource            ../resources/login_func.resource
Resource            ../resources/search_func.resource
Resource            ../resources/contract_func.resource
Library             ../../../../customlib/excelUtility.py
Library             DataDriver    file=${testdata_input_dir}${/}consumer_contract.xlsx   sheet_name=consumer_contract
Suite Setup         Show Execution Env Details
Test Template       consumer_contract


*** Test Cases ***
Consumer contract creation with rateplan:${RATE_PLAN}

*** Keywords ***
consumer_contract
    [Arguments]  ${CUST_CODE}	${RATE_PLAN}	${MSISDN}	${SIM}

    Launch Application
    Login with MRAWDHA User     CONSUMER
    Search Consumer account   ${CUST_CODE}
    Select Rate plan and attributes  ${RATE_PLAN}
    ${CONS_SIM}    Run Keyword If  '${SIM}'=='${EMPTY}'    Select SIM with POS dealer id
    ...   ELSE  Set Variable  ${SIM}
    ${POS_DELAER_ID}  Select POS dealer id   ${CONS_SIM}
    #...   ELSE  Set Variable  ${${POS_DELAER_ID}}
    ${CONS_MSISDN}  Run Keyword If  '${MSISDN}'=='${EMPTY}'    Select MSISDN
    ...   ELSE  Set Variable  ${MSISDN}
    #${CONS_SIM}  ${CONS_MSISDN}   Select SIM and MSISDN
    Assign SIM and MSISDN  ${CONS_SIM}  ${CONS_MSISDN}    ${POS_DELAER_ID}
    Confirm contract
    ${CONTRACT_CODE}=   Get Contract code
    ${CONTRACT_STATUS}=   Get Contract Status
    Log To Console    Contract code==>${CONTRACT_CODE},Status==>${CONTRACT_STATUS}
    Should Be Equal	${CONTRACT_STATUS}	Active	 Expected Status is Active but found  ${CONTRACT_STATUS}
    ## get error from gmd_detailed_response if status is not active
    ${EXEC_TIME}=    get_exec_time_stamp
    Logout Application
    [Teardown]   Close Application
    Append Result To Outputexcel   ${testdata_output_dir}/consumer_contract  consumer_contract  CUST_CODE=${CUST_CODE},MSISDN=${CONS_MSISDN},SIM=${CONS_SIM},CONTRACT_CODE=${CONTRACT_CODE},RATE_PLAN=${RATE_PLAN},CONTRACT_STATUS=${CONTRACT_STATUS},EXEC_TIME=${EXEC_TIME}









