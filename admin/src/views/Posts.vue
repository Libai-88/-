<template>
  <div class="posts-page">
    <div class="page-header">
      <h2>Posts Management</h2>
      <el-button type="primary" @click="openDialog()">
        <el-icon><Plus /></el-icon>
        New Post
      </el-button>
    </div>

    <!-- Search and Filter -->
    <el-card class="filter-card">
      <el-form :inline="true" :model="queryParams">
        <el-form-item label="Search">
          <el-input
            v-model="queryParams.keyword"
            placeholder="Search by title..."
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item label="Status">
          <el-select v-model="queryParams.status" placeholder="All" clearable>
            <el-option label="All" value="" />
            <el-option label="Published" value="published" />
            <el-option label="Draft" value="draft" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            Search
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- Posts Table -->
    <el-card class="table-card">
      <el-table
        :data="posts"
        v-loading="loading"
        stripe
        style="width: 100%"
        row-key="id"
      >
        <el-table-column prop="id" label="ID" width="70" />
        <el-table-column prop="title" label="Title" min-width="200">
          <template #default="{ row }">
            <span class="title-cell">{{ row.title }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="Status" width="120">
          <template #default="{ row }">
            <el-tag :type="row.status === 'published' ? 'success' : 'info'">
              {{ row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="Created" width="160">
          <template #default="{ row }">
            {{ formatDate(row.created_at) }}
          </template>
        </el-table-column>
        <el-table-column prop="updated_at" label="Updated" width="160">
          <template #default="{ row }">
            {{ formatDate(row.updated_at) }}
          </template>
        </el-table-column>
        <el-table-column label="Actions" width="180" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="openDialog(row)">
              Edit
            </el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">
              Delete
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.pageSize"
          :total="pagination.total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next"
          @size-change="loadPosts"
          @current-change="loadPosts"
        />
      </div>
    </el-card>

    <!-- Edit/Create Dialog -->
    <el-dialog
      v-model="dialogVisible"
      :title="editingPost ? 'Edit Post' : 'New Post'"
      width="720px"
      destroy-on-close
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="Title" prop="title">
          <el-input v-model="formData.title" placeholder="Enter post title" />
        </el-form-item>
        <el-form-item label="Slug" prop="slug">
          <el-input v-model="formData.slug" placeholder="url-friendly-slug" />
        </el-form-item>
        <el-form-item label="Status" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio-button label="draft">Draft</el-radio-button>
            <el-radio-button label="published">Published</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="Content" prop="content">
          <el-input
            v-model="formData.content"
            type="textarea"
            :rows="12"
            placeholder="Write your post content here (Markdown supported)"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitting">
          {{ editingPost ? 'Update' : 'Create' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { postsApi } from '@/api'

const loading = ref(false)
const submitting = ref(false)
const posts = ref([])
const dialogVisible = ref(false)
const editingPost = ref(null)
const formRef = ref(null)

const queryParams = reactive({
  keyword: '',
  status: ''
})

const pagination = reactive({
  page: 1,
  pageSize: 10,
  total: 0
})

const formData = reactive({
  title: '',
  slug: '',
  status: 'draft',
  content: ''
})

const formRules = {
  title: [{ required: true, message: 'Title is required', trigger: 'blur' }],
  content: [{ required: true, message: 'Content is required', trigger: 'blur' }]
}

async function loadPosts() {
  loading.value = true
  try {
    const params = {
      offset: (pagination.page - 1) * pagination.pageSize,
      limit: pagination.pageSize
    }
    if (queryParams.keyword) params.keyword = queryParams.keyword
    if (queryParams.status) params.status = queryParams.status

    const data = await postsApi.getList(params)
    const items = data.items || data || []
    posts.value = items
    pagination.total = data.total || items.length
  } catch (error) {
    ElMessage.error('Failed to load posts: ' + error.message)
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  pagination.page = 1
  loadPosts()
}

function openDialog(post = null) {
  editingPost.value = post
  if (post) {
    Object.assign(formData, {
      title: post.title || '',
      slug: post.slug || '',
      status: post.status || 'draft',
      content: post.content || ''
    })
  } else {
    Object.assign(formData, {
      title: '',
      slug: '',
      status: 'draft',
      content: ''
    })
  }
  dialogVisible.value = true
}

async function handleSubmit() {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    submitting.value = true
    try {
      if (editingPost.value) {
        await postsApi.update(editingPost.value.id, { ...formData })
        ElMessage.success('Post updated successfully')
      } else {
        await postsApi.create({ ...formData })
        ElMessage.success('Post created successfully')
      }
      dialogVisible.value = false
      loadPosts()
    } catch (error) {
      ElMessage.error('Operation failed: ' + error.message)
    } finally {
      submitting.value = false
    }
  })
}

async function handleDelete(post) {
  try {
    await ElMessageBox.confirm(
      `Are you sure you want to delete "${post.title}"?`,
      'Delete Post',
      { type: 'warning' }
    )
    await postsApi.delete(post.id)
    ElMessage.success('Post deleted successfully')
    loadPosts()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('Delete failed: ' + error.message)
    }
  }
}

function formatDate(dateStr) {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('en-US', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

onMounted(loadPosts)
</script>

<style scoped lang="scss">
.posts-page {
  max-width: 1400px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  
  h2 {
    font-size: 22px;
    font-weight: 600;
    color: var(--admin-text-primary);
  }
}

.filter-card {
  margin-bottom: 20px;
}

.table-card {
  :deep(.el-card__body) {
    padding: 16px;
  }
}

.title-cell {
  color: var(--admin-text-primary);
  font-weight: 500;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
