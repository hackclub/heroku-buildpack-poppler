# Heroku Buildpack Poppler

heroku-20 buildpack for poppler, based on [survantjames/heroku-buildpack-poppler](https://github.com/survantjames/heroku-buildpack-poppler) and [k16shikano/heroku-buildpack-poppler](https://github.com/k16shikano/heroku-buildpack-poppler)

heroku-20 needs a newer version of poppler to fix the following issue with PDFs from docusign
- https://bugs.launchpad.net/ubuntu/+source/poppler/+bug/1944453
- https://stackoverflow.com/questions/66636441/pdf2image-library-failing-to-read-pdf-signed-using-docusign/74313286

The only difference in this fork from [k16shikano/heroku-buildpack-poppler](https://github.com/k16shikano/heroku-buildpack-poppler) is we are using a `tar.xz` that matches the published release from the official poppler site https://poppler.freedesktop.org/poppler-21.03.0.tar.xz (md5 641a9f382c4166d5728f1f28f163de58).
