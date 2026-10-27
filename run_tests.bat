@echo off
echo ========================================================
echo  Running ReliefConnect Automated Test Suite
echo ========================================================
echo.
flutter test
echo.
echo ========================================================
echo  Running Flutter Static Code Analysis
echo ========================================================
echo.
flutter analyze
echo.
echo Done!
pause
