# Heroku Buildpack Poppler

heroku-20 buildpack for poppler, based on [survantjames/heroku-buildpack-poppler](https://github.com/survantjames/heroku-buildpack-poppler) and [k16shikano/heroku-buildpack-poppler](https://github.com/k16shikano/heroku-buildpack-poppler)

heroku-20 needs a newer version of poppler to fix the following issue with PDFs from docusign
- https://bugs.launchpad.net/ubuntu/+source/poppler/+bug/1944453
- https://stackoverflow.com/questions/66636441/pdf2image-library-failing-to-read-pdf-signed-using-docusign/74313286

## Differences from [k16shikano/heroku-buildpack-poppler](https://github.com/k16shikano/heroku-buildpack-poppler) 
- We are building our own binaries from scratch, using the source code `tar.xz` from the official poppler site https://poppler.freedesktop.org/poppler-21.03.0.tar.xz.
- Due to a problem with the slug size going over the heroku limit of 500 MB, we are only packaging `pdftoppm` and its dependency so, since this is the only one used by Rails [PopplerPdfPreviewer](https://github.com/rails/rails/blob/8015c2c2cf5c8718449677570f372ceb01318a32/activestorage/lib/active_storage/previewer/poppler_pdf_previewer.rb)


## Rebuilding from source

The included `Dockerfile` installs all the necessary dependencies and builds poppler from source. Follow these steps to build the docker image and copy the tarball out.

```
docker build -t poppler-build .
docker create --platform=linux/amd64 --name poppler-build-container poppler-build
docker cp poppler-build-container:/poppler-21.03.0/build/poppler-21.03.0.tar.gz .
docker rm -f poppler-build-container
```
