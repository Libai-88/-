import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// Request interceptor
api.interceptors.request.use(
  config => config,
  error => Promise.reject(error)
)

// Response interceptor
api.interceptors.response.use(
  response => response.data,
  error => {
    const message = error.response?.data?.detail || error.message || 'Unknown error'
    return Promise.reject(new Error(message))
  }
)

// Posts API
export const postsApi = {
  getList: (params) => api.get('/posts', { params }),
  getById: (id) => api.get(`/posts/${id}`),
  create: (data) => api.post('/posts', data),
  update: (id, data) => api.put(`/posts/${id}`, data),
  delete: (id) => api.delete(`/posts/${id}`)
}

// AI Config API
export const aiConfigApi = {
  getConfig: () => api.get('/ai/config'),
  saveConfig: (data) => api.put('/ai/config', data),
  testConnection: (data) => api.post('/ai/config/test', data)
}

// Stats API
export const statsApi = {
  getDashboard: () => api.get('/stats/dashboard')
}

export default api
