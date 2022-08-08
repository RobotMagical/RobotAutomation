*** Settings ***
Library            SeleniumLibrary
Variables          ../../../../customlib/initialize_env_params.py   ${env}  ${app_name}
Library            Collections

*** Variables ***
${Browser}    chrome
${env}        MAJOR
${app_name}   BSCS
${testdata_input_dir}    application/${app_name}/${env}/testdata/input
${testdata_output_dir}    application/${app_name}/${env}/testdata/output
${custom_lib}         ../../../../customlib




*** Keywords ***

Scan Web Table
    [Arguments]    ${table_locator}    ${table_header}
    ${rownum}      Get Element Count    xpath://table[@class='${table_locator}']/tbody/tr
    ${colnum}      Get Element Count    xpath://table[@class='${table_locator}']/tbody/tr[1]/th
    @{headers}     Get WebElements      xpath://table[@class='${table_locator}']/tbody/tr[1]/th
    ${index} =     Find Index     ${table_header}     @{headers}
    [Return]    ${index}


Find Index
   [Arguments]    ${element}    @{items}
   ${index} =    Set Variable    ${1}
   FOR    ${item}    IN    @{items}
           Return From Keyword If    '${item.text}' == '${element}'    ${index}
           ${index} =    Evaluate    ${index} + 1
   END
   Return From Keyword    ${-1}


Get Web Table Headerlist
    [Arguments]    ${table_locator}

    @{headers}     Get WebElements      xpath://table[@class='${table_locator}']/tbody/tr[1]/th

    ${i} =    Set Variable    ${1}
    ${HD}    create dictionary
    FOR    ${item}    IN    @{headers}
           Set To Dictionary    ${HD}    ${item.text}    ${i}
           ${i} =    Evaluate    ${i} + 1
    END
    [Return]      ${HD}

Find Row Number
    [Arguments]    ${table_locator}
    ${rownum}      Get Element Count    xpath://table[@class='${table_locator}']/tbody/tr
    [Return]      ${rownum}



Select Radio button value
    [Arguments]   ${radiogrp_name}   ${radio_value}
    click element   xpath://input[@name='${radiogrp_name}'][@value='${radio_value}']

Show Execution Env Details
    Log To Console    Running with ...Environment=${env},Application=${app_name},Browser=${Browser}${\n}
    Set Suite Metadata  Application    ${app_name}
    Set Suite Metadata  Environment    ${env}


Get scheduled request status
     [Arguments]    ${expected_target}
     ${header_name}    Get Web Table Headerlist    DATable
     ${row_count}    Find Row Number   DATable
     FOR   ${row}    IN RANGE    2    ${row_count}
        ${target_value}    Get Table Cell   class:DATable    ${row}    ${header_name}[Target]
        ${status}    Get Table Cell   class:DATable    ${row}    ${header_name}[Status]
        ${exec_date}    Get Table Cell   class:DATable    ${row}    ${header_name}[Execution date]
        Return From Keyword If    '${target_value}'=='${expected_target}'    ${status}
     END
     Return From Keyword    NO_MATCH



