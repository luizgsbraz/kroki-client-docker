#!/bin/bash

# Função para testar se um arquivo existe e é válido
function check_file {
   local mmd_file=$1
   local svg_file="${mmd_file%.mmd}.svg"

   echo "Verificando $mmd_file e $svg_file ..."

   # Testa se o arquivo SVG correspondente existe
   if [[ ! -f "$OUT_DIR/$svg_file" ]]; then
      echo "Erro: Arquivo SVG correspondente ($svg_file) não encontrado."
      missing_svg=$((missing_svg + 1))
   else
      # Verifica se o arquivo SVG gerado é do tipo correto
      file_output=$(file "$OUT_DIR/$svg_file")
      if [[ ! "$file_output" =~ "Scalable Vector Graphics" ]]; then
            echo "Erro: Arquivo $svg_file não é do tipo SVG válido."
            invalid_svg=$((invalid_svg + 1))
      fi

      # Verifica se o arquivo SVG não está vazio
      if [[ ! -s "$OUT_DIR/$svg_file" ]]; then
            echo "Erro: Arquivo $svg_file está vazio."
            empty_svg=$((empty_svg + 1))
      fi
   fi
}


function verifica_teste_feito { 

   # Verifica se os diretórios in e out existem
   if [[ ! -d "$IN_DIR" || ! -d "$OUT_DIR" ]]; then
      echo "Erro: Ao menos um dos diretórios in ou out não foram criados corretamente."
      exit 1
   fi

   # Inicializa variáveis para contar falhas
   missing_svg=0
   invalid_svg=0
   empty_svg=0
   mmd_files_found=0

   # Loop sobre todos os arquivos .mmd no diretório in
   for mmd_file in "$IN_DIR"/*.mmd; do
      if [[ -f "$mmd_file" ]]; then
         mmd_files_found=$((mmd_files_found + 1))
         check_file "$(basename "$mmd_file")"
      fi
   done

   # Resumo do teste
   echo
   echo "Resumo:"
   echo "Arquivos .mmd encontrados: $mmd_files_found"
   echo "Arquivos SVG ausentes: $missing_svg"
   echo "Arquivos SVG inválidos: $invalid_svg"
   echo "Arquivos SVG vazios: $empty_svg"

   # Condição de sucesso ou falha
   if [[ $missing_svg -eq 0 && $invalid_svg -eq 0 && $empty_svg -eq 0 ]]; then
      echo "$mmd_files_found testes concluídos com sucesso!"
   else
      echo "Alguns testes falharam. Verifique as mensagens de erro."
   fi
   exit 0
}

prepare_teste() {

   agoramesmo=$(date +%s%3N)
   testedir=$(pwd)/mytestdir_$agoramesmo

   if [[ -d "$testedir" ]]; then
      echo "Removendo $testedir..."
      rm -rf "$testedir"
   fi

   export IN_DIR="$testedir/in"
   export OUT_DIR="$testedir/out"
   export LOG_DIR="$testedir/log"

   mkdir -p $IN_DIR
   mkdir -p $OUT_DIR
   mkdir -p $LOG_DIR

   touch $LOG_DIR/kroki-client.log
   return 0

   # Criar os arquivos de exemplo para o diretório de trabalho
   cp -r $(pwd)/exemplos/*.mmd $IN_DIR

}   

#### INICIO PROCESSA

# Verifica se o Podman está disponível, caso contrário, usa Docker
if command -v podman &> /dev/null
then
   export CONTAINER_TOOL="podman"
else
   export CONTAINER_TOOL="docker"
fi

$CONTAINER_TOOL compose up -d

# Monitorar o log para a mensagem de conclusão
tail -F $LOG_DIR/kroki-client.log | while read LOGLINE
do
   [[ "${LOGLINE}" == *"Processing complete"* ]] && pkill -P $$ tail
done

# Finalizar
$CONTAINER_TOOL compose down

echo "Well done! Processamento concluído."

echo "Arquivos Originais:"
tree $IN_DIR
echo " " 
echo "Arquivos Gerados:"
tree $OUT_DIR

#### FIM PROCESSA

verifica_teste_feito

exemplo_para_firefox=$(ls "$OUT_DIR"/*.svg | head -n 1)
echo "firefox $exemplo_para_firefox &"
echo "firefox $OUT_DIR/$exemplo_para_firefox &"
echo ""

# Pergunta ao usuário se deseja remover o diretório
echo "Deseja remover $testedir? (y/N)"

# Captura a resposta do usuário
read -n 1 -r REPLY
echo    # Adiciona uma nova linha após a entrada do usuário

# Verifica se a resposta é 'y' ou 'Y'
if [[ $REPLY =~ ^[Yy]$ ]]
then
   rm -rf "$testedir"
   echo "$testedir foi removido."
else
   echo "Ação cancelada."
fi
