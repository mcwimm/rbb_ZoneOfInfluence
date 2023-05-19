
class WriteOutput:
    def __init__(self, file_name='example_output'):
        # Write output
        print(file_name + '.txt')
        self.output_file = open(file_name + '.txt', 'w')
        self.output_file.write("timestep, tree, x, y, biomass_act, growth_rates, zoi_radii, effective_area\n")

    def writeOutput(self, timestep, trees, effective_areas):
        # Write output
        string = ""
        delimiter = ", "
        for tree in range(0, len(trees["biomass_act"])):
            string += (str(timestep) + delimiter +
                       str(trees["trees"][tree]) + delimiter +
                       str(trees["positions"][tree][0]) + delimiter +
                       str(trees["positions"][tree][1]) + delimiter +
                       str(trees["biomass_act"][tree]) + delimiter +
                       str(trees["growth_rates"][tree]) + delimiter +
                       str(trees["root_radii"][tree]) + delimiter +
                       str(effective_areas[tree]) + delimiter)
            string += "\n"
        self.output_file.write(string)

    def closeFile(self):
        self.output_file.close()
