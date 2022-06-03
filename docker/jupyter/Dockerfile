# ----------------------------------------------------------------------
# JupyterLab Notebook for analyzing E3SM-ELM land model output
# ----------------------------------------------------------------------

#FROM jupyter/scipy-notebook:latest
#FROM jupyter/datascience-notebook:latest
#https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-scipy-notebook
FROM jupyter/scipy-notebook:lab-3.3.2
LABEL maintainer.name="Shawn P. Serbin" \
      maintainer.email="sserbin@bnl.gov" \
      author.name="Shawn P. Serbin" \
      author.email="sserbin@bnl.gov" \
      description="Jupyter-SciPy Container"

# install Python packages you often use
RUN set -ex \
   && conda install --quiet --yes \
   # choose the Python packages you need
   'plotly' \
   'folium' \
   'dask' \
   'pandas' \
#   'geopandas' \
   && conda install --quiet --yes -c conda-forge 'netCDF4' \
   && conda install --quiet --yes -c conda-forge 'h5py' \
   && conda install --quiet --yes -c conda-forge 'matplotlib' \
   && conda install --quiet --yes -c conda-forge 'mpi4py' \
   && conda install --quiet --yes -c conda-forge 'pyproj' \
   && conda install --quiet --yes -c conda-forge earthengine-api \
   && conda clean --all -f -y \
   && mamba install --quiet --yes 'geemap' 'localtileserver' -c conda-forge \
   && mamba clean --all -f -y \
   # install Jupyter Lab extensions you need
   && jupyter labextension install jupyterlab-plotly --no-build \
   && jupyter lab build -y \
   && jupyter lab clean -y \
   && rm -rf "/home/${NB_USER}/.cache/yarn" \
   && rm -rf "/home/${NB_USER}/.node-gyp" \
   && fix-permissions "${CONDA_DIR}" \
   && fix-permissions "/home/${NB_USER}"

#
# scripts and data folder
USER ${NB_UID}
#USER ${USER}
WORKDIR "${HOME}"

RUN cd $HOME \
    && mkdir -p scripts \
    && cd $HOME/scripts \
    && git -c http.sslVerify=false clone --single-branch --depth 1 https://github.com/fmyuan/elm-pf-tools.git

# EOF
