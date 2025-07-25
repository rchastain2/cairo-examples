
## Create desktop launcher

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
DESKTOP_DIR="$HOME/Desktop"
APPMENU_DIR="$HOME/.local/share/applications"

if [ ! -d $DESKTOP_DIR ]; then
  DESKTOP_DIR="$HOME/Bureau"
fi

if [ ! -d $DESKTOP_DIR ]; then
  DESKTOP_DIR=$(xdg-user-dir DESKTOP)
fi

if [ -d $DESKTOP_DIR ] ;
then
  FILE=$DESKTOP_DIR/cairo-clock-simple.desktop
  echo "Create desktop launcher $FILE"
  cat > $FILE << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Horloge Cairo
Exec=$SCRIPT_DIR/cairo-clock --width 192 --height 192 --seconds
Icon=$SCRIPT_DIR/cairo-clock-icon.png
Path=$SCRIPT_DIR
Terminal=false
StartupNotify=true
Categories=Utility;Clock;
EOF
  echo "Make launcher executable"
  chmod -R 777 $FILE
  
  if [ -d $APPMENU_DIR ] ;
  then
    FILE2=$APPMENU_DIR/cairo-clock-simple.desktop
    echo "Copy $FILE to $FILE2"
    cp -f $FILE $FILE2
  else
    echo "Cannot find directory $APPMENU_DIR"
  fi
  
  echo "Done"
else
  echo "Cannot find directory $DESKTOP_DIR"
fi
