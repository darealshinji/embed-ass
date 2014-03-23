embed-ass
===============
embed-ass is a shell script that allows you to embed fonts into ass files and to extract them.

**Command line arguments:**<br>
`embed-ass <directory> <ass_file>` `attach files from directory`<br>
`embed-ass <file> <ass_file>` `attach single file`<br>
`embed-ass -e <ass_file>` `extract attachments`<br>

**Examples:**
*embed-ass path/to/fonts subtitles.ass*
*embed-ass fonts/new-font.ttf subtitles.ass*
*embed-ass -e my/data/subtitles.ass*


To convert the fonts, it uses UUEncode-simple from Youka (https://github.com/Youka/UUEncode-simple)
which is already included here and can be compiled with `make && make clean`.

It uses mkvtoolnix to extract them (kinda lame, but reliable).
However, the current stable version currupts the checksums of ass attachments.
Do fix that, you either need to patch the source code of
mkvtoolnix-6.8.0 (you can find the patch file in the 'extra' folder),
or you compile from the current Git version: `git clone git://github.com/mbunkus/mkvtoolnix.git`
Ubuntu users can find patched packages at https://launchpad.net/~djcj/+archive/mkvtoolnix

Run `./check-mkvmerge.sh` to check if your version of mkvtoolnix needs to be patched or not.
