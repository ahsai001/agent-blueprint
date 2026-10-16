@echo off
REM ==============================================================================
REM agent-init: Windows CMD / Batch Wrapper
REM Panggilan cepat untuk agent-init.ps1 di lingkungan Windows
REM ==============================================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0agent-init.ps1" %*
