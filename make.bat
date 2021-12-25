@echo off
setlocal

set "_TEMP_ROOT=_temp"
set "_TEMP_ZXS=%_TEMP_ROOT%\zxs"
set "_TEMP_ZXN=%_TEMP_ROOT%\zxn"
set "_ROM_IN_ZXS=_rom\zxs-us.nds"
set "_ROM_IN_ZXN=_rom\zxn-us.nds"
set "_ROM_OUT_ZXS=_rom\zxs-us-out.nds"
set "_ROM_OUT_ZXN=_rom\zxn-us-out.nds"

if /I "%1"=="clean" (
	echo Cleaning...
	for %%f in ("%_ROM_OUT_ZXS%") do (
		del /Q "%%f" 2> nul
		del /Q "%%~dpnf.*" 2> nul
	)
	for %%f in ("%_ROM_OUT_ZXN%") do (
		del /Q "%%f" 2> nul
		del /Q "%%~dpnf.*" 2> nul
	)
	rmdir /S /Q "%_TEMP_ROOT%" 2> nul
	goto :done
) else if /I "%1"=="zxs-us" (
	echo Building target Zerker x Saurian US
	set "_TEMP=%_TEMP_ZXS%"
	set "_ROM_IN=%_ROM_IN_ZXS%"
	set "_ROM_OUT=%_ROM_OUT_ZXS%"
	set "_VERSION=zxs-us"
) else if /I "%1"=="zxn-us" (
	echo Building target Zerker x Ninja US
	set "_TEMP=%_TEMP_ZXN%"
	set "_ROM_IN=%_ROM_IN_ZXN%"
	set "_ROM_OUT=%_ROM_OUT_ZXN%"
	set "_VERSION=zxn-us"
) else (
	echo Unknown target %1.
	goto :error
)

for %%f in ("%_ROM_OUT%") do (
	set "_SYM_OUT=%%~dpnf.sym"
	set "_TEMP_OUT=%%~dpnf.temp"
	set "_TPL_OUT=%%~dpnf.tpl"
	set "_TXT_OUT=%%~dpnf.txt"
)

if not exist "%_ROM_IN%" (
	echo File not found: "%_ROM_IN%"
	goto :error
)

mkdir "%_TEMP%" 2> nul
pushd "%_TEMP%"
rmdir /S /Q . 2> nul
popd

echo Extracting ROM...
tools\ndstool.exe -x "%_ROM_IN%" ^
	-9  "%_TEMP%\arm9.bin" ^
	-7  "%_TEMP%\arm7.bin" ^
	-d  "%_TEMP%\data" ^
	-y  "%_TEMP%\overlay" ^
	-h  "%_TEMP%\header.bin" ^
	-y9 "%_TEMP%\y9.bin" ^
	-y7 "%_TEMP%\y7.bin" ^
	-t  "%_TEMP%\banner.bin" || goto :error

echo Extracting archives...
tools\sfarctool.exe -x -i "%_TEMP%\data\datbin\eng\mess.bin" -o "%_TEMP%\mess" || goto :error

echo Pre-processing files...
tools\armips.exe "src_pre.asm" ^
	-strequ TEMP "%_TEMP%" || goto :error

echo Decompressing files...
rem tools\blz.exe -d "%_TEMP%\arm9.dec" || goto :error

echo Importing text...
tools\TextPet.exe ^
	Load-Plugins "tools\plugins" ^
	Game MMSF2 ^
	Read-Text-Archives "%_TEMP%\mess" --format msg ^
	Read-Text-Archives "tpl" --format tpl --patch ^
	Write-Text-Archives "%_TPL_OUT%" --format tpl --single ^
	Write-Text-Archives "%_TXT_OUT%" --format txt --single ^
	Write-Text-Archives "%_TEMP%\mess_out" --format msg || goto :error

echo Patching files...
tools\armips.exe "src_patch.asm" ^
	-strequ TEMP "%_TEMP%" || goto :error

echo Compressing files...
copy /Y "%_TEMP%\arm9.dec" "%_TEMP%\arm9.bin"
rem tools\blz.exe -en9 "%_TEMP%\arm9.bin" || goto :error

echo Post-processing files...
tools\armips.exe "src_post.asm" ^
	-strequ TEMP "%_TEMP%" || goto :error

echo Packing archives...
tools\sfarctool.exe -p -i "%_TEMP%\mess_out" -o "%_TEMP%\data\datbin\eng\mess.bin" || goto :error

echo Creating ROM...
tools\ndstool.exe -c "%_ROM_OUT%" ^
	-9 "%_TEMP%\arm9.bin" ^
	-7 "%_TEMP%\arm7.bin" ^
	-d "%_TEMP%\data" ^
	-y "%_TEMP%\overlay" ^
	-h "%_TEMP%\header.bin" ^
	-y9 "%_TEMP%\y9.bin" ^
	-y7 "%_TEMP%\y7.bin" ^
	-t "%_TEMP%\banner.bin" || goto :error
tools\armips.exe "fixheader.asm" ^
	-strequ ROM_IN "%_ROM_IN%" ^
	-strequ ROM_OUT "%_ROM_OUT%" ^
	-definelabel PASS 1 || goto :error
tools\ndstool.exe -f "%_ROM_OUT%" || goto :error
tools\armips.exe "fixheader.asm" ^
	-strequ ROM_IN "%_ROM_IN%" ^
	-strequ ROM_OUT "%_ROM_OUT%" ^
	-definelabel PASS 2 || goto :error

echo.
:done
echo Done.
exit /b 0

:error
echo Aborted.
pause