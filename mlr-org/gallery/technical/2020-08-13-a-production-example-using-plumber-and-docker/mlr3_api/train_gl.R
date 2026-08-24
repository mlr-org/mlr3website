library(mlr3)
library(mlr3pipelines)

task_housing = tsk("boston_housing")
task_housing$select(c("crim", "tax", "town"))

graph = po("imputemedian") %>>%
  po("imputeoor") %>>%
  po("fixfactors") %>>%
  lrn("regr.rpart")

learner = as_learner(graph)
learner$train(task_housing)

saveRDS(learner, "model.rds")
