# AnimesEmAltaMac

App macOS nativo para ver os animes mais populares, usando a API GraphQL pública
do [AniList](https://anilist.co).

![Swift](https://img.shields.io/badge/Swift-5.9%2B-F05138?style=flat-square&logo=swift&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-13%2B-000000?style=flat-square&logo=apple&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-F05138?style=flat-square)

## O problema

A API GraphQL do AniList responde bem, mas força qualquer cliente a montar
query e lidar com um envelope aninhado. Quem só quer olhar os animes em alta
não deveria precisar saber que existe GraphQL.

## O que faz

- Lista de animes em tendência, com paginação ao rolar
- Busca local por título, sem nova requisição
- Detalhes: sinopse, nota, popularidade, episódios e ano
- Link direto para o anime no AniList
- Light e Dark Mode

## Decisões

**SwiftUI puro, sem dependência externa.** `NavigationSplitView`, `AsyncImage` e
`URLCache` cobrem o app inteiro. Um gerenciador de pacotes seria custo sem
contrapartida para algo que faz duas requisições GraphQL.

**A busca é local.** Filtrar a lista atual não consome cota da API — o AniList
limita taxa, e busca por título a cada tecla seria o jeito mais rápido de
atingir o limite.

**As chamadas de rede ficam num `actor`.** `AnimeService` é um actor justamente
porque a serialização dá thread-safety de graça, sem travar a main.

## Arquitetura

```
core/
├── Features/Trending/
│   ├── Models/         Anime, Codable
│   ├── Networking/     AnimeService (GraphQL, actor)
│   ├── ViewModels/     paginação e busca local
│   └── Views/          lista, detalhe e linha
├── Shared/
│   ├── Components/     tela de erro
│   ├── DesignSystem/   Theme
│   └── Utils/          erro de rede, HTML, GraphQL
├── Resources/          Assets e localização pt-BR
└── Tests/              testes unitários
```

## Rodar

```bash
git clone https://github.com/loyfus/animeSwift.git
cd animeSwift
open anime-swift.xcodeproj
```

Depois Cmd-R. Requer macOS 13 ou superior e Xcode 15 ou superior.

## Atalhos

| Atalho | Ação |
| --- | --- |
| Cmd-R | Atualizar a lista |
| Cmd-F | Focar a busca |
| Cmd-O | Abrir o anime no AniList |

## API AniList

Endpoint `https://graphql.anilist.co`, sem autenticação. Duas queries: uma
página de `Media` ordenada por `TRENDING_DESC`, e uma `Media(id:)` para a
sinopse.

A API tem limite de taxa. O app faz cache com `URLCache` e carrega imagens com
`AsyncImage` justamente para não repetir requisição. Respeite os
[Termos de Uso](https://anilist.co/terms).

## Testes

`core/Tests/` cobre a decodificação dos modelos e a montagem das requisições
GraphQL.

> O `.xcodeproj` versionado tem apenas o target de aplicação. Para rodar os
> testes, crie no Xcode um target unit-test que inclua `core/Tests`.

## Stack

| | |
| --- | --- |
| Linguagem | Swift 5.9+ |
| UI | SwiftUI · macOS 13+ |
| Concorrência | async/await · actor |
| Dependências | nenhuma |

## Licença

MIT — [LICENSE](LICENSE).
