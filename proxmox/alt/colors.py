"""
ESC [ 0 m       # reset all (colors and brightness)
ESC [ 1 m       # bright
ESC [ 2 m       # dim (looks same as normal brightness)
ESC [ 22 m      # normal brightness

# FOREGROUND:
ESC [ 30 m      # black
ESC [ 31 m      # red
ESC [ 32 m      # green
ESC [ 33 m      # yellow
ESC [ 34 m      # blue
ESC [ 35 m      # magenta
ESC [ 36 m      # cyan
ESC [ 37 m      # white
ESC [ 39 m      # reset

# BACKGROUND
ESC [ 40 m      # black
ESC [ 41 m      # red
ESC [ 42 m      # green
ESC [ 43 m      # yellow
ESC [ 44 m      # blue
ESC [ 45 m      # magenta
ESC [ 46 m      # cyan
ESC [ 47 m      # white
ESC [ 49 m      # reset

# cursor positioning
ESC [ y;x H     # position cursor at x across, y down
ESC [ y;x f     # position cursor at x across, y down
ESC [ n A       # move cursor n lines up
ESC [ n B       # move cursor n lines down
ESC [ n C       # move cursor n characters forward
ESC [ n D       # move cursor n characters backward

# clear the screen
ESC [ mode J    # clear the screen

# clear the line
ESC [ mode K    # clear the line


Fore.RED.LIGHT.BOLD
"""

# class Color:
#     def __init__(self, color):
#         self.color = color
#         self.light = False
#         self.bold = False

#     def __str__(self):
#         color = self.color
#         if self.light:
#             color += 60
#         color = str(color)
#         if self.bold:
#             color += ";1"
#         return f"\033[{color}m"

#     @property
#     def BOLD(self):
#         self.bold = True
#         return self

#     @property
#     def LIGHT(self):
#         self.light = True
#         return self

class Fore:
    """
    \033[param;param;...m
    ESC [ 36 ; 45 ; 1 m     # bright cyan text on magenta background
    https://pypi.org/project/colorama/
    """
    # BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE
    BLACK   = "\033[30m"
    RED     = "\033[31m"
    GREEN   = "\033[32m"
    YELLOW  = "\033[33m"
    BLUE    = "\033[34m"
    MAGENTA = "\033[35m"
    CYAN    = "\033[36m"
    WHITE   = "\033[37m"
    RESET   = "\033[39m"

    LIGHTBLACK   = "\033[30;1m"
    LIGHTRED     = "\033[31;1m"
    LIGHTGREEN   = "\033[32;1m"
    LIGHTYELLOW  = "\033[33;1m"
    LIGHTBLUE    = "\033[34;1m"
    LIGHTMAGENTA = "\033[35;1m"
    LIGHTCYAN    = "\033[36;1m"
    LIGHTWHITE   = "\033[37;1m"

    RESET_ALL = "\033[0m"

    # @property
    # def RED(self):
    #     return Color(31)
    # @property
    # def GREEN(self):
    #     return Color(32)
    # @property
    # def YELLOW(self):
    #     return Color(33)

# class BackgroundColors:
#     RESET="\033[0m"

#     @property
#     def RED(self):
#         return Color(41)
#     @property
#     def GREEN(self):
#         return Color(42)
#     @property
#     def YELLOW(self):
#         return Color(43)

#     # BRIGHT_RED="\033[91;1m" #"\033[91m"
#     # BRIGHT_GREEN="\033[92m"

# Fore = ForeColors()
# Back = BackgroundColors()