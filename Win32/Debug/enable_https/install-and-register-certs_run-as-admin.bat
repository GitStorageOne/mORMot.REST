:: Define SSL port
SET SSLPort=777

:: Install certs
:: You can use certlm.msc to ensure that sertificates was added.
certutil -f -p 100500 -importpfx "%~dp0mORMot-SSL-Test-All.p12"

:: Add SSL port
:: You can use "netsh http show sslcert" to ensure that port was added.
netsh http add sslcert ipport=0.0.0.0:%SSLPort% certhash=9707a1065f2be25fc8d6f634f66196e151f49625 appid={AA4AC37D-B812-46A7-BEFB-A68167A05BA7}

pause