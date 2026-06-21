import { streamText } from 'ai';
import { createOpenAI } from '@ai-sdk/openai';
import { getAIConfig } from '@/lib/ai/config';
import { searchPostsTool } from './tools';

export const runtime = 'nodejs';

// 调用后端 RAG 搜索接口
async function searchPosts(query: string) {
  try {
    const response = await fetch(`${process.env.BACKEND_URL}/api/rag/search`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ query, limit: 3 }),
      cache: 'no-store',
    });
    if (!response.ok) return [];
    return response.json();
  } catch {
    return [];
  }
}

export async function POST(req: Request) {
  try {
    const { messages } = await req.json();

    // 获取用户配置
    const config = await getAIConfig();

    // 获取最新的用户问题
    const lastMessage = messages[messages.length - 1];
    const isUserMessage = lastMessage?.role === 'user';

    let systemPrompt = config.systemPrompt;

    // 如果是用户消息，进行 RAG 检索
    if (isUserMessage) {
      const relevantPosts = await searchPosts(lastMessage.content);

      if (relevantPosts.length > 0) {
        const context = relevantPosts.map((post: any) =>
          `【文章标题】${post.title}\n【文章摘要】${post.summary || ''}\n【文章内容】${post.content || ''}`
        ).join('\n\n');

        systemPrompt = `${config.systemPrompt}

请基于以下博客文章内容回答用户的问题：
${context}

回答要求：
1. 尽量引用博客中的内容来回答
2. 如果博客中没有相关内容，可以说"这个问题博客里还没有提到哦～"
3. 回答要友好、自然、简洁`;
      }
    }

    // 创建模型实例
    const provider = createOpenAI({
      apiKey: config.apiKey,
      baseURL: config.baseURL || 'https://api.deepseek.com/v1',
    });
    const model = provider(config.model);

    const result = streamText({
      model,
      system: systemPrompt,
      messages,
      tools: {
        searchPosts: searchPostsTool,
      },
      maxSteps: 3,
      temperature: config.temperature,
      maxTokens: config.maxTokens,
    });

    return result.toDataStreamResponse();
  } catch (error) {
    console.error('Chat API error:', error);
    return new Response(
      JSON.stringify({ error: 'AI 服务不可用，请检查配置' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
}
