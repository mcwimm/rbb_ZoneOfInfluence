# Reusable Building Block
## Name

Zone-of-Influence (ZOI)

## Purpose

The Zone-Of-Influence Reusable Building Block (ZOI RBB) describes phenomenologically the local interactions of plants. 
Originally, it was developed by Weiner et al. (2021) [^Weiner2021] to describe competition for resources (water, nutrients, light) or space. 

Since competition can be symmetric (plants share the resources equally, often assumed for nutrients) or asymmetric (larger plants get un-proportionally more resources, often assumed for light), the ZOI RBB defines the type of competition (either symmetric or asymmetric), quantifies its strength, as well as its consequences for the growth of the involved plants. 

The ZOI RBB has been used in various plant population models (e.g., Weiner et al. 2001[^Weiner2021]) and forest simulation models (e.g., Berger and Hildebrandt 2007[^Berger2007], Berger et al. 2008[^Berger2008]).
It is synonymous with so-called *Competition Indices* known from forest sciences (see, e.g., Pretzsch 2009[Pretzsch^2009]) and belongs to the family of *Distance Models* sensu Czárán (1998)[^Czaran1998]. 
It was occasionally used to describe animal interactions in agent-based models (e.g. Piou et al. 2007).

The present version of the ZOI describes complete symmetric competition or complete asymmetric competition. 
It can be easily adapted to describe competition proportional to the size ratio of the involved plants or to describe positive local interactions (facilitation, e.g., Lin et al. 2012[^Lin2012]) resulting from the presence of neighbouring plants that  improve, e.g., the microclimate. 


## Narrative Documentation

???


## Reference Implementation and Use Cases



## Inputs and Outputs

**Inputs**

- 

## Relationship to other RBBs

Durable references (i.e., permanent identifiers or URLs) to other related RBBs.

# Tier 2
## Keywords

`ecology`, `plants`, `neighborhood`, `interaction`, `competition`

## General Metadata

- authors: Cyril Piou, Uta Berger
- version: v 1.1.0 **?**
- license: CC-BY-NC-SA-4.0 **?**
- programming language and version:
  - NetLogo
- software, system, and data dependencies: **?**
- repository URL (NOTE: needs clarification, is this the _development_ repository like the URL of this GitHub repository, or a TRUSTed digital repository for
  archival, like https://doi.org/10.5281/zenodo.7241586?)
- peer reviewed (yes/no): **?** by RBB consortium?
- date published
- date last updated

## Software Citation and FAIR4RS Principles

Cyril Piou & Uta Berger (20XX, month date). “Modeling local plant interactions with the Zone-Of_Influence Reusable Building Block” (Version X.X.X). e.g., CoMSES Computational Model Library. Retrieved from

## Concepts

The ZOI RBB builds on the concept of optimal growth which is reduced down to the realized growth by modification factors. 
These modification factors are usually expressed as the negative influences of the environment. 

The ZOI RBB calculates the modification factor for neighbourhood competition. 
This factor is called *effective area* ($A_e$). 
It modifies the potential growth of a plant (which depends on its biomass) down to the realized growth (which depends on the available resources). 
For the seek of simplicity, the resources are described as cells of a grid describing the model's world <span style="color:green"> model world </span>.
The number <span style="color:green">amount </span> of resources a plant can exploit is thus equal to the number of cells overlapped by its ZOI minus the cells claimed by its neighbors.

## Documentation and Use
### Entity

- What entity, or entities, are running the submodel? What state variables does the entity need to have to run this RBB?

    The agents calling on the ZOI RBB are individual plants. 
    An individual plant is defined by a circular zone (hence the name Zone Of Influence - ZOI) which scales with its biomass. 
    The radius of this zone is a state variable and used in the ZOI RBB.

- Which variables describe the entities (normally derived from state variables)? **?**

    - Initial and maximum biomass (average and sd) 
    - Growth rate


### Context, model parameters & patterns:

-   What global variables (e.g., parameters characterizing the environment) or data structures (e.g., a gridded spatial environment) does the use of the RBB require?

  The plants compete for the occupied cells of a grid (the ones they overlap with their ZOI). 
  Hence, the simulated world need to be defined with grid cells.

- Does the RBB directly affect global variables or data structures?

  The RBB counts the number of agents sharing a similar cell. 
  For implementation purpose, it may affect temporary variable storing for each cell the IDs of sharing agents, or their number. **?**

-   Which parameters does the RBB use? Preferably a table including parameter name, meaning, default value, range, and unit (if applicable)

The NetLogo RBB implementation uses the following variables: **?**

| name | meaning | units | typical ranges | 
| -------- | -------- | -------- | -------- | 
| nb-sharing     | State variable of cells. Specifies the # of plants using a certain cell. | counts | 0 .. max # of plants|
| nb-tot     | Total # of cells occupied by the focal plant. | counts | 1 .. $A_{ZOI} / Size_{cell}$)|
| nbsh     | # of cells wich can actually be used by the focal plant. | counts | 0 .. |


### Patterns and data to determine global variables & parameters and/or to claim that the model is realistic enough for its purpose

-  Which of the variables (or parameters) have an empirical meaning and can, in principle, be determined directly?

> **?** Here, imho, we don't need anything tree-related as 'ZOI' only describes the resource sharing of overlapping cycles.

  The scaling factor 2/3 could be obtained by field data using the relationship projected crown area ~ biomass.

-  Which variables can be only determined via calibration?

-  Which data or patterns can be used for calibration?

  - histograms of biomass distributions over time
  - spatial point patterns of plant distributions over time
  - the so-called self-thinning line (diagram showing *mean biomass* ~ *plant density* with log-log scaling of both axes) should have a characteristic slope between $-{3/2}$ and $-{4/3}$. 


-  Which data sets already exist? (include durable references)

There is a long tradition of calibrating the ZOI parameter in plant ecology and forest sciences. Examples are:

1. Stoll, P., Weiner, J., 2000. A neighborhood view of interactions among individual plants. In: Dieckmann, U., Law, R., Metz, J.A.J. (Eds.), The Geometry of Ecological Interactions: Simplifying Spatial Complexity. Cambridge University Press, Cambridge, UK, pp. 11–27
2. Lin, Y., Huth, F., Berger, U., & Grimm, V. (2014). The role of belowground competition and plastic biomass allocation in altering plant mass-density relationships. Oikos, 123(2), 248–256. Retrieved from http://doi.wiley.com/10.1111/j.1600-0706.2013.00921.x: data from greenhouse experiments using birch seedlings


### Interface

- What specific inputs does the RBB require from an external, calling entity and in what units (e.g., [CSDMS Standard Names](https://csdms.colorado.edu/wiki/CSN_Examples) and [UDUnits](https://www.unidata.ucar.edu/software/udunits/))?
  
  - The RBB requires the values of the *radius* of the *ZOI*, the ID number and the position of each calling agent. 
  -  **?** Python RBB: position and zoi of agents

- What specific outputs does it produce and how does this update the state variables of the calling entity?
   
  - The RBB provides the *effective area* $A_e$ as a modification factor for the growth function. 
  -  **?** Python RBB: list (length = number of agents) with effective area of each agent

### Scales

- On which spatio-temporal scales does the RBB work, i.e. what are the resolution and extent of the spatial and temporal scale?

  Both the spatial as well as the temporal scales are artificial and can be related to the particular plant system. 
  A typical spatial scale would be 500 cells X 500 cells. A typical time step could refer to one day.

### Details

How, in detail, does the RBB work? 
This should be written description that describes the code implementing the RBB and can include equations and  pseudo-code which is particularly important if the RBB involves several processes.

Plants with overlapping ZOIs are neighbours and compete for cells within the overlapping area. 
Its size $Size_{ZOI_{overlap}}$ thus describes phenomenologically the strength of competition, which can be symmetric (plants share the resources inside the overlapping area evenly) or asymmetric (the larger plants get all resources in the overlapping area). 
For calculating the # of usable cells, the main procedure of the RBB **ZOI** calls either the subprocedure **attribute_grid** or **share_grid**. 
In **attribute_grid** The size of the competing plants is pairwise compared. The larger plant in each case writes its own ID number in the cells the competing plants share. 
The subprocedure **ZOI_asym** then counts the ratio between *# of cells with own ID : # of all cells covered by the ZOI* for calculating $A_e$.
In case of symmetric competition, **share_grid** counts the # of plants those ZOIs overlap a certain cell. 
The reciproe *1 / # of owning plants* is assigned to the subprocedure **ZOI_sym** which uses the ratio *part of cells which can be used : # of all cells covered by the ZOI* for calculating $A_e$.

![](/figs/zoi_flowchart.png)

### Source Code

Provided in a format that is readable by compilers/development environments,
well commented, written for which programming language, operation system,
version etc., if possible, provided for different programming languages

**NetLogo**

````commandline
to ZOI
ifelse asymmetric-competition              
  [ 
    ask patches [set nb-sharing 10000] ;state variable gets a dummy value
    ask turtles [attribute-grids]      ;all plants claim the cells they occupy  
    ;calculates the effective area (aka resources) which can be used:
    ask turtles [zoi-asym]             
  ]
  [
    ask patches [set nb-sharing 0]     ;another dummy value 
    ask turtles [share-grids]          ;adds how many plants use a certain cell
    ;the resources are shared proportional to the number of plants using the patch:
    ask patches with [nb-sharing > 0] [set nb-sharing 1 / nb-sharing] 
    ;calculates the effective area (aka resources):
    ask turtles [zoi-sym]                  
  ]

end 
````

## Example implementation

An executable deployment that includes a simplified environment in which the RBB can be run.


An example of implementation of the ZOI RBB can be found in the AZOI (Another Zone Of Influence model) re-implementation of Weiner et al. (2001) model in NetLogo at the following link:
https://www.comses.net/codebases/4273/releases/1.1.0/

## Example analyses of a simulation output, benchmark, or test cases

Results obtained with the example implementation providing insights into how, under different settings, the RBB performs, including extreme scenarios.

The graphs implemented in the Netlogo version of the AZOI model are showing already several aspects that Weiner et al. (2001) noted with their original model. 
The easiest result to observe is the mean biomass changing through time and arriving to different values with different competition, density and spatial distribution configurations.
The shapes of the distributions are also quite easy to compare among simulation settings and corresponding to what Weiner et al. documented.
With the help of the behavior space analysis of NetLogo it is possible to produce relatively quickly some results showing further comparisons between parameterizations. For example, in figure 1, the biomass distributions are presented as in the histograms of Weiner et al. (with log scale) but at time step = 30 and with three densities.
It illustrates the differences among simulation settings in spread of sizes and direction of the skewness.

![](/figs/zoi_analysis_nl.jpg)
_Figure 1. Histograms of biomass distributions of individual plants after 30 time steps with different simulation settings (results are out of all individual sizes of 30 replicates with identical settings, thus the high frequency numbers); the columns of histograms correspond to different densities (100, 506 and 992 individuals in the simulation area); the rows presents different spatial configurations (random or uniform (hexagonal packing) distributions) and different competition regimes (asymmetric or symmetric)._

## Use history

What is the history of the RBB? Is it entirely new or based on earlier submodels, or an implementation of an existing submodel? 
 
**?** What's the difference to line 131 and to the following questions?

1. Stoll, P., Weiner, J., 2000. A neighborhood view of interactions among individual plants. In: Dieckmann, U., Law, R., Metz, J.A.J. (Eds.), The Geometry of Ecological Interactions: Simplifying Spatial Complexity. Cambridge University Press, Cambridge, UK, pp. 11–27
2. Weiner, J., P. Stoll, H. Muller-Landau, and A. Jasentuliyana. 2001. The effects of density, spatial pattern, and competitive symmetry on size variation in simulated plant populations. The American Naturalist, 158:438-450
3. Stoll, P., J. Weiner, H. Muller-Landau, E. Müller and T. Hara. 2002. Size symmetry of competition alters biomass–density relationships. Proceedings of the Royal Society, London Series B, 269:2191-2195
4. Piou, C., U. Berger, H. Hildenbrandt, V. Grimm, K. Diele, and C. D’Lima. 2007. Simulating cryptic movements of a mangrove crab: Recovery phenomena after small scale fishery. Ecological Modelling 205:110-122.
5. Lin, Y., Huth, F., Berger, U., & Grimm, V. (2014). The role of belowground competition and plastic biomass allocation in altering plant mass-density relationships. Oikos, 123(2), 248–256.

Has the RBB, or its predecessors, been used in literature?

Include a reference list of publications where the RBB was successfully used.

## User's guide | manual | tutorial

For more complex RBBs, a detailed user's guide or manual and a tutorial walk through can be very helpful to onboard new users.

## References

[^Weiner2021]: Weiner et al. 2021: The Effects of Density, Spatial Pattern, and Competitive Symmetry on Size Variation in Simulated Plant Populations
[^Berger2007]: Berger, Hildebrandt 2007
[^Berger2008]: Berger 2008
[^Pretzsch2009]: Pretzsch 2009
[^Czaran1998]: Czárán (1998)
[^Piou2007]: Piou et al. 2007
[^Lin2012]: Lin et al. 2012