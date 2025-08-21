# AnimesEmAltaMac

Um aplicativo macOS elegante e nativo para visualizar os animes mais populares do momento, utilizando a API GraphQL pública do AniList.

![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)
![macOS](https://img.shields.io/badge/macOS-13%2B-blue)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Native-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

## Recursos

### Funcionalidades Principais
- 📺 **Lista de Animes em Tendência**: Visualize os animes mais populares do momento
- 🔄 **Paginação Infinita**: Carregamento automático ao rolar a lista
- 🔍 **Busca Local**: Filtre rapidamente animes pelo título
- 📊 **Detalhes Completos**: Veja sinopse, avaliação, popularidade e mais
- 🌐 **Integração com AniList**: Abra facilmente no site oficial
- 🎨 **Suporte a Temas**: Funciona perfeitamente em Light e Dark Mode

### Interface Moderna
- NavigationSplitView nativo do macOS
- Toolbar customizada com controles intuitivos
- Atalhos de teclado (⌘R para atualizar)
- Design responsivo e adaptativo

## Requisitos

- **macOS 13.0** (Ventura) ou superior
- **Xcode 15.0** ou superior
- Conexão com internet para acessar a API do AniList

## Instalação e Execução

1. **Clone o repositório ou copie os arquivos do projeto**

2. **Abra o projeto no Xcode**
   ```bash
   cd AnimesEmAltaMac
   open AnimesEmAltaMac.xcodeproj
   ```
   
   Ou crie um novo projeto no Xcode:
   - File → New → Project
   - Choose macOS → App
   - Product Name: `AnimesEmAltaMac`
   - Interface: SwiftUI
   - Language: Swift
   - Copie os arquivos para o projeto

3. **Configure o projeto**
   - Target: macOS 13.0+
   - Bundle Identifier: `com.seudominio.AnimesEmAltaMac`
   - Adicione os arquivos mantendo a estrutura de pastas

4. **Compile e execute**
   - Pressione ⌘R ou clique no botão Play
   - O app será compilado e executado

## Estrutura do Projeto

```
AnimesEmAltaMac/
├── AnimesEmAltaMacApp.swift          # Entry point da aplicação
├── Features/
│   └── Trending/
│       ├── Models/
│       │   └── Anime.swift           # Modelos de dados (Codable)
│       ├── Networking/
│       │   └── AnimeService.swift    # Serviço de API GraphQL
│       ├── ViewModels/
│       │   └── AnimeListViewModel.swift  # ViewModel com paginação
│       └── Views/
│           ├── AnimeListView.swift   # View principal com sidebar
│           ├── AnimeDetailView.swift # View de detalhes
│           └── AnimeRow.swift        # Componente de linha da lista
├── Shared/
│   ├── Components/
│   │   └── ErrorStateView.swift      # View de estado de erro
│   └── Utils/
│       ├── NetworkError.swift        # Enum de erros de rede
│       └── URLRequest+GraphQL.swift  # Extension para requisições
├── Resources/
│   ├── Assets.xcassets               # Assets do projeto
│   └── Localizable.strings           # Localização pt-BR
└── Tests/
    └── AnimesEmAltaMacTests/
        ├── AnimeModelTests.swift      # Testes dos modelos
        └── URLRequestGraphQLTests.swift # Testes de requisições
```

## Arquitetura

### MVVM Leve
- **Models**: Estruturas Codable para deserialização JSON
- **ViewModels**: ObservableObject com @Published para estado reativo
- **Views**: SwiftUI puro com componentes reutilizáveis
- **Service**: Actor para thread-safety nas chamadas de rede

### Principais Decisões Técnicas

1. **Sem Dependências Externas**: Utiliza apenas frameworks nativos da Apple
2. **Async/Await**: Concorrência moderna do Swift para operações assíncronas
3. **@MainActor**: Garante atualizações de UI na thread principal
4. **URLCache**: Cache automático de respostas HTTP
5. **AsyncImage**: Carregamento e cache de imagens nativo

## API AniList

### Endpoints Utilizados

**URL Base**: `https://graphql.anilist.co`

**Query de Lista (Trending)**:
```graphql
query ($page: Int, $perPage: Int) {
  Page(page: $page, perPage: $perPage) {
    media(type: ANIME, sort: TRENDING_DESC) {
      id
      title { romaji english native }
      coverImage { medium large extraLarge }
      averageScore
      popularity
      episodes
      seasonYear
    }
  }
}
```

**Query de Detalhes (Sinopse)**:
```graphql
query ($id: Int) {
  Media(id: $id, type: ANIME) {
    id
    description(asHtml: false)
  }
}
```

### Limites e Políticas
- API pública sem necessidade de autenticação
- Rate limiting generoso para uso normal
- Respeite os [Termos de Uso](https://anilist.co/terms) do AniList
- Cache local reduz requisições redundantes

## Funcionalidades Detalhadas

### Paginação
- Carrega 20 itens por página
- Detecção automática ao chegar próximo ao fim da lista
- Indicador visual durante carregamento

### Busca Local
- Filtro em tempo real sem nova requisição
- Case-insensitive
- Busca no título preferencial (English → Romaji → Native)

### Estados da Aplicação
- **Carregando**: ProgressView com mensagem
- **Erro**: Tela dedicada com opção de retry
- **Vazio**: ContentUnavailableView informativa
- **Conteúdo**: Lista interativa com seleção

### Acessibilidade
- VoiceOver totalmente suportado
- Labels descritivos para todos elementos
- Dynamic Type para textos ajustáveis
- Contraste adequado em ambos os temas

## Testes

Execute os testes unitários no Xcode:
- ⌘U para rodar todos os testes
- Cobertura focada em:
  - Decodificação de modelos JSON
  - Formatação de dados para exibição
  - Construção de requisições GraphQL

## Atalhos de Teclado

- **⌘R**: Atualizar lista
- **⌘F**: Focar na busca
- **⌘O**: Abrir anime selecionado no AniList
- **↑↓**: Navegar na lista
- **Enter**: Selecionar anime

## Troubleshooting

### Problema: Lista não carrega
- Verifique conexão com internet
- Confirme que a API do AniList está online
- Tente o botão "Tentar novamente"

### Problema: Imagens não aparecem
- AsyncImage pode demorar no primeiro carregamento
- Cache será usado em acessos subsequentes

### Problema: App não compila
- Confirme versão mínima do macOS (13.0)
- Verifique versão do Xcode (15.0+)
- Limpe build folder (⌘⇧K) e tente novamente

## Contribuindo

Contribuições são bem-vindas! Por favor:
1. Fork o projeto
2. Crie uma feature branch
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## Licença

Este projeto é disponibilizado sob a licença MIT. Veja o arquivo LICENSE para detalhes.

## Agradecimentos

- [AniList](https://anilist.co) pela excelente API pública
- Comunidade Swift/SwiftUI pelos recursos e documentação
- Apple pelos frameworks nativos poderosos

## Contato

Para dúvidas, sugestões ou reportar bugs, abra uma issue no GitHub.

---

Desenvolvido com ❤️ para a comunidade macOS e anime