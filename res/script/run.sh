#!/bin/bash

RAWDIRNAME=raw
PPDIRNAME=preprocessed
TAGGEDDIRNAME=tagged
FINALDIRNAME=final
SCRIPTDIR=script
FORBIDDENDIR=forbidden
TAGGERDIR=../TreeTagger/cmd

DIRS=( $TAGGEDDIRNAME $FINALDIRNAME )

if [ "$1" = "pp" ]; then
    if [ -d $RAWDIRNAME ]; then
        for lang in $( ls $RAWDIRNAME ); do
            PPDIR=$PPDIRNAME/$lang
            RAWDIR=$RAWDIRNAME/$lang

            # build directory structure
            [ -d $PPDIRNAME ] || mkdir $PPDIRNAME
            [ -d $PPDIR ] || mkdir $PPDIR

            # iterate through the texts in each language
            for text in $( ls $RAWDIR ); do
                outfile=./$PPDIR/$text
                if [ ! -e $outfile ]; then # only process if not already done
                    msg="Stripping Headers and Footers from $text"
                    echo $msg
                    infile=./$RAWDIR/$text
                    ./$SCRIPTDIR/stripgutenberg.pl < $infile > $outfile
                fi
            done
        done
    fi
else
    if [ -d $PPDIRNAME ]; then
        for lang in $( ls $PPDIRNAME ); do
            PPDIR=$PPDIRNAME/$lang
            TAGGEDDIR=$TAGGEDDIRNAME/$lang
            FINALDIR=$FINALDIRNAME/$lang

            # build directory structure
            [ -d $TAGGEDDIRNAME ] || mkdir $TAGGEDDIRNAME
            [ -d $TAGGEDDIR ] || mkdir $TAGGEDDIR
            [ -d $FINALDIRNAME ] || mkdir $FINALDIRNAME
            [ -d $FINALDIR ] || mkdir $FINALDIR

            for text in $( ls $PPDIR ); do
                outfile=./$TAGGEDDIR/$text
                finalfile=./$FINALDIR/$text
                if [ ! -e $outfile ]; then
                    msg="Tagging $text with language $lang"
                    echo $msg
                    infile=./$PPDIR/$text
                    $TAGGERDIR/tree-tagger-$lang $infile > $outfile
                fi
                if [ ! -e $finalfile ]; then
                    msg="Cleaning $text with language $lang"
                    echo $msg
                    forbiddenfile=./$FORBIDDENDIR/$lang
                    ./$SCRIPTDIR/cleanup.rb "$outfile" "$finalfile" "$forbiddenfile"
                fi
       done
        done
    fi
fi
