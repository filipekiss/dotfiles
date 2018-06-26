unalias mcd 2> /dev/null

function mcd(){
	if [ -z $1 ]; then;
		echo "Usage: mcd <folderName>"
		return 1
	fi
	mkdir $1 && cd $1
}

#complete like cd
compdef _cd mcd
