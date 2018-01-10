# JAVA_HOME needs to be set from .Renvionment
# export JAVA_HOME=/usr/lib/jvm/default-java
Sys.setenv(JAVA_HOME="/usr/lib/jvm/default-java")


system('inst/ermineJ-3.0.3/bin/ermineJ.sh')


.jinit(); .jcall( 'java/lang/System', 'S', 'getProperty', 'java.home' )
Sys.getenv(x = 'JAVA_HOME', unset = "", names = NA)

