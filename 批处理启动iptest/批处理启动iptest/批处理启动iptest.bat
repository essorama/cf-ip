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
set /p file="IP地址文件名称(默认%file%):"
echo 是否启用TLS?
set /p tls="0禁用、1启用(默认%tls%):"
if !tls!==1 (set tls=true&set port=443) else (set tls=false&set port=80)
set /p port="检测端口(默认%port%):"
set /p max="并发请求最大协程数(默认%max%):"
set /p outfile="输出文件名称(默认%outfile%):"
set /p speedtest="下载测速协程数量,设为0禁用测速(默认%speedtest%):"
if !speedtest!==0 (goto mode1) else (
echo 是否限制测速IP数量?
set /p test="0不限制、1限制(默认%test%):"
)
if !test!==1 (set /p limit="按延迟排序最多测速多少个IP(默认%limit%):"
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
echo 测试完毕,请按任意键关闭窗口
pause>nul