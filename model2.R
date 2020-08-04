#
#======== Homework 3 - model configuration
#

# model instantiation -----------------------------------------------
# set defaul flags
FLAGS <- flags(
  flag_numeric("dropout_1", 0.4),
  flag_numeric("dropout_2", 0.4),
  flag_integer("size_1", 10),
  flag_integer("size_2", 10),
  flag_string("optimizer", "sgd")
)

# model configuration
model <- keras_model_sequential() %>%
  layer_dense(units = FLAGS$size_1, input_shape = ncol(x_train),
              activation = "relu", name = "layer_1") %>%
  layer_dropout(rate = FLAGS$dropout_1) %>%
  layer_dense(units = FLAGS$size_2, activation = "relu", name = "layer_2") %>%
  layer_dropout(rate = FLAGS$dropout_2) %>%
  layer_dense(units = ncol(y_train), activation = "softmax", name = "layer_out") %>%
  compile(loss = "categorical_crossentropy", metrics = "accuracy",
          optimizer = switch(FLAGS$optimizer,
                             sgd = optimizer_sgd(),
                             rmsprop = optimizer_rmsprop(),
                             adam = optimizer_adam()
          )
  )

fit <- model %>% fit(
  x = x_train, y = y_train,
  validation_data = list(x_val, y_val),
  epochs = 100,
  batch_size = bs,
  verbose = 1,
  callbacks = callback_early_stopping(monitor = "val_accuracy", patience = 10)
)

# store accuracy on test set for each run
score <- model %>% evaluate(
  x_test, y_test,
  verbose = 0
)
