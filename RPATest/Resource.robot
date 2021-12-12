*** Settings ***
Library  SeleniumLibrary
Library  ExcelLibrary
Library  DataDriver    .xlsx


*** Variables ***
${username}  Salesforce User Name
${password}  Salesforce Password
${api_token}  Salesforce Security Token




*** Keywords ***
Open Salesforce and Launch Excel
    Open Salesforce
    Launch Excel


Open Salesforce
    Auth With Token
    ...         username=${username}
    ...         password=${password}
    ...         api_token=${api_token}

Launch Excel

    Open Excel Document  filename=C:/Users/wally/Documents/Python/Demo/MFRest/ARAPI/RPASalesforce.xlsx  doc_id=docid   keep_vba=false
    Get Sheet  sheet_name=TCases
    ${sObject}=  Read Excel Cell  row_num=2  col_num=2  sheet_name=TCases
    ${testcase}  Read Excel Column  col_num=1  row_offset=0  max_num=0  sheet_name=TCases
    ${description}  Read Excel Column  col_num=4  row_offset=0  max_num=0  sheet_name=TCases
    ${operators}  Read Excel Column  col_num=3  row_offset=0  max_num=0  sheet_name=TCases

    #Open Browser  about:blank  ${browser}

Stop Excel

    Close All Excel Documents

Define Variables as Global
    [Arguments]  ${sObject}  ${operators}  ${value1}  ${value2}  ${value3}
    Set Global Variable  ${sObject}
    Set Global Variable  ${operators}
    Set Global Variable  ${value1}
    Set Global Variable  ${value2}
    Set Global Variable  ${value3}


Get Object
    [Arguments]  ${sObject}  ${operators}  ${value1}
    ${data}=      Get Salesforce Object By Id   ${sObject}  ${value1}
    Log Many  "Object Record Data: \n"  ${data}


Update Object
    [Arguments]  ${sObject}  ${operators}  ${value1}  ${value2}
    ${response}=  Update Salesforce Object   ${sObject}  ${newID}  ${data}
    Log Many  "Update Request Status: "  ${response}
    ${data1}=      Get Salesforce Object By Id   ${sObject}  ${newID}
    Log Many  "Object Updated Record Data: \n"  ${data1}

Create Object
    [Arguments]  ${sObject}  ${operators}  ${value1}  ${value2}  ${value3}
    ${record}=  Create Salesforce Object   ${sObject}  ${datanew}
    Run Keyword If  '${record}[success]'=='False'  Error Bypass
    Log Many  "New Record Status: "  ${record}
    ${newID}=  Set Variable  ${record}[id]

    ${data1}=      Get Salesforce Object By Id   ${sObject}  ${newID}
    Log Many  "Object New Record Data: \n"  ${data1}
    Set Global Variable  ${newID}

Error Bypass
    Log Many  "Create Failed: Duplicate"  ${passed}

Query Object
    [Arguments]  ${sObject}  ${operators}  ${value1}
    ${query}=  Salesforce Query  ${value1}
    Log Many  "Object Query Results: "  ${query}
    ${query}=  Salesforce Query Result As Table  ${value1}
    Log Many  "Object Query Results Table: "  ${query}

Describe Object
    [Arguments]  ${sObject}
    ${result}=  Describe Salesforce Object  ${sObject}
    Log Many  "Object Describe Results: "  ${result}


Setup Data
    [Arguments]  ${sObject}  ${operators}  ${value1}  ${value2}  ${value3}
    Run Keyword If  '${operators}'=='Update'  Dictionary Build 1
    Run Keyword If  '${operators}'=='Create'  Dictionary Build 2

Dictionary Build 1
    ${data}=  Create Dictionary  key=value
    Remove From Dictionary  ${data}  key
    ${key1}  ${val1}  Split Key Value Pair  ${value1}
    ${key2}  ${val2}  Split Key Value Pair  ${value2}
    Set To Dictionary  ${data}  ${key1}  ${val1}
    Set To Dictionary  ${data}  ${key2}  ${val2}
    Log Many  "Data Build 1: "  ${data}
    Set Global Variable  ${data}

Dictionary Build 2
    ${datanew}=  Create Dictionary  key=value
    Remove From Dictionary  ${datanew}  key
    ${key1}  ${val1}  Split Key Value Pair  ${value1}
    ${key2}  ${val2}  Split Key Value Pair  ${value2}
    ${key3}  ${val3}  Split Key Value Pair  ${value3}
    Set To Dictionary  ${datanew}  ${key1}  ${val1}
    Set To Dictionary  ${datanew}  ${key2}  ${val2}
    Set To Dictionary  ${datanew}  ${key3}  ${val3}
    Log Many  "Data Build 2: "  ${datanew}
    Set Global Variable  ${datanew}
