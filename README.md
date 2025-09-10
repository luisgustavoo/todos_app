# 📋 Todos App

Aplicativo de **lista de tarefas (To-Do List)** desenvolvido em **Flutter** como parte de um **teste técnico para a Idez**.  
O projeto tem como objetivo demonstrar organização de código, boas práticas de arquitetura e utilização de testes automatizados no Flutter.  

Este app utiliza a **arquitetura recomendada pela documentação oficial do Flutter** ([Flutter App Architecture](https://docs.flutter.dev/app-architecture)).

---

## 🚀 Funcionalidades

- ✅ Adicionar tarefas  
- 🗑️ Remover tarefas  
- ✔️ Marcar tarefas como concluídas  
- 🔍 Filtrar tarefas (todas, concluídas e pendentes)  
- 🌐 Suporte a múltiplos idiomas (i18n/l10n)  

---

## 🛠️ Tecnologias Utilizadas

- [Flutter](https://flutter.dev/) (SDK estável mais recente)  
- [SharedPreferences](https://pub.dev/packages/shared_preferences) – armazenamento local  
- [GetIt](https://pub.dev/packages/get_it) + [Injectable](https://pub.dev/packages/injectable) – injeção de dependências  
- [Freezed](https://pub.dev/packages/freezed) – modelos de dados imutáveis  
- [Flutter Localizations](https://docs.flutter.dev/development/accessibility-and-localization/internationalization) – internacionalização  
- Testes com `flutter_test` e `mocktail`  

---

## 📂 Estrutura do Projeto

```text
lib/
 ├─ config/          # Configurações e injeção de dependências
 ├─ data/            # Fontes de dados (SharedPreferences)
 ├─ domain/          # Entidades e contratos
 ├─ routing/         # Definições de rotas
 ├─ ui/              # Camada de apresentação (telas, widgets, temas, l10n)
 └─ main.dart        # Ponto de entrada
```

### 🧪 Rodando todos os testes
flutter test

### 🧪 Rodando testes de integração em dispositivo/emulador
flutter test integration_test

## Clone este repositório
```text
git clone https://github.com/luisgustavoo/todos_app.git
cd todos_app
flutter pub get
flutter run
```