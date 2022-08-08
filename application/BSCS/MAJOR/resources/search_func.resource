*** Settings ***
Library     SeleniumLibrary
Variables   ../objrepo/bscs_objects.py
Resource    common_func.resource

*** Keywords ***
Search Contract with MSISDN
    [Arguments]   ${msisdn}
    Click Link    ${link_contracts}
    Click Link    ${link_searchcontract}
    Wait Until Page Contains    Search for contract
    Select From List By Value    ${resource_type}   DIRNUM
    Input Text    ${resource_num}    ${msisdn}
    Click Button    ${btn_search}
    Scroll Element Into View     ${table_search}
    Capture Element Screenshot    ${table_search}
    Validate search and navigate to contract overview page  Resource no.   ${msisdn}

Search Contract with CUSTCODE
    [Arguments]   ${custcode}
    Click Link    ${link_contracts}
    Click Link    ${link_searchcontract}
    Wait Until Page Contains    Search for contract
    Input Text    ${cust_num}  ${custcode}
    Click Button    ${btn_search}
    Scroll Element Into View     ${table_search}
    Capture Element Screenshot    ${table_search}
    Validate search and navigate to contract overview page  Customer code   ${custcode}

Search Contract with CONTRACTCODE
    [Arguments]   ${contract_num}
    Click Link    ${link_contracts}
    Click Link    ${link_searchcontract}
    Wait Until Page Contains    Search for contract
    Input Text    ${contract_code}  ${contract_num}
    Click Button    ${btn_search}
    Scroll Element Into View     ${table_search}
    Capture Element Screenshot    ${table_search}
    Validate search and navigate to contract overview page  Contract code   ${contract_num}

Search Consumer account
    [Arguments]   ${cons_custcode}
    Click Link    ${link_customers}
    Click Link    ${link_search_customer}
    Wait Until Page Contains    Search for customer
    Input Text    ${cust_num}  ${cons_custcode}
    Click Button    ${btn_cons_accnt_search}
    Scroll Element Into View     ${table_search}
    Capture Element Screenshot    ${table_search}
    Validate search and navigate to account overview page  Customer code   ${cons_custcode}

Search Enterprise account
    [Arguments]   ${ent_custcode}
    Click Link    ${link_large_accounts}
    Click Link    ${link_searchlevel}
    Wait Until Page Contains    Search for level or subscriber
    Input Text    ${cust_num}  ${ent_custcode}
    Click Button    ${btn_accnt_search}
    Scroll Element Into View     ${table_search}
    Capture Element Screenshot    ${table_search}
    Validate search and navigate to account overview page  Customer code   ${ent_custcode}

Validate search and navigate to account overview page
    [Arguments]  ${search_field}    ${search_value}
     ${index} =    Scan Web Table  DATable    ${search_field}
    Table Cell Should Contain    ${table_search}    2    ${index}     ${search_value}

    ${account_code}      Get Table Cell   ${table_search}    2    ${index}
    Click Link    link:${account_code}
    Sleep    1 seconds
    #Click Link    link:${account_code}
    #Capture Page Screenshot
    #Click Link    link:Large account root: ${account_code}

Validate search and navigate to contract overview page
    [Arguments]  ${search_field}    ${search_value}
     ${index} =    Scan Web Table  DATable    ${search_field}
    Table Cell Should Contain    ${table_search}    2    ${index}     ${search_value}
    ${index} =    Scan Web Table  DATable    Contract code
    ${co_code}      Get Table Cell   ${table_search}    2    ${index}
    Click Link    link:${co_code}
    Sleep    1 seconds
    Capture Page Screenshot

BACKUP Scan Web Table
    [Arguments]    ${table_locator}    ${table_header}
    ${rownum}      Get Element Count    xpath://table[@class='${table_locator}']/tbody/tr
    ${colnum}      Get Element Count    xpath://table[@class='${table_locator}']/tbody/tr[1]/th
    @{headers}     Get WebElements      xpath://table[@class='${table_locator}']/tbody/tr[1]/th
    ${index} =     Find Index     ${table_header}     @{headers}
    [Return]    ${index}


BACKUP Find Index
   [Arguments]    ${element}    @{items}
   ${index} =    Set Variable    ${1}
   FOR    ${item}    IN    @{items}
           Return From Keyword If    '${item.text}' == '${element}'    ${index}
           #${index} =    Set Variable    ${index + 1}
           ${index} =    evaluate    ${index} + 1
   END
   Return From Keyword    ${-1}



