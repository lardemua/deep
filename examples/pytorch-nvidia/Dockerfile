FROM pytorch/pytorch:1.1.0-cuda10.0-cudnn7.5-runtime

RUN conda install -y jupyterlab opencv && \
    conda install -y -c fastai fastai

RUN useradd --create-home deep

USER deep

EXPOSE 8888

CMD ["jupyter", "lab", "--ip", "0.0.0.0"]
