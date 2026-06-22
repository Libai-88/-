export interface AIConfig {
  provider: 'deepseek' | 'openai' | 'qwen' | 'anthropic' | 'custom';
  apiKey: string;
  model: string;
  baseURL?: string;
  systemPrompt: string;
  temperature: number;
  maxTokens: number;
}

const defaultConfig: AIConfig = {
  provider: (process.env.AI_PROVIDER as AIConfig['provider']) || 'deepseek',
  apiKey: process.env.DEEPSEEK_API_KEY || '',
  model: process.env.AI_MODEL || 'deepseek-chat',
  baseURL: process.env.AI_BASE_URL || 'https://api.deepseek.com/v1',
  systemPrompt: process.env.AI_SYSTEM_PROMPT || '你是一个友好的博客 AI 助手，擅长回答关于博客内容的问题。回答要友好、自然、简洁。',
  temperature: parseFloat(process.env.AI_TEMPERATURE || '0.7'),
  maxTokens: parseInt(process.env.AI_MAX_TOKENS || '2000'),
};

export async function getAIConfig(): Promise<AIConfig> {
  // 优先从数据库获取配置，如果没有则使用环境变量
  try {
    const backendUrl = process.env.BACKEND_URL;
    if (!backendUrl) {
      return defaultConfig;
    }

    const response = await fetch(`${backendUrl}/api/ai/config/active`, {
      cache: 'no-store',
    });
    if (response.ok) {
      return response.json();
    }
  } catch {
    // 使用默认配置
  }

  return defaultConfig;
}
