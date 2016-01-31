# SETUP
APPLIVERY_FRAMEWORK_PATH="${SRCROOT}/Frameworks/Applivery.framework"


# DON'T MODIFY BELOW

set -e

copy_framework ()
{
    local framework=$1
    local frameworks_folder="${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
    
    echo "framework: ${framework}"
    echo "frameworks folder: ${frameworks_folder}"
    
    mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
    rsync -av "$framework" "$frameworks_folder"
    
    local framework_path="$frameworks_folder/Applivery.framework"
    local file_path="$framework_path/Applivery"
    
    if [[ ! "$VALID_ARCHS" =~ "$i386" ]];
    then
    lipo -remove i386 "$file_path" -output "$file_path"
    fi
    
    if [[ ! "$VALID_ARCHS" =~ "$x86_64" ]];
    then
    lipo -remove x86_64 "$file_path" -output "$file_path"
    fi
    
    if [[ "$CODE_SIGNING_REQUIRED" -eq YES ]];
    then
    codesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY" --preserve-metadata=identifier,entitlements,resource-rules "$framework_path"
    fi
}

export -f copy_framework

if [ "${CONFIGURATION}" = "Release" ]; then
    copy_framework "${APPLIVERY_FRAMEWORK_PATH}"
fi
