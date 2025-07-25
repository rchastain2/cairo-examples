
DEST=~/.local/share/fonts/troika

mkdir -p $DEST

cp -f resources/troika.otf $DEST
cp -f resources/freefont_license.txt $DEST

fc-cache -f -v 
