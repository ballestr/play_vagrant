## HAProxy Log format
```
Mar 10 03:27:33 localhost haproxy[143041]: 1.187.243.108 - - [10/Mar/2018:03:27:33 +0000] "GET /favicon.ico HTTP/1.1" 503 0 "" "" 34096 147 "com-https~" "com-https-servers" "com_https_b1" 0 0 -1 -1 0 CC-- -21930 242 1 0 0 0 0 "" "" 
```

```
log-format %{+Q}o %{-Q}Ci - - [%T] %r %st %B "" "" %Cp 
    %ms 
    %ft %b %s 
    %Tq %Tw %Tc %Tr %Tt 
    %tsc : termination state with cookie status
    %ac : actconn
    %fc : feconn
    %bc : beconn
    %sc %rc %sq %bq 
    %cc %cs 
    %hrl %hsl
```