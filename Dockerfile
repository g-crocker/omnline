FROM noronhadataops/noronha:latest

ENV TZ America/Sao_Paulo

RUN apt -y update \
 && apt -y install gnupg build-essential curl wget vim apt-transport-https \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

ADD requirements_linux.txt requirements.txt

RUN bash -c "source ${CONDA_HOME}/bin/activate ${CONDA_VENV} \
 && pip install -r requirements.txt \
 && rm -rf requirements.txt"

ADD notebooks ./notebooks
