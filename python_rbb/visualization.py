import matplotlib.pyplot as plt
import matplotlib.cm as cm
import pandas as pd


class Visualization:
    def __init__(self, file='TreeGrowthModel/output.txt'):
        data = pd.read_csv(file, sep=', ', header=0)
        self.data = pd.DataFrame(data)

    def getZOIPlot(self):
        xx = self.data['x']
        yy = self.data['y']
        cc = self.data['timestep']
        colors = [cm.jet(color) for color in cc]  # gets the RGBA values from a float

        sizes = self.data['root_radii']

        plt.figure()
        ax = plt.gca()
        for x, y, color, size in zip(xx, yy, colors, sizes):
            circle = plt.Circle((x, y), size,
                                color=color, fill=False)
            ax.add_artist(circle)

        maxxy = 1.5 * max(max(xx), max(yy))
        plt.xlim([0, maxxy + 5])
        plt.ylim([0, maxxy + 5])
        ax.set_aspect(1.0)  # make aspect ratio square
        # plot the scatter plot
        plt.scatter(xx, yy,
                    s=0, cmap='jet', facecolors='none')
        plt.grid()
        plt.colorbar(label="Time step")
        plt.clim(0, max(cc))
        plt.show()

    def getBiomassPlot(self):
        fig = plt.figure(figsize=(10, 5))
        ax = fig.add_subplot(111)
        for unq_value in self.data['tree'].unique():
            mask = self.data['tree'] == unq_value
            df_subset = self.data[mask]
            plt.plot(df_subset['timestep'], df_subset['biomass_act'])

        ax.set_xlabel('Time step')
        ax.set_ylabel('Actual biomass')
        plt.gca().legend((self.data['tree'].unique()))
        plt.show()

    def getEffectiveArea(self):
        fig = plt.figure(figsize=(10, 5))
        ax = fig.add_subplot(111)
        for unq_value in self.data['tree'].unique():
            mask = self.data['tree'] == unq_value
            df_subset = self.data[mask]
            plt.plot(df_subset['timestep'], df_subset['effective_area'])

        ax.set_xlabel('Time step')
        ax.set_ylabel('Effective Area (ZOI)')
        plt.gca().legend((self.data['tree'].unique()))
        plt.show()


# plot = Visualization()
# plot.getZOIPlot()
# plot.getEffectiveArea()

