# TODO: Make proper functions files

function psaux() {
	ps aux | grep $1 | grep -v grep | awk '{print $11" "$2}'
}

function p2browser() {
  pbpaste >! /var/tmp/p2browser.html && open /var/tmp/p2browser.html && sleep 10 && rm -f /var/tmp/p2browser.html
}

 function css2sass() {
      sass-convert -F css -T sass -s | pbcopy
 }

 function yt2mp3() {
      youtube-dl -t -i --extract-audio --audio-format mp3 $1
  }

  function mov-to-gif() {
    time=$3
    if [[ -z $3 ]]; then
        time="00:00:10.000"
    fi;
    ffmpeg -ss 00:00:00.000 -i $1 -pix_fmt rgb24 -r 10 -s 320x240 -t $time $2
  }

	function bkp() {
		REALPATH_BIN=`which grealpath` #darwin has the binary as grealpath if coreutils is installed
		if [ -z $1 ]; then;
			echo "Usage: bkp <file_to_backup>"
			echo "This will create a file.bkp in the same folder as the original file"
			return 1
		fi
		ORIGINAL_FILE=$(grealpath $1)
		BACKUP_FILE=$ORIGINAL_FILE".bkp"
		if [ -f $ORIGINAL_FILE ]; then
			echo "Copying $1 to $1.bkp..."
			cp -i $ORIGINAL_FILE $BACKUP_FILE
		else
			echo "File $1 not found. Aborting..."
		fi
	}

function apmsi() {
	apm star $@ && apm install $@
}

function docker-ssh () {
	docker exec -it $1 bash
}

function transfer() { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }