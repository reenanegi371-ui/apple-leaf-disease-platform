// Camera functionality for LeafHealth AI Website

class CameraManager {
    constructor() {
        this.stream = null;
        this.videoElement = null;
        this.canvasElement = null;
    }
    
    // Initialize camera
    async initialize(videoElement, canvasElement) {
        this.videoElement = videoElement;
        this.canvasElement = canvasElement;
        
        try {
            this.stream = await navigator.mediaDevices.getUserMedia({
                video: {
                    facingMode: 'environment',
                    width: { ideal: 1280 },
                    height: { ideal: 720 }
                }
            });
            
            this.videoElement.srcObject = this.stream;
            await this.videoElement.play();
            
            return true;
        } catch (error) {
            console.error('Camera initialization failed:', error);
            throw error;
        }
    }
    
    // Capture photo
    capturePhoto() {
        if (!this.videoElement || !this.canvasElement) {
            throw new Error('Camera not initialized');
        }
        
        const context = this.canvasElement.getContext('2d');
        this.canvasElement.width = this.videoElement.videoWidth;
        this.canvasElement.height = this.videoElement.videoHeight;
        
        context.drawImage(
            this.videoElement,
            0, 0,
            this.canvasElement.width,
            this.canvasElement.height
        );
        
        return this.canvasElement.toDataURL('image/jpeg');
    }
    
    // Stop camera
    stop() {
        if (this.stream) {
            this.stream.getTracks().forEach(track => track.stop());
            this.stream = null;
        }
    }
    
    // Switch camera (front/back)
    async switchCamera() {
        this.stop();
        
        const currentFacingMode = this.videoElement?.srcObject?.getVideoTracks()[0]?.getSettings().facingMode;
        const newFacingMode = currentFacingMode === 'environment' ? 'user' : 'environment';
        
        try {
            this.stream = await navigator.mediaDevices.getUserMedia({
                video: {
                    facingMode: newFacingMode,
                    width: { ideal: 1280 },
                    height: { ideal: 720 }
                }
            });
            
            this.videoElement.srcObject = this.stream;
            await this.videoElement.play();
            
            return newFacingMode;
        } catch (error) {
            console.error('Failed to switch camera:', error);
            throw error;
        }
    }
    
    // Check if camera is supported
    static isSupported() {
        return !!(navigator.mediaDevices && navigator.mediaDevices.getUserMedia);
    }
    
    // Get available cameras
    static async getCameras() {
        if (!this.isSupported()) {
            return [];
        }
        
        try {
            const devices = await navigator.mediaDevices.enumerateDevices();
            return devices.filter(device => device.kind === 'videoinput');
        } catch (error) {
            console.error('Failed to get cameras:', error);
            return [];
        }
    }
}

// Camera UI Controller
class CameraUIController {
    constructor() {
        this.cameraManager = new CameraManager();
        this.modal = document.getElementById('camera-modal');
        this.video = document.getElementById('camera-feed');
        this.canvas = document.getElementById('camera-canvas');
        this.captureBtn = document.getElementById('capture-btn');
        this.closeBtn = document.querySelector('.close');
        this.switchBtn = document.getElementById('switch-camera-btn');
    }
    
    async open() {
        if (!this.modal || !this.video) return;
        
        this.modal.style.display = 'block';
        
        try {
            await this.cameraManager.initialize(this.video, this.canvas);
            this.setupEventListeners();
        } catch (error) {
            this.showError('Failed to access camera. Please check permissions.');
            console.error(error);
        }
    }
    
    close() {
        if (this.modal) {
            this.modal.style.display = 'none';
        }
        this.cameraManager.stop();
        this.removeEventListeners();
    }
    
    setupEventListeners() {
        if (this.captureBtn) {
            this.captureBtn.addEventListener('click', () => this.capture());
        }
        
        if (this.closeBtn) {
            this.closeBtn.addEventListener('click', () => this.close());
        }
        
        if (this.switchBtn) {
            this.switchBtn.addEventListener('click', () => this.switchCamera());
        }
        
        // Close on outside click
        window.addEventListener('click', (e) => {
            if (e.target === this.modal) {
                this.close();
            }
        });
    }
    
    removeEventListeners() {
        if (this.captureBtn) {
            this.captureBtn.removeEventListener('click', () => this.capture());
        }
        if (this.closeBtn) {
            this.closeBtn.removeEventListener('click', () => this.close());
        }
        if (this.switchBtn) {
            this.switchBtn.removeEventListener('click', () => this.switchCamera());
        }
    }
    
    capture() {
        const imageData = this.cameraManager.capturePhoto();
        this.close();
        
        // Trigger image preview
        const previewArea = document.getElementById('preview-area');
        const preview = document.getElementById('image-preview');
        
        if (previewArea && preview) {
            preview.src = imageData;
            previewArea.style.display = 'block';
            document.querySelector('.upload-options').style.display = 'none';
        }
        
        // Store image for upload
        window.capturedImage = imageData;
    }
    
    async switchCamera() {
        try {
            await this.cameraManager.switchCamera();
        } catch (error) {
            this.showError('Failed to switch camera');
        }
    }
    
    showError(message) {
        const errorDiv = document.createElement('div');
        errorDiv.className = 'error-alert';
        errorDiv.innerHTML = `
            <span class="error-icon">⚠️</span>
            <p>${message}</p>
        `;
        
        this.modal?.querySelector('.modal-body')?.appendChild(errorDiv);
        
        setTimeout(() => {
            errorDiv.remove();
        }, 3000);
    }
}

// Initialize camera when page loads
document.addEventListener('DOMContentLoaded', () => {
    window.cameraUI = new CameraUIController();
});

// Export for use in other files
window.CameraManager = CameraManager;
window.CameraUIController = CameraUIController;