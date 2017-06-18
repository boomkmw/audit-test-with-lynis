hostname=$1 
currentDate=`date +%Y%m%d-%H:%M:%S`

echo "Start Audit Test at $1"
cd lynis
# create tarball
# make directory
mkdir -p ./files
# change working directory to previous working directory
echo "Please wait ..."
cd .. 
# create zip file lynis-remote.tar.gz form directory ./lynis and keep in ./lynis/files/
tar czf ./lynis/files/lynis-remote.tar.gz --exclude=files/lynis-remote.tar.gz ./lynis 
# change working directory to lynis
cd lynis

#copy tarball to target [host address]
#secure copy lynis-remote.tar.gz  to [host address] 
scp -q ./files/lynis-remote.tar.gz root@$1:~/tmp-lynis-remote.tgz
echo "Please wait for copy files to $1"

# Execute audit command
#make directory, unzip file, remove zip file and audit system in hostname
echo "Please wait for processing audit system."
ssh root@$1 "mkdir -p ~/tmp-lynis && cd ~/tmp-lynis && tar xzf ../tmp-lynis-remote.tgz && rm ../tmp-lynis-remote.tgz && cd lynis && ./lynis audit system --no-log --no-colors > ~/result-test/$currentDate.txt"
echo "Audit Test at $1 successfull"

# Retrieve report
# Retrieve report to local host directory
scp root@$1:~/$currentDate.txt /test-tools/result-test/$currentDate.txt
# Remove rreport in [host address]
# wait for string path by mike
cat /test-tools/result-test/$currentDate.txt