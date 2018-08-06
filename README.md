# Peripheral Lab : CS 321

This repository contains the hard-work(mostly copied) of group 03 in CSE pre-final year at IIT Guwahati.

## Getting Started

To run the scripts, connect the serial COM port of the MPS 8085 microprocessor trainer kit to the pc.
Install xt85.exe from CSE repository IITG.

Save the .asm file in the same folder as the xt85 and c16 and run the following command in command prompt(administrator mode) to generate the hex file.

```
c16 -h filename.hex -l filename.lst filename.asm
```

Now,turn on the 4th dip switch on the kit and run xt85.exe.
Press Ctrl+D till it asks to enter hex file name.
Enter the generated .hex file's name(usually in Capitals)
Press enter thrice.
Turn off the 4th dip switch and operate according to your code.

### Prerequisites

Computer Organization and Architecture Course.

### Contributors

* Aadil Hoda - 160101001
* Arpan Konar - 160101014
* Arpit Gupta - 160101015
* Debangshu Banerjee - 160101081

