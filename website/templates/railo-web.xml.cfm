<?xml version="1.0" encoding="UTF-8"?><railo-configuration pw="{{cfml_website_password_hash}}" version="4.2"><cfabort/>

<!-- 
Path placeholders:
    {railo-web}: path to the railo web directory typical "{web-root}/WEB-INF/railo"
    {railo-server}: path to the railo server directory typical where the railo.jar is located
    {railo-config}: same as {railo-server} in server context and same as {railo-web} in web context}
    {temp-directory}: path to the temp directory of the current user of the system
    {home-directory}: path to the home directory of the current user of the system
    {web-root-directory}: path to the web root
    {system-directory}: path to thesystem directory
    {web-context-hash}: hash of the web context
-->
    
    
    
    
    <!--
    arguments:
        close-connection -  write connection-close to response header
        suppress-whitespace -   supress white space in response
        show-version - show railo version uin response header
     -->
    <setting/>

<!--    definition of all database used inside your application.                                        -->
<!--    above you can find some definition of jdbc drivers (all this drivers are included at railo)     -->
<!--    for other database drivers see at:                                                              -->
<!--     - http://servlet.java.sun.com/products/jdbc/drivers                                            -->
<!--     - http://sourceforge.net                                                                       -->
<!--    or ask your database distributor                                                                -->
    <data-sources>
        {% for datasource in cfml_datasources %}
            {% if datasource.type == 'mysql' %}
            <data-source allow="511" blob="true" class="org.gjt.mm.mysql.Driver" clob="true" connectionLimit="-1" connectionTimeout="1" custom="useUnicode=true&amp;characterEncoding=UTF-8&amp;allowMultiQueries=true&amp;useLegacyDatetimeCode=true" database="{{datasource.database}}" dbdriver="MySQL" dsn="jdbc:mysql://{host}:{port}/{database}" host="{{datasource.host}}" metaCacheTimeout="60000" name="{{datasource.name}}" password="{% if datasource.password_hash != "" %}encrypted:{{datasource.password_hash}}{% endif %}" port="{{datasource.port}}" storage="false" timezone="AET" username="{{datasource.username}}" validate="false"/>
            {% elif datasource.type == 'mssql2005' %}
            <data-source allow="511" blob="true" class="com.microsoft.jdbc.sqlserver.SQLServerDriver" clob="true" connectionTimeout="1" custom="DATABASENAME={{datasource.database}}&amp;sendStringParametersAsUnicode=true&amp;SelectMethod=direct" database="{{datasource.database}}" dbdriver="MSSQL" dsn="jdbc:sqlserver://{host}:{port}" host="{{datasource.host}}" metaCacheTimeout="60000" name="{{datasource.name}}" password="{% if datasource.password_hash != "" %}encrypted:{{datasource.password_hash}}{% endif %}" port="{{datasource.port}}" storage="false" username="{{datasource.username}}" validate="false"/>
            {% endif %}
        {% endfor %}

        {% if cfml_datasource_type == 'mysql' %}
        <data-source allow="511" blob="true" class="org.gjt.mm.mysql.Driver" clob="true" connectionLimit="-1" connectionTimeout="1" custom="useUnicode=true&amp;characterEncoding=UTF-8&amp;allowMultiQueries=true&amp;useLegacyDatetimeCode=true" database="{{cfml_datasource_database}}" dbdriver="MySQL" dsn="jdbc:mysql://{host}:{port}/{database}" host="{{cfml_datasource_host}}" metaCacheTimeout="60000" name="{{cfml_datasource}}" password="{% if cfml_datasource_password_hash != "" %}encrypted:{{cfml_datasource_password_hash}}{% endif %}" port="{{cfml_datasource_port}}" storage="false" timezone="AET" username="{{cfml_datasource_username}}" validate="false"/>
        {% elif cfml_datasource_type == 'mysql2005' %}
        <data-source allow="511" blob="true" class="com.microsoft.jdbc.sqlserver.SQLServerDriver" clob="true" connectionTimeout="1" custom="DATABASENAME={{cfml_datasource_database}}&amp;sendStringParametersAsUnicode=true&amp;SelectMethod=direct" database="{{cfml_datasource_database}}" dbdriver="MSSQL" dsn="jdbc:sqlserver://{host}:{port}" host="{{cfml_datasource_host}}" metaCacheTimeout="60000" name="{{cfml_datasource}}" password="{% if cfml_datasource_password_hash != "" %}encrypted:{{cfml_datasource_password_hash}}{% endif %}" port="{{cfml_datasource_port}}" storage="false" username="{{cfml_datasource_username}}" validate="false"/>
        {% endif %}
    </data-sources>
    
    <resources>
        <!--
        arguments:
        lock-timeout   -    define how long a request wait for a log
        -->
        <resource-provider arguments="case-sensitive:true;lock-timeout:1000;" class="railo.commons.io.res.type.ram.RamResourceProvider" scheme="ram"/>
    <resource-provider arguments="lock-timeout:10000;" class="railo.commons.io.res.type.s3.S3ResourceProvider" scheme="s3"/></resources>
    
    <remote-clients directory="{railo-web}remote-client/" log="logs/" log-level="info"/>
    
    
    <!--
        deploy-directory - directory where java classes will be deployed
        custom-tag-directory - directory where the custom tags are
        tld-directory / fld-directory - directory where additional Function and Tag Library Deskriptor are.
        temp-directory - directory for temporary files (upload aso.)
     -->
    <file-system deploy-directory="{railo-web}/cfclasses/" fld-directory="{railo-web}/library/fld/" temp-directory="{railo-web}/temp/" tld-directory="{railo-web}/library/tld/">
    </file-system>
    
    <!--
    scope configuration:
    
        cascading (expanding of undefined scope)
            - strict (argument,variables)
            - small (argument,variables,cgi,url,form)
            - standard (argument,variables,cgi,url,form,cookie)
            
        cascade-to-resultset: yes|no
            when yes also allow inside "output type query" and "loop type query" call implizid call of resultset
            
        merge-url-form:yes|no
            when yes all form and url scope are synonym for both data
        
        client-directory:path to directory where client scope values are stored
        client-directory-max-size: max size of the client scope directory
    -->
    <scope applicationtimeout="1,0,0,0" cascade-to-resultset="true" cascading="standard" client-directory="{railo-web}/client-scope/" client-directory-max-size="100mb" clientmanagement="false" clienttimeout="90,0,0,0" local-mode="update" merge-url-form="false" requesttimeout-log="{railo-web}/logs/requesttimeout.log" session-type="j2ee" sessionmanagement="true" sessionstorage="memory" sessiontimeout="0,0,30,0" setclientcookies="true" setdomaincookies="false"/>
        
    <mail log="{railo-web}/logs/mail.log">
        {% if cfml_smtp_server != "" %}<server password="encrypted:{{cfml_smtp_password_hash}}" port="{{cfml_smtp_port}}" smtp="{{cfml_smtp_server}}" ssl="{{cfml_smtp_ssl}}" tls="{{cfml_smtp_tls}}" username="{{cfml_smtp_user}}"/>{% endif %}
    </mail>
    
    <!--
    define path to search directory
        directory: path
        engine-class: class that implement the Search Engine. Class must be subclass of railo.runtime.search.SearchEngine
    --> 
    <search directory="{railo-web}/search/" engine-class="railo.runtime.search.lucene.LuceneSearchEngine"/>
    
    <!--
    define path to scedule task directory
        directory: path
    --> 
    <scheduler directory="{railo-web}/scheduler/" log="{railo-web}/logs/scheduler.log"/>
    
    <mappings>
    <!--
    directory mapping:
        
        trusted: yes|no
            trusted cache -> recheck every time if there are changes in the called cfml file or not.
        virtual:
            virtual path of the application
            example: /somedir/
            
        physical: 
            physical path to the apllication
            example: d:/projects/app1/webroot/somedir/
            
        archive:
            path to a archive file:
            example: d:/projects/app1/rasfiles/somedir.ras
        primary: archive|physical
            define where railo first look for a called cfml file.
            for example when you define physical you can partiquel overwrite the archive.
        -->
        <mapping archive="{railo-web}/context/railo-context.ra" physical="{railo-web}/context/" primary="physical" readonly="yes" toplevel="yes" trusted="true" virtual="/railo-context/"/>
        <mapping inspect-template="" physical="/opt/www" primary="physical" toplevel="true" virtual="/farcry"/>
        <mapping inspect-template="" physical="/opt/www/core/webtop" primary="physical" toplevel="true" virtual="/webtop"/>
        {% for alias in nginx_aliases %}{% if alias.cfml|default(true) %}
        <mapping inspect-template="" physical="{{alias.actual}}" primary="physical" toplevel="true" virtual="{{alias.virtual}}"/>
        {% endif %}{% endfor %}
    </mappings> 
    
    <custom-tag>
        <mapping physical="{railo-web}/customtags/" trusted="yes"/>
    </custom-tag>
    
    <ext-tags>
        <ext-tag class="railo.cfx.example.HelloWorld" name="HelloWorld" type="java"/>
    </ext-tags>
    
    <!--
    component:
        
        base: 
            path to base component for every component that have no base component defined 
        data-member-default-access: remote|public|package|private
            access type of component data member (variables in this scope)
        use-shadow: if true component variable scope has a second scope, not only the this scope
    -->
    <component base="/railo-context/Component.cfc" data-member-default-access="public" use-shadow="yes"> 
    </component>
    
    <!--
    regional configuration:
        
        locale: default: system locale
            define the locale 
        timezone: default:maschine configuration
            the ID for a TimeZone, either an abbreviation such as "PST", 
            a full name such as "America/Los_Angeles", or a custom ID such as "GMT-8:00". 
        timeserver: [example: swisstime.ethz.ch] default:local time
            dns of a ntp time server
    -->
    <regional/>
    
    <!--
        enable and disable debugging
     -->
    <debugging template="/railo-context/templates/debugging/debugging.cfm"/>
        
    <application application-log="{railo-web}/logs/application.log" application-log-level="error" cache-directory="{railo-web}/cache/" cache-directory-max-size="100mb" exception-log="{railo-web}/logs/exception.log" exception-log-level="error" trace-log="{railo-web}/logs/trace.log" trace-log-level="info"/>
    
    <cache default-function="" default-include="" default-object="defaultcache" default-query="" default-resource="" default-template="">
        <connection class="railo.runtime.cache.eh.EHCache" custom="bootstrapAsynchronously=true&amp;replicatePuts=true&amp;automatic_hostName=&amp;bootstrapType=on&amp;maxelementsinmemory=10000&amp;manual_rmiUrls=&amp;automatic_multicastGroupAddress=230.0.0.1&amp;distributed=off&amp;replicatePutsViaCopy=true&amp;memoryevictionpolicy=LFU&amp;maximumChunkSizeBytes=5000000&amp;timeToIdleSeconds=86400&amp;automatic_multicastGroupPort=4446&amp;listener_socketTimeoutMillis=120000&amp;timeToLiveSeconds=86400&amp;manual_addional=&amp;replicateRemovals=true&amp;replicateUpdatesViaCopy=true&amp;automatic_addional=&amp;replicateAsynchronously=true&amp;maxelementsondisk=10000000&amp;listener_remoteObjectPort=&amp;asynchronousReplicationIntervalMillis=1000&amp;listener_hostName=&amp;replicateUpdates=true&amp;manual_hostName=&amp;automatic_timeToLive=unrestricted&amp;listener_port=" name="defaultcache" read-only="false" storage="false"/>
    </cache>

    <rest/>

    <gateways/>

    <logging>
        <logger appender="resource" appender-arguments="path:logs/" layout="classic" level="info" name="remoteclient"/>
        <logger appender="resource" appender-arguments="path:{railo-web}/logs/mail.log" layout="classic" name="mail"/>
        <logger appender="resource" appender-arguments="path:{railo-web}/logs/scheduler.log" layout="classic" name="scheduler"/>
        <logger appender="resource" appender-arguments="path:{railo-web}/logs/application.log" layout="classic" level="error" name="application"/>
        <logger appender="resource" appender-arguments="path:{railo-web}/logs/exception.log" layout="classic" level="error" name="exception"/>
        <logger appender="resource" appender-arguments="path:{railo-web}/logs/trace.log" layout="classic" level="info" name="trace"/>
    </logging>

    <orm/>

</railo-configuration>
