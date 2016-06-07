# mORMot.REST
Testing mORMot REST capabilities.  
It's my first meeting with mORMot, so, something may be unoptimized or implemented wrong.  
Feel free to post your suggestions. Don't forget that this is not final build, there is a lot to do.

I use REST services via interfaces, IMO it's more friendly for developers.  
You may find that project group contain both server and client projects.  
In addition, you can use .jmx files with apache jmeter to simulate multiclient heavy load via HTTP connection.  

Official Synopse mORMot repository [available here][mormot-repo].  
Official Synopse mORMot documentation [available here][mormot-docs].

# 2do
Category / Status | Feature
--- | ---
**mORMot REST architecture** |
`done` | Services via interfaces
**Protocol usage** |
`done` |  HTTP (socket)
`done` |  HTTP (http.sys)
`done` |  WebSocket (bidirectional, JSON)
`done` |  WebSocket (bidirectional, Binary)
`done` |  WebSocket (bidirectional, Binary + AES)
`done` |  Named pipe (on local PC include LAN network support)
**Method interfaces** |
`done` | IRestMethods (no session support).
`.` | IRestMethodsEx (session support, callback support).
**Authentication schemes** |
`done` | No authentication
`.` | URI
`.` | Signed URI
`done` | Default
`done` | None
`done` | HTTP Basic
`.` | SSPI
**Authorization** |
`.` | Allow all to execute any method
`.` | Deny all to execute any method
`.` | Follow method / group settings
**jmx test plan** (without authentication) |
`done` |  Method call via URL
`done` |  Send parameters via body
`done` |  Method result as JSON object
`done` |  Send JSON objects via body
`done` |  Send multiple JSON objects via body
`.` |  Method result as custom JSON string
`.` | Detect empty parameters from server side
**Other** |
`.` | HTTPS and certificates
`.` | HTTP/s proxy bypass

[mormot-repo]: <https://github.com/synopse/mORMot>
[mormot-docs]: <http://synopse.info/files/html/Synopse%20mORMot%20Framework%20SAD%201.18.html>