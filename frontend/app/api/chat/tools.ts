import { tool } from 'ai';
import { z } from 'zod';

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:8000';

// 搜索文章工具
export const searchPostsTool = tool({
  description: '搜索博客中的文章，根据关键词或语义查找相关内容',
  parameters: z.object({
    query: z.string().describe('搜索关键词或问题描述'),
    limit: z.number().optional().default(5).describe('返回结果数量，默认 5 条'),
  }),
  execute: async ({ query, limit = 5 }) => {
    try {
      const response = await fetch(`${BACKEND_URL}/api/posts/search`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ query, limit }),
      });
      if (!response.ok) {
        return { error: '搜索失败', details: await response.text() };
      }
      return await response.json();
    } catch (err) {
      return { error: '搜索服务不可用', details: err instanceof Error ? err.message : 'Unknown error' };
    }
  },
});

// 获取文章详情工具
export const getPostTool = tool({
  description: '根据文章 ID 获取文章的详细内容',
  parameters: z.object({
    postId: z.number().describe('文章 ID'),
  }),
  execute: async ({ postId }) => {
    try {
      const response = await fetch(`${BACKEND_URL}/api/posts/${postId}`);
      if (!response.ok) {
        return { error: '获取文章失败', details: await response.text() };
      }
      return await response.json();
    } catch (err) {
      return { error: '文章服务不可用', details: err instanceof Error ? err.message : 'Unknown error' };
    }
  },
});

// 获取所有标签工具
export const getTagsTool = tool({
  description: '获取博客中所有的标签列表',
  parameters: z.object({}),
  execute: async () => {
    try {
      const response = await fetch(`${BACKEND_URL}/api/tags`);
      if (!response.ok) {
        return { error: '获取标签失败', details: await response.text() };
      }
      return await response.json();
    } catch (err) {
      return { error: '标签服务不可用', details: err instanceof Error ? err.message : 'Unknown error' };
    }
  },
});

// 获取统计数据工具
export const getStatsTool = tool({
  description: '获取博客的统计数据，如文章数量、说说数量、访问量等',
  parameters: z.object({}),
  execute: async () => {
    try {
      const response = await fetch(`${BACKEND_URL}/api/stats`);
      if (!response.ok) {
        return { error: '获取统计数据失败', details: await response.text() };
      }
      return await response.json();
    } catch (err) {
      return { error: '统计服务不可用', details: err instanceof Error ? err.message : 'Unknown error' };
    }
  },
});

// 创建文章草稿工具（需要确认）
export const createPostDraftTool = tool({
  description: '创建一篇新的文章草稿，需要管理员确认后才能发布。生成的文章为 Markdown 格式。',
  parameters: z.object({
    title: z.string().describe('文章标题'),
    content: z.string().describe('文章内容，Markdown 格式'),
    summary: z.string().optional().describe('文章摘要'),
    tags: z.array(z.string()).optional().describe('文章标签列表'),
  }),
  execute: async ({ title, content, summary, tags }) => {
    try {
      const response = await fetch(`${BACKEND_URL}/api/posts/draft`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, content, summary, tags, status: 'draft' }),
      });
      if (!response.ok) {
        return { error: '创建草稿失败', details: await response.text() };
      }
      return await response.json();
    } catch (err) {
      return { error: '草稿服务不可用', details: err instanceof Error ? err.message : 'Unknown error' };
    }
  },
});

// 导出所有工具
export const allTools = {
  searchPosts: searchPostsTool,
  getPost: getPostTool,
  getTags: getTagsTool,
  getStats: getStatsTool,
  createPostDraft: createPostDraftTool,
};

// 只读工具（AI 可以自由调用）
export const readOnlyTools = {
  searchPosts: searchPostsTool,
  getPost: getPostTool,
  getTags: getTagsTool,
  getStats: getStatsTool,
};
