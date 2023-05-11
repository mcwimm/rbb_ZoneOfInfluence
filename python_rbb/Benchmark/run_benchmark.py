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


# BENCHMARK 1
# 5 trees with different size
# critical points: 1 tree completely covered, 1 not covered, 2 exactly same size

# Read positions and zoi radii from input file
setup_1 = pd.read_csv('setup_1.txt', sep=', ', header=0)
positions = setup_1[['x', 'y']]
radii = setup_1['zoi_radii']

# A) Initialize ZOI with symmetric ZOI
# and a low grid resolution
zoi = ZoneOfInfluence(l_x=15, l_y=15,
                      r_x=5, r_y=5,
                      type="sym")

zoi.setEffectiveArea(positions=np.array(positions),
                     zoi_radii=radii)

ef_area_1a = zoi.getEffectiveArea()
zoi_factor_1a = zoi.getZOIfactor()
print(ef_area_1a)
print(zoi_factor_1a)

# B) Initialize ZOI with asymmetric ZOI
# and a low grid resolution
zoi = ZoneOfInfluence(l_x=15, l_y=15,
                      r_x=5, r_y=5,
                      type="asym")

zoi.setEffectiveArea(positions=np.array(positions),
                     zoi_radii=radii)

ef_area_1b = zoi.getEffectiveArea()
zoi_factor_1b = zoi.getZOIfactor()
print(ef_area_1b)
print(zoi_factor_1b)

# plot = Visualization("benchmark_B.txt")
# plot.getZOIPlot(np.arange(1.5, 15, 3), np.arange(1.5, 15, 3), 'effective_area')

# C) Initialize ZOI with symmetric ZOI
# and a high grid resolution
zoi = ZoneOfInfluence(l_x=15, l_y=15,
                      r_x=15, r_y=15,
                      type="sym")

zoi.setEffectiveArea(positions=np.array(positions),
                     zoi_radii=radii)

ef_area_1c = zoi.getEffectiveArea()
zoi_factor_1c = zoi.getZOIfactor()
print(ef_area_1c)
print(zoi_factor_1c)


# D) Initialize ZOI with asymmetric ZOI
# and a high grid resolution
zoi = ZoneOfInfluence(l_x=15, l_y=15,
                      r_x=15, r_y=15,
                      type="asym")

zoi.setEffectiveArea(positions=np.array(positions),
                     zoi_radii=radii)

ef_area_1d = zoi.getEffectiveArea()
zoi_factor_1d = zoi.getZOIfactor()
print(ef_area_1d)
print(zoi_factor_1d)


# plot = Visualization("benchmark_D.txt")
# plot.getZOIPlot(np.arange(0.5, 15, 1), np.arange(0.5, 15, 1))

#exit()
# Write Output to file
ef_area = [ef_area_1a, ef_area_1b, ef_area_1c, ef_area_1d]
zoi_factor = [zoi_factor_1a, zoi_factor_1b, zoi_factor_1c, zoi_factor_1d]

ef_lab = ["A", "B", "C", "D"]
# output_file = open('setup_1_reference.txt', 'w')
# output_file.write("setup, tree, x, y, zoi_radii, effective_area\n")
for i in range(4):
    filename = 'benchmark_' + str(ef_lab[i]) + '.txt'
    print(filename)
    output_file = open(filename, 'w')
    output_file.write("setup, tree, x, y, zoi_radii, zoi_factor, effective_area, timestep\n")
    for j in range(0, len(ef_area_1a)):
        string = ef_lab[i] + ", " + str(j) + ", " + str(positions['x'][j]) + ", " + str(positions['y'][j]) + ", " + \
                 str(radii[j]) + ", " + str(zoi_factor[i][j]) + ", " + str(ef_area[i][j]) + ", " + str(0) + "\n"
        output_file.write(string)
