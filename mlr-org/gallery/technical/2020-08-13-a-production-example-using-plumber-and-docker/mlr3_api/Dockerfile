FROM rstudio/plumber

WORKDIR /app

RUN R -e 'pak::pak(c("mlr3", "mlr3pipelines"))'

COPY train_gl.R predict_gl.R ./
RUN Rscript train_gl.R

EXPOSE 8000

CMD ["predict_gl.R"]
