from logging import info

import tensorflow as tf
from tensorflow import keras
import numpy as np
import matplotlib.pyplot as plt

tf.enable_v2_behavior()

## Dataset Loading
(x_train, y_train), (x_test, y_test) = keras.datasets.mnist.load_data()

def normalize(x):
    return (x / 255 - 0.1307) / 0.381

x_train = normalize(x_train).reshape(-1, 28, 28, 1)
x_test = normalize(x_test).reshape(-1, 28, 28, 1)

## Model

from tensorflow.keras.layers import (
    Conv2D, MaxPool2D, Input,
    BatchNormalization, GlobalAveragePooling2D,
    Dense, Flatten)

model = keras.Sequential([
    Input(shape=(28, 28, 1)),
    Conv2D(filters=32, kernel_size=5, padding='same', activation='relu'),
    Conv2D(filters=64, kernel_size=5, padding='same', activation='relu'),
    BatchNormalization(),
    MaxPool2D(pool_size=2, strides=2, padding='same'),
    Conv2D(filters=32, kernel_size=5, padding='same', activation='relu'),
    BatchNormalization(),
    MaxPool2D(pool_size=2, strides=2, padding='same'),
    Conv2D(filters=32, kernel_size=5, padding='same', activation='relu'),
    BatchNormalization(),
    GlobalAveragePooling2D(),
    Flatten(),
    Dense(10, activation='softmax'),
])

info("preparing the model")

model.summary()

## Dataset preparation with tf.data
AUTOTUNE = tf.data.experimental.AUTOTUNE

print(x_test.shape)

train = tf.data.Dataset \
            .from_tensor_slices((x_train, y_train)) \
            .shuffle(20000) \
            .batch(200) \
            .prefetch(AUTOTUNE)

validation = tf.data.Dataset \
            .from_tensor_slices((x_test, y_test)) \
            .batch(200)

## start training
model.compile(loss='sparse_categorical_crossentropy',
              optimizer='adam',
              metrics=['accuracy'])

model.fit(train, epochs=20, validation_data=validation)
