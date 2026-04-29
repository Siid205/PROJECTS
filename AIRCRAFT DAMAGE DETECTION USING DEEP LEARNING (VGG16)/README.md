#  Aircraft Damage Detection using Deep Learning (VGG16)

##  Overview
This project focuses on detecting aircraft surface damage (cracks and dents) using a deep learning-based image classification model. Transfer learning with VGG16 is used to efficiently extract features and classify damage types.

---

##  Key Features
- Detects aircraft damage (cracks vs dents)
- Uses pretrained VGG16 (ImageNet)
- Applies transfer learning for efficient training
- Implements data augmentation for better generalization

---

##  Tech Stack
- Python
- TensorFlow / Keras
- VGG16 (Transfer Learning)
- NumPy
- Matplotlib

---

##  Model Details
- Base Model: VGG16 (pretrained on ImageNet)
- Top layers replaced with custom Dense layers
- Convolutional layers frozen for feature extraction

---

##  Results
- Achieved **78% classification accuracy** on the test dataset

