#/usr/bin/env python
# -*- coding: utf-8 -*-

import scribus
from scribus import *
import math  


scribus.setUnit(2)


startMsg1 = "This script automates some simple setup taskss."

startMsg = startMsg1

#sets colors (no need to import color palette any longer)


defineColor("Nimble Maroon", 0, 100, 100, 55)
defineColor("Nimble Napoleonic Green", 73, 0, 78, 73) 
defineColor("Nimble Blue", 100, 67, 0, 62) 
defineColor("Nimble Feldgrau", 60, 40, 51, 43) 
defineColor("Nimble Metallic Gold", 44, 47, 78, 20) 
defineColor("Nimble Reference Red", 0, 100, 100, 0)

createLayer("Cover")

createLayer("ISBN_Box")


createLayer("ISBN")

