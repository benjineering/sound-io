# Example usage:
#   make example name=list_devices && bin/list_devices

example: $(name)

$(name): $(name).c
	cc $(name).c -lsoundio -o bin/$(name)
