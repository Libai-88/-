<template>
  <div class="dashboard">
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="24" :sm="12" :lg="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon total">
              <el-icon :size="24"><Document /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.totalPosts }}</div>
              <div class="stat-label">Total Posts</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :xs="24" :sm="12" :lg="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon published">
              <el-icon :size="24"><CircleCheck /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.publishedPosts }}</div>
              <div class="stat-label">Published</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :xs="24" :sm="12" :lg="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon draft">
              <el-icon :size="24"><EditPen /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.draftPosts }}</div>
              <div class="stat-label">Drafts</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :xs="24" :sm="12" :lg="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon ai">
              <el-icon :size="24"><Cpu /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.aiProvider || 'Not Set' }}</div>
              <div class="stat-label">AI Provider</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="content-row">
      <el-col :xs="24" :lg="12">
        <el-card class="recent-card">
          <template #header>
            <div class="card-header">
              <span>Recent Posts</span>
              <el-button text type="primary" @click="$router.push('/posts')">View All</el-button>
            </div>
          </template>
          <el-empty v-if="recentPosts.length === 0" description="No posts yet" />
          <div v-else class="post-list">
            <div v-for="post in recentPosts" :key="post.id" class="post-item">
              <div class="post-title">{{ post.title }}</div>
              <div class="post-meta">
                <el-tag :type="post.status === 'published' ? 'success' : 'info'" size="small">
                  {{ post.status }}
                </el-tag>
                <span>{{ formatDate(post.created_at) }}</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :xs="24" :lg="12">
        <el-card class="quick-card">
          <template #header>
            <span>Quick Actions</span>
          </template>
          <div class="quick-actions">
            <el-button type="primary" size="large" @click="$router.push('/posts')">
              <el-icon><Plus /></el-icon>
              New Post
            </el-button>
            <el-button type="success" size="large" @click="$router.push('/ai-config')">
              <el-icon><Setting /></el-icon>
              AI Settings
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { postsApi, aiConfigApi } from '@/api'

const stats = ref({
  totalPosts: 0,
  publishedPosts: 0,
  draftPosts: 0,
  aiProvider: null
})

const recentPosts = ref([])

async function loadStats() {
  try {
    const posts = await postsApi.getList({ limit: 5, offset: 0 })
    const postsList = posts.items || posts || []
    
    stats.value.totalPosts = postsList.length || posts.total || 0
    stats.value.publishedPosts = postsList.filter(p => p.status === 'published').length
    stats.value.draftPosts = postsList.filter(p => p.status === 'draft').length
    recentPosts.value = postsList.slice(0, 5)
  } catch (error) {
    ElMessage.warning('Could not load posts stats')
  }

  try {
    const config = await aiConfigApi.getConfig()
    stats.value.aiProvider = config.provider || 'Not Set'
  } catch {
    // AI config might not be set yet
  }
}

function formatDate(dateStr) {
  if (!dateStr) return ''
  return new Date(dateStr).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

onMounted(loadStats)
</script>

<style scoped lang="scss">
.dashboard {
  max-width: 1400px;
}

.stats-row {
  margin-bottom: 24px;
}

.stat-card {
  :deep(.el-card__body) {
    padding: 20px;
  }
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 16px;
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  
  &.total { background: rgba(124, 58, 237, 0.15); color: #7c3aed; }
  &.published { background: rgba(34, 197, 94, 0.15); color: #22c55e; }
  &.draft { background: rgba(234, 179, 8, 0.15); color: #eab308; }
  &.ai { background: rgba(59, 130, 246, 0.15); color: #3b82f6; }
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: var(--admin-text-primary);
}

.stat-label {
  font-size: 13px;
  color: var(--admin-text-secondary);
  margin-top: 2px;
}

.content-row {
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
}

.recent-card, .quick-card {
  height: 100%;
}

.post-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.post-item {
  padding: 12px;
  background: var(--admin-bg-color);
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s;
  
  &:hover {
    background: var(--admin-bg-hover);
  }
}

.post-title {
  font-size: 14px;
  font-weight: 500;
  color: var(--admin-text-primary);
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.post-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: var(--admin-text-secondary);
}

.quick-actions {
  display: flex;
  flex-direction: column;
  gap: 12px;
  
  .el-button {
    width: 100%;
    justify-content: flex-start;
  }
}
</style>
