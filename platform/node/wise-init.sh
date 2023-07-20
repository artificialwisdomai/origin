###
#
# run only once
#
# originally this was in the wise-a30x1, wise-a30x2, and wise-a40x2, which resulted
# in a kernel backtrace.
#
# [   98.145089] vfio-pci 0000:24:00.0: No device request channel registered, blocked until released by user
# [  605.420779] INFO: task driverctl:1660 blocked for more than 120 seconds.
# [  605.420822]       Not tainted 6.1.0-10-amd64 #1 Debian 6.1.37-1
# [  605.420842] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
# [  605.420863] task:driverctl       state:D stack:0     pid:1660  ppid:1659   flags:0x00000002
# [  605.420869] Call Trace:
# [  605.420871]  <TASK>
# [  605.420876]  __schedule+0x351/0xa20
# [  605.420888]  schedule+0x5d/0xe0
# [  605.420892]  schedule_preempt_disabled+0x14/0x30
# [  605.420896]  __mutex_lock.constprop.0+0x3b4/0x700
# [  605.420902]  driver_set_override+0x90/0x140
# [  605.420909]  driver_override_store+0x15/0x30
# [  605.420915]  kernfs_fop_write_iter+0x11e/0x1f0
# [  605.420923]  vfs_write+0x244/0x400
# [  605.420930]  ksys_write+0x6b/0xf0
# [  605.420935]  do_syscall_64+0x5b/0xc0
# [  605.420939]  ? handle_mm_fault+0xdb/0x2d0
# [  605.420945]  ? preempt_count_add+0x47/0xa0
# [  605.420949]  ? up_read+0x37/0x70
# [  605.420953]  ? do_user_addr_fault+0x1bb/0x570
# [  605.420957]  ? fpregs_assert_state_consistent+0x22/0x50
# [  605.420962]  ? exit_to_user_mode_prepare+0x40/0x1d0
# [  605.420967]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
# [  605.420971] RIP: 0033:0x7fb7eccda0e0
# [  605.420975] RSP: 002b:00007ffccc751518 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
# [  605.420979] RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 00007fb7eccda0e0
# [  605.420981] RDX: 0000000000000009 RSI: 000055db097272d0 RDI: 0000000000000001
# [  605.420982] RBP: 000055db097272d0 R08: 00007fb7ecdb4d40 R09: 00007fb7ecdb4d40
# [  605.420984] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000009
# [  605.420985] R13: 00007fb7ecdb5760 R14: 0000000000000009 R15: 00007fb7ecdb09e0
# [  605.420989]  </TASK>

###
#
# NVIDIA PCI bus addressing
#
# https://wiki.xenproject.org/wiki/Bus:Device.Function_(BDF)_Notation
#
# sdake@beast-06:/usr/local/bin$ sudo lspci -tnnd 10de:
# -+-[0000:00]-+-01.1-[01]----00.0
#  +-[0000:20]-+-03.1-[24]----00.0
#  +-[0000:40]-+-01.1-[41]----00.0
#  +-[0000:60]-+-03.1-[61]----00.0
#  +-[0000:a0]-+-03.1-[a1]----00.0
#
# N.B. The tool driverctl uses /etc/driverctl.d/* for persistence
#
# Assign the GPU device to the vfio-pci driver

###
#
# The choices are:
#
# One A30 -> 0000:24:00.0
# Two A30 -> 0000:01:00.0, 0000:41:00.0
# Two A40 -> 0000:61:00.0, 0000:a1:00.0

sudo driverctl set-override 0000:01:00.0 vfio-pci
sudo driverctl set-override 0000:24:00.0 vfio-pci
sudo driverctl set-override 0000:41:00.0 vfio-pci
sudo driverctl set-override 0000:61:00.0 vfio-pci
sudo driverctl set-override 0000:a1:00.0 vfio-pci

