#!/bin/sh

# Copyright (c) 2014, djcj <djcj@gmx.de>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


script="embed-ass"
uuencoder="uuencode-simple"

if [ "$(`which mkvmerge`)" = "" ] ; then
    echo "Can't find 'mkvmerge'"
    exit 0
else
    echo "'mkvmerge' found"
fi

if [ "$(`which mkvextract`)" = "" ] ; then
    echo "Can't find 'mkvextract'"
    exit 0
else
    echo "'mkvextract' found"
fi

if [ "$(`which $uuencoder`)" = "" ] ; then
    if [ ! -f "uuencode-simple" ] ; then
        echo "Can't find '$uuencoder'. Run 'make && make clean' first."
        exit 0
    fi
else
    echo "'$uuencoder' found"
fi

if [ ! -f "$script" ] ; then
    echo "Can't find '$script'"
    exit 0
else
    echo "'$script' found"
fi

if [ ! -f "check/random.c" ] ; then
    echo "Can't find 'random.c'"
    exit 0
else
    echo "'random.c' found"
fi

if [ ! -f "check/test.ass" ] ; then
    echo "Can't find 'test.ass'"
    exit 0
else
    echo "'test.ass' found"
fi


echo ""
echo "Let's see if we can use your version of mkvtoolnix to extract embedded fonts from ass files without getting currupted checksums."
echo ""


echo "generate random binary file"
gcc -o random check/random.c
./random test.bin 524288
checksum1=$(md5sum test.bin | cut -d ' ' -f1)
echo "-> checksum: $checksum1"

echo "generate ass file and attach binary"
./$script test.bin check/test.ass

echo "extract binary file from ass attachments"
./$script -e check/test_fonts_attached.ass

checksum2=$(md5sum check/test_fonts_attached.ass_attachments/test.bin | cut -d ' ' -f1)
echo "-> checksum: $checksum2"
echo ""
rm -rf random test.bin check/test_fonts_attached.ass*

if [ $checksum1 = $checksum2 ] ; then
    echo "Checksums are equal!"
    echo "mkvmerge is capable of handling embedded ass fonts."
else
    echo "Checksums are NOT equal!"
    echo "mkvmerge CAN'T handle embedded ass fonts."
fi
