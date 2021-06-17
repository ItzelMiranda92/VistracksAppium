*** Settings ***
Library    AppiumLibrary

*** Keywords ***

Dismiss Uncertified Logs
    Add missing data Location
    Switch To Intrastate Driving Rules
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Uncertified Log(s)"]
    Run Keyword If   ${count} > 0    click element    xpath=//*[@text="OK"]


Add missing data Location
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Clear Missing Data Elements: Location"]
    #Run Keyword If   ${count} > 0    click element    xpath=//*[@text="Cancel"]
    Run Keyword If   ${count} > 0     Input Text    id=com.vistracks:id/locationET    TestLocation
    Run Keyword If   ${count} > 0     Click Element    id=com.vistracks:id/missingLocationsBtn
    Run Keyword If   ${count} > 0     sleep      2s
    Run Keyword If   ${count} > 0     go back
    Run Keyword If   ${count} > 0     sleep      2s
    Run Keyword If   ${count} > 0     go back



Dismiss Pending Requests
    sleep    1.5s
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Action"]
    Run Keyword If   ${count} > 0    click element    xpath=//*[@text="CANCEL"]


Wait for warning to stop vehicle
    wait until element is visible    xpath=//*[@text="You are not currently logged in, stop the vehicle"]       timeout=20
    click element    xpath=//*[@text="OK"]
    sleep    1s

Cancel VIN Mismatch
    wait until element is visible    xpath=//*[@text="VIN Mismatch"]        timeout=60
    click element    xpath=//*[@text="CANCEL"]

Swipe and search
    swipe by percent    40     80   50     20   1000
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Simulator"]
    Run Keyword If   ${count} > 0    click element      xpath=//*[@text="Simulator"]
        ...   ELSE    Swipe and search

#-----------------------------------------#
Verify if there are uncertified logs
    Switch To Intrastate Driving Rules
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Uncertified Log(s)"]
    Run Keyword If   ${count} > 0    certify log
    ...   ELSE   no logs to certify

Certify log
    ${elements}=   Get Webelements    xpath=//*[@text="Certify"]
    click Element    ${elements}[0]
    wait until element is visible    xpath=//*[@text="AGREE"]      timeout=10
    ${emailLog} =    Run Keyword And Return Status    Checkbox Should Be Selected   id=com.vistracks:id/confirmationDialogCheckbox
    Run Keyword If   ${emailLog}    click element    id=com.vistracks:id/confirmationDialogCheckbox
    click Element    xpath=//*[@text="AGREE"]
    wait until element is visible    id=android:id/message      timeout=10
    wait until page does not contain element       id=android:id/message   timeout=30
    sleep    2s
    verify if there are uncertified logs

No logs to certify
    log to console   No logs to certify

Connect to Simulator
    wait until element is visible    xpath=//android.widget.TextView[@content-desc="VBUS connection indicator"]      timeout=10
    click Element    xpath=//android.widget.TextView[@content-desc="VBUS connection indicator"]
    wait until element is visible   xpath=//*[@text="MANUAL CONNECTION"]    timeout=10
    click element    xpath=//*[@text="MANUAL CONNECTION"]
    Sleep     3s
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Simulator"]
    Run Keyword If   ${count} > 0    sleep    0.5s
        ...   ELSE   Swipe and search
    click element    xpath=//*[@text="NEXT"]
    wait until element is visible    xpath=//*[@text="YES"]      timeout=10
    click element    xpath=//*[@text="YES"]
    sleep    7s
    ${count0}=   Get Matching XPath Count    xpath=//*[@text="Switch To Intrastate Driving Rules"]
    Run Keyword If   ${count0} > 0    click element    id=com.vistracks:id/standardPositiveBtn
    sleep    2s
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Warning!"]
    Run Keyword If   ${count} > 0    click element    xpath=//*[@text="OK"]
    sleep     2s
    ${count}=   Get Matching XPath Count    xpath=//*[@text="CONNECT ANYWAY"]
    Run Keyword If   ${count} < 1     go back
    Run Keyword If   ${count} < 1     sleep    1s
    wait until element is visible    xpath=//*[@text="CONNECT ANYWAY"]      timeout=10
    click element    xpath=//*[@text="CONNECT ANYWAY"]
    sleep    5s
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Warning!"]
    Run Keyword If   ${count} > 0    click element    xpath=//*[@text="OK"]
    sleep    2s
    ${count}=   Get Matching XPath Count    xpath=//*[@text="REMAINING TO VIOLATION"]
    Run Keyword If   ${count} > 0    click element    xpath=//*[@text="OK"]
    log to console    Connected to simulator

Enable debug mode
    wait until element is visible    xpath=//android.widget.ImageButton[@content-desc="VisTracks"]  timeout=10
    click element    xpath=//android.widget.ImageButton[@content-desc="VisTracks"]
    wait until element is visible    xpath=//*[@text="Settings"]        timeout=10
    click element    xpath=//*[@text="Settings"]
    sleep    1.5s
    swipe by percent    40     80   50     20   1000
    sleep    1s
    swipe by percent    40     80   50     20   1000
    sleep    1s
    click element    xpath=//*[@text="Debugging"]
    wait until element is visible    xpath=//*[@text="Debug"]       timeout=10
    click element    xpath=//*[@text="Debug"]
    sleep    1s
    go back
    sleep    1s
    go back
    log to console    Debug mode enabled

Stop moving
    sleep    1s
    wait until element is visible    accessibility_id=VBUS connection indicator
    Click Element    accessibility_id=VBUS connection indicator
    sleep    1.5s
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Do you want to connect to vehicle V1 VIN CONFIGURED?"]
    Run Keyword If   ${count} > 0    go back
    ...         ELSE    Set speed to cero
    sleep    1s
    log to console    vehicle is not conected to simulator or speed is cero

Set speed to cero
    Click Element    id=com.vistracks:id/setVbusDataBtn
    sleep    1s
    Clear Text    id=com.vistracks:id/speedEt
    Input Text    id=com.vistracks:id/speedEt    0
    sleep    1s
    Click Element    id=com.vistracks:id/standardPositiveBtn
    sleep    1s
    Click Element    id=com.vistracks:id/cancelDialogBtn
    sleep    1s

Change status to OffDuty
    wait until element is visible      accessibility_id=dutyStatusIcon
    Click Element   accessibility_id=dutyStatusIcon
    sleep    1.5s
    Click Element    id=com.vistracks:id/offDutyEventCv
    Input Text    id=com.vistracks:id/annotationOneATV    go home
    Swipe    713    1128    844    844  1000
    wait until element is visible    xpath=//*[@text="SAVE"]        timeout=10
    click element    xpath=//*[@text="SAVE"]
    sleep    3s
    log to console    Status updated to Off Duty

Change status to OnDuty ND
    wait until element is visible      accessibility_id=dutyStatusIcon
    Click Element   accessibility_id=dutyStatusIcon
    sleep    2s
    Click Element    id=com.vistracks:id/onDutyEventCv
    Input Text    id=com.vistracks:id/annotationOneATV    start working
    Swipe    713    1128    844    844  1000
    wait until element is visible    xpath=//*[@text="SAVE"]        timeout=10
    click element    xpath=//*[@text="SAVE"]
    sleep    3.5s
    log to console    Status updated to OnDuty ND

Change status to Sleeper
    wait until element is visible      accessibility_id=dutyStatusIcon
    Click Element   accessibility_id=dutyStatusIcon
    sleep    2s
    Click Element    xpath=//*[@text="Sleeper"]
    sleep    1s
    Input Text    id=com.vistracks:id/annotationOneATV    going to sleep
    Swipe    713    1128    844    844  1000
    wait until element is visible    xpath=//*[@text="SAVE"]        timeout=10
    click element    xpath=//*[@text="SAVE"]
    sleep    3.5s
    log to console    Status updated to Sleeper

Change status to Personal Conveyance
    wait until element is visible      accessibility_id=dutyStatusIcon
    Click Element   accessibility_id=dutyStatusIcon
    sleep    1.5s
    ${personalConveyance} =    Run Keyword And Return Status    element should be enabled    id=com.vistracks:id/personalConveyanceCv
    Run Keyword If   ${personalConveyance}    Select Personal Conveyance
    ...         ELSE      run keyword    Personal Conveyance is not enabled

Select Personal Conveyance
    Click Element    id=com.vistracks:id/personalConveyanceCv
    Input Text    id=com.vistracks:id/annotationOneATV    Personal Conveyance
    Swipe    713    1128    844    844  1000
    wait until element is visible    xpath=//*[@text="SAVE"]        timeout=10
    click element    xpath=//*[@text="SAVE"]
    sleep    3.5s
    log to console    Status updated to Personal Conveyance

Personal Conveyance is not enabled
    sleep    1s
    Swipe    713    1128    844    844  1000
    wait until element is visible    xpath=//*[@text="CANCEL"]        timeout=10
    click element    xpath=//*[@text="CANCEL"]
    sleep    2s
    log to console    Personal Conveyance is not enabled

Remove Pesonal Conveyance
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Personal Conveyance"]
    Run Keyword If   ${count} == 0    sleep 1s
    ...         ELSE      run keywords    click Element    xpath=//*[@text="Disable"]    AND     sleep    2s     AND         click Element    xpath=//*[@text="YES"]
    sleep    1s
    log to console    Ended Personal Conveyance

Change status to Yard Moves
    wait until element is visible      accessibility_id=dutyStatusIcon
    Click Element   accessibility_id=dutyStatusIcon
    sleep    1.5s
    ${personalConveyance} =    Run Keyword And Return Status    element should be enabled    id=com.vistracks:id/yardMovesCv
    Run Keyword If   ${personalConveyance}    Select Yard Moves
    ...         ELSE      run keyword    Yard Moves is not enabled

Select Yard Moves
    Click Element    id=com.vistracks:id/yardMovesCv
    Input Text    id=com.vistracks:id/annotationOneATV    Yard Moves
    Swipe    713    1128    844    844  1000
    wait until element is visible    xpath=//*[@text="SAVE"]        timeout=10
    click element    xpath=//*[@text="SAVE"]
    sleep    3.5s
    log to console    Status updated to Yard Moves

Yard Moves is not enabled
    sleep    1s
    Swipe    713    1128    844    844  1000
    wait until element is visible    xpath=//*[@text="CANCEL"]        timeout=10
    click element    xpath=//*[@text="CANCEL"]
    sleep    2s
    log to console    Yard Moves is not enabled

Remove Yard Moves
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Yard Moves"]
    Run Keyword If   ${count} == 0    sleep 1s
    ...         ELSE      run keywords    click Element    xpath=//*[@text="Disable"]    AND     sleep    2s     AND         click Element    xpath=//*[@text="YES"]
    sleep    1s
    log to console    Ended Yard Moves

Change status to Start Break
    wait until element is visible      accessibility_id=dutyStatusIcon
    Click Element   accessibility_id=dutyStatusIcon
    sleep    1.5s
    Click Element    id=com.vistracks:id/startBreakCv
    wait until element is visible    xpath=//*[@text="SAVE"]        timeout=10
    click element    xpath=//*[@text="SAVE"]
    sleep    3.5s
    log to console    Status updated to Start Break

Close Warning
    click element    xpath=//*[@text="OK"]

Disconnect from simulator
    wait until element is visible    accessibility_id=VBUS connection indicator
    Click Element    accessibility_id=VBUS connection indicator
    sleep    1.5s
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Do you want to connect to vehicle V1 VIN CONFIGURED?"]
    Run Keyword If   ${count} > 0    go back
    ...         ELSE      run keywords    click Element    xpath=//*[@text="DISCONNECT"]    AND     sleep    1s     AND         click Element    xpath=//*[@text="YES"]
    sleep    1s
    log to console    vehicle disconnected from simulator

End Break and change status to OnDuty ND
    wait until element is visible    id=com.vistracks:id/endBreakBtn
    Click Element    id=com.vistracks:id/endBreakBtn
    wait until element is visible      xpath=//*[@text="Are you sure you want to end your break?"]
    click Element    xpath=//*[@text="YES"]
    wait until element is visible   id=com.vistracks:id/onDutyEventCv
    Click Element    id=com.vistracks:id/onDutyEventCv
    Input Text    id=com.vistracks:id/annotationOneATV    start working
    Swipe    713    1128    844    844  1000
    wait until element is visible    xpath=//*[@text="SAVE"]        timeout=10
    click element    xpath=//*[@text="SAVE"]
    sleep    3.5s
    log to console    Status updated to OnDuty ND

Switch To Intrastate Driving Rules
    ${count0}=   Get Matching XPath Count    xpath=//*[@text="Switch To Intrastate Driving Rules"]
    Run Keyword If   ${count0} > 0    click element    id=com.vistracks:id/standardPositiveBtn
    sleep    1s