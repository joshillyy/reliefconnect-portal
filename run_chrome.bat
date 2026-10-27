@echo off
echo ========================================================
echo  Starting ReliefConnect Portal on Google Chrome
echo ========================================================
echo.
echo Stopping any lingering background Dart/Chrome instances...
powershell -Command "Stop-Process -Name 'dart', 'dartvm', 'dartaotruntime' -Force -ErrorAction SilentlyContinue"
echo.
echo Launching Flutter Web...
flutter run -d chrome
pause
