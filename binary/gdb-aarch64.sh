#!/bin/bash

gdb-multiarch \
	-ex "target remote 127.0.0.1:1234"
	-ex ""
