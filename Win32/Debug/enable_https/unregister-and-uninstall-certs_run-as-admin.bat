:: Define SSL port
SET SSLPort=777

:: Delete SSL port
:: You can use "netsh http show sslcert" to ensure that port was deleted.
netsh http delete sslcert ipport=0.0.0.0:%SSLPort%

:: Remove certificates
:: You can use certmgr.msc and certlm.msc to ensure that sertificates was removed.
certutil -delstore "My"   "97 07 a1 06 5f 2b e2 5f c8 d6 f6 34 f6 61 96 e1 51 f4 96 25"
certutil -delstore "Root" "23 ee 2b 14 92 bb b8 80 34 79 89 7c 88 fa 0b 09 80 d2 e3 0f"

:: Remove URL listener from windows httpapi (temporary solution).
:: This must be done from application, but not work for some reason.
:: THttpApiServer(fHTTPServer.HttpServer).RemoveUrl(ROOT_NAME, fHTTPServer.Port, fServerSettings.Protocol = HTTPsys_SSL, '+');
netsh http delete urlacl http://+:%SSLPort%/service/
netsh http delete urlacl https://+:%SSLPort%/service/

pause