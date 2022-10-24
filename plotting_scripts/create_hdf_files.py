#!usr/bin/env python

import numpy
from pycbc.inference import io

## ST+PST

# names of free parameters ordered as in sample files
columns = ['distance', 'mass', 'radius', 'cos_inclination',
           'p__super_colatitude', 'p__super_radius', 'p__super_temperature',
           's__super_colatitude', 's__super_radius', 's__omit_colatitude',
           's__omit_radius', 's__omit_azimuth', 's__super_temperature',
           'column_density',
           'alpha', 'beta', 'gamma',
           'p__phase_shift', 's__phase_shift'] 

### sugwg-analysis
# load as structured array
data = numpy.loadtxt('../j0030_analysis/output/run1_nlive1000_eff0.3_noCONST_noMM_noIS_tol-1post_equal_weights.dat', dtype=[(p, float) for p in columns])

# convert to dict
data = {p: data[p] for p in columns}

fp = io.loadfile('ST_PST_reanalysis.hdf', 'w', filetype='posterior_file')
fp.write_samples(data)
fp.attrs['static_params'] = []
fp.attrs['variable_params'] = list(data.keys())
fp.close()



### broader radius priors
# load as structured array
data = numpy.loadtxt('../j0030_analysis_broader_radius_priors/output/run1_nlive1000_eff0.3_noCONST_noMM_npost_equal_weights.dat', dtype=[(p, float) for p in columns])

# convert to dict
data = {p: data[p] for p in columns}

fp = io.loadfile('ST_PST_reanalysis_broader_radius_priors.hdf', 'w', filetype='posterior_file')
fp.write_samples(data)
fp.attrs['static_params'] = []
fp.attrs['variable_params'] = list(data.keys())
fp.close()



### N_live 4000
# load as structured array
data = numpy.loadtxt('../j0030_analysis_Nlive4000/output/run1_nlive1000_eff0.3_noCONST_noMM_noIS_tol-1post_equal_weights.dat', dtype=[(p, float) for p in columns])

# convert to dict
data = {p: data[p] for p in columns}

fp = io.loadfile('ST_PST_reanalysis_nlive4k.hdf', 'w', filetype='posterior_file')
fp.write_samples(data)
fp.attrs['static_params'] = []
fp.attrs['variable_params'] = list(data.keys())
fp.close()


## ST+EST model

# names of free parameters ordered as in sample files
columns = ['distance', 'mass', 'radius', 'cos_inclination',
           'p__super_colatitude', 'p__super_radius', 'p__super_temperature',
           's__super_colatitude', 's__super_radius', 's__omit_colatitude',
           's__omit_radius', 's__omit_azimuth', 's__super_temperature',
           'column_density',
           'alpha', 'beta', 'gamma',
           'p__phase_shift', 's__phase_shift'] 

### sugwg-analysis
# load as structured array
data = numpy.loadtxt('../j0030_analysis_ST_EST/output/run1_nlive1000_eff0.3_noCONST_noMM_noIS_tol-1post_equal_weights.dat', dtype=[(p, float) for p in columns])

# convert to dict
data = {p: data[p] for p in columns}

fp = io.loadfile('ST_EST_reanalysis.hdf', 'w', filetype='posterior_file')
fp.write_samples(data)
fp.attrs['static_params'] = []
fp.attrs['variable_params'] = list(data.keys())
fp.close()

# load as structured array
data = numpy.loadtxt('../j0030_analysis_ST_EST_broader_radius_priors/output/run1_nlive1000_eff0.3_noCONSTpost_equal_weights.dat', dtype=[(p, float) for p in columns])

# convert to dict
data = {p: data[p] for p in columns}

fp = io.loadfile('ST_EST_reanalysis_broader_radius_priors.hdf', 'w', filetype='posterior_file')
fp.write_samples(data)
fp.attrs['static_params'] = []
fp.attrs['variable_params'] = list(data.keys())
fp.close()





################### Following files are to compare sugwg analysis with zenodo repository
# ST+PST
# load as structured array
data = numpy.loadtxt('../data/A_NICER_VIEW_OF_PSR_J0030p0451/ST_PST/run1/run1_nlive1000_eff0.3_noCONST_noMM_noIS_tol-1post_equal_weights.dat', dtype=[(p, float) for p in columns])

# convert to dict
data = {p: data[p] for p in columns}

fp = io.loadfile('ST_PST_zenodo.hdf', 'w', filetype='posterior_file')
fp.write_samples(data)
fp.attrs['static_params'] = []
fp.attrs['variable_params'] = list(data.keys())
fp.close()


# ST+EST
# load as structured array
data = numpy.loadtxt('../data/A_NICER_VIEW_OF_PSR_J0030p0451/ST_EST/run1/run1_nlive1000_eff0.3_noCONST_noMM_IS_tol-1post_equal_weights.dat', dtype=[(p, float) for p in columns])

# convert to dict
data = {p: data[p] for p in columns}

fp = io.loadfile('ST_EST_zenodo.hdf', 'w', filetype='posterior_file')
fp.write_samples(data)
fp.attrs['static_params'] = []
fp.attrs['variable_params'] = list(data.keys())
fp.close()

