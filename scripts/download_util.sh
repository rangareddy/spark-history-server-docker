#!/bin/bash
  
if test $# -lt 3 ; then
    echo "Please specify <SOFTWARE_TYPE>, <SOFTWARE_HOME> and <SOFTWARE_URL>";
    exit 1;
fi

SOFTWARE_TYPE="$1"
SOFTWARE_HOME="$2"
SOFTWARE_TGZ=${SOFTWARE_TYPE}_software.tgz

mkdir -p $SOFTWARE_HOME

shift 2
for DOWNLOAD_URL in "$@" 
do
    echo "Downloading the software <$SOFTWARE_TYPE> with the url <$DOWNLOAD_URL> and location is <$SOFTWARE_HOME>"
    wget -t 10 --show-progress --tries=3 --max-redirect 1 --retry-connrefused -O "$SOFTWARE_TGZ" "$DOWNLOAD_URL" > /dev/null 2>&1
    download_status=$?
    if [ $download_status -eq 0 ]; then
        break;
    fi
done

if [ ! -f "$SOFTWARE_TGZ" ]; then
    echo "$SOFTWARE_TGZ does not exist."
    exit 1
fi

tar --extract \
    --file ${SOFTWARE_TGZ} \
    --directory "${SOFTWARE_HOME}" \
    --strip-components 1 \
    --no-same-owner

files_count=$(ls -1 | wc -l)

if [ $files_count -eq 0 ]; then
    echo "$SOFTWARE_TGZ not extracted properly"
    exit 1
fi

chown -R 755 ${SOFTWARE_HOME}
rm -rf ${SOFTWARE_TGZ}
