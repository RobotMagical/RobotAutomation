*** Settings ***
Library             SeleniumLibrary    screenshot_root_directory=${OUTPUT_DIR}/screenshot/${SUITE_NAME}
Resource            ../resources/login_func.resource
Resource            ../resources/account_func.resource
Library             ../../../../customlib/excelUtility.py
Library             DataDriver    file=${testdata_input_dir}/consumer_account.xlsx     sheet_name=consumer_account
Suite Setup         Show Execution Env Details
Test Template       consumer_account

*** Test Cases ***
Consumer account creation with ID:${ID}

*** Keywords ***
consumer_account
    [Arguments]  ${CUSTOMER_TYPE}	${ID}	${EID_NUM}    ${TITLE}    ${FIRST_NAME}	 ${LAST_NAME}	${NATIONALITY}	${EMAIL}	${BILL_LANG}    ${PREF_DELIVERY_METHOD}

    Launch Application
    Login with MRAWDHA User     CONSUMER
    Navigate to Consumer account
    Enter consumer account information  ${CUSTOMER_TYPE}
    Enter consumer customer details  ${TITLE}  ${FIRST_NAME}  ${LAST_NAME}  ${ID}  ${EID_NUM}   ${NATIONALITY}  ${EMAIL}  ${BILL_LANG}    ${PREF_DELIVERY_METHOD}
    ${cons_custcode}=    Confirm and Get Consumer code
    ${EXEC_TIME}=    get_exec_time_stamp
    Logout Application
    [Teardown]   Close Application
    Append Result To Outputexcel   ${testdata_output_dir}/consumer_account   consumer_account  CUST_CODE=${cons_custcode},ID=${ID},FIRST_NAME=${FIRST_NAME},LAST_NAME=${LAST_NAME},NATIONALITY=${NATIONALITY},EXEC_TIME=${EXEC_TIME}

    update_result_to_inputexcel    ${testdata_input_dir}/consumer_contract  consumer_contract  CUST_CODE=${cons_custcode}






