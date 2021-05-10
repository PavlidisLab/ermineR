#!/bin/sh
ERMINEJ_OPTS="-Xmx3g"

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false;
darwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  Darwin*) darwin=true 
           if [ -z "$JAVA_VERSION" ] ; then
             JAVA_VERSION="CurrentJDK"
           else
             echo "Using Java version: $JAVA_VERSION"
           fi
           if [ -z "$JAVA_HOME" ] ; then
             JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/${JAVA_VERSION}/Home
           fi
           ;;
esac


if [ -z "$ERMINEJ_HOME" ] ; then
  # try to find ERMINEJ
  if [ -d /opt/ermineJ ] ; then
    ERMINEJ_HOME=/opt/ermineJ
  fi

  if [ -d ${HOME}/ermineJ ] ; then
    ERMINEJ_HOME=${HOME}/ermineJ
  fi

  ## resolve links - $0 may be a link to ermineJ's home
  PRG=$0
  progname=`basename $0`
  saveddir=`pwd`

  # need this for relative symlinks
  cd `dirname $PRG`

  while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '.*/.*' > /dev/null; then
  PRG="$link"
    else
  PRG="`dirname $PRG`/$link"
    fi
  done

  ERMINEJ_HOME=`dirname "$PRG"`/..

  # make it fully qualified
  ERMINEJ_HOME=`cd "$ERMINEJ_HOME" && pwd`

  cd $saveddir
fi



# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
  [ -n "$ERMINEJ_HOME" ] &&
    ERMINEJ_HOME=`cygpath --unix "$ERMINEJ_HOME"`
  [ -n "$ERMINEJ_HOME_LOCAL" ] &&
    ERMINEJ_HOME_LOCAL=`cygpath --unix "$ERMINEJ_HOME_LOCAL"`
  [ -n "$JAVA_HOME" ] &&
    JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
  [ -n "$CLASSPATH" ] &&
    CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
fi

if [ -z "$JAVACMD" ] ; then
  if [ -n "$JAVA_HOME"  ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
      # IBM's JDK on AIX uses strange locations for the executables
      JAVACMD="$JAVA_HOME/jre/sh/java"
    else
      JAVACMD="$JAVA_HOME/bin/java"
    fi
  else
    JAVACMD=java
  fi
fi

if [ ! -x "$JAVACMD" ] ; then
  echo "Error: JAVA_HOME is not defined correctly."
  echo "  We cannot execute $JAVACMD"
  exit
fi

ERMINEJ_LIB=${ERMINEJ_HOME}/lib



# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  [ -n "$ERMINEJ_HOME" ] &&
    ERMINEJ_HOME=`cygpath --path --windows "$ERMINEJ_HOME"`
  [ -n "$ERMINEJ_HOME_LOCAL" ] &&
    ERMINEJ_HOME_LOCAL=`cygpath --path --windows "$ERMINEJ_HOME_LOCAL"`
  [ -n "$JAVA_HOME" ] &&
    JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
  [ -n "$ERMINEJ_LIB" ] &&
    ERMINEJ_ENDORSED=`cygpath --path --windows "$ERMINEJ_LIB"`
fi

MAIN_CLASS=com.werken.forehead.Forehead

"$JAVACMD" \
  $ERMINEJ_OPTS \
  -Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl \
  -classpath "${ERMINEJ_HOME}/lib/forehead.jar" \
  "-Dforehead.conf.file=${ERMINEJ_HOME}/bin/forehead.conf"  \
  "-DermineJ.home=${ERMINEJ_HOME}" \
  $MAIN_CLASS "$@"


