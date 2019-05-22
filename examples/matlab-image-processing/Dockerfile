FROM fedora:29

RUN dnf install -y octave octave-image pstoedit transfig

COPY src /workspace
ADD data.tar.xz /data
RUN mkdir /results

ENV DATASET=/data/seq320
ENV OUTPUT=/results
ENV SAVE_PROCESSED_IMAGES=false

WORKDIR /workspace

CMD ["octave", "-W", "main.m"]
