#!/bin/sh

echo "Usage: provide file.pdf -then- target image resoltion\n"

gs  -dNOPAUSE -dBATCH -dSAFER \
    -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.5 \
    -dPDFSETTINGS=/screen \
    -dEmbedAllFonts=true \
    -dSubsetFonts=true \
    -dColorImageDownsampleType=/Bicubic \
    -dColorImageResolution="$2" \
    -dGrayImageDownsampleType=/Bicubic \
    -dGrayImageResolution="$2" \
    -dMonoImageDownsampleType=/Bicubic \
    -dMonoImageResolution="$2" \
    -sOutputFile=out.pdf \
     "$1"
