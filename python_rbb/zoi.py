import numpy as np
import random


class ZoneOfInfluence:
    def __init__(self, l_x, l_y, r_x, r_y, type="sym"):
        self.type = type
        self.effective_area = None
        self.makeGrid(l_x, l_y, r_x, r_y)
        print("Initialize ZOI of type " + self.type)

    def makeGrid(self, l_x, l_y, r_x, r_y):
        x_step = l_x / r_x
        y_step = l_y / r_y

        xe = np.linspace(x_step / 2.,
                          l_x - x_step / 2.,
                          r_x,
                          endpoint=True)
        ye = np.linspace(y_step / 2.,
                              l_y - y_step / 2.,
                              r_y,
                              endpoint=True)
        self.grid = np.meshgrid(xe, ye)

    ## This function calculates the effectve area of each agent
    # @param positions:
    # @return: array of length n (number of agents)
    def setEffectiveArea(self, positions, zoi_radii):
        agent_x = positions[:, 0]
        agent_y = positions[:, 1]
        self.agent_n = len(agent_x)

        # Numpy array of shape [res_x, res_y, n_agents]
        # Distance of all nodes to each tree
        self.distance = (((self.grid[0][:, :, np.newaxis] -
                      np.array(agent_x)[np.newaxis, np.newaxis, :])**2 +
                     (self.grid[1][:, :, np.newaxis] -
                      np.array(agent_y)[np.newaxis, np.newaxis, :])**2)**0.5)

        self.zoi_radii = np.array(zoi_radii).flatten()

        # Array of shape distance [res_x, res_y, n_agents], indicating which
        # cells are occupied by agents zoi
        self.agents_present = self.zoi_radii[np.newaxis, np.newaxis, :] > self.distance

        if self.type == "sym":
            self.calculateSymZoi()
        elif self.type == "asym":
            self.calculateAsymZoi()
        else:
            print("ERROR: Selected ZOI type not available.\n")
            print("Available options: `sym`, `asym`")

    def calculateSymZoi(self):
        # Count all nodes, which are occupied by agents
        # returns array of shape [n_agents]
        # BETTINA ODD 2017: variable 'countbelow'
        agents_counts = self.agents_present.sum(axis=(0, 1))

        # Calculate reciprocal of cell-own variables (array to count wins)
        # BETTINA ODD 2017: variable 'compete_below'
        # [res_x, res_y]
        agents_present_reci = 1. / self.agents_present.sum(axis=-1)

        # Sum up wins of each agent = agents_present_reci[agent]
        n_agents = len(self.agents_present[0, 0, :])
        agents_wins = np.zeros(n_agents)
        for i in range(n_agents):
            agents_wins[i] = np.sum(agents_present_reci[np.where(
                self.agents_present[:, :, i])])

        self.effective_area = agents_wins / agents_counts

    def calculateAsymZoi(self):
        agents_counts = self.agents_present.sum(axis=(0, 1))

        agents_wins = np.zeros(self.agent_n)
        for xv in range(len(self.grid[0])):
            for yv in range(len(self.grid[1])):
                cells = self.agents_present[xv, yv, :]
                if any(cells):
                    bools = self.zoi_radii == max(self.zoi_radii[cells])
                    if np.count_nonzero(bools) != 1:
                        pos_bools = [i for i, x in enumerate(bools) if x]
                        bools = random.sample(pos_bools, 1)
                    agents_wins[bools] += 1

        self.effective_area = agents_wins / agents_counts

    def getEffectiveArea(self):
        return self.effective_area



