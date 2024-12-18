#!/bin/sh

MERMAID_URL="$ENV_KROKI_BASE_URL/mermaid/svg"
MERMAID_URL_PNG="$ENV_KROKI_BASE_URL/mermaid/png"


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
for file in "$SRC_DIR"/*.md; do
  # Verifica se é um arquivo regular
  if [ -f "$file" ]; then
    # Extrai o nome do arquivo sem extensão
    filename=$(basename "$file")
    name="${filename%.*}"
    
    # Copia o arquivo para o diretório temporário, mudando a extensão de .md para .mmd 
    cp "$file" "$LOG_DIR/$name.mmd"

    # Usando o sed faça as seguinte substituições no conteúdo do arquivo: 
    
    # a) eliminar a primeira linha que contém a string "```mermaid"
    sed -i '1d' "$LOG_DIR/$name.mmd"

    # b) eliminar as linhas que não possuam caracteres significativos (letras, números, etc)
    sed -i '/^[[:space:]]*$/d' "$LOG_DIR/$name.mmd"

    # c) eliminar a última linha que deve conter a string "```"
    sed -i '$d' "$LOG_DIR/$name.mmd"

    # Imprimir o conteúdo do arquivo no log para fins de depuração
    echo "Conteúdo do arquivo $name.mmd:"

    # Define o nome do arquivo de destino
    output_file="$BUILD_DIR/$name.svg"
    
    # Faz a conversão usando curl
    COMANDO="curl -X POST -o $output_file -T $LOG_DIR/$name.mmd $MERMAID_URL"
    echo $COMANDO
    sh -c "$COMANDO"
    echo "Convertido: $file -> $output_file"

    # Define o nome do arquivo de destino
    output_file="$BUILD_DIR/$name.png"
    
    # Faz a conversão usando curl
    COMANDO="curl -X POST -o $output_file -T $LOG_DIR/$name.mmd $MERMAID_URL_PNG"
    echo $COMANDO
    sh -c "$COMANDO"
    echo "Convertido: $file -> $output_file"

    # Testes
    # curl -X POST -o /app/work/build/USR800.png -T work/src/full/cadastro_empresas.md "http://core:8000/mermaid/png?er_min-entity-width=80&er_min-entity-height=60"
    # use-width=800
    # use-max-width=1
    # er_fill=FFFFFF
    # er_min-entity-width=800
    # er_min-entity-height=600
    name800="${name}_800"
    ext800="?use-width=800&use-max-width=1&er_fill=FFFFFF&er_min-entity-width=800&er_min-entity-height=600"
    ext800="?&er_min-entity-width=800&er_min-entity-height=600"
    output_file="$BUILD_DIR/$name800.png"
    COMANDO="curl -X POST -o $output_file -T $LOG_DIR/$name.mmd $MERMAID_URL_PNG$ext800"
    echo $COMANDO
    sh -c "$COMANDO"
    echo "Convertido: $file -> $output_file"

  fi
done

echo "Processing complete!"

