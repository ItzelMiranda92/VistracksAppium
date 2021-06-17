*** Settings ***
Documentation  This is a basic test suite for mobile testing with RobotFramework
Resource    ../Resources/Common.robot
Resource    ../Resources/PO/DrivingRoutines.robot
Resource    ../Resources/PO/OT1Portal.robot

Test Template    Run Driving Routine With Multiple Drivers


*** Test Cases ***                           USER                               PASSWORD         TIME       Codriver

#Driving Routine two - Driver00              miranda00@ot1solidtest01.com           1234           2s         miranda02@ot1solidtest01.com
#Driving Routine two - Driver03              miranda03@ot1solidtest01.com           1234           2s         miranda04@ot1solidtest01.com
Driving Routine two - Driver00              drive01@driver.com                     123           2s         miranda02@ot1solidtest01.com
#Driving Routine two - Driver03              drive02@driver.com                     123           2s         miranda04@ot1solidtest01.com
#Driving Routine two - Driver03              drive05@driver.com                     123           2s         miranda04@ot1solidtest01.com



# Driving Routine Co-Driver - Driver05         miranda05@ot1solidtest01.com         1234           2s         miranda06@ot1solidtest01.com

*** Keywords ***

Run Driving Routine With Multiple Drivers
    [Documentation]     Driver certifying logs routine
    [Tags]    DriverStatus
    [Arguments]    ${user}  ${password}   ${time}    ${codriver}
    #drivingroutines.driving routine two     ${user}   ${password}   ${time}
    #drivingroutines.driving routine unid events     ${user}   ${password}
    #DrivingRoutines.Driving Routine Adding Co-driver    ${user}  ${password}   ${time}    ${codriver}
     OT1Portal.Open portal
