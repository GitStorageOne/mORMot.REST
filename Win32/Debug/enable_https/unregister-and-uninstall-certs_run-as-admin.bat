:: Define SSL port
SET SSLPort=777

:: Delete SSL port
:: You can use "netsh http show sslcert" to ensure that port was deleted.
netsh http delete sslcert ipport=0.0.0.0:%SSLPort%

:: Remove certificates
:: You can use certmgr.msc and certlm.msc to ensure that sertificates was removed.
certutil -delstore "My"   "b1 0e 64 f2 68 35 fe 52 97 8d 9a 1e 61 8f 42 88 27 7d ed 91"
certutil -delstore "Root" "23 ee 2b 14 92 bb b8 80 34 79 89 7c 88 fa 0b 09 80 d2 e3 0f"

:: Remove URL listener from windows httpapi (temporary solution).
:: This must be done from application, but not work for some reason.
:: THttpApiServer(fHTTPServer.HttpServer).RemoveUrl(ROOT_NAME, fHTTPServer.Port, fServerSettings.Protocol = HTTPsys_SSL, '+');
netsh http delete urlacl http://+:%SSLPort%/service/
netsh http delete urlacl https://+:%SSLPort%/service/

pause