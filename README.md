embed-ass
===============
**embed-ass** is a shell script that allows you to embed fonts into ass files and to extract them.

**Command line arguments:**<br>
`embed-ass <directory> <ass_file>` `attach files from directory`<br>
`embed-ass <file> <ass_file>` `attach single file`<br>
`embed-ass -x <ass_file>` `extract attachments`<br>

**Examples:**<br>
`embed-ass path/to/fonts subtitles.ass`<br>
`embed-ass fonts/new-font.ttf subtitles.ass`<br>
`embed-ass -x my/data/subtitles.ass`<br>


To convert the fonts, it uses UUEncode-simple from Youka (https://github.com/Youka/UUEncode-simple)
which is already included here and can be compiled with `make`.
