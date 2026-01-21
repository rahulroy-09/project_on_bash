Script name: os_info.sh
#!/bin/bash
echo "===== OPERATING SYSTEM ====="
uname -a
echo "===== OS RELEASE DETAILS ====="
cat /etc/os-release
echo "===== CPU INFORMATION ====="
lscpu
echo "===== MEMORY INFORMATION ====="
free -h
echo "===== DISK USAGE ====="
df -h

