<template>
  <div class="ai-config-page">
    <div class="page-header">
      <div class="header-left">
        <h2>AI Configuration</h2>
        <p class="subtitle">Configure your AI provider for intelligent blog features</p>
      </div>
      <div class="header-actions">
        <el-button @click="loadConfig" :loading="configLoading">
          <el-icon><RefreshRight /></el-icon>
          Load Config
        </el-button>
      </div>
    </div>

    <el-row :gutter="24">
      <el-col :xs="24" :lg="16">
        <el-card class="config-card">
          <template #header>
            <div class="card-header">
              <el-icon><Setting /></el-icon>
              <span>AI Provider Settings</span>
              <el-tag v-if="isConfigured" type="success" size="small">Configured</el-tag>
              <el-tag v-else type="info" size="small">Not Configured</el-tag>
            </div>
          </template>

          <el-form
            ref="formRef"
            :model="formData"
            :rules="formRules"
            label-width="140px"
            label-position="top"
          >
            <!-- AI Provider -->
            <el-form-item label="AI Provider" prop="provider">
              <el-select v-model="formData.provider" placeholder="Select an AI provider" style="width: 100%">
                <el-option label="DeepSeek" value="deepseek" />
                <el-option label="OpenAI" value="openai" />
                <el-option label="通义千问 (Qwen)" value="qwen" />
                <el-option label="Anthropic" value="anthropic" />
                <el-option label="Custom" value="custom" />
              </el-select>
              <div class="field-hint" v-if="providerHint">
                <el-icon><InfoFilled /></el-icon>
                <span>{{ providerHint }}</span>
              </div>
            </el-form-item>

            <!-- API Key -->
            <el-form-item label="API Key" prop="api_key">
              <el-input
                v-model="formData.api_key"
                type="password"
                show-password
                placeholder="Enter your API key"
                size="large"
              >
                <template #prefix>
                  <el-icon><Key /></el-icon>
                </template>
              </el-input>
              <div class="field-hint">
                <el-icon><Lock /></el-icon>
                <span>Your API key is encrypted and stored securely</span>
              </div>
            </el-form-item>

            <!-- Model Name -->
            <el-form-item label="Model Name" prop="model">
              <el-input
                v-model="formData.model"
                :placeholder="modelPlaceholder"
                size="large"
              >
                <template #prefix>
                  <el-icon><Cpu /></el-icon>
                </template>
              </el-input>
              <div class="field-hint">
                {{ modelHint }}
              </div>
            </el-form-item>

            <!-- Base URL (for custom or when needed) -->
            <el-form-item label="Base URL" prop="base_url" v-if="showBaseUrl">
              <el-input
                v-model="formData.base_url"
                :placeholder="baseUrlPlaceholder"
                size="large"
              >
                <template #prefix>
                  <el-icon><Link /></el-icon>
                </template>
              </el-input>
              <div class="field-hint">
                {{ baseUrlHint }}
              </div>
            </el-form-item>

            <!-- System Prompt -->
            <el-form-item label="System Prompt">
              <el-input
                v-model="formData.system_prompt"
                type="textarea"
                :rows="6"
                placeholder="Enter the system prompt that will be used for AI generations..."
                resize="vertical"
              />
              <div class="field-hint">
                <el-icon><ChatDotRound /></el-icon>
                <span>This prompt guides the AI's behavior when generating blog content</span>
              </div>
            </el-form-item>

            <el-divider content-position="left">
              <el-icon><Operation /></el-icon>
              <span style="margin-left: 8px">Generation Parameters</span>
            </el-divider>

            <!-- Temperature -->
            <el-form-item label="Temperature">
              <div class="slider-container">
                <el-slider
                  v-model="formData.temperature"
                  :min="0"
                  :max="2"
                  :step="0.1"
                  :format-tooltip="formatTemperature"
                  show-input
                  input-size="small"
                />
              </div>
              <div class="field-hint">
                {{ temperatureHint }}
              </div>
            </el-form-item>

            <!-- Max Tokens -->
            <el-form-item label="Max Tokens">
              <el-input-number
                v-model="formData.max_tokens"
                :min="100"
                :max="32000"
                :step="100"
                controls-position="right"
                size="large"
                style="width: 200px"
              />
              <div class="field-hint">
                Maximum number of tokens the AI can generate in a single response
              </div>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>

      <!-- Right Sidebar: Quick Reference -->
      <el-col :xs="24" :lg="8">
        <el-card class="info-card">
          <template #header>
            <span>Quick Reference</span>
          </template>
          
          <div class="provider-info">
            <h4>Provider Quick URLs</h4>
            <div class="info-item" v-for="item in providerUrls" :key="item.name">
              <strong>{{ item.name }}:</strong>
              <code>{{ item.url }}</code>
            </div>
          </div>

          <el-divider />

          <div class="provider-info">
            <h4>Recommended Models</h4>
            <div class="info-item" v-for="item in recommendedModels" :key="item.name">
              <strong>{{ item.name }}:</strong>
              <code>{{ item.model }}</code>
            </div>
          </div>

          <el-divider />

          <div class="provider-info">
            <h4>Temperature Guide</h4>
            <div class="temp-guide">
              <div class="temp-item">
                <span class="temp-value">0.0 - 0.3</span>
                <span class="temp-desc">Precise, factual</span>
              </div>
              <div class="temp-item">
                <span class="temp-value">0.4 - 0.7</span>
                <span class="temp-desc">Balanced creativity</span>
              </div>
              <div class="temp-item">
                <span class="temp-value">0.8 - 1.0</span>
                <span class="temp-desc">Creative, varied</span>
              </div>
              <div class="temp-item">
                <span class="temp-value">1.0 - 2.0</span>
                <span class="temp-desc">Experimental</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- Action Buttons -->
    <div class="action-bar">
      <el-button @click="resetForm">
        <el-icon><RefreshLeft /></el-icon>
        Reset Form
      </el-button>
      <el-button type="warning" @click="testConnection" :loading="testing">
        <el-icon><Connection /></el-icon>
        Test Connection
      </el-button>
      <el-button type="primary" @click="saveConfig" :loading="saving" size="large">
        <el-icon><Check /></el-icon>
        Save Configuration
      </el-button>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { aiConfigApi } from '@/api'

const formRef = ref(null)
const configLoading = ref(false)
const saving = ref(false)
const testing = ref(false)
const isConfigured = ref(false)

const formData = reactive({
  provider: 'deepseek',
  api_key: '',
  model: 'deepseek-chat',
  base_url: 'https://api.deepseek.com',
  system_prompt: 'You are a helpful assistant that writes engaging blog posts. Write in a clear, concise, and engaging manner.',
  temperature: 0.7,
  max_tokens: 4000
})

const formRules = {
  provider: [{ required: true, message: 'Please select an AI provider', trigger: 'change' }],
  api_key: [{ required: true, message: 'API Key is required', trigger: 'blur' }],
  model: [{ required: true, message: 'Model name is required', trigger: 'blur' }]
}

// Provider-specific hints
const providerHint = computed(() => {
  const hints = {
    deepseek: 'DeepSeek provides cost-effective models. Get your API key at https://platform.deepseek.com',
    openai: 'OpenAI offers GPT-4, GPT-3.5 models. Get your API key at https://platform.openai.com',
    qwen: '通义千问 (Qwen) by Alibaba. Get your API key at https://dashscope.console.aliyun.com',
    anthropic: 'Anthropic Claude models. Get your API key at https://console.anthropic.com',
    custom: 'Enter custom provider details below. Must be OpenAI-compatible API.'
  }
  return hints[formData.provider] || ''
})

const showBaseUrl = computed(() => {
  return formData.provider === 'custom' || formData.provider === 'qwen'
})

const baseUrlPlaceholder = computed(() => {
  const placeholders = {
    deepseek: 'https://api.deepseek.com',
    openai: 'https://api.openai.com/v1',
    qwen: 'https://dashscope.aliyuncs.com/compatible-mode/v1',
    anthropic: 'https://api.anthropic.com',
    custom: 'https://your-api-endpoint.com/v1'
  }
  return placeholders[formData.provider] || ''
})

const baseUrlHint = computed(() => {
  const hints = {
    deepseek: 'Default: https://api.deepseek.com',
    openai: 'Default: https://api.openai.com/v1 (for Azure or proxies, enter custom URL)',
    qwen: 'Default: https://dashscope.aliyuncs.com/compatible-mode/v1',
    anthropic: 'Default: https://api.anthropic.com',
    custom: 'Enter your OpenAI-compatible API endpoint URL'
  }
  return hints[formData.provider] || ''
})

const modelPlaceholder = computed(() => {
  const placeholders = {
    deepseek: 'deepseek-chat or deepseek-reasoner',
    openai: 'gpt-4o, gpt-4o-mini, gpt-3.5-turbo',
    qwen: 'qwen-plus, qwen-max, qwen-turbo',
    anthropic: 'claude-3-5-sonnet-20241022, claude-3-opus-20240229',
    custom: 'model-name'
  }
  return placeholders[formData.provider] || 'Enter model name'
})

const modelHint = computed(() => {
  return `Current provider: ${formData.provider}`
})

const temperatureHint = computed(() => {
  const t = formData.temperature
  if (t <= 0.3) return 'Low temperature: More deterministic and focused outputs'
  if (t <= 0.7) return 'Medium temperature: Balanced between creativity and accuracy'
  if (t <= 1.0) return 'High temperature: More creative and varied outputs'
  return 'Very high temperature: Highly experimental outputs'
})

function formatTemperature(val) {
  return val.toFixed(1)
}

// Provider reference data
const providerUrls = [
  { name: 'DeepSeek', url: 'https://api.deepseek.com' },
  { name: 'OpenAI', url: 'https://api.openai.com/v1' },
  { name: 'Qwen', url: 'https://dashscope.aliyuncs.com/compatible-mode/v1' },
  { name: 'Anthropic', url: 'https://api.anthropic.com' }
]

const recommendedModels = [
  { name: 'DeepSeek', model: 'deepseek-chat' },
  { name: 'OpenAI', model: 'gpt-4o' },
  { name: 'Qwen', model: 'qwen-plus' },
  { name: 'Anthropic', model: 'claude-3-5-sonnet-20241022' }
]

// Load configuration on mount
async function loadConfig() {
  configLoading.value = true
  try {
    const config = await aiConfigApi.getConfig()
    if (config) {
      Object.assign(formData, {
        provider: config.provider || 'deepseek',
        api_key: config.api_key || '',
        model: config.model || getDefaultModel(formData.provider),
        base_url: config.base_url || '',
        system_prompt: config.system_prompt || formData.system_prompt,
        temperature: config.temperature ?? 0.7,
        max_tokens: config.max_tokens ?? 4000
      })
      isConfigured.value = !!(config.api_key && config.provider)
      ElMessage.success('Configuration loaded')
    }
  } catch (error) {
    ElMessage.info('No existing configuration found')
    isConfigured.value = false
  } finally {
    configLoading.value = false
  }
}

function getDefaultModel(provider) {
  const defaults = {
    deepseek: 'deepseek-chat',
    openai: 'gpt-4o',
    qwen: 'qwen-plus',
    anthropic: 'claude-3-5-sonnet-20241022',
    custom: ''
  }
  return defaults[provider] || ''
}

// Save configuration
async function saveConfig() {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    saving.value = true
    try {
      await aiConfigApi.saveConfig({ ...formData })
      ElMessage.success('AI configuration saved successfully!')
      isConfigured.value = true
    } catch (error) {
      ElMessage.error('Failed to save configuration: ' + error.message)
    } finally {
      saving.value = false
    }
  })
}

// Test connection
async function testConnection() {
  if (!formData.api_key) {
    ElMessage.warning('Please enter an API key first')
    return
  }
  if (!formData.model) {
    ElMessage.warning('Please enter a model name')
    return
  }

  testing.value = true
  try {
    await aiConfigApi.testConnection({
      provider: formData.provider,
      api_key: formData.api_key,
      model: formData.model,
      base_url: formData.base_url || undefined
    })
    ElMessage.success('Connection successful! The API is working.')
  } catch (error) {
    ElMessage.error('Connection test failed: ' + error.message)
  } finally {
    testing.value = false
  }
}

function resetForm() {
  if (formRef.value) {
    formRef.value.resetFields()
  }
  formData.provider = 'deepseek'
  formData.api_key = ''
  formData.model = 'deepseek-chat'
  formData.base_url = 'https://api.deepseek.com'
  formData.system_prompt = 'You are a helpful assistant that writes engaging blog posts. Write in a clear, concise, and engaging manner.'
  formData.temperature = 0.7
  formData.max_tokens = 4000
  isConfigured.value = false
  ElMessage.info('Form reset to defaults')
}

onMounted(loadConfig)
</script>

<style scoped lang="scss">
.ai-config-page {
  max-width: 1400px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 24px;
  flex-wrap: wrap;
  gap: 16px;
}

.header-left {
  h2 {
    font-size: 22px;
    font-weight: 600;
    color: var(--admin-text-primary);
    margin-bottom: 4px;
  }
}

.subtitle {
  font-size: 14px;
  color: var(--admin-text-secondary);
  margin: 0;
}

.config-card {
  :deep(.el-card__body) {
    padding: 24px;
  }
}

.card-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 500;
}

.field-hint {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-top: 6px;
  font-size: 12px;
  color: var(--admin-text-secondary);
  
  .el-icon {
    flex-shrink: 0;
  }
}

.slider-container {
  width: 100%;
  max-width: 500px;
}

.info-card {
  position: sticky;
  top: 20px;
}

.provider-info {
  h4 {
    font-size: 14px;
    font-weight: 600;
    color: var(--admin-text-primary);
    margin-bottom: 12px;
  }
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 8px 0;
  border-bottom: 1px solid var(--admin-border-color);
  
  &:last-child {
    border-bottom: none;
  }
  
  strong {
    font-size: 13px;
    color: var(--admin-text-primary);
  }
  
  code {
    font-size: 12px;
    color: var(--admin-accent-color);
    background: rgba(124, 58, 237, 0.1);
    padding: 4px 8px;
    border-radius: 4px;
    font-family: 'Fira Code', monospace;
  }
}

.temp-guide {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.temp-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 6px 0;
  
  .temp-value {
    font-size: 13px;
    font-weight: 500;
    color: var(--admin-accent-color);
  }
  
  .temp-desc {
    font-size: 12px;
    color: var(--admin-text-secondary);
  }
}

.action-bar {
  margin-top: 24px;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 0;
  border-top: 1px solid var(--admin-border-color);
}

// Override ElFormItem for top labels
:deep(.el-form-item__label) {
  font-weight: 500;
}

:deep(.el-divider__text) {
  display: flex;
  align-items: center;
  font-size: 14px;
  font-weight: 500;
  color: var(--admin-text-primary);
}
</style>
