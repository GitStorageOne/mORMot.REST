:: Define SSL port
SET SSLPort=777

:: Install certs
:: You can use certlm.msc to ensure that sertificates was added.
certutil -f -p 100500 -importpfx "My" "%~dp0mORMot-SSL-Test-All.p12"

:: Add SSL port
:: You can use "netsh http show sslcert" to ensure that port was added.
netsh http add sslcert ipport=0.0.0.0:%SSLPort% certhash=b10e64f26835fe52978d9a1e618f4288277ded91 appid={AA4AC37D-B812-46A7-BEFB-A68167A05BA7}

pause