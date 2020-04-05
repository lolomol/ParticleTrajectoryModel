# Trashtracker v1 --> v2 changes

Trashtracker is a 2d lagrangian advection model.  It advects using surface currents.  If it instead advects using currents from arbitrary depth, it can do horizontal advection at any depth.  Thus, assuming vertical advection is negligible, a 3d simulation can be performed by coupling trashtracker with a function which prescribes vertical motion.  I have modified trashtracker to support this 3d simulation scheme.


# Changes

Visual comparison here: [https://github.com/themodellinghouse/trashtracker/compare/klink](https://github.com/themodellinghouse/trashtracker/compare/klink)


## Dispersal Model: Existing Files

<span style="text-decoration:underline;"><span style="text-decoration:underline;">getSSCurrent.m</span>



*   Current files now have depth dimension, netcdf loading altered accordingly
*   Loaded arrays of currents now have depth dimension, indexing altered accordingly

<span style="text-decoration:underline;"><span style="text-decoration:underline;">loadParticles.m</span>



*   Adds p.z and p.Z, analog to p.lat and p.LAT
*   Adds many biofouling-specific fields to particles if necessary

<span style="text-decoration:underline;"><span style="text-decoration:underline;">loadSettings.m</span>



*   New field settings.verticalTransport, determines which vertical transport mechanism is used for a model run.  Also adds fields to control each particular mechanism.
*   New fields forcingsLatRange, forcingsLonRange, forcingsDepthRange, which controls the spatial extent of forcing data to load for this model run.  Useful for regional model runs.
*   New fields nestedVerticalTimesteps, determines how many vertical timesteps to run for every horizontal timestep.  Allows, e.g., daily horizontal timesteps, hourly vertical calculations.  Useful for resolving different timescales in different dimensions.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">main.m</span>



*   New struct, “forcings”, which is updated every timestep by a call to loadForcings.m.  This struct is passed to any functions which need forcing data.
    *   Note: ocean current forcing data does not follow this paradigm for the sake of minimizing changes to the existing model.  If code is updated so that currents follow this paradigm, it could reduce I/O time and significantly speed up the model.  For example, could be implemented so that each month of currents is loaded into RAM as a block, reducing number of I/O calls by ~30x
*   New block of code which updates the vertical position of the particles.  Loop allows for nested timesteps.
    *   First: call getVerticalTransport.m to get a dz for each particle
    *   Second: call updateParticlesVertical.m to apply this dz to each particle, and constrain to bathymetry/surface
*   Moves time update and call to storeOutput into the vertical loop

<span style="text-decoration:underline;"><span style="text-decoration:underline;">storeOutput.m</span>



*   Now store depth each timestep, as it does for lat/lon


## Dispersal Model: New Files

<span style="text-decoration:underline;"><span style="text-decoration:underline;">getVerticalTransport.m</span>



*   Returns the vertical particle transport in a timestep according to vertical transport mechanism, specified in settings.verticalTransport
*   Fixed depth: simply forces particles to a particular depth
*   Biofouling
    *   1. loads local forcing data onto particles (so they know their local S, T, chl, etc.)
    *   2. Grows algae on the particles
    *   3. Calculates their settling velocities
    *   4. Calculates dz from their settling velocities

<span style="text-decoration:underline;"><span style="text-decoration:underline;">loadForcings.m</span>



*   Called every loop in main.m, is responsible for making sure the struct “forcings” contains the forcing data needed by the model for this timestep.
*   This is where logic lives which loads in new data when settings.date reaches a new year, for example, or which loads on additional forcing data depending on what transport mechanisms are being used.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">updateParticlesVertical.m</span>



*   Given a dz for each particle, updates p.z on each particle accordingly, but constrains to bathymetry and surface.  Direct analog to updateParticles, which deals with lateral movements.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">writeOutput.m</span>



*   Stores p.Z in addition to p.LAT and p.LON
*   If using biofouling vertical transport, stores plastic radius and density


## Vertical Dynamics Implementations 


#### Fixed Depth

Simple enough to reside in getVerticalTransport.m, simply calculates the dz necessary to move each particle to the depth specified in settings.fixedDepth.  Particles are not constrained to bathymetry, this is done by updateParticlesVertical.

This vertical dynamic essentially uses trashtracker as a 2d dispersion model, constrained to bathymetry.  For example, settings.fixedDepth=0 should restore trashtracker’s original surface dispersion behavior.


#### Biofouling

Reasonably complex model borrowed from Merel Kooi ([2017](https://doi.org/10.1021/acs.est.6b04702)), involves a lot of moving parts, both in terms of code and forcing data.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">BiofoulingConstants.m</span>



*   Houses all the physical constants and adjustable model parameters unique to the biofouling dynamic.  Complicated enough to justify being split off from global model settings.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">algaeCollisions.m</span>



*   Calculates the rate of accumulation of algae on the particles due to collisions with algal cells.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">algaeGrowth.m</span>



*   Calculates the rate of growth of algae on the particles.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">algaeMortality.m</span>



*   Calculates the rate of death of algae due to “grazing mortality,” i.e. the rate at which marine fauna consumes algae off the particle.  Poorly understood and crudely parameterized.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">algaeRespiration.m</span>



*   Calculates the rate of death of algae due to “bacterial respiration”, i.e. the rate at which ambient bacteria consumes algae off the particle.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">dimensionlessSettlingVelocity.m</span>



*   Calculates the dimensionless settling velocity of a particle, an intermediate value needed to compute the real settling velocity of a particle.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">dynamicViscositySeawater.m</span>



*   Calculates the dynamic viscosity of seawater at each particle

<span style="text-decoration:underline;"><span style="text-decoration:underline;">getSeawaterDensity.m</span>



*   Parameterized density function

<span style="text-decoration:underline;"><span style="text-decoration:underline;">getSettlingVelocity.m</span>



*   Gets the vertical velocity of particles due to density difference from local seawater

<span style="text-decoration:underline;"><span style="text-decoration:underline;">readme.txt</span>



*   Helpful overview, includes DOIs of papers cited in the model

<span style="text-decoration:underline;"><span style="text-decoration:underline;">updateBiofouling.m</span>



*   Simulates the growth of algae on the particles for a given timestep.  Packages together all the algae growth/death dynamics.
*   Call this when you want your algae to grow

<span style="text-decoration:underline;"><span style="text-decoration:underline;">updateBiofoulingForcingDataOnParticles.m</span>



*   For convenience, local forcing conditions are stored on the particles struct.  This function pulls the appropriate values out of the forcing data and sticks them onto the particles.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">updateRadiusAndDensity.m</span>



*   Calculates the total density/total radius of the plastic particle/algae film, and updates these values on the particle struct.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">UitzConstants.m</span>



*   Contains the necessary constants to construct vertical profiles of chlorophyll, using the method/parameters from [Uitz 2006](https://doi.org/10.1029/2005JC003207).

<span style="text-decoration:underline;"><span style="text-decoration:underline;">chlAboveZ.m</span>



*   Vertically integrates the chlorophyll profile above a certain depth

<span style="text-decoration:underline;"><span style="text-decoration:underline;">chlAtZ.m</span>



*   Calculates the chlorophyll concentration at a certain depth

<span style="text-decoration:underline;"><span style="text-decoration:underline;">lightAtZ.m</span>



*   Calculates the light intensity at given depth.


## Forcing Data Accessing

Due to the many new forcings necessary for the biofouling model, I made some tools for representing and indexing into these multidimensional arrays.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">Hyperslab.m</span>



*   This object basically holds all or part of a netcdf file with 3 spatial dimensions and 1 time dimension.  It stores the coordinates along each axis, and the data itself.
*   It contains a crucial function, “select”, which allows you to pull an arbitrary number of values out of the data by passing it vectors of coordinate sets.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">chlSurf2Hyperslab.m</span>



*   Deals with the messy transition from a chlorophyll netcdf file on disk to a Hyperslab object in memory.
*   Works for Aqua-MODIS data.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">getSurfacePAR.m</span>



*   Calculates the Photosynthetically Active Radiation at the earth’s surface for vectors of lat, lon, time coordinates.
*   Technically not accessing forcing data on disk, but externally serves same function

<span style="text-decoration:underline;"><span style="text-decoration:underline;">tempSal2Hyperslab.m</span>



*   Deals with the messy transition from a temperature/salinity netcdf file on disk to Hyperslab objects in memory.
*   Works for HYCOM data.


## Existing Forcing Data Downloading

<span style="text-decoration:underline;"><span style="text-decoration:underline;">aggregateHycom.m</span>



*   Changed to deal with the new dimension (depth) in the downloaded hycom files

<span style="text-decoration:underline;"><span style="text-decoration:underline;">dowloadHycomTimestep.m</span>



*   Changed to deal with the new dimension we need to download (depth)


## New Forcing Data Downloading

<span style="text-decoration:underline;"><span style="text-decoration:underline;">aggregateHycomTempSal.m</span>



*   Uses NCO (netcdf operators library) to concatenate all the downloaded files.
*   Advantage of this method: clean, utilizes the de-facto netcdf manipulation library
*   Disadvantage: dependence on NCO

<span style="text-decoration:underline;"><span style="text-decoration:underline;">downloadHycomTempSalTimestep.m</span>



*   Slight variation of downloadHycomTimestep.m to download water temp and salinity rather than north/east currents

<span style="text-decoration:underline;"><span style="text-decoration:underline;">aggregateAquaChl.m</span>



*   Uses NCO (netcdf operators library) to concatenate all the downloaded files.  Also rotates longitude range to match hycom’s 0-to-360 range, keeping all the forcing data consistent.  Also decreases horizontal resolution by 5x.
*   Dependent on NCO, but very simple because of this.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">downloadAquaChlTimeStep.m</span>



*   Downloads surface chlorophyll-a concentration data from Nasa AQUA-MODIS.
*   Kind of challenging, because the download server requires a login.  MATLAB’s downloading functions can’t quite handle this task, so I use wget for the downloading.
*   Downsides: dependent on wget and some unix commands (chmod, echo); probably only functions on unix.  Users on windows may need to figure out an alternate download method.


## Output Visualization

<span style="text-decoration:underline;"><span style="text-decoration:underline;">animateParticle.m</span>



*   Neat little animation of particles moving around the globe, using output files from model runs.  Toy script.

<span style="text-decoration:underline;"><span style="text-decoration:underline;">drawStochasticMap.m</span>



*   Draws global maps of the log concentration of particle data for a whole year; e.g. shows where particles were during 2015.


## Utils

<span style="text-decoration:underline;"><span style="text-decoration:underline;">utils/createSourceFile.m</span>



*   Creates a linearly spaced, whole-world grid of particles to seed the model with
