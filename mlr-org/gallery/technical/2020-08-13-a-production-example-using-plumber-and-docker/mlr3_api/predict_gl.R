library(data.table)
library(mlr3)
library(mlr3pipelines)

learner = readRDS("model.rds")

#* @get /health
function() {
  list(status = "ok")
}

#* @post /predict
#* @parser json
function(observations) {
  new_data = as.data.table(observations)
  prediction = learner$predict_newdata(new_data)
  list(predictions = prediction$response)
}
