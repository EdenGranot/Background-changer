#!/bin/bash
# Simple background changer for kde plasme.
# Written by Eden Granot.

path=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/";

if [ ! -f $path".index.txt" ]; then
    touch $path".index.txt";
    echo "0" > $path".index.txt";
fi

index=$(cat $path".index.txt");
backgrounds=($(ls $path | grep ".png\|.jpg"));
max=${#backgrounds[@]};
if [ $index -ge $((max - 1)) ]; then
    index=0;
else
    index=$((index + 1));
fi

echo "$index" > $path".index.txt";
background=${backgrounds[$index]};

dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string:
var Desktops = desktops();
for (i=0;i<Desktops.length;i++) {
        d = Desktops[i];
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = Array("Wallpaper",
                                    "org.kde.image",
                                    "General");
        d.writeConfig("Image", "'$path$background'");
}'
