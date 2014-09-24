property myDisks : {"SOMESHARE"}
set mountedDisks to paragraphs of (do shell script "/bin/ls /Volumes")
with timeout of 500 seconds
	repeat with aDisk in myDisks
		try
			if aDisk is not in mountedDisks then
				mount volume "[protocol]://SOMESERVER" & aDisk as user name "SOMEUSER" with password "SOMEPASS"
			end if
		on error
			delay 30
		end try
	end repeat
end timeout