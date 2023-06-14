Output demo.gif

Require docker

Set FontSize 14
Set Width 640
Set Height 360
Set Padding 15
Set LoopOffset 0%

# BEGIN image-frame settings
Set MarginFill background.png
Set MarginSize 25
Set WindowBar Colorful
Set WindowBarSize 25
Set CornerRadius 10
# END

Hide
Type "cd ../.." Enter
Type "make clean && clear" Enter Sleep 3s
Show

Sleep 250ms
Type "# Conduit plugin quick start!" Enter Sleep 1s
Type "make run" Enter 2 Sleep 2s
Type "# Follow the instructions" Enter
Type "make docker-node" Sleep 1s Enter Sleep 2
Type "./cmd/conduit/conduit -d run_data" Sleep 1s Enter

Sleep 5
