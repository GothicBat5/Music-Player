import tensorflow as tf
import numpy as np 

import matplotlib.pyplot as plt  

from tensorflow.keras.applications.mobilenet_v2 import MobileNetV2, preprocess_input, decode_predictions
from tensorflow.keras.preprocessing import image
from PIL import Image 

model = MobileNetV2(weights= 'imagenet')

img_path = 'sms.jpg' #image source
img = image.load_img(img_path, target_size = (224, 224))
img_array = image.img_to_array(img)
img_array = np.expand_dims(img_array, axis=0)
img_array = preprocess_input(img_array)

preds = model.predict(img_array)
decoded = decode_predictions(preds, top=3)[0]

plt.imshow(img)
plt.axis('off')
plt.title(f"Top Predictions: {decoded[0][1]} ({round(decoded[0][2]*100, 2)}%)")
plt.show()

print("\nTop 3 Predictions")
for i, (imagenetID, label, prob) in enumerate(decoded): 
    print(f"{i+1}.{label} ({round(prob*100, 2)}%)")


