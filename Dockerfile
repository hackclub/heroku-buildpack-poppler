FROM --platform=linux/amd64 heroku/heroku:20-build

SHELL ["/bin/bash", "-c"]

RUN wget https://poppler.freedesktop.org/poppler-21.03.0.tar.xz
RUN tar -xf poppler-21.03.0.tar.xz

RUN mkdir -p /poppler-21.03.0/build
WORKDIR /poppler-21.03.0/build
RUN git clone git://git.freedesktop.org/git/poppler/test

RUN apt-get -y update -qq

RUN apt -y install \
    libopenjp2-7-dev
    #libboost-dev \ # include other dependencies if slug size isn't a concern
    #libnss3-dev \
    #libopenjpip-dec-server \
    #libopenjp2-tools \
    #libgirepository1.0-dev \
    #libgtk-3-dev \
    #libopenjpip-server

RUN cmake -DTESTDATADIR=./test -DCMAKE_INSTALL_MANDIR:PATH=/usr/local/share/man ..
RUN make
RUN make install

RUN mkdir -p tmp/bin
RUN mkdir -p tmp/lib/pkgconfig

RUN cp /usr/local/bin/pdftoppm tmp/bin

# include other utilities if slug size isn't a concern
# RUN cp /usr/local/bin/{pdfattach,pdfdetach,pdffonts,pdfimages,pdfinfo,pdfseparate,pdftocairo,pdftohtml,pdftops,pdftotext,pdfunite} tmp/bin

# -P keeps symlinks
RUN cp -P /usr/local/lib/{libpoppler.so.108.0.0,libpoppler.so.108,libpoppler.so} tmp/lib

# include other shared objects if slug size isn't a concern
# RUN cp -P /usr/local/lib/{libpoppler-glib.so.8.19.0,libpoppler-glib.so.8,libpoppler-glib.so,libpoppler-cpp.so.0.9.0,libpoppler-cpp.so.0,libpoppler-cpp.so} tmp/lib

RUN cp /usr/local/lib/pkgconfig/{poppler.pc,poppler-glib.pc,poppler-cpp.pc} tmp/lib/pkgconfig

# Use metadata recommended by https://reproducible-builds.org/docs/archives/ for producing tarball with consistent checksum
# if contents haven't changed
RUN tar --sort=name \
        --mtime="2023-01-15 00:00Z" \
        --owner=0 --group=0 --numeric-owner \
        --pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime,delete=ctime \
        -czvf poppler-21.03.0.tar.gz -C tmp .