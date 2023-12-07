*** Settings ***
Library           DatabaseLibrary

*** Variables ***
${MDBHost}        localhost
${MDBPort}        ${52010}

*** Test Cases ***
Connect-Disconnect
    [Tags]    regression
    Comment    Connect to MongoDB Server
    Connect To Database     ${MDBHost}    ${MDBPort}
    Comment    Disconnect from MongoDB Server
    Disconnect From Database

Get MongoDB Databases
    [Tags]    regression
    Comment
    Connect To Database    ${MDBHost}    ${MDBPort}
    Comment    Retrieve a list of databases on the MongoDB server
    @{output} =    Get Variables
    Log Many    @{output}
    Comment    Verify the order in which the databases are returned by checking specific elements of return for exact db name
    Should Contain    @{output}[0]    test
    Should Contain    @{output}[1]    admin
    Should Contain    @{output}[2]    local
    Comment    Verify that db name is contained in the list output
    Should Contain    ${output}    admin
    Should Contain    ${output}    local
    Should Contain    ${output}    test
    Comment    Log as a list
    Log    ${output}
    Comment    Disconnect from MongoDB Server
    Disconnect From Database

Save MongoDB Records
   