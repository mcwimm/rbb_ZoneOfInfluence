import matplotlib.pyplot as plt
import matplotlib.cm as cm
import pandas as pd
import numpy

class Visualization:
    def __init__(self, file='TreeGrowthModel/output.txt'):
        data = pd.read_csv(file, sep=', ', header=0)
        self.data = pd.DataFrame(data)

    def getZOIPlot(self, major_ticks_x=None, major_ticks_y=None, color_l='timestep'):
        xx = self.data['x']
        yy = self.data['y']
        cc = self.data[color_l]
        colors = [cm.jet(color) for color in cc]  # gets the RGBA values from a float

        sizes = self.data['zoi_radii']

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
        plt.colorbar(label=color_l)
        plt.clim(0, max(cc))

        if major_ticks_x is not None:
            import numpy as np
            ax.set_xticks(major_ticks_x)
            ax.set_yticks(major_ticks_y)
            plt.grid(which="major", alpha=0.5)
        plt.show()

    def getOverTimePlot(self, y_var, y_label):
        fig = plt.figure(figsize=(10, 5))
        ax = fig.add_subplot(111)
        for unq_value in self.data['tree'].unique():
            mask = self.data['tree'] == unq_value
            df_subset = self.data[mask]
            plt.plot(df_subset['timestep'], df_subset[y_var])

        ax.set_xlabel('Time step')
        ax.set_ylabel(y_label)
        plt.gca().legend((self.data['tree'].unique()))
        plt.show()

    def getEffectiveAreaPlot(self):
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

