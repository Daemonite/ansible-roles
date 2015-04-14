# Tomcat memory settings
# -Xms<size> set initial Java heap size
# -Xmx<size> set maximum Java heap size
# -Xss<size> set java thread stack size
# -XX:MaxPermSize sets the java PermGen size

{% if lucee_aws_settings %}
INSTANCE_TYPE=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-type`
HOSTNAME=`curl http://169.254.169.254/latest/meta-data/hostname`

case $INSTANCE_TYPE in
	m1.small)
		lucee_XMS=768m
		lucee_XMX=768m
		lucee_MAXPERMSIZE=192m
		;;
	m1.medium | m3.medium | c3.large | c3.xlarge | c3.2xlarge | c3.4xlarge | c3.8xlarge)
		lucee_XMS=2560m
		lucee_XMX=2560m
		lucee_MAXPERMSIZE=256m
		;;
	m1.large | m1.xlarge | m3.large | m3.xlarge | m3.2xlarge)
		lucee_XMS=3500m
		lucee_XMX=3500m
		lucee_MAXPERMSIZE=512m
		;;
esac
{% else %}
HOSTNAME=`hostname`
lucee_XMS={{lucee_xms}}
lucee_XMX={{lucee_xmx}}
lucee_MAXPERMSIZE={{lucee_max_perm_size}}
{% endif %}

CATALINA_OPTS="-javaagent:lib/lucee-inst.jar \
               {% if fusionreactor_deploy %}-javaagent:/opt/fusionreactor/instance/Lucee/fusionreactor.jar=name=lucee,address=8088{% endif %} \
               -Dmail.smtp.localhost=$HOSTNAME
               -XX:+CMSIncrementalMode \
               -XX:+ExplicitGCInvokesConcurrent \
               -XX:+CMSPermGenSweepingEnabled \
               -XX:+CMSClassUnloadingEnabled \
               -XX:+UseConcMarkSweepGC
               -Xms$lucee_XMS \
               -Xmx$lucee_XMX \
               -XX:MaxPermSize=$lucee_MAXPERMSIZE"

JAVA_OPTS="{% if fusionreactor_deploy and fusionreactor_license_key != "" %}-Dfrlicense={{fusionreactor_license_key}}{% endif %}"

export CATALINA_OPTS;
export JAVA_OPTS;