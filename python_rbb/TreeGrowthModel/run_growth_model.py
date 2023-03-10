import os
import sys
import inspect

currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0, parentdir)

from zoi import ZoneOfInfluence
from write_output import WriteOutput
from visualization import Visualization
from tree_growth_model import TreeModel

timesteps = 1000
world_width = 10
number_individuals = 10
filename_output = "output"

trees = TreeModel(world_width=world_width,
                  number_individuals=number_individuals)

# Initialize ZOI RBB
# Note: cell size needs to be larger than initial root_radii
zoi = ZoneOfInfluence(l_x=world_width, l_y=world_width,
                      r_x=world_width*5, r_y=world_width*5)

output = WriteOutput(file_name=filename_output)

for timestep in range(1, timesteps+1):
    print("timestep: " + str(timestep))
    zoi.setEffectiveArea(positions=trees.getPositions(),
                         zoi_radii=trees.getRootRadii())
    effective_areas = zoi.getEffectiveArea()

    trees.treeGrowth(effective_areas=effective_areas)

    output.writeOutput(timestep=timestep,
                       trees=trees.__dict__,
                       effective_areas=effective_areas)

output.closeFile()


# plot = Visualization(file=filename_output+'.txt')
# plot.getZOIPlot()

