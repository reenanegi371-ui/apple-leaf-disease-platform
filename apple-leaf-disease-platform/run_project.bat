@echo off
echo =======================================================
echo   LeafHealth AI - Starting All Servers
echo =======================================================

:: Activate virtual environment
call apple\Scripts\activate.bat

:: Install requirements if needed
pip install -r requirements.txt >nul 2>&1
pip install -r backend\requirements.txt >nul 2>&1
pip install -r website\requirements.txt >nul 2>&1

:: Start the project
python start.py
pause
