`# Apple Leaf Disease Detection Platform

## Overview
This project is an end-to-end platform for detecting diseases in apple leaves using deep learning. It features:
- A FastAPI backend for model inference
- A Flask web frontend for user interaction
- A YOLO-based model for disease detection and bounding box annotation
- Mobile app and documentation support

## Features
- Upload or capture leaf images via web or mobile
- Automatic disease detection with bounding boxes
- Detailed disease information and treatment suggestions
- Modern, responsive UI
- Extensible backend for new models or diseases

## Project Structure
```
project_apple/
├── apple-leaf-disease-platform/
│   ├── backend/           # FastAPI backend, model inference, configs
│   ├── website/           # Flask frontend, static files, templates
│   ├── mobile_app/        # Flutter mobile app (optional)
│   ├── docs/              # Documentation, API docs, reports
│   ├── explaination/      # Project documentation
│   ├── requirements.txt   # Combined requirements for all components
│   ├── run_project.bat    # Windows batch script to start everything
│   ├── start.py           # Python script to launch backend & frontend
│   └── README.md          # Project overview (this file)
```

## Workflow
### 1. User Interaction
- User visits the web app (`/detect`) or uses the mobile app
- User uploads or captures a leaf image
- Image is previewed and submitted for analysis

### 2. Frontend to Backend
- Flask frontend receives the image and sends it to the FastAPI backend `/detect` endpoint
- Mobile app can also POST images to the backend API

### 3. Model Inference
- FastAPI backend loads the YOLO model (`backend/models/best.pt`)
- Image is processed and passed through the model
- Model returns detected disease class, confidence, and bounding boxes
- Backend draws bounding boxes and encodes the annotated image as base64

### 4. Results Display
- Backend responds with JSON including disease, confidence, probabilities, and annotated image
- Frontend displays the annotated image, diagnosis, and treatment info
- User can view detailed disease info or try another image

## How to Run
1. **Clone the repository**
2. **Create and activate the virtual environment**
   ```
   python -m venv apple
   apple\Scripts\activate  # On Windows
   ```
3. **Install all requirements**
   ```
   pip install -r requirements.txt
   ```
4. **Start the project**
   ```
   .\run_project.bat
   ```
5. **Access the app**
   - Web: [http://127.0.0.1:5000/detect](http://127.0.0.1:5000/detect)
   - API: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

## Backend API Endpoints
- `POST /detect` — Detect disease from uploaded image
- `GET /disease-info/{disease_name}` — Get info for a specific disease
- `GET /all-diseases` — List all diseases and info
- `GET /class-names` — List all model classes
- `GET /health` — Health check

## Model
- YOLOv8 or compatible PyTorch model (`backend/models/best.pt`)
- Supports bounding box detection and classification

## Customization
- Add new diseases/classes in `backend/config.py`
- Replace model file for improved accuracy
- Update frontend UI in `website/templates/` and `website/static/css/`

## Documentation
- See `docs/` and `explaination/` for detailed reports, API docs, and user manual

## Credits
- Developed as a college project for apple disease detection
- Uses open-source libraries: FastAPI, Flask, YOLO, Torch, etc.

---
For any issues or contributions, please open an issue or pull request.
