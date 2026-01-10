# Available AI Models

Models accessible through Zo Secure AI Proxy, organized by provider.

**Total Models**: 80+

---

## OpenAI

### GPT-4 Series
- `openai/gpt-4o-2024-08-06`
- `openai/gpt-4o-2024-11-20`
- `openai/gpt-4o-mini`

### GPT-4.1 Series
- `openai/gpt-4.1`
- `openai/gpt-4.1-mini`
- `openai/gpt-4.1-nano`

### GPT-5 Series
- `openai/gpt-5`
- `openai/gpt-5-chat`
- `openai/gpt-5-mini`
- `openai/gpt-5-nano`
- `openai/gpt-5.1`
- `openai/gpt-5.2`
- `openai/gpt-5.2-chat`

### Reasoning Models
- `openai/o1`
- `openai/o1-mini`
- `openai/o1-pro`
- `openai/o3-mini`
- `openai/o3-mini-high`
- `openai/o3-2025-04-16`
- `openai/o3-deep-research-2025-06-26`
- `openai/o4-mini`
- `openai/o4-mini-high`

**Best for:** Advanced reasoning, complex problem-solving, research tasks

---

## Anthropic

### Claude 3.7
- `anthropic/claude-3.7-sonnet`
- `anthropic/claude-3.7-sonnet:thinking`

### Claude 4 Series
- `anthropic/claude-opus-4`
- `anthropic/claude-sonnet-4`
- `anthropic/claude-sonnet-4.5`
- `claude-opus-4-5`
- `claude-haiku-4-5-5`

**Best for:** Coding, analysis, nuanced text generation

---

## Google

### Gemini 2.5
- `google/gemini-2.5-flash`
- `google/gemini-2.5-flash-lite`
- `google/gemini-2.5-pro-preview`

### Gemini 2.0
- `google/gemini-2.0-flash-001`

### Gemini 1.5
- `google/gemini-pro-1.5`

### Gemma 2
- `google/gemma-2-27b-it`

**Best for:** Multimodal tasks, long context, coding

---

## Meta

### Llama 4
- `meta-llama/llama-4-maverick`

### Llama 3.3
- `meta-llama/llama-3.3-70b-instruct`

### Llama 3.1
- `meta-llama/llama-3.1-405b-instruct`
- `meta-llama/llama-3.1-70b-instruct`

### Llama 3
- `meta-llama/llama-3-70b-instruct:nitro`

**Best for:** General-purpose, cost-effective, open-source

---

## Microsoft

### Phi 4
- `microsoft/phi-4`

### WizardLM
- `microsoft/wizardlm-2-8x22b`

**Best for:** Lightweight tasks, efficient inference

---

## Amazon

### Nova Series
- `amazon/nova-lite-v1`
- `amazon/nova-micro-v1`

**Best for:** AWS-integrated workloads, cost-optimized

---

## xAI

### Grok 4
- `x-ai/grok-4`
- `x-ai/grok-4-fast`

### Grok 3
- `x-ai/grok-3-beta`
- `x-ai/grok-3-mini-beta`

### Grok 2
- `x-ai/grok-2-1212`

**Best for:** Real-time information, social media integration

---

## DeepSeek

### DeepSeek V3.1
- `deepseek/deepseek-chat-v3.1`
- `deepseek/deepseek-chat-v3-0324`

### DeepSeek Chat
- `deepseek/deepseek-chat`

### DeepSeek R1
- `deepseek/deepseek-r1`
- `deepseek/deepseek-r1:nitro`

**Best for:** Coding, mathematics, reasoning tasks

---

## Qwen (Alibaba)

### Qwen 3
- `qwen/qwen3-235b-a22b`
- `qwen/qwen3-coder`

### Qwen 2.5
- `qwen/qwen-2.5-72b-instruct`

### Qwen 2
- `qwen/qwen-2-72b-instruct`
- `qwen/qwen-2-vl-72b-instruct`

### Qwen Free
- `qwen/qwen2.5-vl-32b-instruct:free`

**Best for:** Multilingual, vision, coding tasks

---

## NVIDIA

### Nemotron Ultra
- `nvidia/llama-3.1-nemotron-ultra-253b-v1`

### Nemotron Super
- `nvidia/llama-3.3-nemotron-super-49b-v1`
- `nvidia/llama-3.3-nemotron-super-49b-v1.5`

**Best for:** GPU-optimized workloads, enterprise deployment

---

## Cohere

### Command R
- `cohere/command-r-08-2024`
- `cohere/command-r-plus-08-2024`

**Best for:** RAG, enterprise applications, retrieval

---

## Mistral AI

### Mistral Medium
- `mistralai/mistral-medium-3`

### Codestral
- `mistralai/codestral-mamba`

**Best for:** Coding, multilingual generation

---

## Moonshot AI

### Kimi K2
- `moonshotai/kimi-k2-0905`
- `moonshotai/kimi-k2-thinking`
- `moonshotai/kimi-k2:free`

**Best for:** Chinese language, long context

---

## Perplexity

### Sonar
- `perplexity/sonar`

### Sonar Deep Research
- `perplexity/sonar-deep-research`

**Best for:** Research, citations, factual accuracy

---

## Z AI

### GLM Series
- `z-ai/glm-4.5v`
- `z-ai/glm-4.6`

**Best for:** Multimodal, Chinese language

---

## Open Source / Community

### Goliath
- `alpindale/goliath-120b`

### Dolphin Mixtral
- `cognitivecomputations/dolphin-mixtral-8x7b`

### MythoMax
- `gryphe/mythomax-l2-13b`

### MiniMax
- `minimax/minimax-m2`

**Best for:** Experimentation, custom fine-tuning, cost savings

---

## Auto-Selection Models

These models automatically choose the best provider/model based on your criteria:

### Budget Optimized
- `auto_select_model/budget:latest`
- Prioritizes lowest cost per request
- Automatically selects most cost-effective model for your task

### Quality Optimized
- `auto_select_model/quality:latest`
- Prioritizes highest performance
- Chooses best model regardless of cost

### Balanced
- `auto_select_model/balance:latest`
- Balances cost and performance
- Default selection for most use cases

**Best for:** Uncertain requirements, cost optimization, testing new models

---

## Model Suffixes

### Special Suffixes

| Suffix | Meaning | Effect |
|--------|-----------|---------|
| `:thinking` | Enhanced reasoning | Activates chain-of-thought reasoning |
| `:free` | No cost | Model available at no charge |
| `:nitro` | Optimized performance | Faster inference, potentially higher cost |
| `:fast` | Low latency | Prioritizes response speed over quality |

### Examples

- `anthropic/claude-3.7-sonnet:thinking` - Enhanced reasoning
- `moonshotai/kimi-k2:free` - Free usage
- `meta-llama/llama-3-70b-instruct:nitro` - Optimized performance

---

## Choosing the Right Model

### By Use Case

| Use Case | Recommended Models | Reason |
|----------|------------------|---------|
| **Coding** | GPT-4.1, Claude Sonnet 4, DeepSeek Chat | Strong code generation |
| **Analysis** | Claude Opus 4, o1, o3 | Advanced reasoning |
| **Creative** | GPT-5, Grok 4, Gemini 2.5 | Strong generation |
| **Fast Response** | GPT-4o-mini, Llama 4, Nova Micro | Low latency |
| **Research** | o3-deep-research, Sonar Deep Research | Deep search |
| **Cost-Effective** | Llama 3.1, Gemma 2, Auto-Budget | Low per-token cost |
| **Multilingual** | Qwen 3, GLM 4.6, Mistral | Multiple language support |

### By Budget

| Budget Level | Models | Approximate Cost |
|-------------|---------|------------------|
| **Free** | `:free` suffix models, Auto-Budget | $0 |
| **Low** | Llama 3, Gemma 2, Nova Micro | $ | 
| **Medium** | GPT-4o-mini, Claude 3.7 Sonnet | $$ |
| **High** | GPT-5, Claude Opus 4, Grok 4 | $$$ |

*Note: Actual costs vary by provider. Check your provider's pricing page for details.*

---

## All Models List

Complete alphabetical list of available models:

```
alpindale/goliath-120b
amazon/nova-lite-v1
amazon/nova-micro-v1
anthropic/claude-3.7-sonnet
anthropic/claude-3.7-sonnet:thinking
anthropic/claude-opus-4
anthropic/claude-sonnet-4
anthropic/claude-sonnet-4.5
auto_select_model/balance:latest
auto_select_model/budget:latest
auto_select_model/quality:latest
claude-haiku-4-5-5
claude-opus-4-5
cognitivecomputations/dolphin-mixtral-8x7b
cohere/command-r-08-2024
cohere/command-r-plus-08-2024
deepseek/deepseek-chat
deepseek/deepseek-chat-v3-0324
deepseek/deepseek-chat-v3.1
deepseek/deepseek-r1
deepseek/deepseek-r1:nitro
google/gemini-2.0-flash-001
google/gemini-2.5-flash
google/gemini-2.5-flash-lite
google/gemini-2.5-pro-preview
google/gemini-pro-1.5
google/gemma-2-27b-it
gryphe/mythomax-l2-13b
meta-llama/llama-3-70b-instruct:nitro
meta-llama/llama-3.1-405b-instruct
meta-llama/llama-3.1-70b-instruct
meta-llama/llama-3.3-70b-instruct
meta-llama/llama-4-maverick
microsoft/phi-4
microsoft/wizardlm-2-8x22b
minimax/minimax-m2
mistralai/codestral-mamba
mistralai/mistral-medium-3
moonshotai/kimi-k2-0905
moonshotai/kimi-k2-thinking
moonshotai/kimi-k2:free
nvidia/llama-3.1-nemotron-ultra-253b-v1
nvidia/llama-3.3-nemotron-super-49b-v1
nvidia/llama-3.3-nemotron-super-49b-v1.5
o3-2025-04-16
o3-deep-research-2025-06-26
openai/gpt-4.1
openai/gpt-4.1-mini
openai/gpt-4.1-nano
openai/gpt-4o-2024-08-06
openai/gpt-4o-2024-11-20
openai/gpt-4o-mini
openai/gpt-5
openai/gpt-5-chat
openai/gpt-5-mini
openai/gpt-5-nano
openai/gpt-5.1
openai/gpt-5.2
openai/gpt-5.2-chat
openai/o1
openai/o1-mini
openai/o1-pro
openai/o3-mini
openai/o3-mini-high
openai/o4-mini
openai/o4-mini-high
perplexity/sonar
perplexity/sonar-deep-research
qwen/qwen-2-72b-instruct
qwen/qwen-2-vl-72b-instruct
qwen/qwen-2.5-72b-instruct
qwen/qwen2.5-vl-32b-instruct:free
qwen/qwen3-235b-a22b
qwen/qwen3-coder
x-ai/grok-2-1212
x-ai/grok-3-beta
x-ai/grok-3-mini-beta
x-ai/grok-4
x-ai/grok-4-fast
z-ai/glm-4.5v
z-ai/glm-4.6
```

---

## Notes

- All models support streaming and tool-calling through this proxy
- Model availability may vary by provider and region
- Check provider documentation for up-to-date model list
- New models are added regularly by providers

---

*Built for Zo Computer - Your Personal AI Cloud*

