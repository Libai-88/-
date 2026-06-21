import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    redirect: '/dashboard'
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: () => import('@/views/Dashboard.vue'),
    meta: { title: 'Dashboard' }
  },
  {
    path: '/posts',
    name: 'Posts',
    component: () => import('@/views/Posts.vue'),
    meta: { title: 'Posts Management' }
  },
  {
    path: '/ai-config',
    name: 'AIConfig',
    component: () => import('@/views/AIConfig.vue'),
    meta: { title: 'AI Configuration' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  document.title = to.meta.title ? `${to.meta.title} - Kirameku Admin` : 'Kirameku Admin'
  next()
})

export default router
