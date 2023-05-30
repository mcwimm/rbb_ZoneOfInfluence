# Reusable Building Block
## 1. The name of the RBB [_*_]

Zone-of-Influence (ZOI)

## 2. The author(s) names [_*_] & affiliation(s)

Cyril Piou, Marie-Christin Wimmler, Uta Berger

## 3. Keywords [_*_]

competition, ecology, interaction, neighborhood, plants

## 4. The purpose of the RBB [_*_]

The Zone-Of-Influence Reusable Building Block (ZOI RBB) was originally developed by Weiner et al. (2021) [^Weiner2021] to describe competition between plants for resources (water, nutrients, light) or space phenomenologically.
Since competition can be symmetric (plants share the resources equally, often assumed for nutrients) or asymmetric (larger plants get un-proportionally more resources, often assumed for light), the ZOI RBB defines the type of competition (either symmetric or asymmetric), quantifies its strength, as well as its consequences for the growth of the involved plants. 

The ZOI RBB has been used in various plant population models (e.g., Weiner et al. 2001[^Weiner2021]) and forest simulation models (e.g., Berger et al. 2008[^Berger2008]).
It is synonymous with so-called *Competition Indices* known from forest sciences (see, e.g., Pretzsch 2009[Pretzsch^2009]) and belongs to the family of *Distance Models* sensu Czárán (1998)[^Czaran1998]. 
It was occasionally used to describe animal interactions in agent-based models (e.g. Piou et al. 2007[^Piou2007]).

The present version of the ZOI describes complete symmetric competition or complete asymmetric competition. 
It can be easily adapted to describe competition proportional to the size ratio of the involved plants or to describe positive local interactions (facilitation, e.g., Lin et al. 2012[^Lin2012]) resulting from the presence of neighbouring plants that  improve, e.g., the microclimate. 


## 5. Concepts

The ZOI RBB builds on the concept of optimal growth which is reduced down to the realized growth by modification factors. 
These modification factors are usually expressed as the negative influences of the environment. 

The ZOI RBB calculates the modification factor for neighbourhood competition. 
This factor is called *effective area* ($A_e$). 
It modifies the potential growth of a plant (which depends on its biomass) down to the realized growth (which depends on the available resources). 
For the seek of simplicity, the resources are described as cells of a grid describing the model's world.
The amount of resources a plant can exploit is thus equal to the number of cells overlapped by its ZOI minus the cells claimed by its neighbors.

## 6. An overview of the RBB and its use [_*_]

*Note: Agents in the ZOI are usually plants but can also represent other individuals such as animals. 
In the following we use the term `plant`*

### Entity

- What entity, or entities, are running the submodel or are involved (e.g., by providing information)? 
  - The agents calling on the ZOI RBB are individual plants.
- What state variables does the entity need to have to run this RBB? 
  - The radius of the zone of influence and the effective area are state variables and used in the ZOI RBB.
- Which other variables describe the entities?
  - Growth rate
  - Biomass (or a proxy of such)


### Context, model parameters & patterns

+ What global variables (e.g., parameters characterising the environment) or data structures (e.g., a gridded spatial environment) does the use of the RBB require?
  + The plants compete for the occupied cells of a grid (the ones they overlap with their ZOI). Hence, the simulated world need to be defined with grid cells.
+ Does the RBB directly affect global variables or data structures?
  + The RBB counts the number of agents sharing a similar cell. For implementation purpose, it may affect temporary variable storing for each cell the IDs of sharing agents, or their number.
  + In the Python implementation, the counts are based on cell nodes.
  + The RBB influences the plant biomass.
+ What parameters does the RBB use? Preferably a table including parameter name, meaning, default value, range, and unit (if applicable). 
  + The NetLogo RBB implementation uses the following variables: 

| name       | meaning | units | typical ranges                | 
|------------| -------- | -------- |-------------------------------| 
| nb-sharing | State variable of cells. Specifies the # of plants using a certain cell. | counts | 0 .. max # of plants          |
| nb-tot     | Total # of cells occupied by the focal plant. | counts | 1 .. $A_{ZOI} / Size_{cell}$) |
| nbsh       | # of cells wich can actually be used by the focal plant. | counts | 0 .. max # of cells           |

  + The Python RBB implementation uses the following variables: 

| name | meaning                                                                   | units  | typical ranges       | 
| -------- |---------------------------------------------------------------------------|--------|----------------------| 
| agents_present | State variable of cells. Specifies which plants are using a certain cell. | index  | 0 .. max # of plants |
| agents_counts | Total # of nodes (cell junctions) occupied by the focal plant.            | counts | 1 .. max # of nodes) |
| agents_wins      | # of nodes wich can actually be used by the focal plant.                  | counts | 0 .. max # of nodes            |

### Patterns and data to determine parameters and/or to claim that the RBB is realistic enough for its purpose

- Patterns and data are not available for the RBB itself but for the RBB integrated a plant growth model.
- Patterns that can be used for calibration: biomass distribution, size distribution of dying plants 

- Are pre-existing datasets available to users already exist (references)?
  + There is a long tradition of calibrating the ZOI parameter in plant ecology and forest sciences. Examples are:
    + Stoll, P., Weiner, J., 2000. A neighborhood view of interactions among individual plants. In: Dieckmann, U., Law, R., Metz, J.A.J. (Eds.), The Geometry of Ecological Interactions: Simplifying Spatial Complexity. Cambridge University Press, Cambridge, UK, pp. 11–27
    + Lin, Y., Huth, F., Berger, U., & Grimm, V. (2014). The role of belowground competition and plastic biomass allocation in altering plant mass-density relationships. Oikos, 123(2), 248–256. Retrieved from http://doi.wiley.com/10.1111/j.1600-0706.2013.00921.x: data from greenhouse experiments using birch seedlings


### Interface - A list of all inputs and outputs of the RBB [_*_]
#### Inputs

| Input                 | Unit   |
|-----------------------|--------|
| x,y-position of agent | length |
| radius of ZOI         | length |

Additional input of NetLogo implementation

| Input | Unit |
| -------- | -------- |
| ID of agent     | none     |

#### Outputs

| Output         | Unit     |
|----------------|----------|
| ZOI_factor     | ratio    |
| Effective area | length^2 |
 
The ZOI_factor is a modification factor for the *effective area* $A_e$.
This factor is the ratio of shared to total number of cells below a plant.

### Scales [_*_]:

Both the spatial and the temporal scales are artificial and can be related to the particular plant system. 

The accuracy of the RBB depends on the number of cells. 
The higher the resolution the better the estimate of the effective area.

## 7. Pseudocode, a Flowchart or other type of graphical representation [_*_] 

*Note: The following description follows the implementation within the NetLogo framework.*

Plants with overlapping ZOIs are neighbours and compete for cells within the overlapping area. 
Its size $Size_{ZOI_{overlap}}$ thus describes phenomenologically the strength of competition, which can be symmetric (plants share the resources inside the overlapping area equally) or asymmetric (the larger plants get all resources in the overlapping area). 
For calculating the # of usable cells, the main procedure of the RBB **ZOI** calls either the subprocedure **attribute_grid** or **share_grid**. 
In **attribute_grid** The size of the competing plants is pairwise compared. The larger plant in each case writes its own ID number in the cells the competing plants share. 
The subprocedure **ZOI_asym** then counts the ratio between *# of cells with own ID : # of all cells covered by the ZOI* for calculating $A_e$.
In case of symmetric competition, **share_grid** counts the # of plants those ZOIs overlap a certain cell. 
The reciproe *1 / # of owning plants* is assigned to the subprocedure **ZOI_sym** which uses the ratio *part of cells which can be used : # of all cells covered by the ZOI* for calculating $A_e$.

![](https://github.com/mcwimm/rbb_ZoneOfInfluence/blob/master/figs/zoi_flowchart.png)

## 8. The program code [_*_]

Program code for the [NetLogo](https://github.com/mcwimm/rbb_ZoneOfInfluence/tree/master/netlogo_rbb) and [Python](https://github.com/mcwimm/rbb_ZoneOfInfluence/tree/master/python_rbb) implementations can be found in te respective folders.

* Information on the programming language, operating system, development environments incl. any required software package or library, version etc.  [_*_]. 
  * NetLogo:
    * NetLogo 6.3.0 (tested on Mac and Windows)
  * Python: 
    * developed and tested with Python 3.7 (tested on Windows)
    * Python packages: numpy (for mathematical operations) and random (for generation of random numbers)

## 9. Example analyses of a simulation output, test cases and benchmarks [_*_]

We provide a synthetic benchmark consisting of only 5 individuals (e.g., trees) with different sizes.
The individuals are positioned in order to trigger critical points: 1 tree is completely covered, 1 is not covered at all, 1 is partly covered and 2 have exactly same size.
The size and position of those trees can be found [here](https://github.com/mcwimm/rbb_ZoneOfInfluence/blob/master/python_rbb/Benchmark/setup_1.txt).

This setup is calculated with the two types of ZOI (i.e., symmetric vs. asymmetric) as well as with two different resolutions of the grid system (i.e. low vs. high).

The figure below shows the results with A) low and B) high grid resolution.
To run the benchmark with the python implementation open and run the file ['run_benchmark.py'](https://github.com/mcwimm/rbb_ZoneOfInfluence/blob/master/python_rbb/Benchmark/run_benchmark.py).

![](https://github.com/mcwimm/rbb_ZoneOfInfluence/blob/master/figs/zoi_benchmark.jpg)

_Figure: Results of the benchmark shown as top view on plants (represented as circles). 
The size of circles represents the size of the ZOI and the color represents the ZOI factor, i.e., the ratio of effective to total area occupied by each plant.
Red grid lines indicate the grid resolution which is 3x3m in (A) and 1x1m in (B)._


The implementation of the ZOI RBB in different languages can lead to slightly different results, as shown below.
One reason for this is the different implementation of the grid system and thus the calculation of the area occupied by a plant.
In NetLogo this area is a function of cells, whereas in the Python implementation it is a function of nodes (intersections in the grid).
Another reason for differences in the calculation of the asymmetric ZOI is stochasticity.
If two overlapping ZOIs are exactly the same size - which is very unlikely in a simulation - the "winner" is chosen randomly.

![](https://github.com/mcwimm/rbb_ZoneOfInfluence/blob/master/figs/zoi_benchmark_C_D_comparison.jpg)

_Figure: Comparison of ZOI factors for each tree calculated using the Python (orange) and NetLogo (green) implementations. Numbers indicate relative difference between results with NetLogo as reference scenario. Grid resolution is 1x1m._


## 10. Version control [_*_]

We use GitHub for version control.

## 11. Status info

*	Peer Review: no
*	Licence (if relevant): Creative Commons Attribution Non Commercial Share Alike 4.0 International (CC-BY-NC-SA-4.0)


## 12. Citation of the RBB 

-

## 13. Example implementation of the RBB to demonstrate its use

An example of implementation of the ZOI RBB can be found in the AZOI (Another Zone Of Influence model) re-implementation of Weiner et al. (2001) model in NetLogo at the following link: https://www.comses.net/codebases/4273/releases/1.1.0/

Results obtained with the example implementation providing insights into how, under different settings, the RBB performs, including extreme scenarios.

The graphs implemented in the Netlogo version of the AZOI model are showing already several aspects that Weiner et al. (2001) noted with their original model. 
The easiest result to observe is the mean biomass changing through time and arriving to different values with different competition, density and spatial distribution configurations.
The shapes of the distributions are also quite easy to compare among simulation settings and corresponding to what Weiner et al. documented.
With the help of the behavior space analysis of NetLogo it is possible to produce relatively quickly some results showing further comparisons between parameterizations. For example, in figure 1, the biomass distributions are presented as in the histograms of Weiner et al. (with log scale) but at time step = 30 and with three densities.
It illustrates the differences among simulation settings in spread of sizes and direction of the skewness.

![](https://github.com/mcwimm/rbb_ZoneOfInfluence/blob/master/figs/zoi_analysis_nl.jpg)
_Figure: Histograms of biomass distributions of individual plants after 30 time steps with different simulation settings (results are out of all individual sizes of 30 replicates with identical settings, thus the high frequency numbers); the columns of histograms correspond to different densities (100, 506 and 992 individuals in the simulation area); the rows presents different spatial configurations (random or uniform (hexagonal packing) distributions) and different competition regimes (asymmetric or symmetric)._

## 14. Use history

The ZOI concept were successfully used in several model implementations:

- Stoll, P., Weiner, J., 2000. A neighborhood view of interactions among individual plants. In: Dieckmann, U., Law, R., Metz, J.A.J. (Eds.), The Geometry of Ecological Interactions: Simplifying Spatial Complexity. Cambridge University Press, Cambridge, UK, pp. 11–27
- Weiner, J., P. Stoll, H. Muller-Landau, and A. Jasentuliyana. 2001. The effects of density, spatial pattern, and competitive symmetry on size variation in simulated plant populations. The American Naturalist, 158:438-450
- Stoll, P., J. Weiner, H. Muller-Landau, E. Müller and T. Hara. 2002. Size symmetry of competition alters biomass–density relationships. Proceedings of the Royal Society, London Series B, 269:2191-2195
- Piou, C., U. Berger, H. Hildenbrandt, V. Grimm, K. Diele, and C. D’Lima. 2007. Simulating cryptic movements of a mangrove crab: Recovery phenomena after small scale fishery. Ecological Modelling 205:110-122.
- Lin, Y., Huth, F., Berger, U., & Grimm, V. (2014). The role of belowground competition and plastic biomass allocation in altering plant mass-density relationships. Oikos, 123(2), 248–256.

## 15. A manual and/or tutorial, in particular for more complex  RBBs

-

## 16. Relationship to other RBBs

The Field-Of-Neighbourhood (FON), which describes competition or facilitation among neighbouring plants, is an extension of the Zone-of-Influence (ZOI).

## 17. References 

[^Weiner2021]: Weiner J, Stoll P, Muller-Landau H, Jasentuliyana A (2021): The Effects of Density, Spatial Pattern, and Competitive Symmetry on Size Variation in Simulated Plant Populations
[^Berger2008]: Berger U, Piou C, Schiffers K, Grimm V (2008): Competition among plants: Concepts, individual-based modelling approaches, and a proposal for a future research strategy. Perspectives in Plant Ecology, Evolution and Systematics.  9: 121-135
[^Pretzsch2009]: Pretzsch (2009): Forest Dynamics, Growth and Yield - From Measurement to Model. Springer Berlin (Verlag).
[^Czaran1998]: Czárán T (1998): Spatiotemporal models of population and community dynamics. Vol. 21. Springer Science & Business Media, 1998.
[^Piou2007]: Piou C, Berger U, Hildenbrandt H, Grimm V, Diele K, D’Lima C (2007): Simulating cryptic movements of a mangrove crab: recovery phenomena after small scale fishery. Ecological Modelling. 205: 110-122
[^Lin2012]: Lin Y, Berger U, Grimm V, Ji Q-R (2012): Differences between symmetric and asymmetric facilitation matter: exploring the interplay between modes of positive and negative plant interactions. Journal of Ecology.

