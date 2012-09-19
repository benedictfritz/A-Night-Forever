OUTPUT := game.swf

all : build play

build:
	fcsh-wrap -optimize=true -output $(OUTPUT) Preloader.as -frames.frame mainframe Main;
play:
	open $(OUTPUT)
clean:
	rm -f *~ $(OUTPUT) .FW.*
