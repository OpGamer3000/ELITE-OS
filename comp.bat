@echo off

fasm ./boot/boot.asm ./os.bin && goto fasm_noerr

:: fasm err
echo FASM COMPILE ERR
goto end

:: if no err
:fasm_noerr

echo.
echo =====================
echo FASM compile complete
echo =====================
echo.

qemu-system-i386 -hda os.bin

:end
@echo on