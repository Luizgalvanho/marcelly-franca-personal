# 💪 Marcelly França Personal

> App premium de personal training — Flutter Web PWA

![Flutter](https://img.shields.io/badge/Flutter-3.35.4-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
![PWA](https://img.shields.io/badge/PWA-Instalável-FF1493)
![License](https://img.shields.io/badge/License-Privado-black)

---

## 🎯 Sobre o App

Plataforma completa de personal training desenvolvida para **Marcelly França Personal**, com identidade visual sofisticada, feminina e moderna.

### ✨ Funcionalidades
- 🏋️ **Meu Treino** — fichas personalizadas por dia/músculo, cargas, séries, histórico
- 📹 **Vídeos Online** — biblioteca de aulas categorizadas com YouTube
- 📅 **Agenda** — calendário de treinos, aulas e avaliações
- 📊 **Evolução Corporal** — avaliação física completa com gráficos
- 🥗 **Meu Plano** — dieta personalizada com macronutrientes
- 💧 **Hidratação** — controle de água gamificado
- 🏆 **Conquistas** — pontos, medalhas, desafios e ranking
- 👤 **Perfil** — dados pessoais, objetivos e histórico
- 🔧 **Painel Admin** — gestão completa para a personal

### 🎨 Design
- Tema escuro premium com neon pink `#FF1493`
- Cards com glassmorphism e bordas sutis
- Animações fluidas e transições elegantes
- PWA instalável (funciona como app nativo)

---

## 🚀 Como Rodar Localmente

### Pré-requisitos
- [Flutter SDK 3.35.4+](https://flutter.dev/docs/get-started/install)
- [Git](https://git-scm.com)
- Editor: VS Code ou Android Studio

### Passos

```bash
# 1. Clone o repositório
git clone https://github.com/SEU_USUARIO/marcelly-franca-personal.git
cd marcelly-franca-personal

# 2. Instale as dependências
flutter pub get

# 3. Rode na web
flutter run -d chrome

# 4. Build para produção
flutter build web --release
```

---

## 📱 Instalar como App (PWA)

**Android (Chrome):**
1. Abra o link no Chrome
2. Menu (⋮) → "Adicionar à tela inicial"

**iPhone (Safari):**
1. Abra no Safari
2. Compartilhar (□↑) → "Adicionar à Tela de Início"

---

## 🔑 Credenciais de Demo

| Perfil | Email | Senha |
|--------|-------|-------|
| 🏃 Aluna | `aluna@email.com` | `123456` |
| 💼 Personal | `marcelly@personal.com` | `123456` |

---

## 🌐 Deploy — GitHub Pages

Após o push, o GitHub Pages publica automaticamente o app em:
```
https://SEU_USUARIO.github.io/marcelly-franca-personal/
```

---

## 📦 Estrutura do Projeto

```
lib/
├── main.dart              # Ponto de entrada
├── models/                # Modelos de dados
├── screens/               # Telas do app
│   ├── auth/              # Login e cadastro
│   ├── dashboard/         # Dashboard principal
│   ├── training/          # Treinos
│   ├── videos/            # Vídeos online
│   ├── schedule/          # Agenda
│   ├── assessment/        # Avaliação física
│   ├── diet/              # Plano alimentar
│   ├── hydration/         # Hidratação
│   ├── gamification/      # Conquistas
│   ├── profile/           # Perfil
│   └── admin/             # Painel admin
├── services/              # Serviços e APIs
├── utils/                 # Utilitários
├── widgets/               # Widgets reutilizáveis
└── theme/                 # Tema e estilos
```

---

## 👩‍💼 Desenvolvido para
**Marcelly França Personal** — Personal Trainer Premium

---

*Desenvolvido com ❤️ usando Flutter*
