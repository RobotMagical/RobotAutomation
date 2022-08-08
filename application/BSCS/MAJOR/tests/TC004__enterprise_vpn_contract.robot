*** Settings ***
Library             SeleniumLibrary    screenshot_root_directory=${OUTPUT_DIR}/screenshot/${SUITE_NAME}
Resource            ../resources/login_func.resource
Resource            ../resources/search_func.resource
Resource            ../resources/contract_func.resource
Library             ../../../../customlib/common.py
Library             ../../../../customlib/excelUtility.py
Library             DataDriver    file=${testdata_input_dir}/enterprise_vpn_contract.xlsx   sheet_name=enterprise_vpn_contract
Suite Setup         Show Execution Env Details
Test Template       enterprise_vpn_contract

*** Test Cases ***
Enterprise vpn contract creation with ${ENT_CODE}


*** Keywords ***
enterprise_vpn_contract
    [Arguments]     ${ENT_CODE}

    Launch Application
    Login with Admin User
    Search Enterprise account    ${ENT_CODE}
    Navigate to VPN Owner contract   ${ENT_CODE}
    Enter VPN contract attributes   ${ENT_CODE}
    ${VPN_CONTRACT_CODE}=   Get Contract code
    ${VPN_CONTRACT_STATUS}=   Get Contract Status
    Log To Console    VPN Contract code==>${VPN_CONTRACT_CODE},Status==>${VPN_CONTRACT_STATUS}
    Should Be Equal	${VPN_CONTRACT_STATUS}	Active	 Expected Status is Active but found  ${VPN_CONTRACT_STATUS}

    ${EXEC_TIME}=    get_exec_time_stamp
    Logout Application
    [Teardown]  Close Application
    Append Result To Outputexcel   ${testdata_output_dir}/enterprise_vpn_contract  enterprise_vpn_contract  ENT_CODE=${ENT_CODE},VPN_CONTRACT_CODE=${VPN_CONTRACT_CODE},CONTRACT_STATUS=${VPN_CONTRACT_STATUS},EXEC_TIME=${EXEC_TIME}
    update_result_to_inputexcel    ${testdata_input_dir}/enterprise_contract  enterprise_contract  ENT_CODE=${ENT_CODE}


