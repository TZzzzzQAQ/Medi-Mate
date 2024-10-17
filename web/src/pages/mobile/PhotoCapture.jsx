import React, { useState, useRef, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import Webcam from 'react-webcam';
import axios from 'axios';
import { Camera, Clipboard } from 'lucide-react';
import { APP_API_URL } from '@/../config.js';

const PhotoCapture = () => {
  const [showCamera, setShowCamera] = useState(false);
  const [capturedImage, setCapturedImage] = useState(null);
  const [uploading, setUploading] = useState(false);
  const [uploadStatus, setUploadStatus] = useState(null);
  const webcamRef = useRef(null);
  const navigate = useNavigate();

  const handleCapture = useCallback(() => {
    const imageSrc = webcamRef.current.getScreenshot();
    fetch(imageSrc)
      .then(res => res.blob())
      .then(blob => {
        setCapturedImage(blob);
        setShowCamera(false);
      });
  }, []);

  const handleRetake = () => {
    setCapturedImage(null);
    setUploadStatus(null);
    setShowCamera(true);
  };

  const uploadImage = async (imageBlob) => {
    const formData = new FormData();
    formData.append('file', imageBlob, 'image.jpg');

    try {
      const response = await axios.post(`${APP_API_URL}/message/image`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      console.log('Upload successful:', response.data);
      return response.data;
    } catch (error) {
      console.error('Upload error:', error);
      if (error.response) {
        throw new Error(`Upload failed: ${error.response.data.message || JSON.stringify(error.response.data) || 'Unknown error'}`);
      } else if (error.request) {
        throw new Error('No response from server, please try again later');
      } else {
        throw new Error(`Request setup error: ${error.message}`);
      }
    }
  };

  const handleUpload = async () => {
    setUploading(true);
    setUploadStatus(null);

    try {
      console.log('Starting image upload...');
      const response = await uploadImage(capturedImage);
      console.log('Upload successful, response:', response);
      setUploadStatus('Upload successful');
      
      console.log('Preparing to navigate...');
      // Add a small delay before navigation to ensure state updates are processed
      setTimeout(() => {
        console.log('Attempting to navigate to result page...');
        navigate('result', { 
          state: { productData: response.data.records },
          replace: true // Use replace to avoid issues with back navigation
        });
        console.log('Navigation function called');
      }, 100);
    } catch (error) {
      console.error('Error during upload:', error);
      setUploadStatus(`Upload failed: ${error.message}`);
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100 p-4">
      <div className="w-full max-w-md">
        {showCamera ? (
          <div className="relative w-full aspect-square mb-4">
            <Webcam
              audio={false}
              ref={webcamRef}
              screenshotFormat="image/jpeg"
              className="rounded-xl w-full h-full object-cover"
            />
            <button
              onClick={handleCapture}
              className="absolute bottom-4 left-1/2 transform -translate-x-1/2 bg-white text-gray-800 font-bold px-4 py-2 rounded-full shadow-md text-sm"
            >
              Take Photo
            </button>
          </div>
        ) : capturedImage ? (
          <div className="relative w-full aspect-square mb-4">
            <img 
              src={URL.createObjectURL(capturedImage)} 
              alt="Captured" 
              className="rounded-xl w-full h-full object-cover" 
            />
            <div className="absolute bottom-4 left-1/2 transform -translate-x-1/2 flex space-x-2">
              <button
                onClick={handleRetake}
                className="bg-white text-gray-800 font-bold px-4 py-2 rounded-full shadow-md text-sm"
              >
                Retake
              </button>
              <button
                onClick={handleUpload}
                disabled={uploading}
                className="bg-blue-500 text-white font-bold px-4 py-2 rounded-full shadow-md text-sm disabled:bg-gray-400"
              >
                {uploading ? 'Uploading...' : 'Upload'}
              </button>
            </div>
          </div>
        ) : (
          <div className="grid grid-cols-2 gap-4">
            <button
              onClick={() => setShowCamera(true)}
              className="aspect-square bg-white text-gray-800 font-bold text-lg rounded-xl shadow-md focus:outline-none focus:ring-2 focus:ring-gray-300 transition duration-300 ease-in-out transform hover:scale-105 hover:bg-gray-50 flex flex-col items-center justify-center"
            >
              <Camera className="w-1/2 h-1/2 mb-2" />
              <span>Open Camera</span>
            </button>
            <button className="aspect-square bg-white text-gray-800 font-bold text-lg rounded-xl shadow-md focus:outline-none focus:ring-2 focus:ring-gray-300 transition duration-300 ease-in-out transform hover:scale-105 hover:bg-gray-50 flex flex-col items-center justify-center">
              <Clipboard className="w-1/2 h-1/2 mb-2" />
              <span>Record</span>
            </button>
          </div>
        )}
        {uploadStatus && (
        <div className={`mt-4 p-2 rounded ${uploadStatus.includes('successful') ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
          {uploadStatus}
          {uploadStatus.includes('successful') && (
            <p className="mt-2 text-sm">Redirecting to results page...</p>
          )}
        </div>
      )}
          </div>
      </  div> 
  );
};
          

export default PhotoCapture;
