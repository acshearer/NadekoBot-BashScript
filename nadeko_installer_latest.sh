#!/bin/sh
echo ""
echo "NadekoBot Installer started."

if hash git 1>/dev/null 2>&1
then
    echo ""
    echo "Git Installed."
else
    echo ""    
    echo "Git is not installed. Please install Git."
    exit 1
fi


if hash dotnet 1>/dev/null 2>&1
then
    echo ""
    echo "Dotnet installed."
else
    echo ""
    echo "Dotnet is not installed. Please install dotnet."
    exit 1
fi

root=$(pwd)
builddir="${root}NadekoInstall_Temp"

rm -rf "$builddir" 1>/dev/null 2>&1
mkdir -p "$builddir"
cd "$builddir"

echo ""
echo "Downloading NadekoBot, please wait."
git clone -b 1.9 --recursive --depth 1 https://gitlab.com/Kwoth/nadekobot.git
echo ""
echo "NadekoBot downloaded."

echo ""
echo "Downloading Nadeko dependencies"
cd $builddir/NadekoBot/Discord.Net/src/Discord.Net.Core/
dotnet restore 1>/dev/null 2>&1
cd $builddir/NadekoBot/Discord.Net/src/Discord.Net.Rest/
dotnet restore 1>/dev/null 2>&1
cd $builddir/NadekoBot/Discord.Net/src/Discord.Net.WebSocket/
dotnet restore 1>/dev/null 2>&1
cd $builddir/NadekoBot/Discord.Net/src/Discord.Net.Commands/
dotnet restore 1>/dev/null 2>&1
cd $builddir/NadekoBot/src/NadekoBot/
dotnet restore 1>/dev/null 2>&1
echo ""
echo "Download done"

echo ""
echo "Building NadekoBot"
cd $builddir/NadekoBot/src/NadekoBot/
dotnet build --configuration Release 1>/dev/null 2>&1
echo ""
echo "Building done. Moving Nadeko"

cd "$root"

if [ ! -d NadekoBot ]
then
    mv "$builddir"/NadekoBot NadekoBot
else
    rm -rf NadekoBot_old 1>/dev/null 2>&1
    mv -fT NadekoBot NadekoBot_old 1>/dev/null 2>&1
    mv $builddir/NadekoBot NadekoBot
    cp -f $root/NadekoBot_old/src/NadekoBot/credentials.json $root/NadekoBot/src/NadekoBot/credentials.json 1>/dev/null 2>&1
    echo ""
    echo "credentials.json copied to the new version"
    cp -RT $root/NadekoBot_old/src/NadekoBot/bin/ $root/NadekoBot/src/NadekoBot/bin/ 1>/dev/null 2>&1
    echo ""
    echo "Database copied to the new version"
    cp -RT $root/NadekoBot_old/src/NadekoBot/data/ $root/NadekoBot/src/NadekoBot/data/ 1>/dev/null 2>&1
    echo ""
    echo "Other data copied to the new version"
fi

rm -r "$builddir"
echo ""
echo "Installation Complete."
exit 0
