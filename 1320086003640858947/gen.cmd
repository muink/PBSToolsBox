@echo off
.\ImageMagick\convert 16.ico 24.ico 32.ico 48.ico 64.ico 128.ico 256.ico -colors 256 icon.ico
.\ImageMagick\convert 256.ico -define icon:auto-resize=16,24,32,48,64,128,256 -compress zip auto.ico
