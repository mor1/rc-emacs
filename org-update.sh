#!/bin/sh

# script to automate pulling the latest org from Carsten's site
# PJP pete@smtl.co.uk
# $Revision: 1.2 $
# $Log: update-org.sh,v $
# Revision 1.2  2007/12/12 18:56:40  pete
# added changes due to change of location of the archive, and some other
# changes suggested by Harald Weis <hawei@free.fr>
#
# Revision 1.1  2007/04/26 05:53:54  pete
# Initial revision
#

# set up some variables
# EDIT THESE.!!!

# directory where the org directory is located
# Note that you must have write permission in the DIR 
# directory at a minimum. 
DIR=~/.emacs.d
ORGDIR=$DIR/org
TMP=/tmp
TMPTAR=$TMP/org.tar.gz

# This is where I keep my copy of CVS emacs. 
#EMACSBIN=/usr/local/emacs-cvs/bin/emacs
#EMACSBIN=/usr/bin/emacs-snapshot
#EMACSBIN=/usr/local/bin/emacs
EMACSBIN=/sw/bin/emacs

# you should not need to edit anything else below here

# go to the tmp dir
cd $TMP

# make sure we have the lisp dir
mkdir -p $DIR

# remove the tmpfile in case there is still one hanging around
rm -f $TMPTAR

# get the tar file
#wget http://staff.science.uva.nl/~dominik/Tools/org/org.tar.gz
wget http://orgmode.org/org.tar.gz

# ORGDIR is a symbolic link. We get rid of it
rm $ORGDIR

# cd to the lisp directory
cd $DIR

# unpack the tar file
tar xzvf $TMPTAR

# what is the new directory name?
# ORGVER=`tar tvf $TMPTAR | head -1 | sed 's/  */ /g' | cut -d' ' -f6`
# Thanks to Harald Weis <hawei@free.fr> for this simplification
ORGVER=`tar tf $TMPTAR | head -1`

# remake the link...
ln -s $ORGVER org

# make ...
cd $ORGDIR
mv Makefile Makefile.orig
sed s:EMACS=emacs:EMACS=$EMACSBIN: < Makefile.orig > Makefile
make

