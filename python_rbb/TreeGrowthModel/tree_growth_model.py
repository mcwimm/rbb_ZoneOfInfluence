
import numpy as np


class TreeModel:
    def __init__(self, world_width, number_individuals):
        # World (model domain)
        self.world_width = world_width

        # Set a random seed for initial values
        np.random.seed(42)

        # Generate initial population
        self.number_individuals = number_individuals
        self.generateInitialPopulation()

    def generateInitialPopulation(self):
        # Tree IDs
        self.trees = np.array(['tree_' + str(n) for n in range(1, self.number_individuals + 1)])
        # [x, y] position of each tree
        self.positions = np.random.randint(0, self.world_width, (self.number_individuals, 2))
        # Initial biomass
        self.biomass_act = np.random.normal(size=self.number_individuals, loc=1, scale=0.1)
        # Initial biomass
        self.biomass_max = np.random.normal(size=self.number_individuals, loc=20000, scale=2000)
        # Initial growth rate
        self.growth_rate_opt = np.random.normal(size=self.number_individuals, loc=1, scale=0.1)
        # root radius of each tree
        self.root_radii = self.biomass_act ** (2 / 6) * (np.pi ** (-1 / 2))
        self.effective_area = np.array(self.biomass_act ** (2 / 3))

    def treeGrowth(self):
        self.growth_rates = self.growth_rate_opt * (self.effective_area - ((self.biomass_act ** 2) / (self.biomass_max ** (4 / 3))))
        self.treeDeath()

        self.biomass_act += self.growth_rates
        self.root_radii = (self.biomass_act ** (2 / 6)) * (np.pi ** (-1 / 2))

    def treeDeath(self):
        survival_idx = (self.growth_rates > 0)
        if not all(survival_idx):
            print("Tree died")
            self.trees = self.trees[survival_idx]
            self.positions = self.positions[survival_idx]
            self.biomass_act = self.biomass_act[survival_idx]
            self.biomass_max = self.biomass_max[survival_idx]
            self.growth_rates = self.growth_rates[survival_idx]
            self.growth_rate_opt = self.growth_rate_opt[survival_idx]

    def getRootRadii(self):
        return self.root_radii

    def getPositions(self):
        return self.positions

    def setEffectiveArea(self, effective_area):
        self.effective_area = effective_area
