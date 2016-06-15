:: Delete SSL port
:: You can use "netsh http show sslcert" to ensure that port was deleted.
netsh http delete sslcert ipport=0.0.0.0:777

:: Remove certificates
:: You can use certmgr.msc and certlm.msc to ensure that sertificates was removed.
certutil -delstore "My"   "b1 0e 64 f2 68 35 fe 52 97 8d 9a 1e 61 8f 42 88 27 7d ed 91"
certutil -delstore "Root" "23 ee 2b 14 92 bb b8 80 34 79 89 7c 88 fa 0b 09 80 d2 e3 0f"

pause