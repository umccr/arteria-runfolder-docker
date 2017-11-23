FROM python:2.7

ENV SERVICE_DIR="/opt/runfolder-service"
ENV SERVICE_PORT=80

RUN mkdir -p $SERVICE_DIR
# RUN git clone https://github.com/arteria-project/arteria-runfolder.git $SERVICE_DIR
# use a custom service version that allows to save the runfolder state outside
# the actual runfolder, which is required if there is no write access to the runfolder
RUN git clone --branch state_folder https://github.com/umccr/arteria-runfolder.git  $SERVICE_DIR


COPY app.config $SERVICE_DIR/config/
RUN pip install -r $SERVICE_DIR/requirements/dev $SERVICE_DIR

EXPOSE $SERVICE_PORT
ENTRYPOINT ["sh", "-c", "exec runfolder-ws --configroot $SERVICE_DIR/config/ --port $SERVICE_PORT"]
