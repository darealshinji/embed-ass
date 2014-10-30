#!/bin/sh -e

cd "`dirname ${0}`"

echo "Make clean..."
rm -rf test.bin test_fonts_attached.ass test_fonts_attached.ass_attachments
echo "done."
if test "${1}" = clean ; then
   exit 0
fi

echo "Create binary file..."
g++ -o test.bin test.c
echo "done."

echo "Attach binary file..."
../embed-ass test.bin test.ass
echo "done."

echo "Extract binary file..."
../embed-ass -x test_fonts_attached.ass
echo "done."

original=$(md5sum --binary test.bin | cut -d ' ' -f1)
extracted=$(md5sum --binary test_fonts_attached.ass_attachments/test.bin | cut -d ' ' -f1)
echo "original  md5: $original"
echo "extracted md5: $extracted"

if test $original = $extracted; then
   echo "It works!"
else
   echo "Oops! Something went wrong."
   exit 1
fi
