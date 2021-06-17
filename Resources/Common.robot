*** Settings ***
Library    AppiumLibrary
Resource    PO/Login.robot
Resource    PO/ChangeStatus.robot

*** Variables ***
#${REMOTE_URL}     http://127.0.0.1:4725/wd/hub
${REMOTE_URL}     http://127.0.0.1:4723/wd/hub
${PLATFORM_NAME}    Android
${PLATFORM_VERSION}    9.0
${DEVICE_NAME}    emulator-5554
${Activity_NAME}        com.vistracks.vtlib.authentication.StartMainActivity
${PACKAGE_NAME}     com.vistracks
${AUTOMATION_NAME}  UiAutomator2
${enableMultiWindows}   true


*** Keywords ***
Open vistracks
  Open Application   ${REMOTE_URL}
  ...        platformName=${PLATFORM_NAME}
  ...    platformVersion=${PLATFORM_VERSION}
  ...   deviceName=${DEVICE_NAME}
  ...   automationName=UiAutomator2
  ...   noReset=False
  ...   autoGrantPermissions=True
    ...    newCommandTimeout=2500
    ...    appActivity=${Activity_NAME}
    ...    appPackage=${PACKAGE_NAME}

Accept license
    login.verify license button loaded
    login.click license button
    login.verify account name loaded

Check license text
    login.verify license button loaded
    login.verify license text

Login with Admin data
    login.input admin user
    login.input admin password
    login.click login button

Login with Driver data
    [Arguments]    ${user}  ${password}
    login.input driver user     ${user}
    login.input driver password     ${password}
    login.click login button
    login.wait for syncing account data
    login.wait for preparing logs
    sleep    7s

Logout
    sleep    2s
    ${countLO}=   Get Matching XPath Count    xpath=//android.widget.TextView[@content-desc="Logout"]
    ${countMO}=   Get Matching XPath Count    xpath=//android.widget.TextView[@content-desc="More options"]
    Run Keyword If   ${countLO} > 0    Click Element    accessibility_id=Logout
    Run Keyword If   ${countMO} > 0    More options icon
    Run Keyword If   ${countMO}+${countMO} == 0     More options by coordinates
    sleep    2s
    dismiss uncertified logs
    dismiss pending requests
    dismiss uncertified logs
    #ChangeStatus.Verify if there are uncertified logs
    wait until element is visible    xpath=//*[@text="LOGOUT"]      timeout=10
    click Element    xpath=//*[@text="LOGOUT"]
    sleep    10s
    log to console    logged out

More options icon
    Click Element    xpath=//android.widget.ImageView[@content-desc="More options"]
    sleep    2s
    dismiss uncertified logs
    dismiss pending requests
    dismiss uncertified logs
    Click Element   xpath=//*[@text="Logout"]

More options by coordinates
    log to console    By coordinates
    click element at coordinates    1019    144
    log to console    tap at 1019 144
    dismiss uncertified logs
    dismiss pending requests
    dismiss uncertified logs
    ${logout}=   Get Matching XPath Count    xpath=//*[@text="Logout"]
    Run Keyword If   ${logout} < 1    click element at coordinates    1014    127
    Run Keyword If   ${logout} < 1    log to console    tap at 1014 127
    dismiss uncertified logs
    dismiss pending requests
    dismiss uncertified logs
    log to console    before click logout
    Click Element   xpath=//*[@text="Logout"]

Check successful login with Admin
    login.verify alert for admin text

Add Driving status
    changestatus.enable debug mode
    changestatus.connect to simulator
    dismiss uncertified logs
    dismiss pending requests

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

Add Yard Moves status
    ${count}=   Get Matching XPath Count    xpath=//*[@text="Yard Moves"]
    Run Keyword If   ${count} == 0       changestatus.change status to yard moves
    ...     ELSE    log to console    Already with Yard Moves status

Add Start Break status
    ${count}=   Get Matching XPath Count    xpath=//*[@text="END BREAK"]
    ${count2}=   Get Matching XPath Count    xpath=//*[@text="OffDuty"]
    Run keyword if   ${count} > 0       log to console    Already in Break
    ...     ELSE IF     ${count2} == 0      changestatus.change status to start break
    ...     ELSE    run keywords    changestatus.change status to onduty nd     AND     ChangeStatus.Change status to Start Break

Add Co-driver
    [Arguments]    ${codriver}  ${password}
    wait until element is visible    xpath=//android.widget.ImageButton[@content-desc="VisTracks"]  timeout=10
    click element    xpath=//android.widget.ImageButton[@content-desc="VisTracks"]
    wait until element is visible    xpath=//*[@text="Tap to add or change driver"]        timeout=10
    click element    xpath=//*[@text="Tap to add or change driver"]
    sleep    1.5s
    wait until element is visible    id=com.vistracks:id/manageCoDriverLogonBtn  timeout=10
    click element    id=com.vistracks:id/manageCoDriverLogonBtn
    login.input driver user     ${codriver}
    login.input driver password     ${password}
    login.click login button
    sleep    7s
    dismiss uncertified logs
    dismiss pending requests
    dismiss uncertified logs

Change Co-driver to driver
    [Arguments]    ${password}
    wait until element is visible    id=com.vistracks:id/manageBtn
    Click Element    id=com.vistracks:id/manageBtn
    wait until element is visible    id=com.vistracks:id/switchCoDriver
    Click Element    id=com.vistracks:id/switchCoDriver
    wait until element is visible    id=com.vistracks:id/passwordField
    Input Text    id=com.vistracks:id/passwordField    ${password}
    wait until element is visible    id=com.vistracks:id/driverAuthOkBtn
    Click Element    id=com.vistracks:id/driverAuthOkBtn
    sleep    10s
    wait until page does not contain element    id=com.vistracks:id/manageBtn

View Co-driver
    [Arguments]    ${password}
    wait until element is visible    xpath=//android.widget.ImageButton[@content-desc="VisTracks"]  timeout=10
    click element    xpath=//android.widget.ImageButton[@content-desc="VisTracks"]
    wait until element is visible    xpath=//*[@text="Tap to add or change driver"]        timeout=10
    click element    xpath=//*[@text="Tap to add or change driver"]
    sleep    1.5s
    wait until element is visible    xpath=//*[@text="View"]        timeout=10
    click element    xpath=//*[@text="View"]
    wait until element is visible    id=com.vistracks:id/passwordField
    Input Text    id=com.vistracks:id/passwordField    ${password}
    wait until element is visible    id=com.vistracks:id/driverAuthOkBtn
    Click Element    id=com.vistracks:id/driverAuthOkBtn
    wait until element is visible    id=com.vistracks:id/manageBtn       timeout=10

View Current Driver
    [Arguments]    ${password}
    wait until element is visible    id=com.vistracks:id/manageBtn
    Click Element    id=com.vistracks:id/manageBtn
    wait until element is visible    xpath=//*[@text="View"]        timeout=10
    click element    xpath=//*[@text="View"]
    wait until element is visible    id=com.vistracks:id/passwordField
    Input Text    id=com.vistracks:id/passwordField    ${password}
    wait until element is visible    id=com.vistracks:id/driverAuthOkBtn
    Click Element    id=com.vistracks:id/driverAuthOkBtn
    sleep    10s
    wait until page does not contain element    id=com.vistracks:id/manageBtn

Logout Co-driver
    wait until element is visible    xpath=//android.widget.ImageButton[@content-desc="VisTracks"]  timeout=10
    click element    xpath=//android.widget.ImageButton[@content-desc="VisTracks"]
    wait until element is visible    xpath=//*[@text="Tap to add or change driver"]        timeout=10
    click element    xpath=//*[@text="Tap to add or change driver"]
    sleep    1.5s
    wait until element is visible    id=com.vistracks:id/logoutCoDriver        timeout=10
    click element    id=com.vistracks:id/logoutCoDriver
    wait until element is visible    xpath=//*[@text="LOGOUT"]      timeout=10
    click Element    xpath=//*[@text="LOGOUT"]
    sleep    10s
    log to console    logged out






