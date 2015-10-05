# GutenbergTreeTagger

This project semi automates tagging of Project Gutenberg texts using TreeTagger
part-of-speech tagger from
http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/

## Usage
This project is designed to be run from within the `res` directory.

Ensure you have the TreeTagger system installed properly.

Download the raw text version of the text you desire to tag into a folder
denoting the language of the text (I use ISO 639-1 codes, however this causes
more issues later) such as `raw/de`.

Ensure that the variables in the `script/run.sh` script are set correctly for
your configuration.

Strip the header and footer from this file by running `./script/run.sh pp`, this
invokes a perl script that cleans up the majority of the header, following this
ensure that the files are correctly stripped of all the Project Gutenberg
information.

Following this run `./script/run.sh` this runs TreeTagger on all of the
preprocessed files and then removes any symbols listed in a forbidden word list
for the language (easy to remove punctuation and sentence markers).

The Tagger and Forbidden symbol file used depends on the directory structure of
the `$PPDIRNAME` folder, i.e. if a subdirectory is named `german` then the
tagger attempted to be used is `tree-tagger-german` within the `TAGGERDIR`
directory and the forbidden symbol file would be `$FORBIDDENDIR/german`.

The output of this process is a tab-separated data file containing the word,
the part of speech and the lemma for each word in the source.
