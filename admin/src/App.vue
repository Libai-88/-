<template>
  <el-container class="admin-layout">
    <el-aside :width="sidebarWidth" class="admin-sidebar">
      <Sidebar />
    </el-aside>
    <el-container>
      <el-header class="admin-header">
        <el-icon class="collapse-btn" @click="toggleSidebar">
          <Fold v-if="!sidebarCollapsed" />
          <Expand v-else />
        </el-icon>
        <span class="header-title">{{ currentTitle }}</span>
      </el-header>
      <el-main class="admin-main">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useConfigStore } from '@/stores/config'
import Sidebar from '@/components/Sidebar.vue'

const route = useRoute()
const configStore = useConfigStore()

const sidebarCollapsed = computed(() => configStore.sidebarCollapsed)
const sidebarWidth = computed(() => sidebarCollapsed.value ? '64px' : '240px')
const currentTitle = computed(() => route.meta.title || 'Dashboard')

function toggleSidebar() {
  configStore.toggleSidebar()
}
</script>

<style scoped lang="scss">
.admin-layout {
  height: 100vh;
}

.admin-sidebar {
  background-color: var(--admin-bg-lighter);
  border-right: 1px solid var(--admin-border-color);
  transition: width 0.3s ease;
  overflow: hidden;
}

.admin-header {
  height: var(--header-height);
  background-color: var(--admin-bg-lighter);
  border-bottom: 1px solid var(--admin-border-color);
  display: flex;
  align-items: center;
  padding: 0 20px;
  gap: 12px;
}

.collapse-btn {
  font-size: 20px;
  cursor: pointer;
  color: var(--admin-text-secondary);
  transition: color 0.2s;

  &:hover {
    color: var(--admin-accent-color);
  }
}

.header-title {
  font-size: 16px;
  font-weight: 500;
  color: var(--admin-text-primary);
}

.admin-main {
  background-color: var(--admin-bg-color);
  padding: 24px;
  min-height: calc(100vh - var(--header-height));
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
