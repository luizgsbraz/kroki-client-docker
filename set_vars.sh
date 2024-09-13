export CLIENT_MERMAID_URL="$ENV_KROKI_BASE_URL/mermaid/svg"
export CLIENT_SRC_DIR="/app/work/src"
export CLIENT_BUILD_DIR="/app/work/build"
export CLIENT_LOG_DIR="/app/work/log"

env | grep ENV_ | sort 
env | grep CLIENT_ | sort 
env | grep LOCAL_ | sort 