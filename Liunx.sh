#!/usr/bin/env bash
Suffix=`date '+%Y-%m-%d-%H-%M-%S'`

cp /etc/shadow /etc/shadow.$Suffix
awk -F: '($1~"^lp$|^nobody$|^uucp$|^games$|^rpm$|^smmsp$|^nfsnobody$") {OFS=":";$2="!!"}{print $0}' /etc/shadow >/etc/shadow.tmp
mv -f /etc/shadow.tmp /etc/shadow

cp /etc/sysctl.conf  /etc/sysctl.conf.$Suffix
egrep "^net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf
if [ $? = 0 ] ;then
awk '/^net\.ipv4\.conf\.all\.accept_redirects/{print "net.ipv4.conf.all.accept_redirects = 0";next};{print}' /etc/sysctl.conf>/etc/sysctl.conf.tmp
mv -f /etc/sysctl.conf.tmp /etc/sysctl.conf
else
echo "net.ipv4.conf.all.accept_redirects = 0" >>/etc/sysctl.conf
fi

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$Suffix
egrep "^PermitRootLogin" /etc/ssh/sshd_config
if [ $? = 0 ] ;then
awk '/^PermitRootLogin/{print "PermitRootLogin no";next};{print}' /etc/ssh/sshd_config>/etc/ssh/sshd_config.tmp
mv -f /etc/ssh/sshd_config.tmp /etc/ssh/sshd_config
else
echo "PermitRootLogin no" >>/etc/ssh/sshd_config
fi

touch /etc/sshbanner
chown bin:bin /etc/sshbanner
chmod 644 /etc/sshbanner
echo "Authorized users only. All activity may be monitored and reported" >/etc/sshbanner
egrep "^Banner" /etc/ssh/sshd_config
if [ $? = 0 ] ;then
awk '/^Banner/{print "Banner /etc/sshbanner";next};{print}' /etc/ssh/sshd_config>/etc/ssh/sshd_config.tmp
mv -f /etc/ssh/sshd_config.tmp /etc/ssh/sshd_config
else
echo "Banner /etc/sshbanner" >>/etc/ssh/sshd_config
fi

cp /etc/profile /etc/profile.$Suffix
egrep  "^TMOUT" /etc/profile
if [ $? = 0 ] ;then
awk '/^TMOUT/{print "TMOUT=180;export TMOUT";next};{print}' /etc/profile>/etc/profile.tmp
mv -f /etc/profile.tmp /etc/profile
else
echo "TMOUT=180;export TMOUT" >>/etc/profile
fi

egrep "^umask" /etc/profile
if [ $? = 0 ] ;then
awk '/^umask/{print "umask 027";next};{print}' /etc/profile>/etc/profile.tmp
mv -f /etc/profile.tmp /etc/profile
else
echo "umask 027" >>/etc/profile
fi


egrep "^alias[[:space:]]{1,}rm" /etc/profile
if [ $? = 0 ] ;then
awk --posix '/^alias[[:space:]]{1,}rm/{print "alias rm='\''rm -i'\''";next};{print}' /etc/profile>/etc/profile.tmp
mv -f /etc/profile.tmp /etc/profile
else
echo "alias rm='rm -i'" >>/etc/profile
fi

egrep "^alias[[:space:]]{1,}ls" /etc/profile
if [ $? = 0 ] ;then
awk --posix '/^alias[[:space:]]{1,}ls/{print "alias ls='\''ls -aol'\''";next};{print}' /etc/profile>/etc/profile.tmp
mv -f /etc/profile.tmp /etc/profile
else
echo "alias ls='ls -aol'" >>/etc/profile
fi

cp /etc/securetty /etc/securetty.$Suffix
egrep  "^console" /etc/securetty
if [ $? = 0 ] ;then
awk '/^console/{print "console=/dev/tty01";next};{print}' /etc/securetty>/etc/securetty.tmp
mv -f /etc/securetty.tmp /etc/securetty
else
echo "console=/dev/tty01" >>/etc/securetty
fi

cp /etc/login.defs /etc/login.defs.$Suffix
egrep "^PASS_MIN_LEN" /etc/login.defs
if [ $? = 0 ] ;then
awk '/^PASS_MIN_LEN/{print "PASS_MIN_LEN 8";next};{print}' /etc/login.defs>/etc/login.defs.tmp
mv -f /etc/login.defs.tmp /etc/login.defs
else
echo "PASS_MIN_LEN 8" >>/etc/login.defs
fi

egrep "^PASS_MAX_DAYS" /etc/login.defs
if [ $? = 0 ] ;then
awk '/^PASS_MAX_DAYS/{print "PASS_MAX_DAYS 90";next};{print}' /etc/login.defs>/etc/login.defs.tmp
mv -f /etc/login.defs.tmp /etc/login.defs
else
echo "PASS_MAX_DAYS 90" >>/etc/login.defs
fi

egrep "^PASS_MIN_DAYS" /etc/login.defs
if [ $? = 0 ] ;then
awk '/^PASS_MIN_DAYS/{print "PASS_MIN_DAYS 0";next};{print}' /etc/login.defs>/etc/login.defs.tmp
mv -f /etc/login.defs.tmp /etc/login.defs
else
echo "PASS_MIN_DAYS 0" >>/etc/login.defs
fi

egrep "^PASS_WARN_AGE" /etc/login.defs
if [ $? = 0 ] ;then
awk '/^PASS_WARN_AGE/{print "PASS_WARN_AGE 7";next};{print}' /etc/login.defs>/etc/login.defs.tmp
mv -f /etc/login.defs.tmp /etc/login.defs
else
echo "PASS_WARN_AGE 7" >>/etc/login.defs
fi

chmod 644 /etc/passwd
chmod 400 /etc/shadow
chmod 644 /etc/group

cp /etc/security/limits.conf /etc/security/limits.conf.$Suffix
egrep "^\*[[:space:]]{1,}soft[[:space:]]{1,}core" /etc/security/limits.conf
if [ $? = 0 ] ;then
awk --posix '/^\*[[:space:]]{1,}soft[[:space:]]{1,}core/{print "* soft core 0";next};{print}' /etc/security/limits.conf>/etc/security/limits.conf.tmp
mv -f /etc/security/limits.conf.tmp /etc/security/limits.conf
else
echo "* soft core 0" >>/etc/security/limits.conf
fi

egrep "^\*[[:space:]]{1,}hard[[:space:]]{1,}core" /etc/security/limits.conf
if [ $? = 0 ] ;then
awk --posix '/^\*[[:space:]]{1,}hard[[:space:]]{1,}core/{print "* hard core 0";next};{print}' /etc/security/limits.conf>/etc/security/limits.conf.tmp
mv -f /etc/security/limits.conf.tmp /etc/security/limits.conf
else
echo "* hard core 0" >>/etc/security/limits.conf
fi

chmod -R 750 /etc/init.d/*

cp /etc/syslog.conf /etc/syslog.conf.old

egrep -v "^#|^$" /etc/syslog.conf|egrep "\*\.err"
if [ $? != 0 ] ;then
echo "*.err        /var/adm/messages" >>/etc/syslog.conf
fi

egrep -v "^#|^$" /etc/syslog.conf|egrep "\*\.info"
if [ $? != 0 ] ;then
echo "*.info        /var/adm/messages" >>/etc/syslog.conf
fi

egrep -v "^#|^$" /etc/syslog.conf|egrep "\*\.emerg"
if [ $? != 0 ] ;then
echo "*.emerg        /var/adm/messages" >>/etc/syslog.conf
fi

egrep -v "^#|^$" /etc/syslog.conf|egrep "local7\.\*"
if [ $? != 0 ] ;then
echo "local7.*        /var/adm/messages" >>/etc/syslog.conf
fi

egrep -v "^#|^$" /etc/syslog.conf|egrep "kern\.debug"
if [ $? != 0 ] ;then
echo "kern.debug       /var/adm/messages" >>/etc/syslog.conf
fi

egrep -v "^#|^$" /etc/syslog.conf|egrep "kern\.warning"
if [ $? != 0 ] ;then
echo "kern.warning       /var/adm/messages" >>/etc/syslog.conf
fi

egrep -v "^#|^$" /etc/syslog.conf|egrep "kern\.warning"
if [ $? != 0 ] ;then
echo "kern.warning       /var/adm/messages" >>/etc/syslog.conf
fi

egrep -v "^#|^$" /etc/syslog.conf|egrep "authpriv\.none"
if [ $? != 0 ] ;then
echo "authpriv.none       /var/adm/messages" >>/etc/syslog.conf
fi

egrep -v "^#|^$" /etc/syslog.conf|egrep "mail\.none"
if [ $? != 0 ] ;then
echo "mail.none       /var/adm/messages" >>/etc/syslog.conf
fi

egrep -v "^#|^$" /etc/syslog.conf|egrep "daemon\.notice"
if [ $? != 0 ] ;then
echo "daemon.notice        /var/adm/messages" >>/etc/syslog.conf
fi

egrep -v "^#|^$" /etc/syslog.conf|egrep "cron\.\*"
if [ $? != 0 ] ;then
echo "cron.*      /var/log/cron" >>/etc/syslog.conf
fi

cp /etc/host.conf /etc/host.conf.$Suffix
echo -e "order bind,hosts\nnospoof on" >/etc/host.conf

echo 1 > /proc/sys/net/ipv4/tcp_syncookies
sysctl -w net.ipv4.tcp_max_syn_backlog="2048"
sysctl -w net.ipv4.conf.all.accept_redirects=0

cp /etc/issue /etc/issue.$Suffix
echo " Authorized users only. All activity may be monitored and reported " > /etc/issue
cp /etc/issue.net /etc/issue.net.$Suffix
echo " Authorized users only. All activity may be monitored and reported " >/etc/issue.net
cp /etc/motd /etc/motd.$Suffix
echo " Authorized users only. All activity may be monitored and reported " >/etc/motd

cp /etc/pam.d/system-auth /etc/pam.d/system-auth.$Suffix
echo "auth    required pam_tally2.so deny=6 onerr=fail no_magic_root unlock_time=120">>/etc/pam.d/system-auth
echo "password    required pam_unix.so remember=5">>/etc/pam.d/system-auth
echo "password    requisite     pam_cracklib.so dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 minclass=2 minlen=6">>/etc/pam.d/system-auth
echo "password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok">>/etc/pam.d/system-auth

for FILE in sendmail chargen chargen-udp cups-lpd cups daytime daytime-udp echo echo-udp eklogin finger gssftp imap imaps ipop2 ipop3 klogin kshell ktalk ntalk pop3s rexec rlogin rsh rsync servers services sgi_fam talk tftp time time-udp vnc
do
    chkconfig ${FILE} off
done
