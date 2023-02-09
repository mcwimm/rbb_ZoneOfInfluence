import numpy as np


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

        # Numpy array of shape [res_x, res_y, n_agents]
        self.distance = (((self.grid[0][:, :, np.newaxis] -
                      np.array(agent_x)[np.newaxis, np.newaxis, :])**2 +
                     (self.grid[1][:, :, np.newaxis] -
                      np.array(agent_y)[np.newaxis, np.newaxis, :])**2)**0.5)

        if self.type == "sym":
            self.calculateSymZoi(zoi_radii)

    def calculateSymZoi(self, zoi_radii):
        # Array of shape distance [res_x, res_y, n_agents], indicating which
        # cells are occupied by agents zoi
        zoi_radii = np.array(zoi_radii).flatten()
        agents_present = zoi_radii[np.newaxis, np.newaxis, :] > self.distance

        # Count all nodes, which are occupied by agents
        # returns array of shape [n_agents]
        # BETTINA ODD 2017: variable 'countbelow'
        agents_counts = agents_present.sum(axis=(0, 1))

        # Calculate reciprocal of cell-own variables (array to count wins)
        # BETTINA ODD 2017: variable 'compete_below'
        # [res_x, res_y]
        agents_present_reci = 1. / agents_present.sum(axis=-1)

        # Sum up wins of each agent = agents_present_reci[agent]
        n_agents = len(agents_present[0, 0, :])
        agents_wins = np.zeros(n_agents)
        for i in range(n_agents):
            agents_wins[i] = np.sum(agents_present_reci[np.where(
                agents_present[:, :, i])])

        self.effective_area = agents_wins / agents_counts

    def getEffectiveArea(self):
        return self.effective_area



