# Tomcat memory settings
# -Xms<size> set initial Java heap size
# -Xmx<size> set maximum Java heap size
# -Xss<size> set java thread stack size
# -XX:MaxPermSize sets the java PermGen size

{% if railo_aws_settings %}
INSTANCE_TYPE=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-type`
HOSTNAME=`curl http://169.254.169.254/latest/meta-data/hostname`

case $INSTANCE_TYPE in
	m1.small)
		RAILO_XMS=768m
		RAILO_XMX=768m
		RAILO_MAXPERMSIZE=192m
		;;
	m1.medium | m3.medium | c3.large | c3.xlarge | c3.2xlarge | c3.4xlarge | c3.8xlarge)
		RAILO_XMS=2560m
		RAILO_XMX=2560m
		RAILO_MAXPERMSIZE=256m
		;;
	m1.large | m1.xlarge | m3.large | m3.xlarge | m3.2xlarge)
		RAILO_XMS=3500m
		RAILO_XMX=3500m
		RAILO_MAXPERMSIZE=512m
		;;
esac
{% else %}
HOSTNAME=`hostname`
RAILO_XMS={{railo_xms}}
RAILO_XMX={{railo_xmx}}
RAILO_MAXPERMSIZE={{railo_max_perm_size}}
{% endif %}

CATALINA_OPTS="-javaagent:lib/railo-inst.jar \
               {% if fusionreactor_deploy %}-javaagent:/opt/fusionreactor/instance/Railo/fusionreactor.jar=name=Railo,address=8088{% endif %} \
               -Dmail.smtp.localhost=$HOSTNAME
               -XX:+CMSIncrementalMode \
               -XX:+ExplicitGCInvokesConcurrent \
               -XX:+CMSPermGenSweepingEnabled \
               -XX:+CMSClassUnloadingEnabled \
               -XX:+UseConcMarkSweepGC
               -Xms$RAILO_XMS \
               -Xmx$RAILO_XMX \
               -XX:MaxPermSize=$RAILO_MAXPERMSIZE"

JAVA_OPTS="{% if fusionreactor_deploy and fusionreactor_license_key != "" %}-Dfrlicense={{fusionreactor_license_key}}{% endif %}"

export CATALINA_OPTS;
export JAVA_OPTS;