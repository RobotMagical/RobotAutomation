*** Settings ***
Library             SeleniumLibrary    screenshot_root_directory=${OUTPUT_DIR}/screenshot/${SUITE_NAME}
Resource            ../resources/login_func.resource
Resource            ../resources/search_func.resource
Library             ../../../../customlib/excelUtility.py
Library             DataDriver    file=${testdata_input_dir}${/}consumer_product_offer.xlsx   sheet_name=consumer_product_offer
Suite Setup         Show Execution Env Details
Test Template       consumer_product_offer
Library             Dialogs

*** Test Cases ***
Consumer product offer on contract:${CONTRACT_CODE} with PO:${PRODUCT_OFFER}

*** Keywords ***
consumer_product_offer
    [Arguments]  ${CONTRACT_CODE}	${PRODUCT_OFFER}

    Launch Application
    Login with Admin User
    Search Contract With CONTRACTCODE    ${CONTRACT_CODE}
    Navigate to solution unit    Product Offer - Service    Activate
    Wait Until Page Contains     Activate offer    timeout=1 min
    scroll element into view    //table//td/span[.='${PRODUCT_OFFER}']/../preceding-sibling::td
    Select Checkbox    //table//td/span[.='${PRODUCT_OFFER}']/../preceding-sibling::td//input
    #input text    ${dealer_id}    NN122
    click element    ${btn_service_finish}
    Wait Until Page Contains    Contract overview    timeout=1 min
    Validate scheduled request    Product offer Activate    ${PRODUCT_OFFER}
    #${EXEC_TIME}=    get_exec_time_stamp
    Logout Application
    [Teardown]   Close Application








