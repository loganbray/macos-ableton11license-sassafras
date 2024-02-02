#!/bin/zsh

# get the ableton 11 folder
Ableton11Version=$(defaults read "/Applications/Ableton Live 11 Suite.app/Contents/Info.plist" CFBundleShortVersionString | cut -d' ' -f1)

# check if the root ableton folder exists
if [ -d "/Library/Preferences/Ableton" ]; then
    echo "Ableton Folder exists"
else 
    mkdir "/Library/Preferences/Ableton"
    echo "Created Ableton Folder"
fi
CheckFolderVersion

# checks the version of existing ableton live folder
CheckFolderVersion () {
    if [ -d "/Library/Preferences/Ableton/Live $Ableton11Version" ]; then
        echo "Live license folder exists"
    else 
        # create the ableton folder if it does not exist
        mkdir "/Library/Preferences/Ableton/Live $Ableton11Version"
        echo "Created Live $Ableton11Version folder"
    fi

    UseLicenseServer
}

UseLicenseServer() {
    # create the Ableton License Server file
    echo -e "-LicenseServer\n-_DisableAutoUpdates" >> "/Library/Preferences/Ableton/Live $Ableton11Version/Options.txt"
    CheckUserLicenses
}

CheckUserLicenses() {
    # Iterate through user directories in /Users/
    for user_dir in /Users/*; do
        if [ -d "$user_dir" ]; then
            # Construct the path to Ableton folder
            ableton_folder="$user_dir/Library/Preferences/Ableton"

            # Check if Ableton folder exists before deleting
            if [ -d "$ableton_folder" ]; then
                echo "Deleting Ableton folder for user: $(basename "$user_dir")"
                rm -rf "$ableton_folder"
            else
                echo "Ableton folder not found for user: $(basename "$user_dir")"
            fi
        fi
done
}
