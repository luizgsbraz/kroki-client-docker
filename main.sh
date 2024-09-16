#!/bin/sh

MERMAID_URL="$ENV_KROKI_BASE_URL/mermaid/svg"

SRC_DIR="/app/work/src"
BUILD_DIR="/app/work/build"
LOG_DIR="/app/work/log"

# Cria uma função usage para mostrar a mensagem de uso
usage() {
  echo "Usage: "
  echo "The following volumes should be mapped in your Docker Compose file:"
  echo "  SRC_DIR    - Directory containing source files"
  echo "  BUILD_DIR  - Directory where the processed files will be stored"
  echo "  LOG_DIR    - Directory for log files"
  echo ""
  echo "Besides, the KROKI base URL should be set"
  echo "  ENV_KROKI_BASE_URL - Base URL for for Kroki"
  echo " "
  echo "See the README.md file for more instructions!"
  end_processing
  exit 1
}

# Verifica se o diretório de origem existe e interrompe o script se não existir
if [ ! -d "$SRC_DIR" ]; then
  echo "Diretório de origem não encontrado: $SRC_DIR"
  usage
fi

# Verifica se o diretório de destino existe, se não, cria-o
if [ ! -d "$BUILD_DIR" ]; then
  mkdir -p "$BUILD_DIR"
fi

# Verifica se o diretório de log existe, se não, cria-o
if [ ! -d "$LOG_DIR" ]; then
  mkdir -p "$LOG_DIR"
fi

# Espera os demais containers subirem
sleep 10

# Loop através de todos os arquivos no diretório de origem
for file in "$SRC_DIR"/*.mmd; do
  # Verifica se é um arquivo regular
  if [ -f "$file" ]; then
    # Extrai o nome do arquivo sem extensão
    filename=$(basename "$file")
    name="${filename%.*}"
    
    # Define o nome do arquivo de destino
    output_file="$BUILD_DIR/$name.svg"
    
    # Faz a conversão usando curl
    COMANDO="curl -X POST -o $output_file -T $file $MERMAID_URL"
    echo $COMANDO
    sh -c "$COMANDO"
    echo "Convertido: $file -> $output_file"
  fi
done

echo "Processing complete!"

