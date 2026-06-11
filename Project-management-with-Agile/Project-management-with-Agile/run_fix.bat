@echo off
echo Cleaning and compiling...
.\mvnw.cmd clean compile
if %errorlevel% neq 0 (
    echo Compilation failed!
    exit /b %errorlevel%
)
echo Compilation successful!
echo Starting application...
.\mvnw.cmd spring-boot:run
