SCRIPT=./script
FIRMWARE=./firmware
SETUP=./setup

all: run

run:
	${SCRIPT}/run

clean:
	rm -rf ${FIRMWARE} && rm -rf ${SETUP}

