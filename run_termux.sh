#!/bin/bash

CONV_LLM_PATH="/data/data/com.termux/files/home/storage/downloads/gemma-3-4b-it-Q4_0.gguf"
EMBD_LLM_PATH="/data/data/com.termux/files/home/storage/downloads/bge-large-en-v1.5-q8_0.gguf"
LLAMA_CPP_PATH="$(realpath ./llama.cpp/build_cpu/bin/llama-server)"

# Запускаем convex-local-backend в сессии 'convex_backend'
screen -S cback -d -m ./run_backend.sh

# Запускаем ai_town_embeddings.sh в сессии 'embeddings'
screen -S embd -d -m ./ai_town_embeddings.sh $LLAMA_CPP_PATH $EMBD_LLM_PATH

# Запускаем ai_town_llm.sh в сессии 'llm'
screen -S llm -d -m ./ai_town_llm.sh $LLAMA_CPP_PATH $CONV_LLM_PATH

# Запускаем npm run dev в сессии 
screen -S aitown -d -m bash -c "npm run dev"

echo "Все screen-сессии успешно запущены:"
screen -list


termux-open-url http://localhost:5173/ai-town