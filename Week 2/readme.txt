1. Clock:
	Features
	-> 24 Hour Clock
	-> Take Starting Time(hours and seconds) from user 
	-> Resets to 00:00:00 after 23:59:59
	Steps to run
	-> Generate hex file,upload to device
	-> Execute at starting address 9000H
	-> Enter hours and minutes(starting) in address field
	-> Press go

2. Countdown Timer:
	Features
	->Countdown timer which halts at zero
	->Interrupt to pause and play
	->Start from any hour,minute and second
	Steps to run
	-> Generate hex file, upload to device
	-> Store seconds in 8050H
	-> Store address of ISR in 8FEFH 
	-> Execute at starting address 9000H
	-> Enter hours and minutes in address field
	-> Press Go
	-> On pressing INT, timer pauses
	-> Press any other key 2 times to resume timer 