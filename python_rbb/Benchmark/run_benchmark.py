import pandas as pd
import numpy as np
import os
import sys
import inspect

currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0, parentdir)

from zoi import ZoneOfInfluence
from visualization import Visualization

import matplotlib.pyplot as plt


# BENCHMARK 1
# 5 trees with different size
# critical points: 1 tree completely covered, 1 not covered, 2 exactly same size

# Read positions and zoi radii from input file
setup_1 = pd.read_csv('setup_1.txt', sep=', ', header=0)
positions = setup_1[['x', 'y']]
radii = setup_1[['zoi_radii']]

# Initialize ZOI with symmetric ZOI
# and a low grid resolution
zoi = ZoneOfInfluence(l_x=15, l_y=15,
                      r_x=5, r_y=5,
                      type="sym")

zoi.setEffectiveArea(positions=np.array(positions),
                     zoi_radii=radii)

ef_area_1a = zoi.getEffectiveArea()
print(ef_area_1a)

# Initialize ZOI with symmetric ZOI
# and a low grid resolution
zoi = ZoneOfInfluence(l_x=15, l_y=15,
                      r_x=5, r_y=5,
                      type="asym")

zoi.setEffectiveArea(positions=np.array(positions),
                     zoi_radii=radii)

ef_area_1b = zoi.getEffectiveArea()
print(ef_area_1b)

plot = Visualization("setup_1.txt")
plot.getZOIPlot(np.arange(1.5, 15, 3), np.arange(1.5, 15, 3))

# Initialize ZOI with symmetric ZOI
# and a high grid resolution
zoi = ZoneOfInfluence(l_x=15, l_y=15,
                      r_x=15, r_y=15,
                      type="sym")

zoi.setEffectiveArea(positions=np.array(positions),
                     zoi_radii=radii)

ef_area_1c = zoi.getEffectiveArea()
print(ef_area_1c)

# Initialize ZOI with symmetric ZOI
# and a high grid resolution
zoi = ZoneOfInfluence(l_x=15, l_y=15,
                      r_x=15, r_y=15,
                      type="asym")

zoi.setEffectiveArea(positions=np.array(positions),
                     zoi_radii=radii)

ef_area_1d = zoi.getEffectiveArea()
print(ef_area_1d)

plot = Visualization("setup_1.txt")
plot.getZOIPlot(np.arange(0.5, 15, 1), np.arange(0.5, 15, 1))

# Write Output to file
ef_area = [ef_area_1a, ef_area_1b, ef_area_1c, ef_area_1d]
ef_lab = ["a", "b", "c", "d"]
output_file = open('setup_1_reference.txt', 'w')
output_file.write("setup, tree, effective_area\n")
for i in range(4):
    for j in range(0, len(ef_area_1a)):
        string = ef_lab[i] + ", " + str(j) + ", " + str(ef_area[i][j]) + "\n"
        output_file.write(string)
