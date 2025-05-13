# Zymmo - App de Gastronomia Inteligente

Zymmo é uma plataforma colaborativa de gastronomia que permite aos usuários:

* Buscar receitas com base nos ingredientes que possuem
* Criar, salvar e compartilhar receitas e dicas culinárias
* Planejar compras com base nos ingredientes faltantes
* Participar de uma rede social gastronômica com curtidas, comentários e seguidores

Este repositório contém o código-fonte do aplicativo desenvolvido com **Flutter** e integrado com **Firebase**.

---

## 📁 Estrutura do Projeto

```
lib/
├── main.dart
├── models/
│   ├── user_model.dart
│   ├── post_model.dart
│   ├── recipe_model.dart
│   └── comment_model.dart
├── screens/
│   ├── auth/
│   └── main_app/
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
├── theme/
│   └── app_theme.dart
├── widgets/
│   ├── post_card.dart
│   └── comment_widget.dart
└── routes/
    └── app_routes.dart
```

---

## 🚀 Como rodar o projeto (localmente)

> Recomendado para desenvolvedores

### Requisitos:

* Flutter instalado ([https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install))
* Firebase CLI (opcional para deploy)

```bash
flutter pub get
flutterfire configure
flutter run
```

---

## 🚜 Integração com Firebase

Este app usa:

* Firebase Auth (login social + email/senha)
* Cloud Firestore (usuários, posts, receitas, comentários)
* Firebase Storage (imagens de receitas, perfil, etc.)

**Arquivo necessário:**

* `google-services.json` (coloque em `/android/app`)
* `firebase_options.dart` será gerado automaticamente com `flutterfire configure`

---

## 🏠 Hosting + Builds

### GitHub + Firebase Hosting (opcional)

1. Conecte este repositório ao Firebase Hosting pelo console
2. Configure uma build para web (PWA) se quiser ter versão navegável

### Codemagic (build automático)

* Integre via GitHub para gerar APK/iOS automático

---

## 📊 Roadmap

* [x] MVP funcional (login, feed, postagens)
* [x] Firestore estruturado
* [ ] Lista de compras com precificação
* [ ] Perfil completo com seguidores
* [ ] Deploy no Google Play

---

## 🙏 Agradecimentos

Zymmo foi criado para transformar a maneira como cozinhamos, compartilhamos e nos conectamos através da comida.

---

**Licença:** MIT
