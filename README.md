# Rick and Morty SwiftUI App

Este é um aplicativo iOS simples, construído com SwiftUI, que exibe uma lista de personagens da famosa série de TV "Rick and Morty". O aplicativo consome dados de uma API pública para buscar e mostrar os personagens.

## Visão Geral

O objetivo deste projeto é demonstrar uma arquitetura limpa e moderna para desenvolvimento iOS utilizando SwiftUI, seguindo o padrão MVVM (Model-View-ViewModel).

## Estrutura do Projeto

O código-fonte está organizado nas seguintes pastas:

### Estrutura de Pastas
```bash
RickAndMortyApp
├── README.md
├── RickAndMortyApp
│   ├── App
│   ├── Assets.xcassets
│   ├── Components
│   ├── Models
│   │   ├── Character
│   │   ├── Episode
│   │   └── Location
│   ├── Resources
│   ├── Services
│   ├── Utilities
│   ├── ViewModels
│   │   ├── Episode
│   │   ├── Home
│   │   └── Location
│   └── Views
│       ├── CharacterDetail
│       └── Home
├── RickAndMortyApp.xcodeproj
└── RickAndMortyAppTests
    ├── Mocks
    │   └── Services
    └── ViewModels
```
## Funcionalidades

-   Exibição de uma lista de personagens de Rick and Morty.
-   Busca de dados de forma assíncrona a partir de uma API REST.
-   Interface de usuário reativa construída inteiramente com SwiftUI.
-   Arquitetura MVVM para uma clara separação de responsabilidades.

## Tecnologias Utilizadas

-   **SwiftUI:** Para a construção da interface de usuário.
-   **Combine:** (Implícito no uso de `@Published` e `ObservableObject`) para programação reativa e gerenciamento de estado.
-   **URLSession:** Para realizar as chamadas de rede à API.
-   **Xcode:** Ambiente de desenvolvimento.

## Como Executar o Projeto

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/Santosfael/RickAndMortyApp
    ```
2.  **Abra no Xcode:**
    Navegue até a pasta do projeto e abra o arquivo `RickAndMortyApp.xcodeproj`.
    ```bash
    cd RickAndMortyApp
    open RickAndMortyApp.xcodeproj
    ```
3.  **Compile e Execute:**
    Selecione um simulador de iPhone ou um dispositivo físico e pressione o botão "Run" (▶) no Xcode.

O aplicativo será compilado e instalado, e você poderá ver a lista de personagens carregada da API.
