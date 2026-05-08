# Abstract

Apple cultivation is one of the most significant horticultural activities in India, particularly in the northern regions of Jammu & Kashmir, Himachal Pradesh, and Uttarakhand. However, apple orchards are frequently affected by a variety of leaf diseases—such as Apple Scab, Cedar Apple Rust, Black Rot, and powdery mildew—that cause substantial reductions in fruit yield and quality. Traditional methods of disease identification rely heavily on manual visual inspection by trained agronomists, which is time-consuming, subjective, and often impractical for large-scale orchards. Early and accurate detection of these diseases is therefore critical to enabling timely intervention and minimizing crop losses.

This project presents the **Apple Leaf Disease Detection Platform**, an end-to-end, AI-powered web application designed to automate the identification and classification of diseases in apple leaves using deep learning. The system leverages a **YOLOv8 (You Only Look Once)** object-detection model trained on a curated dataset of apple leaf images encompassing multiple disease categories as well as healthy leaf samples. The trained model is capable of detecting diseased regions within a leaf image, drawing bounding boxes around affected areas, and classifying each detection with a confidence score.

The platform follows a modular, client–server architecture:

- **Backend (FastAPI):** A high-performance REST API built with FastAPI that handles image upload, preprocessing, model inference using PyTorch, bounding-box annotation, and JSON-based response generation. The backend exposes endpoints for disease detection (`/detect`), disease information retrieval (`/disease-info`), and model metadata (`/class-names`, `/all-diseases`).

- **Frontend (Flask):** A responsive, user-friendly web interface built with Flask, HTML5, CSS3, and JavaScript. Users can upload or capture leaf images directly through the browser, submit them for analysis, and receive annotated results—including the detected disease name, confidence level, class-wise probability distribution, and recommended treatment measures.

- **Mobile App (Flutter):** An optional cross-platform mobile application that allows users to capture leaf images using their smartphone camera and interact with the backend API for on-the-go disease diagnosis.

The deep learning model was trained using transfer learning on a pre-trained YOLO architecture, fine-tuned on a dataset of labelled apple leaf images. Data augmentation techniques—including rotation, flipping, brightness adjustment, and scaling—were applied to improve model generalization. The final model achieves high accuracy and real-time inference speeds suitable for practical deployment.

Experimental results demonstrate that the platform can accurately detect and classify common apple leaf diseases with a high degree of precision and recall. The system provides not only a diagnosis but also comprehensive disease descriptions, symptoms, causes, and actionable treatment recommendations drawn from an integrated disease knowledge base.

The platform has been deployed for public access using **Render** (backend API) and **Vercel** (frontend), enabling users to interact with the system remotely without any local installation. The entire codebase is version-controlled and hosted on **GitHub** for reproducibility and collaboration.

In summary, this project contributes a practical, scalable, and accessible tool for precision agriculture that bridges the gap between advanced computer-vision research and real-world agricultural practice. By automating disease detection, the platform empowers farmers and agricultural extension workers to make informed decisions quickly, ultimately contributing to improved crop health and food security.

**Keywords:** Apple Leaf Disease Detection, Deep Learning, YOLOv8, Object Detection, FastAPI, Flask, Precision Agriculture, Computer Vision, Transfer Learning, Web Application.
