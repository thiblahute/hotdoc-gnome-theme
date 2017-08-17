#!/bin/bash -e
USER=thiblahute
REPO=hotdoc-gnome-theme

if [ -z ${1+x} ]; then echo "Need to pass new version as argument"; exit 1; else echo "Releasing $1"; fi

version=$1
meson_projline="project('$REPO', 'c', version: '$version')"

sed -i "1s/.*/$meson_projline/" meson.build
git add meson.build
git commit -m "Release $version"
git tag $version -m "Release $version"
git push origin master
git push origin $version

cd subprojects/hotdoc_bootstrap_theme
git pull --rebase
bootstrap_theme_commit=`git rev-list --format=%B --max-count=1 HEAD`
cd -

echo "Producing new release tarball"
rm -Rf build/
mkdir build/
meson.py build/
ninja -C build tar
sha=`sha256sum $REPO-$1.tar.xz | cut -d ' ' -f 1`

TXT="Update hotdoc-bootstrap-theme

Pass --html-theme=https://github.com/$USER/$REPO/releases/download/$1/$REPO-$1.tar.xz?sha256=$sha to hotdoc to use as a theme.

Hotdoc bootstrap theme commit:

\`\`\`
$bootstrap_theme_commit
\`\`\`
"

github-release release \
    --user $USER \
    --repo $REPO \
    --tag $version \
    --name "Release $version" \
    --description "$TXT"

github-release upload \
    --user $USER \
    --repo $REPO \
    --tag $version \
    --name $REPO-$1.tar.xz \
    --file $REPO-$1.tar.xz
