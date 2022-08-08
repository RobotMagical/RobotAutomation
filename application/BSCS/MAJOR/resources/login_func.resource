*** Settings ***
Library     SeleniumLibrary
Variables   ../objrepo/bscs_objects.py
Resource    common_func.resource

*** Keywords ***

Launch Application
    [Arguments]    ${app_name}=BSCS
    Log   Launch ${app_name} application in ${Browser} browser
    Open Browser   ${URL}    ${Browser}    options=add_argument("--ignore-certificate-errors");add_argument("--ignore-ssl-errors");add_argument("--log-level=3");add_experimental_option("excludeSwitches", ["enable-logging"])
    #uncomment below for headless
    #Open Browser   ${URL}    ${Browser}    options=add_argument("--ignore-certificate-errors");add_argument("--ignore-ssl-errors");add_argument("--headless");add_argument("--log-level=3");add_experimental_option("excludeSwitches", ["enable-logging"])
    Maximize Browser Window
    Title Should Be    Login


Login with Admin User
   Input Text    ${username}    ${admin_user}
   Input Text    ${password}    ${admin_pwd}
   Click Button    ${btn_ok}
   Title Should Be    Start page
   Sleep    2 seconds

Login with MRAWDHA User
   [Arguments]   ${customer_type}=CONSUMER
   Input Text    ${username}    ${consumer_user}
   Input Text    ${password}    ${consumer_pwd}
   Click Button    ${btn_ok}
   Title Should Be    Select sales partner
   Click Element    xpath://td/span[contains(text(),'${customer_type}')]/../../td[1]
   Click Button   ${btn_suok}
   Title Should Be    Start page
   Sleep    2 seconds

Logout Application
   Click Link    ${link_logout}
   Click Button    ${btn_yes}
   Element Should Contain    ${msg_logout}    logged out


Close Application
    #run keyword if any tests failed    capture page screenshot
    Close Browser


