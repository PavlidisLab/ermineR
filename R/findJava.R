findJava = function(){
    javaHome = ''
    if(grepl('^darwin',R.version$os)){ # detect macs
        javaHome = system2('/usr/libexec/java_home',stdout = TRUE)
    }
    
    if(grepl('linux',R.version$os)){
        # if java executable is in path, find it
        javaLink = system2('which', 'java',stdout = TRUE,stderr = TRUE)
        if(length(javaLink) != 0){
            symLink = Sys.readlink(javaLink)
            while(symLink != ''){
                javaLink = symLink
                symLink = Sys.readlink(javaLink)
            }
        }
        if(grepl('jre/bin/java$',javaLink)){
            javaHome = gsub('/jre/bin/java$','',javaLink)
        } else{
            javaHome = ''
        }
    }
    
    if(Sys.info()[1] =='Windows'){
        javaLink = system2('where', 'java',stdout = TRUE,stderr = TRUE)
        if(!grepl('INFO: Could not find files',javaLink)){
            while (fs::is_link(javaLink)){
                javaLink = fs::link_path(javaLink)
            }
        }
        if(grepl('bin/java.exe$',javaLink) & !grepl('Program Files \\(x86\\)',javaLink)){ # doesn't work with 32 bit java
            javaHome = gsub('/bin/java.exe$','',javaLink) %>% gsub('/', '\\\\',.)
        } else{
            javaHome = ''
        }
    }
    # if OS specific methods fail, 
    if(javaHome =='' & 'rJava' %in% installed.packages()){
        rJava::.jinit()
        javaHome = rJava::.jcall('java/lang/System', 'S', 'getProperty', 'java.home')
        if(Sys.info()[1] == 'Windows'){
            javaHome %<>% gsub('/', '\\\\',.)
        }
    }
    
    # if all fails
    if(javaHome == ''){
        stop('JAVA_HOME is not defined correctly. Install rJava and make sure',
             ' it can be loaded or use Sys.setenv() to set JAVA_HOME. Note',
             ' that ermineJ requires 64 bit java')
    }
    Sys.setenv(JAVA_HOME=javaHome)
    return(javaHome)
}