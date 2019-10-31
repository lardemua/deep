#!/usr/bin/env python
from math import ceil

from argparse import ArgumentParser

from tabulate import tabulate
from PIL import Image
import numpy as np

import tensorflow as tf
from tensorflow import keras

tf.enable_eager_execution()

parser = ArgumentParser()
parser.add_argument('images', nargs='+',
                    help='the images of the dogs and cats to be classified')

parser.add_argument('--model',
                    help='the path of the model')

args = parser.parse_args()

print("loading the model...")
model = keras.models.load_model(args.model)

IMG_SIZE=160
BATCH_SIZE=4

def process_image(image):
    image = np.array(Image.open(image))
    image = tf.cast(image, tf.float32)
    image = (image/127.5) - 1
    image = tf.image.resize(image, (IMG_SIZE, IMG_SIZE))
    return image

images = tf.stack([ process_image(image) for image in args.images ])

predictions = model.predict(images, steps=1).flatten()

def which_animal(prediction):
    if prediction > 0:
        return 'dog'
    else:
        return 'cat'

import math

def sigmoid(x):
    return 1 / (1 + math.exp(-x))
    
results = [
    { 'image': image, 'prediction': sigmoid(prediction), 'animal': which_animal(prediction) }
    for image, prediction in  zip(args.images, predictions)
]

print(tabulate(results, headers='keys'))
