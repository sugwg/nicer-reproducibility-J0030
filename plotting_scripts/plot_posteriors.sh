#!/bin/sh

# Create pycbc-readable .hdf posterior files  
# python pycbc_plot_posterior.py


# plot posterior comparison for ST+PST: original analysis vs reanalysis vs broader radius prior vs nlive=4k
pycbc_inference_plot_posterior --verbose \
        --input-file ST_PST_zenodo.hdf:ST_PST_Riley_et_al ST_PST_reanalysis.hdf:ST_PST_reanalysis ST_PST_reanalysis_broader_radius_priors.hdf:ST_PST_reanalysis_broader_radius_priors ST_PST_reanalysis_nlive4k.hdf:ST_PST_reanalysis_nlive4k\
        --output-file ST_PST.png \
        --contour-color black \
        --plot-contours \
        --contour-percentiles 68.3 95.4 99.7 \
        --max-kde-samples 5000 \
        --plot-marginal \
        --marginal-percentiles 16 50 84 \
	--maxs radius:16.0 compactness:0.2 mass:2.0 \
        --mins radius:7.5 compactness:0.1125 mass:1.0 \
        --parameters 'radius:$R_{\mathrm{eq}}\;\mathrm{[km]}$' '1.4771*mass/radius:$M/R_{\mathrm{eq}}$' 'mass:$M\;\mathrm{[M}_{\odot}\mathrm{]}$'

cp ST_PST.png ~/secure_html/nicer/posteriors/

# plot posterior comparison for ST+EST: original analysis vs reanalysis vs broader radius prior
pycbc_inference_plot_posterior --verbose \
        --input-file ST_EST_zenodo.hdf:ST_EST_Riley_et_al ST_EST_reanalysis.hdf:ST_EST_reanalysis ST_EST_reanalysis_broader_radius_priors.hdf:ST_EST_reanalysis_broader_radius_priors \
        --output-file ST_EST.png \
        --contour-color black \
        --plot-contours \
        --contour-percentiles 68.3 95.4 99.7 \
        --max-kde-samples 5000 \
        --plot-marginal \
        --marginal-percentiles 16 50 84 \
	--maxs radius:18.0 compactness:0.2 mass:2.0 \
        --mins radius:7.5 compactness:0.1125 mass:1.0 \
        --parameters 'radius:$R_{\mathrm{eq}}\;\mathrm{[km]}$' '1.4771*mass/radius:$M/R_{\mathrm{eq}}$' 'mass:$M\;\mathrm{[M}_{\odot}\mathrm{]}$'

cp ST_EST.png ~/secure_html/nicer/posteriors/




## plot posterior comparison for ST+PST: original analysis vs reanalysis
#pycbc_inference_plot_posterior --verbose \
#        --input-file ST_PST_zenodo.hdf:ST_PST_Riley_et_al ST_PST_reanalysis.hdf:ST_PST_reanalysis \
#        --output-file ST_PST_comparison.png \
#        --contour-color black \
#        --plot-contours \
#        --contour-percentiles 68.3 95.4 99.7 \
#        --max-kde-samples 5000 \
#        --plot-marginal \
#        --marginal-percentiles 16 50 84 \
#	--maxs radius:16.0 compactness:0.2 mass:2.0 \
#        --mins radius:7.5 compactness:0.1125 mass:1.0 \
#        --parameters 'radius:$R_{\mathrm{eq}}\;\mathrm{[km]}$' '1.4771*mass/radius:$M/R_{\mathrm{eq}}$' 'mass:$M\;\mathrm{[M}_{\odot}\mathrm{]}$'
#
#cp ST_PST_comparison.png ~/secure_html/nicer/posteriors/
#
#
## plot posterior comparison for ST+PST: original analysis vs reanalysis with broader radius priors
#pycbc_inference_plot_posterior --verbose \
#        --input-file ST_PST_zenodo.hdf:ST_PST_Riley_et_al ST_PST_reanalysis_broader_radius_priors.hdf:ST_PST_reanalysis_broader_radius_priors \
#        --output-file ST_PST_broader_radius_priors_comparison.png \
#        --contour-color black \
#        --plot-contours \
#        --contour-percentiles 68.3 95.4 99.7 \
#        --max-kde-samples 5000 \
#        --plot-marginal \
#        --marginal-percentiles 16 50 84 \
#	--maxs radius:16.0 compactness:0.2 mass:2.0 \
#        --mins radius:7.5 compactness:0.1125 mass:1.0 \
#        --parameters 'radius:$R_{\mathrm{eq}}\;\mathrm{[km]}$' '1.4771*mass/radius:$M/R_{\mathrm{eq}}$' 'mass:$M\;\mathrm{[M}_{\odot}\mathrm{]}$'
#
#cp ST_PST_broader_radius_priors_comparison.png ~/secure_html/nicer/posteriors/
#
#
## plot posterior comparison for ST+PST: original analysis vs reanalysis with nlive = 4000
#pycbc_inference_plot_posterior --verbose \
#        --input-file ST_PST_zenodo.hdf:ST_PST_Riley_et_al ST_PST_reanalysis_nlive4k.hdf:ST_PST_reanalysis_nlive4k \
#        --output-file ST_PST_nlive4k_comparison.png \
#        --contour-color black \
#        --plot-contours \
#        --contour-percentiles 68.3 95.4 99.7 \
#        --max-kde-samples 5000 \
#        --plot-marginal \
#        --marginal-percentiles 16 50 84 \
#	--maxs radius:16.0 compactness:0.2 mass:2.0 \
#        --mins radius:7.5 compactness:0.1125 mass:1.0 \
#        --parameters 'radius:$R_{\mathrm{eq}}\;\mathrm{[km]}$' '1.4771*mass/radius:$M/R_{\mathrm{eq}}$' 'mass:$M\;\mathrm{[M}_{\odot}\mathrm{]}$'
#
#cp ST_PST_nlive4k_comparison.png ~/secure_html/nicer/posteriors/
#
#
## plot posterior comparison for ST+EST: original analysis vs reanalysis
#pycbc_inference_plot_posterior --verbose \
#        --input-file ST_EST_zenodo.hdf:ST_EST_Riley_et_al ST_EST_reanalysis.hdf:ST_EST_reanalysis \
#        --output-file ST_EST_comparison.png \
#        --contour-color black \
#        --plot-contours \
#        --contour-percentiles 68.3 95.4 99.7 \
#        --max-kde-samples 5000 \
#        --plot-marginal \
#        --marginal-percentiles 16 50 84 \
#	--maxs radius:16.0 compactness:0.2 mass:2.0 \
#        --mins radius:7.5 compactness:0.1125 mass:1.0 \
#        --parameters 'radius:$R_{\mathrm{eq}}\;\mathrm{[km]}$' '1.4771*mass/radius:$M/R_{\mathrm{eq}}$' 'mass:$M\;\mathrm{[M}_{\odot}\mathrm{]}$'
#
#cp ST_EST_comparison.png ~/secure_html/nicer/posteriors/
#
#
## plot posterior comparison for ST+EST: original analysis vs reanalysis with broader radius priors
#pycbc_inference_plot_posterior --verbose \
#        --input-file ST_EST_zenodo.hdf:ST_EST_Riley_et_al ST_EST_reanalysis_broader_radius_priors.hdf:ST_EST_reanalysis_broader_radius_priors \
#        --output-file ST_EST_broader_radius_priors_comparison.png \
#        --contour-color black \
#        --plot-contours \
#        --contour-percentiles 68.3 95.4 99.7 \
#        --max-kde-samples 5000 \
#        --plot-marginal \
#        --marginal-percentiles 16 50 84 \
#	--maxs radius:18.0 compactness:0.2 mass:2.0 \
#        --mins radius:7.5 compactness:0.1125 mass:1.0 \
#        --parameters 'radius:$R_{\mathrm{eq}}\;\mathrm{[km]}$' '1.4771*mass/radius:$M/R_{\mathrm{eq}}$' 'mass:$M\;\mathrm{[M}_{\odot}\mathrm{]}$'
#
#cp ST_EST_broader_radius_priors_comparison.png ~/secure_html/nicer/posteriors/
