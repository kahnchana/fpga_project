# fpga_project

## Description 
processor.v contains the outline for a simple processor. 
Used IP cores to build counter (PC) and ALU. Can have upto 16 micro instructions. 
(http://www.pldworld.com/_altera/html/_sw/q2help/source/mega/mega_file_lpm_counter.htm)

## To Do
* Finalize ISA
* Code Control Units Logic (the micro instructions)
* Test the current architecture of processor
* Create RAM to load images and data to
* Algorithm to down-sample a given image

## Proposed ISA instruction set
1) mv X Y
2) mvi X, Din
3) add X, Y
4) sub X, Y
5) load X, [Y]  (load the data in memory location Y to register X)
6) store X, [y] (store the data in register X to memory location Y)
7) mvnz X, Y (move Y to X when ALU output is not nil: can be used to implement while loops easily)

Can add more instructions here if we need. 

## Reference
Followed the guide on "reference.pdf". The architecture built is illustrated in it. 