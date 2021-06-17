*** Settings ***
Library     SeleniumLibrary
Library     String


*** Variables ***
#${REMOTE_URL}     http://127.0.0.1:4725/wd/hub
${OT1_URL}     https://apex-te-dev-ric.aws.roadnet.com/
${Browser}     chrome

${PLATFORM_NAME}    Android
${PLATFORM_VERSION}    9.0
${DEVICE_NAME}    emulator-5554
${Activity_NAME}        com.vistracks.vtlib.authentication.StartMainActivity
${PACKAGE_NAME}     com.vistracks
${AUTOMATION_NAME}  UiAutomator2
${enableMultiWindows}   true


*** Keywords ***
Open portal
  open browser    ${OT1_URL}    ${Browser}
  seleniumlibrary.wait until element is visible        xpath=//*[name()='svg']     10s
  seleniumlibrary.click element    xpath=//*[name()='svg']
  seleniumlibrary.wait until page does not contain element    xpath=//*[name()='svg']    10s
  seleniumlibrary.click element    xpath=//*[@title="New Omnitracs SSO"]
  seleniumlibrary.wait until element is visible        name=user-id      10s
  SeleniumLibrary.input text      name=user-id     itzel@ot1solidtest01.com
  SeleniumLibrary.click button    xpath=//*[contains(text(),'Next')]
  seleniumlibrary.wait until element is visible        name=password     10s
  SeleniumLibrary.input text      name=password     Password1234!
  SeleniumLibrary.click button    xpath=//*[contains(text(),'Login')]
  seleniumlibrary.wait until element is visible        xpath=//*[name()='svg']     15s
  seleniumlibrary.click element    xpath=//*[name()='svg']
  seleniumlibrary.wait until page does not contain element    xpath=//*[name()='svg']    10s
  seleniumlibrary.click element    xpath=//*[@id="componentsHomeView"]//*[@class="icon purple"]
  seleniumlibrary.wait until element is visible        xpath=//*[name()='svg']     10s
  seleniumlibrary.click element    xpath=//*[name()='svg']
  seleniumlibrary.wait until page does not contain element    xpath=//*[name()='svg']
  seleniumlibrary.wait until element is visible    xpath=//*[@id="wizardCurrentStep"]    10s
  SeleniumLibrary.click element    xpath=//*[@id="wizardCurrentStep"]
  seleniumlibrary.wait until element is visible    xpath=//*[@id="workers"]     10s
  SeleniumLibrary.click element    xpath=//*[@id="workers"]
  seleniumlibrary.wait until element is visible    xpath=//*[@id="addButton"]     10s
  SeleniumLibrary.click element    xpath=//*[@id="addButton"]
  ${randNum}=       Generate random string    4    0123456789
  ${driverID}=   catenate    SEPARATOR=    ROBOT    ${randNum}
  seleniumlibrary.wait until element is visible    xpath=//*[@id="identifier"]     10s
  SeleniumLibrary.input text    xpath=//*[@id="identifier"]     ${driverID}
  SeleniumLibrary.input text    xpath=//*[@id="firstName"]      DRIVER
  SeleniumLibrary.input text    xpath=//*[@id="lastName"]      ${driverID}
  SeleniumLibrary.select from list by label        xpath=//select[@id="equipment"]    VEH02 - VEH02
  SeleniumLibrary.select checkbox      xpath=//*[@id="worker_details"]/div[1]/div[6]/div[1]/label[1]/input[1]
  sleep    1s
  SeleniumLibrary.input text    xpath=//*[@id="mobilePassword"]      1234
  SeleniumLibrary.input text    xpath=//*[@id="mobilePasswordConfirm"]      1234
  SeleniumLibrary.scroll element into view    xpath=//*[@href="#worker_hos"]
  SeleniumLibrary.click element    xpath=//*[@href="#worker_hos"]
  sleep    1s
  ${license}=       Generate random string    8    0123456789
  SeleniumLibrary.input text        xpath=//*[@id="cdlNumber"]     ${license}
  sleep    5s
  SeleniumLibrary.scroll element into view     xpath=//*[@class="col-md-4"]//*[@id="saveButton"]
  SeleniumLibrary.click element    xpath=//*[@class="col-md-4"]//*[@id="saveButton"]
  sleep    5s
  SeleniumLibrary.click element    xpath=//*[@class="col-md-4"]//*[@id="saveButton"]
  wait until element is visible    xpath=//*[@id="editMessageView"]//*[contains(text(),'The item was added. You may add more items or press Close when done.')]

#########################################


  sleep    100s
  close browser


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
