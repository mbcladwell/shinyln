#!/bin/bash
rm ./ChangeLog
rm -Rf  ./build-aux
rm ./configure.ac
rm ./Makefile.am
rm ./pre-inst-env.in
rm ./guix.scm
rm ./hall.scm
rm ./*.go
rm ./shinyln/*.go
rm ./scripts/*.*
rm ./shinyln-0.1.tar.gz
hall init --convert --author "mbc" shinyln --execute
hall scan -x
hall build -x
cp /home/mbc/syncd/tobedeleted/shinyln/guix.scm .
cp /home/mbc/syncd/tobedeleted/shinyln/*.sh ./scripts

autoreconf -vif && ./configure && make
cp /home/mbc/syncd/tobedeleted/shinyln/Makefile.am .
make dist

##scp -i /home/mbc/labsolns.pem ./shinyln-0.1.tar.gz admin@ec2-18-189-31-114.us-east-2.compute.amazonaws.com:.
##scp -i /home/mbc/labsolns.pem /home/mbc/syncd/tobedeleted/shinyln/guix.scm admin@ec2-18-189-31-114.us-east-2.compute.amazonaws.com:.
guix package --install-from-file=guix.scm
source /home/mbc/.guix-profile/etc/profile
