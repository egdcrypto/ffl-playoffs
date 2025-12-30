@ANIMA-1152
Feature: LLM Provider Abstraction Layer

As a system architect
I want to abstract the Ollama implementation behind a provider interface
So that I can use different LLM providers through dependency injection
Background:
Given the system currently uses Ollama for entity extraction
And I want to support multiple LLM providers
- Scenario: Define LLM provider interface
- Scenario: Implement dependency injection for providers
- Scenario: Wrap existing Ollama implementation
- Scenario: Implement OpenAI provider adapter
- Scenario: Implement Anthropic Claude provider
- Scenario: Implement Google Colab runtime provider
- Scenario: Implement Hugging Face provider
- Scenario: Implement intelligent provider selection
- Scenario: Provide unified configuration system
- Scenario: Implement unified monitoring
- Scenario: Enable provider testing