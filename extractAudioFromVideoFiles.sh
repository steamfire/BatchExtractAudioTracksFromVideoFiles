#!/bin/zsh
# extractAudioFromVideoFiles.sh
# Requires FFMPEG and FFPROBE


#Gets the directory to use from the first argument to this script

INPUTFILEEXTENSION="$1"
DIRECTORYTOCRAWL="$2"


USAGE="

Usage: 
    
    
    extractAudioFromVideoFiles.sh inputFileExtension directoryToProcess
    
    Don't put a period before the file extensions. 
    * EXECUTE THIS COMMAND IN DIRECTORY WHERE THE MKV FILES ARE STORED *

This will crawl through the current directory and EXTRACT the audio track of the given 
video files. Provide it with the video filename extension that you want it to search for
 and process. Examples are mp4 or mkv .  This command needs to be run from the directory 
 that the mkv files are in

 NOTE: AAC audio files will be named with the extension of ".m4a" which iTunes prefers.

Dan Bowen MIT License
"

#check that the user has entered two arguments (hopefully the extension and directory),
#  otherwise print the usage statement.
if [ $# -ne 2 ] ; then
    echo -e $USAGE
    exit 1;
fi


#Iterates through each file
for FILENAME in "$DIRECTORYTOCRAWL"/*.$INPUTFILEEXTENSION

do
  #Echo filename to console
  INPUTFILESIMPLENAME=`basename $FILENAME`
  echo -n "$INPUTFILESIMPLENAME"
  #echo -e "\n"

  #Get the audio track's codec name
  AUDIOTYPE=`ffprobe -v error -select_streams a -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 $FILENAME`
  #Print the codec name on screen
  #echo -e "  **  Audio codec: $AUDIOTYPE  ** \n"
  
  #Change the file extension if it's aac for iTunes
  if [ $AUDIOTYPE = 'aac' ]
   then
   #Change the file extension if it's aac for iTunes
    OUTPUTFILEEXTENSION='m4a'
   else
   #Otherwise just use the audio codec name for the file extension
    OUTPUTFILEEXTENSION=$AUDIOTYPE
  fi
  
    #print stuff
  echo -e " ---> .$OUTPUTFILEEXTENSION"

  
  # get the filename with whatever extension?????
  TMPOUTFILE="${FILENAME%.*}"
  #strip the existing extension and replace with .m4a ???
  OUTFILE="$DIRECTORYTOCRAWL/${TMPOUTFILE##*/}.$OUTPUTFILEEXTENSION"  

  OUTPUTFILESIMPLENAME=`basename $OUTFILE`
  
  
  #Echo output filename to console
#  echo -n "$OUTPUTFILESIMPLENAME"
#  echo -e "\n"

  ffmpeg -loglevel quiet -i "${FILENAME}" -vn -acodec copy -metadata title="$INPUTFILESIMPLENAME" -n "${OUTFILE}"   

done