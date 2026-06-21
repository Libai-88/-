import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useConfigStore = defineStore('config', () => {
  const sidebarCollapsed = ref(false)
  const backendUrl = import.meta.env.VITE_BACKEND_URL || 'http://localhost:8000'

  function toggleSidebar() {
    sidebarCollapsed.value = !sidebarCollapsed.value
  }

  return { sidebarCollapsed, backendUrl, toggleSidebar }
})
