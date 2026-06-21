<template>
  <div class="sidebar-container">
    <div class="logo">
      <span class="logo-text">Kirameku</span>
    </div>
    
    <el-menu
      :default-active="activeMenu"
      :collapse="isCollapsed"
      :collapse-transition="false"
      router
      class="sidebar-menu"
      background-color="transparent"
      text-color="var(--admin-text-secondary)"
      active-text-color="var(--admin-accent-color)"
    >
      <el-menu-item index="/dashboard">
        <el-icon><Odometer /></el-icon>
        <template #title>Dashboard</template>
      </el-menu-item>
      
      <el-menu-item index="/posts">
        <el-icon><Document /></el-icon>
        <template #title>Posts</template>
      </el-menu-item>
      
      <el-menu-item index="/ai-config">
        <el-icon><Cpu /></el-icon>
        <template #title>AI Configuration</template>
      </el-menu-item>
    </el-menu>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useConfigStore } from '@/stores/config'

const route = useRoute()
const configStore = useConfigStore()

const activeMenu = computed(() => route.path)
const isCollapsed = computed(() => configStore.sidebarCollapsed)
</script>

<style scoped lang="scss">
.sidebar-container {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.logo {
  height: var(--header-height);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 16px;
  border-bottom: 1px solid var(--admin-border-color);
}

.logo-text {
  font-size: 18px;
  font-weight: 700;
  background: linear-gradient(135deg, var(--admin-accent-color), var(--admin-accent-hover));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: 1px;
}

.sidebar-menu {
  flex: 1;
  border-right: none !important;
  padding: 12px 8px;
}

:deep(.el-menu-item) {
  border-radius: 8px;
  margin-bottom: 4px;
  
  &.is-active {
    background-color: rgba(124, 58, 237, 0.15) !important;
  }
  
  &:hover {
    background-color: var(--admin-bg-hover) !important;
  }
}

:deep(.el-menu--collapse) {
  .el-menu-item {
    justify-content: center;
  }
}
</style>
