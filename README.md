# AnimesEmAltaMac

App macOS nativo para ver os animes mais populares, usando a API GraphQL publica
do [AniList](https://anilist.co).

![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)
![macOS](https://img.shields.io/badge/macOS-13%2B-blue)
![SwiftUI](https://img.shields.io/badge/SwiftUI-native-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

## Funcionalidades

- Lista de animes em tendencia, com paginacao ao rolar
- Busca local por titulo, sem nova requisicao
- Detalhes: sinopse, nota, popularidade, episodios e ano
- Link direto para o anime no AniList
- Light e Dark Mode
- `NavigationSplitView` com toolbar, atalhos de teclado e VoiceOver

## Requisitos

- macOS 13 (Ventura) ou superior
- Xcode 15 ou superior
- Internet para acessar a API do AniList

## Como rodar

```bash
git clone https://github.com/loyfus/animeSwift.git
cd animeSwift
open anime-swift.xcodeproj
```

Aperte Cmd-R para rodar.

## Estrutura

```
core/
- Features/Trending/
|   |- Models/Anime.swift            # Codable
|   |- Networking/AnimeService.swift # GraphQL do AniList
|   |- ViewModels/                   # paginacao e busca local
|   |- Views/                        # lista, detalhe e linha
- Shared/
|   |- Components/ErrorStateView.swift
|   |- DesignSystem/Theme.swift
|   |- Utils/                        # erro de rede, HTML, GraphQL
- Resources/Assets.xcassets
- Tests/                             # testes unitarios
```

## Arquitetura

MVVM leve: `Models` sao structs `Codable`, `AnimeListViewModel` e um
`@MainActor ObservableObject`, e as `Views` sao SwiftUI puro. As chamadas de
rede ficam num `actor`, o que da thread-safety sem travar a main. Sem dependencia
externa - so frameworks nativos.

## API AniList

Endpoint `https://graphql.anilist.co`. Duas queries: uma pagina de `Media`
ordenada por `TRENDING_DESC`, e uma `Media(id:)` para a sinopse.

A API e publica e nao exige autenticacao, mas tem limite de taxa. O app faz
cache com `URLCache` e carrega imagens com `AsyncImage` justamente para nao
repetir requisicao. Respeite os [Termos de Uso](https://anilist.co/terms).

## Testes

`core/Tests/` cobre a decodificacao dos modelos e a montagem das requisicoes
GraphQL.

> O `.xcodeproj` versionado tem apenas o target de aplicacao. Para rodar os
> testes, crie um target unit-test que inclua `core/Tests` no Xcode.

## Atalhos

| Atalho | Acao |
| --- | --- |
| Cmd-R | Atualizar a lista |
| Cmd-F | Focar a busca |
| Cmd-O | Abrir o anime no AniList |

## Licenca

MIT - veja [LICENSE](LICENSE).

Agradecimentos ao [AniList](https://anilist.co) pela API publica.
