#!/bin/bash
set -euo pipefail

if [ ! -d "tempdir" ]; then
    mkdir tempdir
fi
if [ ! -d "tempdir/templates" ]; then
   mkdir tempdir/templates
fi
if [ ! -d "tempdir/static" ]; then
   mkdir tempdir/static
fi

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat > tempdir/Dockerfile << _EOF_
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
_EOF_

cd tempdir || exit
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a 
