FROM pytorch/pytorch:1.1.0-cuda10.0-cudnn7.5-runtime

WORKDIR /workspace

COPY requirements.txt /workspace

RUN pip install -r requirements.txt

RUN useradd --create-home deep

USER deep

COPY course-v3/nbs/dl1/ /workspace

EXPOSE 8888

CMD ["jupyter", "lab", "--ip", "0.0.0.0"]
