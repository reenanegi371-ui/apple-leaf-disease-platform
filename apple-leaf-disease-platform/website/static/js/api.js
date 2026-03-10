// API Service for LeafHealth AI Website

const API = {
    baseUrl: 'http://localhost:8000', // Update with your backend URL
    
    // Check API health
    async checkHealth() {
        try {
            const response = await fetch(`${this.baseUrl}/health`);
            return response.ok;
        } catch (error) {
            console.error('Health check failed:', error);
            return false;
        }
    },
    
    // Detect disease from image
    async detectDisease(imageFile) {
        const formData = new FormData();
        formData.append('file', imageFile);
        
        try {
            const response = await fetch(`${this.baseUrl}/detect`, {
                method: 'POST',
                body: formData
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            return await response.json();
        } catch (error) {
            console.error('Detection failed:', error);
            throw error;
        }
    },
    
    // Get disease information
    async getDiseaseInfo(diseaseName) {
        try {
            const response = await fetch(`${this.baseUrl}/disease-info/${encodeURIComponent(diseaseName)}`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            return await response.json();
        } catch (error) {
            console.error('Failed to get disease info:', error);
            throw error;
        }
    },
    
    // Get all diseases
    async getAllDiseases() {
        try {
            const response = await fetch(`${this.baseUrl}/all-diseases`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            return await response.json();
        } catch (error) {
            console.error('Failed to get diseases:', error);
            throw error;
        }
    },
    
    // Get class names
    async getClassNames() {
        try {
            const response = await fetch(`${this.baseUrl}/class-names`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            return await response.json();
        } catch (error) {
            console.error('Failed to get class names:', error);
            throw error;
        }
    },
    
    // Upload image with progress
    async uploadWithProgress(imageFile, onProgress) {
        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            
            xhr.upload.addEventListener('progress', (e) => {
                if (e.lengthComputable && onProgress) {
                    const percent = (e.loaded / e.total) * 100;
                    onProgress(percent);
                }
            });
            
            xhr.addEventListener('load', () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    resolve(JSON.parse(xhr.response));
                } else {
                    reject(new Error(`HTTP error! status: ${xhr.status}`));
                }
            });
            
            xhr.addEventListener('error', () => {
                reject(new Error('Network error'));
            });
            
            xhr.open('POST', `${this.baseUrl}/detect`);
            
            const formData = new FormData();
            formData.append('file', imageFile);
            xhr.send(formData);
        });
    }
};

// Export for use in other files
window.API = API;