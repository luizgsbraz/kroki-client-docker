# Processo de Desenvolvimento

## Faça edições em uma branch qualquer de desenvolvimento:

```
git clone https://github.com/luizgsbraz/kroki-client-docker.git 
git branch featureX
```

## Gere uma imagem local com a tag `testing`

```
./build.sh 
```

## No projeto kroki-client-user, teste a imagem gerada:

```
git clone https://github.com/luizgsbraz/kroki-client-user.git 
converte.sh -testing
ls ./out
```

Se estiver tudo bem, considere integrar a feature à versão atualizada da branch main.

## Integre a feature à branch main

```
git add featureX
git commit -m "nova feature parece OK"
git branch main
git pull
git merge featureX
```

## Reconstrua localmente a imagem com a tag `testing` e faça mais um teste  

* na pasta local do projeto kroki-client-docker  


```
build.sh
``` 

* na pasta local do projeto kroki-client-user

```
convert.sh -testing 
ls ./out
```

## Se estiver tudo ok, suba o código fonte para o branch main remoto 

```
git pull
git push
```

Se não houver novas features para integrar à nova release, considere realizar o teste automatizado do processo de build no github. 

## Envie a nova versão para a branch `build-test` remota

```
git checkout build-test
git merge main 
git push origin build-test 
```

## Verifique o resultado do teste em:

```
https://github.com/luizgsbraz/kroki-client-docker/actions/workflows/build-test.yml
```

Se der tudo certo, considere fazer o release da versão `testing` no docker.io

```
git checkout build-test
./build.sh 
docker login docker.io
docker push luizgsbraz/kroki-client:testing
```

Verifique a nova imagem armazenada em:

```
https://hub.docker.com/r/luizgsbraz/kroki-client/tags
```

## Se tudo der certo, remova as versões `testing` local

```
docker images
docker rmi xxxxxxx (id da imagem de teste)
```

## E repita o teste da versão `testing` baixado-a do docker.io 

```
convert.sh -testing
```

## Se tudo der certo, considere fazer um release de versão `latest`.

### Publique o código na branch `latest` no github

```
git checkout latest
git merge build-test  
git push origin build-test 
```

### Confira a geração da imagem `latest` no docker hub

```
docker hub
```

### Se tudo der certo, teste o a imagem `latest` oriunda do docker hub

na pasta local do projeto `kroki-client-user`

```
docker images
docker rmi xxxxx (a imagem latest local)
./convert.sh
```



