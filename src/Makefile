OUTPUT := game.swf

all : build play

build:
	fcsh-wrap -optimize=true -output $(OUTPUT) Main.as;
play:
	open $(OUTPUT)
clean:
	rm -f *~ $(OUTPUT) .FW.*
