# Kroki Client 

[![Build Image](https://github.com/luizgsbraz/kroki-client-docker/actions/workflows/build-image.yml/badge.svg)](https://github.com/luizgsbraz/kroki-client-docker/actions/workflows/build-image.yml)

Constroi o kroki-client usado no projeto [kroki-client-user](https://github.com/luizgsbraz/kroki-client-user)

A idéia é baixar direto do docker hub.

## Processo de Construção Liberação de Novas Versões

As releases do branch latest geram novas imagens no Docker Hub.

```mermaid
gitGraph TB:
    branch latest
    checkout latest
    commit id: "v1.0-latest"
    branch build-test
    checkout build-test
    checkout main
    commit id: "CHANGE 01"
    commit id: "CHANGE 02"  
    merge latest
    commit id: "CHANGE 03"
    commit id: "CHANGE 04"        
    commit id: "RC1"
    checkout build-test
    merge main
    commit type:REVERSE id: "RC1 Fail"
    checkout main
    commit id: "CHANGE 05 - Fix Fail - RC2"
    checkout build-test
    merge main
    commit id: "RC2 OK"
    checkout main
    commit id: "CHANGE 06 - RC3"        
    checkout build-test
    merge main
    commit id: "RC3 OK"
    checkout main
    commit id: "CHANGE 07"        
    commit id: "CHANGE 08"            
    merge build-test
    checkout latest
    merge build-test
    commit id: "v1.1-latest"
    checkout main
    merge latest
```
