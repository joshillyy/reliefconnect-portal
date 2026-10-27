@echo off
echo ========================================================
echo  Starting ReliefConnect Portal on Windows Desktop
echo ========================================================
echo.
echo Stopping any lingering background Dart instances...
powershell -Command "Stop-Process -Name 'dart', 'dartvm', 'dartaotruntime' -Force -ErrorAction SilentlyContinue"
echo.
echo Launching Windows Desktop build...
flutter run -d windows
pause
