import axios from 'axios'

// Dynamically determine the API URL based on the current host
// This allows the frontend to work with localhost, IP addresses, or any domain
const getApiBaseUrl = () => {
  // If environment variable is set, use it
  if (import.meta.env.VITE_API_URL) {
    return import.meta.env.VITE_API_URL
  }
  
  // Otherwise, use the current host with port 8000
  // This works for localhost, 127.0.0.1, or any IP address
  const protocol = window.location.protocol // http: or https:
  const hostname = window.location.hostname // localhost, 127.0.0.1, or IP address
  return `${protocol}//${hostname}:8000/api`
}

const API_BASE_URL = getApiBaseUrl()

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

export default api
