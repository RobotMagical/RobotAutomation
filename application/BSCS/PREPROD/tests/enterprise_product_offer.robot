*** Settings ***
Library             SeleniumLibrary    screenshot_root_directory=${OUTPUT_DIR}/screenshot/${SUITE_NAME}
Resource            ../resources/login_func.resource
Resource            ../resources/search_func.resource
Library             ../../../../customlib/excelUtility.py
Library             DataDriver    file=${testdata_input_dir}${/}enterprise_product_offer.xlsx   sheet_name=enterprise_product_offer
Suite Setup         Show Execution Env Details
Test Template       enterprise_product_offer
Library             Dialogs


*** Test Cases ***
Enterprise product offer on contract:${CONTRACT_CODE} with PO:${PRODUCT_OFFER}

*** Keywords ***
enterprise_product_offer
    [Arguments]  ${CONTRACT_CODE}	${PRODUCT_OFFER}

    Launch Application
    Login with Admin User
    Search Contract With CONTRACTCODE    ${CONTRACT_CODE}
    Navigate to solution unit    Product Offer - Service    Activate
#    scroll element into view    link:Product Offer - Service
#    Click Link    link:Product Offer - Service
#    sleep    2
#    Click Link    //a[.='Activate'][contains(@href,'ProductOfferActivate')]
    Wait Until Page Contains     Activate offer    timeout=1 min
    scroll element into view    //table//td/span[.='${PRODUCT_OFFER}']/../preceding-sibling::td
    Select Checkbox    //table//td/span[.='${PRODUCT_OFFER}']/../preceding-sibling::td//input
    input text    ${dealer_id}    NN122
    input text    ${activity_number}    ACT112
    click element    ${btn_service_finish}
    Wait Until Page Contains    Contract overview    timeout=1 min
    pause execution
    Validate scheduled request    Product offer Activate    ${PRODUCT_OFFER}


    #${EXEC_TIME}=    get_exec_time_stamp
    Logout Application
    [Teardown]   Close Application

Expand service tree
    ${plus_elements}    Get WebElements    //table[@class='DATree']//img[contains(@src,'plus')]
    FOR    ${plus_element}    IN    ${plus_elements}
       click element   ${plus_element}
    END

OLDValidate scheduled request

     [Arguments]    ${expected_target}
     ${header_name}    Get Web Table Headerlist    DATable
     ${row_count}    Find Row Number   DATable
     FOR   ${row}    IN RANGE    2    ${row_count}
        ${target_value}    Get Table Cell   class:DATable    ${row}    ${header_name}[Target]

        Return From Keyword If    '${target_value}'=='${expected_target}'    MATCH_FOUND
     END
     Return From Keyword    NO_MATCH






