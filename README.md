# Reproducing the results for NICER observation of PSR~J0030+0451

** Chaitanya Afle<sup>1</sup>, Patrick R. Miles<sup>1</sup>, Silvina Caino-Lores<sup>2</sup>, Collin D. Capano<sup>3,4</sup>, Ingo Tews<sup>5</sup>, Karan Vahi<sup>6</sup>, Duncan A. Brown<sup>1</sup>, Ewa Deelman<sup>6</sup>, Michela Taufer<sup>2</sup> 

**<sup>1</sup>Syracuse University**

**<sup>2</sup>University of Tennessee, Knoxville**

**<sup>3</sup>Max Planck Institiute for Gravitational Physics**

**<sup>4</sup>University of Massachusetts, Darthmouth**

**<sup>5</sup>Theoretical Division, Los Alamos National Laboratory**

**<sup>6</sup>University of Southern California**

## License

![Creative Commons License](https://i.creativecommons.org/l/by-sa/3.0/us/88x31.png "Creative Commons License")

This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 United States License](http://creativecommons.org/licenses/by-sa/3.0/us/).

## Abstract

NASA's Neutron Star Interior Composition Explorer (NICER) observed X-ray emission from the pulsar PSR J0030+0451 in 2018. Riley \textit{et al.} reported Bayesian parameter measurements of the mass and the radius of the star using pulse-profile modeling of the X-ray data. In this work we reproduce their result using the open-source software \textit{X-PSI} and the publicly available data. We find that we can reproduce the main result within expected statistical error. We note the challenges we faced in reproducing the results. Additionally, to check the robustness of the results, we modify the original analysis in two ways - by changing the prior distribution for the radius, and by changing the sampler configuration. We find that there is no significant change in measurement of the mass and radius because of either modification. We provide a containerized working environment that facilitates reproduction of the measurements of mass and radius of PSR J0030+0451 using the NICER observations.

## Summary of contents 

* `Dockerfile`: Dockerfile to create a Debian-based Docker container with working \textit{X-PSI} `v0.1` and PyCBC installation. Please read below for detailed instructions on how to create and use the Docker container using `Dockerfile`.

* `mpi.cfg`: Configuration file to point the `mpi4py` installer to the openmpi installation paths.

* `sugwg-openmpi-1.10.6.tar.gz`: tarball of the openmpi installation in the compute nodes of the `sugwg-condor` cluster. 

* `requirements.txt`: requirted dependencies for PyCBC v1.18.3 used for plotting (based on Python 2.7).

* `openmpiscript`: executable script to be launched via HT Condor while submitting the jobs on the `sugwg-condor` cluster.

* `sshd.sh`: companian script for `openmpiscript`.

* `.singularity.d/env/00-xpsi.sh`: script to activate Conda environment within the Docker container.

* `/plotting_scripts`: scripts to plots the posteriors using PyCBC Inference command `pycbc_plot_posteriors`
  * `create_hdf_files.py`: creates `.hdf` files from the output of the Bayesian sampler that can be read by PyCBC Inference.
  * `plot_posteriors.sh`: executing `pycbc_plot_posteriors` to generate the plots.

## Instructions to produce the posterior corner plot using PyCBC

1. Follow the instructions at https://pycbc.org/pycbc/latest/html/docker.html to launch a docker container with a working PyCBC installation:
   * `docker pull pycbc/pycbc-el8:latest`
   * `docker run -it pycbc/pycbc-el8:latest`

2. Get the Riley et al Zenodo files:
   * `wget https://zenodo.org/record/5506838/files/A_NICER_VIEW_OF_PSR_J0030p0451.tar.gz`
   * `tar -xzvf A_NICER_VIEW_OF_PSR_J0030p0451.tar.gz`

3. Get the files from Zenodo repository accompanying this article:
   * `wget <update_the_ZENODO_repository_here>`
   * `tar -xzvf nicer-reproducibility-zenodo.tar.gz`

4. Plot the posteriors:
   * `cd nicer-reproducibility-zenodo/plotting_scripts/`
   * `sh plot_posteriors.sh`
     This should produce two files (for the two models considered in this work): `ST_PST.png` and `ST_EST.png`. To produce a plot without the nlive = 4000 sampler configuration, delete `ST_PST_reanalysis_nlive4k.hdf:ST_PST_reanalysis_nlive4k` from line 8 of `plot_posteriors.sh` and rerun it. 

Once the files are produced, they can be copied out of the container by using the command (for `ST-PST.png` as an example) `docker cp <containername>:/opt/pycbc/nicer-reproducibility-zenodo/plotting_scripts/ST_PST.png /host/path/target`. Here, the `<containername>` can be obtained by using the command `docker ps -a`. 

## Instructions to run the j0030 analysis code as a job on sugwg-condor

The following instructions are intended to streamline the use of XPSI (https://xpsi-group.github.io/xpsi/index.html) via a Docker container.

1. Clone this repository using `git clone https://github.com/sugwg/nicer.git ~/<nicer_path>` where `<nicer_path>` is where you want to clone the repository. 

2. Change the working directory `cd ~/<nicer_path>`, replacing `<nicer_path>` with where you cloned the repository.

3. If you want to build the docker container using the `Dockerfile`:
   1. Use the command `id` to check if you are in the docker group on `sugwg-condor`.  
   2. Use the command `docker build --no-cache --tag chaitanyaafle/nicer:<tag> -f Dockerfile .` to build the container, where one needs to specify a unique tag replacing `<tag>` and the container identifier `chaitanyaafle/nicer` can be changed to anything in OSG's docker_images.txt here https://github.com/opensciencegrid/cvmfs-singularity-sync/blob/master/docker_images.txt.
   3. Push the new container to Docker Hub using `docker push chaitanyaafle/nicer:<tag>`. After waiting ~a day, this docker image should sync with CVMFS and a singularity container built from the image should become available for use. 

4. Once the container is synced, you can use it to submit the analysis jobs. For example, to submit jobs using the build `chaitanyaafle/nicer:8d3b23d`, which is already synced successfully in CVMFS, verify that the correct container identifier and tag are present in the arguments: `/cvmfs/singularity.opensciencegrid.org/chaitanyaafle/nicer:8d3b23d` in the submitfile `submit.sub`. 
   NOTE: The docker image `chaitanyaafle/nicer:8d3b23d` is the latest one that works, and can be used to submit `PSR j0030+0451` analysis jobs.

5. Output directory and logs
   1. Make a directory to store the output of the analysis:`mkdir <output_directory>`.
   2. Make a directory to store the logs of the job: `mkdir <log_directory>`.

6. Changes to be made in the submitfile `submit.sub`:
   1. On lines 3, 4, 6, 7, 8, and 18 replace `<home_dir>` with the path to your home directory, and `<nicer_path>` to where you cloned the repository.  
   2. To use an already-synced container, e.g. `chaitanyaafle/nicer:8d3b23d`, verify that the correct container identifier and tag are present in the arguments on line 4: `/cvmfs/singularity.opensciencegrid.org/chaitanyaafle/nicer:8d3b23d`.
   3. On line 10, give the appropriate argument for the number of machines to be used, eg. `machine_count = 2`.
   4. On line 11, give the appropriate argument for number of nodes per machine to be used, eg. `request_cpus = 40`.
   5. Replace `<log_directory>` with the correct path on lines 6, 7, and 8.

7. Changes to be made in the python script `run_j0030.py`:
   1. Replace `<nicer_path>` to its appropriate value in `/srv/<nicer_path>/`... on lines 19, 23, 24, 25, 28, 30, 114, and 154.
   2. In `runtime_params`, the value of the key `'outputfiles_basename'` (line 154) should be `/srv/<nicer_path>/<output_directory>/run1_nlive1000_eff0.3_noCONST_noMM_noIS_tol-1`, with the appropriate replacements for `<nicer_path>` and `<output_directory>`.

8. Changes to be made in the executable `run_j0030.sh`, assuming `nicer/` was cloned to `~/<nicer_path>`:
      1. Replace `<nicer_path>` to its appropriate value in `/srv/<nicer_path>/run_j0030.py`... on line 8

9. Provide the correct path to `sshd.sh` in line 92 in `openmpiscript`, replacing `<home_dir>/<nicer_path>` to its correct value.

10. Submit the condor job: `condor_submit submit.sub`


