*** Settings ***
Library           MongoDBLibrary

*** Variables ***
${MDBHost}        localhost
${MDBPort}        ${52010}

*** Test Cases ***
Connect-Disconnect
    [Tags]    regression
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Disconnect from MongoDB Server
    Disconnect From MongoDB

Get MongoDB Databases
    [Tags]    regression
    Comment
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Retrieve a list of databases on the MongoDB server
    @{output} =    Get MongoDB Databases
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
    Disconnect From MongoDB

Save MongoDB Records
    [Tags]    regression
    ${MDBDB} =    Set Variable    foo
    ${MDBColl} =    Set Variable    foo
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Get current record count in collection to ensure that count increases correctly
    ${CurCount} =    Get MongoDB Collection Count    ${MDBDB}    ${MDBColl}
    ${output} =    Save MongoDB Records    ${MDBDB}    ${MDBColl}    {"timestamp":1, "msg":"Hello 1"}
    Log    ${output}
    Set Suite Variable    ${recordno1}    ${output}
    ${output} =    Save MongoDB Records    ${MDBDB}    ${MDBColl}    {"timestamp":2, "msg":"Hello 2"}
    Log    ${output}
    Set Suite Variable    ${recordno2}    ${output}
    ${output} =    Save MongoDB Records    ${MDBDB}    ${MDBColl}    {"timestamp":3, "msg":"Hello 3"}
    Log    ${output}
    Set Suite Variable    ${recordno3}    ${output}
    Comment    Verify that the record count increased by the number of records saved above (3)
    ${output} =    Get MongoDB Collection Count    ${MDBDB}    ${MDBColl}
    Should Be Equal    ${output}    ${${CurCount} + 3}
    Disconnect From MongoDB
