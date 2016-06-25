#!/bin/bash
#
##################################################################################################################
# NJsmbclient
# Desc: transfert linux file ( folder recursively ) to win shares  folder on the network with smbclient (samba)
#
# smbclient options::https://www.samba.org/samba/docs/man/manpages/smbclient.1.html 
# 
##################################################################################################################
#path & nom du script & mod debug( 0=false ; 1=true ):
SCRIPT=$0
SCRIPTPATH=$(dirname $SCRIPT)
SCRIPTNAME=$(basename $SCRIPT)
Sdebug=0
SbeROOT=1

#####################################
#Script Test if in terminal ( verbose OK )
#fd=1 ; [[ -t "$fd"  ]] && { SinTerm=1 ;}
[[ -t 1 ]] && { SinTerm=1 ;}
#####################################
#ROOT ONLY:

msg_beroot="<!> Must be root to run this script. <!>"

ROOT_UID=0 # Only users with $UID 0 have root privileges.
E_NOTROOT=67 # Non-root exit error.
# Run as root, of course.
if ((SbeROOT)) && [ "$UID" -ne "$ROOT_UID" ]
then
((SinTerm)) && echo "$msg_beroot"
exit $E_NOTROOT
fi

############################
##Rep & Destination ::
NjRepHomeBackup="/home/nj/rsyncbackupzip"

##WinServer (Smb server) adresse ::
##ip or dns name::
#NjSMBSERVER="192.168.0.33"
NjSMBSERVER="nas.lacie2big.lan"

# Logins var to Winserver
NjWinGroup="xxxGROUP"
NjWinUSER="neoxxx"
NjWinPWD="totototo"

# Server Variables
#Root Directory Server Share
NjRootShare="admin"
#Sub directory Share:
NjSubDirShare="/FilesBackup/Raspbian_backup"

# Local Source Folder to Backup
NjLocalSourceDir="/home/nj/rsyncbackupzip"
[[ -d ${NjLocalSourceDir} ]] || { ((SinTerm)) && echo "Directory Error Location : ${NjLocalSourceDir}" ; exit 1 ;}

#Path smbclient
XSMBCLIENT=$(command -v "smbclient")
[[ -x "${XSMBCLIENT}" ]] || { ((SinTerm)) && echo "Install Samba smbclient Package First!" ; exit 1 ;}

########################################################################################
#RUN backup if NjSMBSERVER is Up :

ping -nq -c3 ${NjSMBSERVER} &>/dev/null && RUNSMBCMD=$( ${XSMBCLIENT} //${NjSMBSERVER}/${NjRootShare} -U ${NjWinGroup}/${NjWinUSER} ${NjWinPWD} -t 30 -c "cd ${NjSubDirShare}; lcd ${NjLocalSourceDir}; prompt; recurse; mput *; exit;" )

exit 0
