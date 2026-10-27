@echo off
echo ========================================================
echo  Starting ReliefConnect Web Server on http://localhost:8080
echo ========================================================
echo.
echo Clearing any previous background Dart instances and build locks...
powershell -Command "Stop-Process -Name 'dart', 'dartvm', 'dartaotruntime' -Force -ErrorAction SilentlyContinue; Remove-Item -Recurse -Force 'build' -ErrorAction SilentlyContinue"
echo.
echo ========================================================
echo  SERVER STARTING:
echo  Once you see "Web Server is available at http://localhost:8080",
echo  open Google Chrome or Edge and navigate to:
echo.
echo       http://localhost:8080
echo ========================================================
echo.
flutter run -d web-server --web-port 8080
pause
