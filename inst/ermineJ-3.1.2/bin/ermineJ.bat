@echo off
@REM enable echoing my setting ERMINEJ_BATCH_ECHO to 'on'
@if "%ERMINEJ_BATCH_ECHO%" == "on"  echo %ERMINEJ_BATCH_ECHO%

echo Starting ErmineJ ...

@REM Execute a user defined script before this one
if exist "%HOME%\ermineJrc_pre.bat" call "%HOME%\ermineJrc_pre.bat"

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM ==== START VALIDATION ====
if not "%JAVA_HOME%" == "" goto OkJHome

echo.
echo ERROR: JAVA_HOME not found in your environment.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation
echo.
goto end

:OkJHome
if exist "%JAVA_HOME%" goto chkMHome

echo.
echo ERROR: JAVA_HOME is set to an invalid directory.
echo JAVA_HOME = %JAVA_HOME%
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation
echo.
goto end

:chkMHome
if not "%ERMINEJ_HOME%" == "" goto valMHome

echo.
echo ERROR: ERMINEJ_HOME not found in your environment.
echo Please set the ERMINEJ_HOME variable in your environment to match the
echo location of the ermineJ installation
echo.
goto end

:valMHome
if exist "%ERMINEJ_HOME%\bin\ermineJ.bat" goto init

echo.
echo ERROR: ERMINEJ_HOME is set to an invalid directory or does not contain the bin\ermineJ.bat script
echo ERMINEJ_HOME = %ERMINEJ_HOME%
echo Please set the ERMINEJ_HOME variable in your environment to match the
echo location of the ermineJ installation
echo.
goto end
@REM ==== END VALIDATION ====

:init
@REM Decide how to startup depending on the version of windows

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set ERMINEJ_CMD_LINE_ARGS=%*
goto endInit

@REM The 4NT Shell from jp software
:4NTArgs
set ERMINEJ_CMD_LINE_ARGS=%$
goto endInit

@REM Reaching here means variables are defined and arguments have been captured
:endInit
if "%ERMINEJ_OPTS%"=="" SET ERMINEJ_OPTS="-Xmx3g"
SET ERMINEJ_JAVA_EXE="%JAVA_HOME%\bin\java.exe"

if exist %ERMINEJ_JAVA_EXE%  goto run
echo.
echo ERROR: ERMINEJ_JAVA_EXE is set to an invalid path.
echo ERMINEJ_JAVA_EXE = %ERMINEJ_JAVA_EXE%
echo Please set the JAVA_HOME variable in your environment to match the
echo location of the java installation
echo.
goto end

:run
SET ERMINEJ_CLASSPATH="%ERMINEJ_HOME%\lib\forehead.jar"
SET ERMINEJ_MAIN_CLASS="com.werken.forehead.Forehead"
SET ERMINEJ_ENDORSED="%JAVA_HOME%\lib\endorsed;%ERMINEJ_HOME%\lib"
if not "%ERMINEJ_HOME_LOCAL%" == "" goto StartMHL

@REM Start ERMINEJ without ERMINEJ_HOME_LOCAL override
%ERMINEJ_JAVA_EXE% -Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl -Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl "-DermineJ.home=%ERMINEJ_HOME%" "-Dtools.jar=%JAVA_HOME%\lib\tools.jar" "-Dforehead.conf.file=%ERMINEJ_HOME%\bin\forehead.conf" -Djava.endorsed.dirs=%ERMINEJ_ENDORSED% %ERMINEJ_OPTS% -classpath %ERMINEJ_CLASSPATH% %ERMINEJ_MAIN_CLASS% %ERMINEJ_CMD_LINE_ARGS%
@REM %ERMINEJ_JAVA_EXE% -Dorg.xml.sax.driver=org.apache.xerces.parsers.SAXParser -Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl -Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl "-DermineJ.home=%ERMINEJ_HOME%" "-Dtools.jar=%JAVA_HOME%\lib\tools.jar" "-Dforehead.conf.file=%ERMINEJ_HOME%\bin\forehead.conf" -Djava.endorsed.dirs=%ERMINEJ_ENDORSED% %ERMINEJ_OPTS% -classpath %ERMINEJ_CLASSPATH% %ERMINEJ_MAIN_CLASS% %ERMINEJ_CMD_LINE_ARGS%
goto :end

@REM Start ERMINEJ with ERMINEJ_HOME_LOCAL override
:StartMHL
%ERMINEJ_JAVA_EXE% -Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl -Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl "-DermineJ.home=%ERMINEJ_HOME%" "-DermineJ.home.local=%ERMINEJ_HOME_LOCAL%" "-Dtools.jar=%JAVA_HOME%\lib\tools.jar" "-Dforehead.conf.file=%ERMINEJ_HOME%\bin\forehead.conf" -Djava.endorsed.dirs=%ERMINEJ_ENDORSED% %ERMINEJ_OPTS% -classpath %ERMINEJ_CLASSPATH% %ERMINEJ_MAIN_CLASS% %ERMINEJ_CMD_LINE_ARGS%
@REM %ERMINEJ_JAVA_EXE% -Dorg.xml.sax.driver=org.apache.xerces.parsers.SAXParser -Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl -Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl "-DermineJ.home=%ERMINEJ_HOME%" "-DermineJ.home.local=%ERMINEJ_HOME_LOCAL%" "-Dtools.jar=%JAVA_HOME%\lib\tools.jar" "-Dforehead.conf.file=%ERMINEJ_HOME%\bin\forehead.conf" -Djava.endorsed.dirs=%ERMINEJ_ENDORSED% %ERMINEJ_OPTS% -classpath %ERMINEJ_CLASSPATH% %ERMINEJ_MAIN_CLASS% %ERMINEJ_CMD_LINE_ARGS%

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set ERMINEJ_JAVA_EXE=
set ERMINEJ_CLASSPATH=
set ERMINEJ_MAIN_CLASS=
set ERMINEJ_CMD_LINE_ARGS=
goto postExec

:endNT
@endlocal

:postExec
@REM if exist "%HOME%\ermineJrc_post.bat" call "%HOME%\ermineJrc_post.bat"
@REM pause the batch file if ERMINEJ_BATCH_PAUSE is set to 'on'
@REM if "%ERMINEJ_BATCH_PAUSE%" == "on" pause

