*** Settings ***
Library    AppiumLibrary
Resource    ../Resources/Common.robot

*** Keywords ***

Add Driving status
    changestatus.enable debug mode
    changestatus.connect to simulator

Add OffDuty status
    ${count}=   Get Matching XPath Count    xpath=//*[@text="OffDuty"]
    Run Keyword If   ${count} == 0    run keywords    changestatus.stop moving      changestatus.change status to offduty
    ...     ELSE    log to console    Already with Off Duty status

Add OnDuty ND status
    ${count}=   Get Matching XPath Count    xpath=//*[@text="OnDuty ND"]
    Run Keyword If   ${count} == 0       changestatus.change status to onduty nd
    ...     ELSE    log to console    Already with On Duty ND status

Add Sleeper status
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Sleeper"]
    Run Keyword If   ${count} == 0       changestatus.change status to sleeper
    ...     ELSE    log to console    Already with Sleeper status

Add Personal Conveyance status
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Personal Conveyance"]
    Run Keyword If   ${count} == 0       changestatus.change status to personal conveyance
    ...     ELSE    log to console    Already with Personal Conveyance status

Add Start Break status
    ${count}=   Get Matching XPath Count    xpath=//*[@text="END BREAK"]
    ${count2}=   Get Matching XPath Count    xpath=//*[@text="OffDuty"]
    Run keyword if   ${count} > 0       log to console    Already in Break
    ...     ELSE IF     ${count2} == 0      changestatus.change status to start break
    ...     ELSE    run keywords    changestatus.change status to onduty nd     AND     ChangeStatus.Change status to Start Break

Driving Routine One
    [Arguments]    ${user}  ${password}     ${time}
    Common.Open vistracks
    Common.Accept license
    Common.Login with Driver data    ${user}      ${password}
    ChangeStatus.Verify if there are uncertified logs
    Common.Add Driving status
    sleep     ${time}
    changestatus.stop moving
    Common.Add OnDuty ND status
    sleep     ${time}
    Common.Add Personal Conveyance status
    sleep     ${time}
    ChangeStatus.Remove Pesonal Conveyance
    sleep    10s
    Common.Add Yard Moves status
    sleep     ${time}
    ChangeStatus.Remove Yard Moves
    sleep    10s
    Common.Add Sleeper status
    sleep     ${time}
    Common.Add Start Break status
    sleep     ${time}
    ChangeStatus.End Break and change status to OnDuty ND
    sleep     10s
    Common.Add OffDuty status
    ChangeStatus.Disconnect from simulator
    Common.Logout

Driving Routine two
    [Arguments]    ${user}  ${password}     ${time}
    Common.Open vistracks
    Common.Accept license
    Common.Login with Driver data    ${user}      ${password}
    ChangeStatus.Dismiss Uncertified Logs
    ChangeStatus.Dismiss Pending Requests
    ChangeStatus.Dismiss Uncertified Logs
    Common.Add Driving status
    sleep     ${time}
    changestatus.stop moving
    Common.Add OnDuty ND status
    sleep     ${time}
    #Common.Add Personal Conveyance status
    #sleep     ${time}
    #ChangeStatus.Remove Pesonal Conveyance
    #sleep    10s
    #Common.Add Yard Moves status
    #sleep     ${time}
    #ChangeStatus.Remove Yard Moves
    #sleep    10s
    Common.Add Sleeper status
    sleep     ${time}
    Common.Add Start Break status
    sleep     ${time}
    ChangeStatus.End Break and change status to OnDuty ND
    sleep     10s
    Common.Add OffDuty status
    ChangeStatus.Disconnect from simulator
    ChangeStatus.Dismiss Uncertified Logs
    ChangeStatus.Dismiss Pending Requests
    ChangeStatus.Dismiss Uncertified Logs
    Common.Logout

Driving Routine Unid Events
    [Arguments]    ${user}  ${password}
    log to console    ${user}
    log to console      ${password}
    log to console    ${user}
    log to console      ${password}
    Common.Open vistracks
    Common.Accept license
    Common.Login with Driver data    ${user}      ${password}
    ChangeStatus.Dismiss Uncertified Logs
    ChangeStatus.Dismiss Pending Requests
    ChangeStatus.Dismiss Uncertified Logs
    Common.Add Driving status
    sleep    2s
    Common.Logout
    ChangeStatus.Wait for warning to stop vehicle
    login.input driver user     ${user}
    login.input driver password     ${password}
    login.click login button
    sleep    7s
    ##new
    ChangeStatus.Dismiss Uncertified Logs
    ChangeStatus.Dismiss Pending Requests
    ChangeStatus.Dismiss Uncertified Logs
    ##
    ChangeStatus.Cancel VIN Mismatch
    ChangeStatus.Dismiss Uncertified Logs
    ChangeStatus.Dismiss Pending Requests
    ChangeStatus.Dismiss Uncertified Logs
    ChangeStatus.Dismiss Pending Requests
    ChangeStatus.Change status to OffDuty
    Common.Logout

Driving Routine LogIn LogOut
    [Arguments]    ${user}  ${password}
    log to console    ${user}
    log to console      ${password}
    log to console    ${user}
    log to console      ${password}
    Common.Open vistracks
    Common.Accept license
    Common.Login with Driver data    ${user}      ${password}
    ChangeStatus.Dismiss Uncertified Logs
    ChangeStatus.Dismiss Pending Requests
    ChangeStatus.Dismiss Uncertified Logs
    sleep    2s
    Common.Logout

Driving Routine Adding Co-driver
    [Arguments]    ${user}  ${password}  ${time}   ${codriver}
    log to console    ${user}
    log to console      ${password}
    log to console    ${user}
    log to console      ${password}
    Common.Open vistracks
    Common.Accept license
    Common.Login with Driver data    ${user}      ${password}
    ChangeStatus.Dismiss Uncertified Logs
    ChangeStatus.Dismiss Pending Requests
    ChangeStatus.Dismiss Uncertified Logs
    Common.Add OffDuty status
    Common.Add Co-driver    ${codriver}      ${password}
    log to console    Co-driver added
    sleep    1s
    Common.Change Co-driver to driver      ${password}
    log to console    Change Co-driver to driver
    sleep    1s
    Common.View Co-driver    ${password}
    log to console     Change to Co-driver's view
    sleep    1s
    Common.View Current Driver    ${password}
    log to console    Change to Current driver view
    sleep    1s
    Common.Logout Co-driver
    log to console    Logout Co-driver with Co-Driver Management Modal
    Common.Logout




