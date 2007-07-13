#!/bin/sh
# Copyright 2003-2006 Gentoo Foundation 
# Distributed under the terms of the GNU General Public License v2

. /etc/initrd.defaults
. /etc/initrd.scripts

splash() {
	return 0
}

[ -e /etc/initrd.splash ] && . /etc/initrd.splash

# Clean input/output
exec >${CONSOLE} <${CONSOLE} 2>&1

if [ "$$" != '1' ]
then
	echo '/linuxrc has to be run as the init process as the one'
	echo 'with a PID of 1. Try adding init="/linuxrc" to the'
	echo 'kernel command line or running "exec /linuxrc".'
	exit 1
fi

mount -t proc proc /proc >/dev/null 2>&1
mount -o remount,rw / >/dev/null 2>&1

# Set up symlinks
if [ "$0" = '/init' ]
then
	/bin/busybox --install -s

	[ -e /linuxrc ] && rm /linuxrc
	 
	if [ -e /bin/lvm ]
	then
		ln -s /bin/lvm /bin/vgscan
		ln -s /bin/lvm /bin/vgchange
	fi
fi

quiet_kmsg

CMDLINE="`cat /proc/cmdline`"
# Scan CMDLINE for any specified real_root= or cdroot arguments
REAL_ROOT=''
FAKE_ROOT=''
REAL_ROOTFLAGS=''
for x in ${CMDLINE}
do
	case "${x}" in
		real_root\=*)
			REAL_ROOT=`parse_opt "${x}"`
		;;
		root\=*)
			FAKE_ROOT=`parse_opt "${x}"`
		;;
		subdir\=*)
			SUBDIR=`parse_opt "${x}"`
		;;
		real_init\=*)
			REAL_INIT=`parse_opt "${x}"`
		;;
		init_opts\=*)
			INIT_OPTS=`parse_opt "${x}"`
		;;
		# Livecd options
		cdroot)
			CDROOT=1
		;;
		cdroot\=*)
			CDROOT=1
			CDROOT_DEV=`parse_opt "${x}"`
		;;
		# Start livecd loop and looptype options
		loop\=*)
			LOOP=`parse_opt "${x}"`
		;;
		looptype\=*)
			LOOPTYPE=`parse_opt "${x}"`
		;;
		# Start Device Manager options 
		devfs)
			USE_DEVFS_NORMAL=1
			USE_UDEV_NORMAL=0
		;;
		udev)
			USE_DEVFS_NORMAL=0
			USE_UDEV_NORMAL=1
		;;
		unionfs)
			if [ ! -x /sbin/unionctl ]
			then
				USE_UNIONFS_NORMAL=0
				bad_msg 'Unionctl not found: aborting use of unionfs!'
			else
				USE_UNIONFS_NORMAL=1
			fi
		;;
		unionfs\=*)
			if [ ! -x /sbin/unionctl ]
			then
				USE_UNIONFS_NORMAL=0
				bad_msg 'Unionctl not found: aborting use of unionfs!'
			else
				USE_UNIONFS_NORMAL=1
				CMD_UNIONFS=`parse_opt "${x}"`
				echo ${CMD_UNIONFS}|grep , >/dev/null 2>&1
				if [ "$?" -eq '0' ]
				then
					UID=`echo ${CMD_UNIONFS#*,}`
					UNIONFS=`echo ${CMD_UNIONFS%,*}`
				else
					UNIONFS=${CMD_UNIONFS}
				fi
			fi
		;;
		# Start Volume manager options 
		dolvm2)
			USE_LVM2_NORMAL=1
		;;
		dodmraid)
			USE_DMRAID_NORMAL=1
		;;
		dodmraid\=*)
			DMRAID_OPTS=`parse_opt "${x}"`
			USE_DMRAID_NORMAL=1
		;;
		doevms2)
			USE_EVMS2_NORMAL=1
		;;
		# Debug Options
		debug)
			DEBUG='yes'
		;;
		 # Scan delay options 
		scandelay\=*)
			SDELAY=`parse_opt "${x}"`
		;;
		scandelay)
			SDELAY=10
		;;
		# Module no-loads
		doload\=*)
			MDOLIST=`parse_opt "${x}"`
			MDOLIST="`echo ${MDOLIST} | sed -e \"s/,/ /g\"`"
		;;
		nodetect)
			NODETECT=1
		;;
		noload\=*)
			MLIST=`parse_opt "${x}"`
			MLIST="`echo ${MLIST} | sed -e \"s/,/ /g\"`"
			export MLIST
		;;
		# Redirect output to a specific tty
		CONSOLE\=*)
			CONSOLE=`parse_opt "${x}"`
			exec >${CONSOLE} <${CONSOLE} 2>&1
		;;
		# /dev/md
		lvmraid\=*)
			RAID_DEVICES="`parse_opt ${x}`"
			RAID_DEVICES="`echo ${RAID_DEVICES} | sed -e 's/,/ /g'`"
		;;
		part\=*)
			MDPART=`parse_opt "${x}"`
		;;
		# NFS
		ip\=*)
			IP=`parse_opt "${x}"`
		;;
		nfsroot\=*)
			NFSROOT=`parse_opt "${x}"`
		;;
		crypt_root\=*)
			LUKS_ROOT=`parse_opt "${x}"`
		;;
		crypt_swap\=*)
			LUKS_SWAP=`parse_opt "${x}"`
		;;
		real_rootflags\=*)
			REAL_ROOTFLAGS=`parse_opt "${x}"`
		;;
	esac
done

if [ -z "${REAL_ROOT}" -a \( "${CDROOT}" -eq 0 \)  -a \( "${FAKE_ROOT}" != "/dev/ram0" \) ]
then
	REAL_ROOT="${FAKE_ROOT}"	
fi

splash 'init'

detect_sbp2_devices
cmdline_hwopts

# Load modules listed in MY_HWOPTS if /lib/modules exists
if [ -d '/lib/modules' ]
then
	good_msg 'Loading modules'
	# Load appropriate kernel modules
	if [ "${NODETECT}" -ne '1' ]
	then
		for modules in $MY_HWOPTS
		do
			modules_scan $modules
			eval DO_`echo $modules | sed 's/-//'`=1
		done
	fi
	# Always eval doload=...
	modules_load $MDOLIST
else
	for modules in $MY_HWOPTS
	do
		eval DO_`echo $modules | sed 's/-//'`=1
	done
	good_msg 'Skipping module load; no modules in the initrd!'
fi

# Mount sysfs
mount_sysfs

# Delay if needed for USB hardware
sdelay

# Start udev/devfs
start_dev_mgr

# Setup md device nodes if they dont exist
setup_md_device

# Scan volumes
startVolumes

# Initialize LUKS root device
startLUKS

# Set up unionfs
mkdir -p ${NEW_ROOT}
setup_unionfs

if [ "${USE_UNIONFS_NORMAL}" -eq '1' ]
then
	CHROOT=${UNION}
else
	CHROOT=${NEW_ROOT}
fi

# Run debug shell if requested
rundebugshell

suspend_resume
suspend2_resume

if [ "${CDROOT}" -eq '1' ]
then
	if [ ! "${USE_UNIONFS_NORMAL}" -eq '1' ]
	then
		good_msg "Making tmpfs for ${NEW_ROOT}"
		mount -t tmpfs tmpfs ${NEW_ROOT}
	fi
	
	for i in dev mnt mnt/cdrom mnt/livecd tmp tmp/.initrd mnt/gentoo sys
	do
		mkdir -p ${NEW_ROOT}/$i
		chmod 755 ${NEW_ROOT}/$i
	done
	[ ! -e ${NEW_ROOT}/dev/null ] && mknod ${NEW_ROOT}/dev/null c 1 3
	[ ! -e ${NEW_ROOT}/dev/console ] && mknod ${NEW_ROOT}/dev/console c 5 1

	# For SGI LiveCDs ...
	if [ "${LOOPTYPE}" = "sgimips" ]
	then
		[ ! -e ${NEW_ROOT}/dev/sr0 ] && mknod ${NEW_ROOT}/dev/sr0 b 11 0
		[ ! -e ${NEW_ROOT}/dev/loop0 ] && mknod ${NEW_ROOT}/dev/loop0 b 7 0
	fi

	# Required for gensplash to work.  Not an issue with the initrd as this
	# device isnt created there and is not needed.
	if [ -e /dev/tty1 ]
	then
		[ ! -e ${NEW_ROOT}/dev/tty1 ] && mknod ${NEW_ROOT}/dev/tty1 c 4 1
	fi

	if [ "${REAL_ROOT}" != "/dev/nfs" ] && [ "${LOOPTYPE}" != "sgimips" ]
	then
		bootstrapCD
	fi

	if [ "${REAL_ROOT}" = '' ]
	then
		echo -n -e "${WARN}>>${NORMAL}${BOLD} No bootable medium found. Waiting for new devices"
		
		COUNTER=0
		while [ $COUNTER -lt 3 ]; do
			sleep 3
			echo -n '.'
			let COUNTER=$COUNTER+1
		done	
		
		sleep 1
		echo -e "${NORMAL}"
		bootstrapCD
	fi

	if [ "${REAL_ROOT}" = '' ]
	then
		# Undo stuff
		umount  ${NEW_ROOT}/dev 2>/dev/null
		umount  ${NEW_ROOT}/sys 2>/dev/null
		umount /sys 2>/dev/null

		umount  ${NEW_ROOT}
		rm -rf  ${NEW_ROOT}/*

		bad_msg 'Could not find CD to boot, something else needed!'
		CDROOT=0
	fi
fi

setup_keymap

# Determine root device
good_msg 'Determining root device...'
while true
do
	while [ "${got_good_root}" != '1' ]
	do
		case "${REAL_ROOT}" in
			LABEL\=*|UUID\=*)
			
				ROOT_DEV=""
				retval=1
				
				if [ "${retval}" -ne '0' ]; then
					ROOT_DEV=`findfs "${REAL_ROOT}" 2>/dev/null`
					retval=$?
				fi
				
				if [ "$retval" -ne '0' ]; then
					ROOT_DEV=`busybox findfs "${REAL_ROOT}" 2>/dev/null`
					retval=$?
				fi
				
				if [ "${retval}" -ne '0' ]; then
					ROOT_DEV=`blkid -t "${REAL_ROOT}" | cut -d ":" -f 1 2>/dev/null`
					retval=$?
				fi
				
				if [ "${retval}" -eq '0' ] && [ -n "${ROOT_DEV}" ]; then
					good_msg "Detected real_root=${ROOT_DEV}"
					REAL_ROOT="${ROOT_DEV}"
				else
					bad_msg "Could not find root block device: ${REAL_ROOT}"
					echo '   Please specify a device to boot, or "shell" for a shell...'
					echo -n 'boot() :: '
					read REAL_ROOT
					got_good_root=0
					continue
				fi
				;;
		esac
				
		if [ "${REAL_ROOT}" = 'shell' ]
		then
			run_shell

			REAL_ROOT=''
			got_good_root=0
			continue
		
		elif [ "${REAL_ROOT}" = '' ]
		then
			# No REAL_ROOT determined/specified. Prompt user for root block device.
			bad_msg "The root block device is unspecified or not detected."
			echo '   Please specify a device to boot, or "shell" for a shell...'
			echo -n 'boot() :: '
			read REAL_ROOT
			got_good_root=0

		# Check for a block device or /dev/nfs
		elif [ -b "${REAL_ROOT}" ] || [ "${REAL_ROOT}" = "/dev/nfs" ]
		then
			got_good_root=1

		else
			bad_msg "Block device ${REAL_ROOT} is not a valid root device..."
			REAL_ROOT=""
			got_good_root=0
		fi
	done


	if [ "${CDROOT}" -eq '1' -a "${got_good_root}" = '1' -a "${REAL_ROOT}" != "/dev/nfs" ]
	then
		# CD already mounted; no further checks necessary
		break
	elif [ "${LOOPTYPE}" = "sgimips" ]
	then
		# sgimips mounts the livecd root partition directly
		# there is no isofs filesystem to worry about
		break
	else
		good_msg "Mounting root..."

		# Try to mount the device as ${NEW_ROOT}
		if [ "${REAL_ROOT}" = '/dev/nfs' ]; then
			findnfsmount
		else
			# mount ro so fsck doesn't barf later
#			REAL_ROOT_TYPE=`vol_id -t ${REAL_ROOT}`
#			mount -t ${REAL_ROOT_TYPE} -o ro ${REAL_ROOT} ${NEW_ROOT}
			if [ "${REAL_ROOTFLAGS}" = '' ]; then
				mount -o ro ${REAL_ROOT} ${NEW_ROOT}
			else
				good_msg "Using mount -o ro,${REAL_ROOTFLAGS}"
				mount -o ro,${REAL_ROOTFLAGS} ${REAL_ROOT} ${NEW_ROOT}
			fi
		fi
		
		# If mount is successful break out of the loop 
		# else not a good root and start over.

		if [ "$?" = '0' ]
		then
			break
		else
			bad_msg "Could not mount specified ROOT, try again"
			got_good_root=0
			REAL_ROOT=''
		fi
	fi
done
# End determine root device

#verbose_kmsg

# If cdroot is set determine the looptype to boot
if [ "${CDROOT}" = '1' ]
then
	good_msg 'Determining looptype ...'
	cd ${NEW_ROOT}

	# Find loop and looptype if we have NFS-mounted a livecd
	if  [ "${LOOP}" = '' ] && [ "${REAL_ROOT}" = '/dev/nfs' ]
	then
		if [ -e "${NEW_ROOT}/mnt/cdrom/livecd.loop" ]; then
			LOOP='/livecd.loop'
			LOOPTYPE='normal'
				elif [ -e "${NEW_ROOT}/mnt/cdrom/zisofs" ]; then
			LOOP='/zisofs'
			LOOPTYPE='zisofs'
				elif [ -e "${NEW_ROOT}/mnt/cdrom/livecd.squashfs" ]; then
			LOOP='/livecd.squashfs'
			LOOPTYPE='squashfs'
				elif [ -e "${NEW_ROOT}/mnt/cdrom/image.squashfs" ]; then
			LOOP='/image.squashfs'
			LOOPTYPE='squashfs'
				elif [ -e "${NEW_ROOT}/mnt/cdrom/livecd.gcloop" ]; then
			LOOP='/livecd.gcloop'
			LOOPTYPE='gcloop'
				else
			LOOPTYPE='noloop'
		fi
	fi

	# Failsafe the loop type wasn't set
	if [ "${LOOPTYPE}" = '' ]
	then
		warn_msg 'Warning: loop type unspecified!'
		if [ "${LOOP}" = '/livecd.loop' ]
		then
			LOOPTYPE='normal'
		elif [ "${LOOP}" = '/zisofs' ]
		then
			LOOPTYPE='zisofs'
		elif [ "${LOOP}" = '/livecd.squashfs' ]
		then
			LOOPTYPE='squashfs'
		elif [ "${LOOP}" = '/image.squashfs' ]
		then
			LOOPTYPE='squashfs'
		elif [ "${LOOP}" = '/livecd.gcloop' ]
		then
			LOOPTYPE='gcloop'
		else
			LOOPTYPE='noloop'
		fi
	fi

	cache_cd_contents
	# Setup the loopback mounts

	if [ "${LOOPTYPE}" = 'normal' ]
	then
		good_msg 'Mounting loop filesystem'
		mount -t ext2 -o loop,ro ${NEW_ROOT}/mnt/cdrom/${LOOPEXT}${LOOP} ${NEW_ROOT}/mnt/livecd
		test_success 'Mount filesystem'
		FS_LOCATION='mnt/livecd'


	elif [ "${LOOPTYPE}" = 'squashfs' ]
	then
		good_msg 'Mounting squashfs filesystem'
		mount -t squashfs -o loop,ro ${NEW_ROOT}/mnt/cdrom/${LOOPEXT}${LOOP} ${NEW_ROOT}/mnt/livecd
		
		test_success 'Mount filesystem'
		FS_LOCATION='mnt/livecd'
	
	elif [ "${LOOPTYPE}" = 'gcloop' ]
	then
		good_msg 'Mounting gcloop filesystem'
		echo ' ' | losetup -E 19 -e ucl-0 -p0 ${NEW_ROOT}/dev/loop0 ${NEW_ROOT}/mnt/cdrom/${LOOPEXT}${LOOP}
		test_success 'losetup the loop device'

		mount -t ext2 -o ro ${NEW_ROOT}/dev/loop0 ${NEW_ROOT}/mnt/livecd
		test_success 'Mount the losetup loop device'
		FS_LOCATION='mnt/livecd'
	
	elif [ "${LOOPTYPE}" = 'zisofs' ]
	then
		FS_LOCATION="mnt/cdrom/${LOOPEXT}${LOOP}"
	
	elif [ "${LOOPTYPE}" = 'noloop' ]
	then
		FS_LOCATION='mnt/cdrom'

	elif [ "${LOOPTYPE}" = 'sgimips' ]
	then
		# getdvhoff finds the starting offset (in bytes) of the squashfs
		# partition on the cdrom and returns this offset for losetup
		#
		# All currently supported SGI Systems use SCSI CD-ROMs, so
		# so we know that the CD-ROM is usually going to be /dev/sr0.
		#
		# We use the value given to losetup to set /dev/loop0 to point
		# to the liveCD root partition, and then mount /dev/loop0 as
		# the LiveCD rootfs
		good_msg 'Locating the SGI LiveCD Root Partition'
		echo ' ' | \
			losetup -o $(/bin/getdvhoff ${NEW_ROOT}${REAL_ROOT} 0) \
				${NEW_ROOT}${CDROOT_DEV} \
				${NEW_ROOT}${REAL_ROOT}
		test_success 'losetup /dev/sr0 /dev/loop0'

		good_msg 'Mounting the Root Partition'
		mount -t squashfs -o ro ${NEW_ROOT}${CDROOT_DEV} ${NEW_ROOT}/mnt/livecd
		test_success 'mount /dev/loop0 /'
		FS_LOCATION='mnt/livecd'
	fi

#
# End cdrom looptype determination and mounting if necessary
#

	if [ "${USE_UNIONFS_NORMAL}" -eq '1' ]
	then
		union_insert_dir ${UNION} ${NEW_ROOT}/${FS_LOCATION}
		
		# Make sure fstab notes livecd is mounted ro.  Makes system skip remount which fails on unionfs dirs.
		sed -e 's|\(.*\s/\s*tmpfs\s*\)defaults\(.*\)|\1defaults,ro\2|' /${UNION}/etc/fstab > /${UNION}/etc/fstab.new
		mv /${UNION}/etc/fstab.new /${UNION}/etc/fstab
	fi

	# Unpacking additional packages from NFS mount
	# This is useful for adding kernel modules to /lib
	# We do this now, so that additional packages can add whereever they want.
	if [ "${REAL_ROOT}" = '/dev/nfs' ]
	then
		if [ -e "${CHROOT}/mnt/cdrom/add" ]
		then
				for targz in `ls ${CHROOT}/mnt/cdrom/add/*.tar.gz`
				do	
					tarname=`basename ${targz}`
					good_msg "Adding additional package ${tarname}"
					(cd ${CHROOT} ; /bin/tar -xzf ${targz})
				done
		fi
	fi

	
	if [ ! "${USE_UNIONFS_NORMAL}" -eq '1' ]
	then
		good_msg "Copying read-write image contents to tmpfs"
		# Copy over stuff that should be writable
		(cd ${NEW_ROOT}/${FS_LOCATION}; cp -a ${ROOT_TREES} ${NEW_ROOT})

		# Now we do the links.
		for x in ${ROOT_LINKS}
		do
			if [ -L "${NEW_ROOT}/${FS_LOCATION}/${x}" ]
			then
				ln -s "`readlink ${NEW_ROOT}/${FS_LOCATION}/${x}`" "${x}" 2>/dev/null
			else
				# List all subdirectories of x
				for directory in `find "${NEW_ROOT}/${FS_LOCATION}/${x}" -type d 2>/dev/null`
				do
					## Strip the prefix of the FS_LOCATION
					directory=${directory#${NEW_ROOT}/${FS_LOCATION}/}

					## Skip this directory if we already linked a parent directory
					if [ "${curent_parrent}" != '' ]; then
						var=`echo "${directory}" | grep "^${curent_parrent}"`
						if [ "${var}" != '' ]; then
							continue
						fi
					fi
					## Test if the directory exists already
					if [ -e "/${NEW_ROOT}/${directory}" ]
					then
						# It does exist, link all the individual files
						for file in `ls /${NEW_ROOT}/${FS_LOCATION}/${directory}`
						do
						if [ ! -d "/${NEW_ROOT}/${FS_LOCATION}/${directory}/${file}" ] && [ ! -e "${NEW_ROOT}/${directory}/${file}" ]; then
								ln -s "/${FS_LOCATION}/${directory}/${file}" "${directory}/${file}" 2> /dev/null
							fi
						done
					else
						# It does not exist, make a link to the livecd
						ln -s "/${FS_LOCATION}/${directory}" "${directory}" 2>/dev/null
						current_parent=${directory}
					fi
				done
			fi
		done

		[ "${DO_slowusb}" ] && sleep 10
		mkdir initrd proc tmp sys 2>/dev/null
		chmod 1777 tmp
	fi
	
	#UML=`cat /proc/cpuinfo|grep UML|sed -e 's|model name.*: ||'`
	#if [ "${UML}" = 'UML' ]
	#then
	#	# UML Fixes
	#	good_msg 'Updating for uml system'
	#fi

	# Let Init scripts know that we booted from CD
	export CDBOOT
	CDBOOT=1
	[ "${DO_slowusb}" ] && sleep 10
else
	if [ "${USE_UNIONFS_NORMAL}" -eq '1' ]
	then
		union_insert_dir ${UNION} ${NEW_ROOT}
		mkdir -p ${UNION}/tmp/.initrd
	fi
fi

# Execute script on the cdrom just before boot to update things if necessary
cdupdate

if [ "${SUBDIR}" != '' -a -e "${CHROOT}/${SUBDIR}" ]
then
	good_msg "Entering ${SUBDIR} to boot"
	CHROOT=${CHROOT}/${SUBDIR}
fi

verbose_kmsg

# Move the /memory mount point to what will be the system root so that 
# init scripts will be able to unmount it properly at next reboot
#
# Eventually, all "unions over /" mounts should go in that /.unions/
if [ "${USE_UNIONFS_NORMAL}" -eq '1' ]
then
	mkdir -p /${CHROOT}/.unions/memory 2>/dev/null
	mount -o move /memory /${CHROOT}/.unions/memory || echo '*: Failed to move unionfs /memory into the system root!'
fi

if [ "$0" = '/linuxrc' ] || [ "$0" = 'linuxrc' ]
then
	[ ! -e ${CHROOT}/dev/console ] && mknod ${CHROOT}/dev/console c 5 1
	echo -ne "${GOOD}>>${NORMAL}${BOLD} Booting"

	cd ${CHROOT}
	mkdir ${CHROOT}/proc ${CHROOT}/sys 2>/dev/null
	pivot_root . tmp/.initrd
	[ "${DO_slowusb}" ] && sleep 10
	echo -n '.'

	if /tmp/.initrd/bin/[ "${USE_DEVFS_NORMAL}" -eq '1' -a "${CDROOT}" -eq '0' ]
	then
		umount /tmp/.initrd/proc || echo '*: Failed to unmount the initrd /proc!'
		mount -n --move /tmp/.initrd/dev dev || echo '*: Failed to move over the /dev tree!'
		rm -rf /tmp/.initrd/dev || echo '*: Failed to remove the initrd /dev!'
	elif /tmp/.initrd/bin/[ "${USE_UDEV_NORMAL}" -eq '1' ]
	then
		/tmp/.initrd/bin/[ -e /tmp/.initrd/dev/fd ] && rm /tmp/.initrd/dev/fd
		/tmp/.initrd/bin/[ -e /tmp/.initrd/dev/stdin ] && rm /tmp/.initrd/dev/stdin
		/tmp/.initrd/bin/[ -e /tmp/.initrd/dev/stdout ] && rm /tmp/.initrd/dev/stdout
		/tmp/.initrd/bin/[ -e /tmp/.initrd/dev/stderr ] && rm /tmp/.initrd/dev/stderr
		/tmp/.initrd/bin/[ -e /tmp/.initrd/dev/core ] && rm /tmp/.initrd/dev/core 
		umount /tmp/.initrd/dev || echo '*: Failed to unmount the initrd /dev!'
		umount /tmp/.initrd/proc || echo '*: Failed to unmount the initrd /proc!'
		umount /tmp/.initrd/sys || echo '*: Failed to unmount the initrd /sys!'
	elif /tmp/.initrd/bin/[ "${CDROOT}" -eq '1' ]
	then
		umount /tmp/.initrd/proc || echo "*: Failed to unmount the initrd /proc!"
		umount /dev 2>/dev/null
		mount -n --move /tmp/.initrd/dev dev 2>/dev/null
		rm -rf /tmp/.initrd/dev || echo '*: Failed to remove the initrd /dev!'

		umount /sys 2>/dev/null
		umount /tmp/.initrd/sys 2>/dev/null
	fi
	echo -n '.'

	# /usr/src/linux/Documentation/initrd.txt:
	#	exec chroot . /sbin/init </dev/console >/dev/console 2>&1

	exec <dev/console >dev/console 2>&1
	echo '.'
	exec chroot . /bin/sh <<- EOF
		umount /tmp/.initrd || echo "*: Failed to unmount the initrd!"
		/sbin/blockdev --flushbufs /dev/ram0 >/dev/null 2>&1
		exec ${REAL_INIT:-/sbin/init} ${INIT_OPTS}
EOF
elif [ "$0" = '/init' ]
then
	[ ! -e ${CHROOT}/dev/console ] && mknod ${CHROOT}/dev/console c 5 1
	[ ! -e ${CHROOT}/dev/tty1 ] && mknod ${CHROOT}/dev/tty1 c 4 1
	echo -ne "${GOOD}>>${NORMAL}${BOLD} Booting (initramfs)"

	cd ${CHROOT}
	mkdir ${CHROOT}/proc ${CHROOT}/sys 2>/dev/null
	echo -n '.'
		umount /sys || echo '*: Failed to unmount the initrd /sys!'
		umount /proc || echo '*: Failed to unmount the initrd /proc!'
	echo -n '.'

	exec switch_root -c "/dev/console" "${CHROOT}" /sbin/init ${REAL_INIT}
fi

splash 'verbose'

echo 'A fatal error has probably occured since /sbin/init did not'
echo 'boot correctly. Trying to open a shell...'
echo
exec /bin/bash
exec /bin/sh
exec /bin/ash
exec sh
