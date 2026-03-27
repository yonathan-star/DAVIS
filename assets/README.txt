Place a TTF font file named font.ttf here to guarantee font availability
on any system without relying on installed system fonts.

Recommended free fonts (SIL Open Font License):
  - Liberation Sans Bold:  https://github.com/liberationfonts/liberation-fonts
  - DejaVu Sans Bold:      https://dejavu-fonts.github.io/

On Raspberry Pi OS, install system fonts instead:
  sudo apt install fonts-liberation fonts-dejavu

The Text2STL engine will auto-detect Liberation Sans / DejaVu Sans from
/usr/share/fonts if this file is absent.
