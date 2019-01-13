#!/bin/bash

# Replace all <..> text for your situation

folders=(
<remote folder 1>
<remote folder 2>
)

fileTypes='\.3G2$|\.3GP$|\.ASF$|\.AVI$|\.FLV$|\.M4V$|\.MOV$|\.MP4$|\.MPG$|\.RM$|\.SWF$|\.VOB$|\.WMV$|\.mkv$'

# Get list of files from remote server
matches=$(sshpass -p <password> ssh -T <user@server> <<EOF
# loop through all folders and save file paths to variable
for folder in ${folders[@]}; do
	resultTmp=\$(find \$folder | egrep -i "$fileTypes" | egrep -i "$1" | egrep -i "$2")
	if [ ! -z "\$resultTmp" ]; then
		if [ -z "\$result" ]; then
			result=\${resultTmp}
		else
			result="\${result}
\${resultTmp}"
		fi
	fi
done

# Add number to lines and use ls to get file sizes
i=0
while read -r file; do
	echo -n "\${i}: "
	ls -hl "\$file"
	let "i++"
done <<< "\$result"
EOF
)
printf "$matches\n"

echo "Enter the number of the video you would like to download and press enter: "
read nr
#echo ${resultArray[$nr]}

# Choose correct line, remove all other than file path and replace spaces (if they exist)
file2download=$(printf "$matches\n" | head -$(( $nr+1 )) | tail -1 | sed 's%.* /%/%' | sed 's/ /\\\ /g')

# Replace file extension with *
files2download="${file2download%.*}.*"

echo "Will download all files that matches (to include e.g. subtitles):"
echo $files2download

# Copy from remote (not using sshpass to see progress)
scp "<user@server>:$files2download" .
