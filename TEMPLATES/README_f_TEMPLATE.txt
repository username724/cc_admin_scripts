!TEMPLATE NOTES!
- use "> /dev/null 2>&1" to redirect output so it doesn't go anywhere
- DO NOT REMOVE "srm" at the end of the script unless you want to add things to remove
- DO NOT CHANGE THE FIRST SET OF VARIABLES
- need to mount server space: use something like this
	echo "mounting macsoftware"
	mkdir /Volumes/Mac\ Software
	mount_afp "afp://USERNAME:PASSWORD@10.10.52.5/Mac%20Software" /Volumes/Mac\ Software/
	wait
- please try to use "wait $!" after a command that will take a long time
- Its almost always neccesary to use absolute paths in Mac OS X. The OS just doesn't handle relativity very well.
- 