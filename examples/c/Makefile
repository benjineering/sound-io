all: list_devices play record

list_devices: list_devices.c
	cc list_devices.c -lsoundio -o bin/list_devices

play: play.c
	cc play.c -lsoundio -o bin/play

record: record.c
	cc record.c -lsoundio -o bin/record
