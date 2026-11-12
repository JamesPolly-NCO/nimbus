#!/bin/bash
 curl -o /dev/null -s -w "\
\n   Nametime (DNS):  %{time_namelookup}s\
\n     Connect Time:  %{time_connect}s\
\n  AppConnect Time:  %{time_appconnect}s\
\n     Pretransfer:  %{time_pretransfer}s\
\n   Redirect Time:  %{time_redirect}s\
\n  Start Transfer:  %{time_starttransfer}s\
\n-------------------------\
\n       Total Time:  %{time_total}s\
\n" $1

