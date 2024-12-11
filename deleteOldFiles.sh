#!/usr/bin/env bash

logger () {
    local message
    local level
    local timestamp

    message=$1
    # info is a default level
    level=${2:-"info"}
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    echo "${timestamp} [$level] - $message"

    if [[ "$level" == "error" ]]; then
        exit 1
    fi
}

set -o errexit
set -o nounset
set -o pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <dirPath> <daysInterval>"
    exit 1
fi

dirPath=$1
daysInterval=$2

oldFilesPath="${dirPath}/old/"

# check if the directory exists
if [[ ! -d "${dirPath}" ]]; then
    echo "The directory does not exist" "error"
    exit 1
fi

# check if daysInterval is a number
if [[ ! "${daysInterval}" =~ ^[0-9]+$ ]]; then
    echo "The daysInterval is not a number" "error"
    exit 1
fi

# check if the old directory exists
if [[ ! -d "${oldFilesPath}" ]]; then
    logger "Creating the old directory"
    mkdir "${oldFiles}" || exit 1
fi

oldFilesObjects=()
oldFiles=$(find "${oldFilesPath}" -maxdepth 1 -type f -mtime +"${daysInterval}" | tr "\n" ",")
# Remove the trailing comma if necessary
oldFiles="${oldFiles%,}"

# Save it into an array
IFS=',' read -r -a oldFilesObjects <<< "$oldFiles"

oldFilesCount=${#oldFilesObjects[@]}
logger "Found ${oldFilesCount} files older than ${daysInterval} days in ${dirPath}/old directory"

if [[ oldFilesCount -gt 0 ]]; then
    logger "Deleting the files from ${dirPath}/old directory"

    for file in "${oldFilesObjects[@]}"; do
        logger "Deleting the file: ${file}"
        rm "${file}" || exit 1
    done
else
    logger "No files found in the directory"
    logger "Updateing mtime of the directory"
    touch -c "${dirPath}"
fi

dirObjects=()
downloads=$(find "${dirPath}" -maxdepth 1 -type f -mtime +"${daysInterval}" | tr "\n" ",")

# Remove the trailing comma if necessary
downloads="${downloads%,}"

# Save it into an array
IFS=',' read -r -a dirObjects <<< "$downloads"
downloadsCount=${#dirObjects[@]}

logger "Found ${downloadsCount} files older than ${daysInterval} days in ${dirPath} directory"
if [[ downloadsCount -gt 0 ]]; then
    logger "Moving the files from downloads directory to old directory"
    for file in "${dirObjects[@]}"; do
        logger "Moving the file: ${file}"
        mv "${file}" "${oldFilesPath}" || exit 1
    done
fi
