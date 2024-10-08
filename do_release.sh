#!/bin/sh

[ $# -eq 1 ] || exit 2

VER="$1"

echo "$VER" | grep '^[0-9]\+\.[0-9]\+\.[0-9]\+$' || {
    echo "Call this script as ./do_release.sh [version] where version has format 1.2.3, without \"v\" prefix."
    exit 2
}

echo "Creating version $VER"

if [ -n "$(git diff --name-only --cached)" ]; then
    echo "Stash or commit staged changes first"
    exit 2
fi

sed -i "s/^\\(\\s*version\\s*=\\s*['\"]\\)[^'\"]*\\(['\"]\\s*\\)$/\\1v"$VER"\\2/" pyproject.toml
sed -i "s/^\\(\\s*version\\s*=\\s*['\"]\\)[^'\"]*\\(['\"]\\s*\\)$/\\1"$VER"\\2/" mpv.py
git add pyproject.toml mpv.py
git commit -m "Version $VER" --no-edit
git -c user.signingkey=E36F75307F0A0EC2D145FF5CED7A208EEEC76F2D -c user.email=python-mpv@jaseg.de tag -s "v$VER" -m "Version $VER"
git push --tags origin
