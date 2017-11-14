FROM python:2.7

ENV SERVICE_DIR="/opt/runfolder-service"

RUN mkdir -p $SERVICE_DIR
RUN git clone https://github.com/arteria-project/arteria-runfolder.git $SERVICE_DIR

COPY app.config $SERVICE_DIR/config/
RUN pip install -r $SERVICE_DIR/requirements/dev $SERVICE_DIR

EXPOSE 80
ENTRYPOINT ["sh", "-c", "exec runfolder-ws --configroot $SERVICE_DIR/config/ --port 80"]
