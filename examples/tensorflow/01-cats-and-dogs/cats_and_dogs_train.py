#!/usr/bin/env python


# # Cats and dogs
#
# Transfer learning using mobilenetv2 and tensorflow
#

import os
import numpy as np
import matplotlib.pyplot as plt

import tensorflow_datasets as tfds
import tensorflow as tf
from tensorflow import keras

# enable the eager execution on tensorflow v1
tf.enable_eager_execution()

#
# ## Dataset
#
#
#


SPLIT_HEIGHTS = (8, 1, 1)
splits = tfds.Split.TRAIN.subsplit(weighted=SPLIT_HEIGHTS)

(raw_train, raw_validation, raw_test), metadata = tfds.load(
    'cats_vs_dogs', split=list(splits),
    with_info=True, as_supervised=True)

# ### Data transformations

# resize the dataset to 160x160
IMG_SIZE = 160


def format_example(image, label):
    image = tf.cast(image, tf.float32)
    image = (image / 127.0) - 1
    image = tf.image.resize(image, (IMG_SIZE, IMG_SIZE))
    return image, label


train = raw_train.map(format_example)
validation = raw_validation.map(format_example)
test = raw_validation.map(format_example)

BATCH_SIZE = 32
SUFFLE_BUFFER_SIZE = 1000

train_batches = train.shuffle(SUFFLE_BUFFER_SIZE).batch(BATCH_SIZE)
validation_batches = validation.shuffle(SUFFLE_BUFFER_SIZE).batch(BATCH_SIZE)
test_batches = test.shuffle(SUFFLE_BUFFER_SIZE).batch(BATCH_SIZE)

#
# ## Model
#

IMG_SHAPE = (IMG_SIZE, IMG_SIZE, 3)

base_model = tf.keras.applications.MobileNetV2(input_shape=IMG_SHAPE,
                                               include_top=False,
                                               weights='imagenet')
base_model.trainable = False


model = tf.keras.Sequential([
    base_model,
    keras.layers.GlobalAveragePooling2D(),
    keras.layers.Dense(1),
])

base_learning_rate = 0.0001
model.compile(optimizer=tf.keras.optimizers.RMSprop(lr=base_learning_rate),
              loss='binary_crossentropy',
              metrics=['accuracy'])

model.summary()

num_train, num_val, num_test = (
    metadata.splits['train'].num_examples*weight/10
    for weight in SPLIT_HEIGHTS)

initial_epochs = 10
steps_per_epoch = round(num_train)//BATCH_SIZE
validation_steps = 20

validation_batches = train.shuffle(SUFFLE_BUFFER_SIZE).batch(BATCH_SIZE)

loss, accuracy = model.evaluate(validation_batches, steps=validation_steps)
print("initial model performance:")
print("  loss: {:.2f}".format(loss))
print("  accuracy: {:.2f}".format(accuracy))

#
# Training
#

history = model.fit(train_batches,
                    epochs=initial_epochs)

loss, accuracy = model.evaluate(validation_batches, steps=validation_steps)
print("final model performance:")
print("  loss: {:.2f}".format(loss))
print("  accuracy: {:.2f}".format(accuracy))


#
# Model Saving
#

model.save('cats_and_dogs_model.h5')
