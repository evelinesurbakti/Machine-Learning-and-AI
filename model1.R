# model instantiation -----------------------------------------------
# set defaul flags
FLAGS = flags(
  flag_numeric("set1",100),
  flag_numeric("set2",100),
  flag_numeric("dropout",0.45)
)

# model definition
model = keras_model_sequential()%>%
  layer_dense(units =FLAGS$set1,
              activation ="relu",
              input_shape = V,
              name ="layer_1")%>%
  layer_dropout(rate=FLAGS$dropout)%>%
  layer_dense(units =FLAGS$set2,
              activation ="relu",
              name ="layer_2")%>%
  layer_dropout(rate=FLAGS$dropout)%>%
  layer_dense(units =ncol(y_train),activation ="softmax",
              name ="layer_out")%>%
  compile(loss ="categorical_crossentropy",
          metrics ="accuracy",
          optimizer =optimizer_sgd())

# model training
fit = model%>%
  fit(x =x_train,y =y_train,
      validation_data =list(x_val, y_val),
      epochs =100,
      batch_size = 64,
      verbose = 1,
      callbacks = callback_early_stopping(monitor = "val_accuracy", patience = 20)
  )

# store accuracy on test set for each run
score <- model %>% evaluate(
  x_test, y_test,
  verbose = 0
)
