.POSIX:
.SUFFIXES: .asm

name	= Discord
src		= src
obj 	= src/main.o src/memory.o src/video.o src/data.o src/string.o src/dialog.o src/input.o src/input_utils.o src/timer.o

all:	clean $(name).gb

clean:
	@rm -f $(obj) $(name).obj $(name).sym src/gfx/*.2bpp src/gfx/*.tilemap

gfx:
	@find . -iname "*.png" -exec sh -c 'rgbgfx -T -u -o $${1%.png}.2bpp $$1' _ {} \;

.asm.o:
	@rgbasm -Weverything -i $(src)/ -o $@ $<

$(name).gb: gfx $(obj)
	@rgblink -n $(name).sym -o $@ $(obj)
	@rgbfix -jv -i XXXX -k XX -l 0x33 -m 0x01 -p 0 -r 0 -t DISCORD $@