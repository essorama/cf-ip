chcp 936 > nul
@echo off
cd "%~dp0"
setlocal EnableDelayedExpansion
cls
set file=ip.txt
set max=100
set outfile=ip.csv
set speedtest=5
set limit=10
set tls=1
set test=1
set /p file="IP��ַ�ļ�����(Ĭ��%file%):"
echo �Ƿ�����TLS?
set /p tls="0���á�1����(Ĭ��%tls%):"
if !tls!==1 (set tls=true&set port=443) else (set tls=false&set port=80)
set /p port="���˿�(Ĭ��%port%):"
set /p max="�����������Э����(Ĭ��%max%):"
set /p outfile="����ļ�����(Ĭ��%outfile%):"
set /p speedtest="���ز���Э������,��Ϊ0���ò���(Ĭ��%speedtest%):"
if !speedtest!==0 (goto mode1) else (
echo �Ƿ����Ʋ���IP����?
set /p test="0�����ơ�1����(Ĭ��%test%):"
)
if !test!==1 (set /p limit="���ӳ����������ٶ��ٸ�IP(Ĭ��%limit%):"
goto mode2:
) else (goto mode1)
:mode1
iptest -file=!file! -port=!port! -tls=!tls! -max=!max! -outfile=!outfile! -speedtest=!speedtest!
goto end
:mode2
set /a n=0
del temp> nul 2>&1
iptest -file=!file! -port=!port! -tls=!tls! -max=!max! -outfile=!outfile! -speedtest=0
for /f "tokens=1 delims=," %%a in ('findstr ms !outfile!') do (
echo %%a>>temp
set /a n=n+1
if !n!==!limit! goto test
)

:test
iptest -file=temp -port=!port! -tls=!tls! -max=!max! -outfile=!outfile! -speedtest=!speedtest!
del temp> nul 2>&1
goto end

:end
echo �������,�밴������رմ���
pause>nul