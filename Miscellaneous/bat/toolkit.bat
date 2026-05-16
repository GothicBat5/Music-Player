@echo off
title Jade's System Toolkit
color 0A

:menu
cls
echo ==========================================
echo         JADE SYSTEM TOOLKIT
echo ==========================================
echo.
echo 1. Show Current Time
echo 2. Show System Information
echo 3. List Files in Current Folder
echo 4. Create Test Folder
echo 5. Generate Random Number
echo 6. Simple Calculator
echo 7. Ping Google
echo 8. Matrix Effect
echo 9. Exit
echo.
set /p choice=Choose an option: 

if %choice%==1 goto time
if %choice%==2 goto sysinfo
if %choice%==3 goto listfiles
if %choice%==4 goto makefolder
if %choice%==5 goto randomnum
if %choice%==6 goto calc
if %choice%==7 goto pingtest
if %choice%==8 goto matrix
if %choice%==9 goto end

goto menu

:time
cls
echo =========================
echo Current Date and Time
echo =========================
echo.
time /t
date /t
pause
goto menu

:sysinfo
cls
echo =========================
echo System Information
echo =========================
echo.
systeminfo
pause
goto menu

:listfiles
cls
echo =========================
echo Files in Current Folder
echo =========================
echo.
dir
pause
goto menu

:makefolder
cls
echo =========================
echo Create Test Folder
echo =========================
echo.
set /p foldername=Enter folder name: 
mkdir %foldername%
echo Folder created successfully.
pause
goto menu

:randomnum
cls
echo =========================
echo Random Number Generator
echo =========================
echo.
set /a num=%random% %% 1000
echo Your random number is: %num%
pause
goto menu

:calc
cls
echo =========================
echo Simple Calculator
echo =========================
echo.
set /p a=Enter first number: 
set /p b=Enter second number: 

set /a sum=a+b
set /a sub=a-b
set /a mul=a*b

echo.
echo Addition: %sum%
echo Subtraction: %sub%
echo Multiplication: %mul%
pause
goto menu

:pingtest
cls
echo =========================
echo Ping Test
echo =========================
echo.
ping google.com
pause
goto menu

:matrix
cls
color 0A

:matrixloop
echo %random%%random%%random%%random%%random%%random%%random%
goto matrixloop

:end
cls
echo.
echo Goodbye!
timeout /t 2 >nul
exit
