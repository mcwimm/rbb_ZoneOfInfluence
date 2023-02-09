import pandas as pd
import numpy as np
import os
import sys
import inspect

currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0, parentdir)

from zoi import ZoneOfInfluence

# BENCHMARK 1
setup_1 = pd.read_csv('setup_1.txt', sep=', ', header=0)
positions = setup_1[['x', 'y']]
radii = setup_1[['radius']]

zoi = ZoneOfInfluence(l_x=15, l_y=15,
                      r_x=15*5, r_y=15*5)
zoi.setEffectiveArea(positions=np.array(positions),
                     zoi_radii=radii)
effective_areas = zoi.getEffectiveArea()


exit()
output_file = open('setup_1_reference.txt', 'w')
output_file.write("tree, effective_area\n")
for i in range(0, len(effective_areas)):
    string = str(i) + ", " + str(effective_areas[i]) + "\n"
    output_file.write(string)