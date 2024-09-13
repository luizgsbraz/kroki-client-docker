#!/bin/sh

source set_vars.sh 
export CLIENT_MERMAID_URL="$ENV_KROKI_BASE_URL/mermaid/svg"
export CLIENT_SRC_DIR="/app/work/src"
export CLIENT_BUILD_DIR="/app/work/build"
export CLIENT_LOG_DIR="/app/work/log"

end_processing() {
  echo "tree /app"
  echo ""
  echo "Processing complete!"
  echo ""
}

# Cria uma função usage para mostrar a mensagem de uso
usage() {
  echo "Usage: "
  echo "The following volumes should be mapped in your Docker Compose file:"
  echo "  LOCAL_SRC_DIR    - Directory containing source files"
  echo "  LOCAL_BUILD_DIR  - Directory where the processed files will be stored"
  echo "  LOCAL_LOG_DIR    - Directory for log files"
  echo ""
  echo "Besides, the KROKI base URL should be set"
  echo "  ENV_KROKI_BASE_URL - Base URL for for Kroki"
  echo " "
  echo "See the README.md file for more instructions!"
  end_processing
  exit 1
}

# Verifica se as variáveis de ambiente foram definidas
[ -z "$CLIENT_SRC_DIR" ] && echo "Error: CLIENT_SRC_DIR is not set." && usage
[ -z "$CLIENT_BUILD_DIR" ] && echo "Error: CLIENT_BUILD_DIR is not set." && usage
[ -z "$CLIENT_LOG_DIR" ] && echo "Error: CLIENT_LOG_DIR is not set." && usage
[ -z "$CLIENT_MERMAID_URL" ] && echo "Error: CLIENT_MERMAID_URL is not set." && usage

# Se todas as variáveis estiverem definidas, exibe os valores
echo "Source Directory: $CLIENT_SRC_DIR"
echo "Build Directory: $CLIENT_BUILD_DIR"
echo "Log Directory: $CLIENT_LOG_DIR"
echo "Mermaid URL: $CLIENT_MERMAID_URL"

# Verifica se o diretório de origem existe e interrompe o script se não existir
if [ ! -d "$CLIENT_SRC_DIR" ]; then
  echo "Diretório de origem não encontrado: $CLIENT_SRC_DIR"
  usage
fi

# Verifica se o diretório de destino existe, se não, cria-o
if [ ! -d "$CLIENT_BUILD_DIR" ]; then
  mkdir -p "$CLIENT_BUILD_DIR"
fi

sleep 10

# Loop através de todos os arquivos no diretório de origem
for file in "$CLIENT_SRC_DIR"/*.mmd; do
  # Verifica se é um arquivo regular
  if [ -f "$file" ]; then
    # Extrai o nome do arquivo sem extensão
    filename=$(basename "$file")
    name="${filename%.*}"
    
    # Define o nome do arquivo de destino
    output_file="$CLIENT_BUILD_DIR/$name.svg"
    
    # Faz a conversão usando curl
    COMANDO="curl -X POST -o $output_file -T $file $CLIENT_MERMAID_URL"
    echo $COMANDO
    sh -c "$COMANDO"
    echo "Convertido: $file -> $output_file"
  fi
done

end_processing

