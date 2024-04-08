#!/usr/bin/env bash
#|---/ /+--------------------------------------+---/ /|#
#|--/ /-| Script to apply post install configs |--/ /-|#
#|-/ /--| Prasanth Rangan                      |-/ /--|#
#|/ /---+--------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi


# themepatcher
echo -e "\033[0;32m[THEMEPATCHER]\033[0m additional themes available..."
awk -F '"' '{print "["NR"]",$2}' "${scrDir}/themepatcher.lst"
prompt_timer 60 "Patch these additional themes? [Y/n]"
thmopt=${promptIn,,}

if [ "${thmopt}" = "y" ] ; then
    echo -e "\033[0;32m[THEMEPATCHER]\033[0m Patching themes..."
    while read -r themeName themeRepo themeCode
    do
        themeName="${themeName//\"/}"
        themeRepo="${themeRepo//\"/}"
        themeCode="${themeCode//\"/}"
        "${scrDir}/themepatcher.sh" "${themeName}" "${themeRepo}" "${themeCode}"
    done < "${scrDir}/themepatcher.lst"
else
    echo -e "\033[0;33m[SKIP]\033[0m additional themes not patched..."
fi

# nautilus
if pkg_installed nautilus && pkg_installed xdg-utils
    then

    echo -e "\033[0;32m[FILEMANAGER]\033[0m detected // nautilus"
    xdg-mime default org.gnome.nautilus.desktop inode/directory
    echo -e "\033[0;32m[FILEMANAGER]\033[0m setting" `xdg-mime query default "inode/directory"` "as default file explorer..."
else
    echo -e "\033[0;33m[WARNING]\033[0m dolphin is not installed..."
fi


# shell
"${scrDir}/restore_shl.sh"



