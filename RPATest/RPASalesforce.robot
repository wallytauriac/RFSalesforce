*** Settings ***
Library  RPA.Salesforce
Library  SeleniumLibrary
Library  ExcelLibrary
Library  DataDriver    .xlsx
Library  RPASalesforce.py
Resource  Resource.robot

Documentation    Salesforce Script for object data REST API Testing
#robot -d ARAPI\Results ARAPI\RPASalesforce.robot

Suite Setup  Open Salesforce and Launch Excel
Suite Teardown  Stop Excel
Test Template  REST API Scenarios

*** Variables ***


*** Test Cases ***
Test Case - ${testcase} - ${description}


*** Keywords ***
REST API Scenarios
    [Arguments]  ${sObject}  ${operators}  ${value1}  ${value2}  ${value3}
    Define Variables as Global  ${sObject}  ${operators}  ${value1}  ${value2}  ${value3}
    Setup Data  ${sObject}  ${operators}  ${value1}  ${value2}  ${value3}
    Run Keyword If  '${operators}'=='Create'  Create Object  ${sObject}  ${operators}  ${value1}  ${value2}  ${value3}
    Run Keyword If  '${operators}'=='Get'  Get Object  ${sObject}  ${operators}  ${value1}
    Run Keyword If  '${operators}'=='Update'  Update Object  ${sObject}  ${operators}  ${value1}  ${value2}
    Run Keyword If  '${operators}'=='Query'  Query Object  ${sObject}  ${operators}  ${value1}
    Run Keyword If  '${operators}'=='Describe'  Describe Object  ${sObject}


