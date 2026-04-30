# Guia de Configuração RevenueCat (iOS & Android)

Este guia resume as etapas para criar as chaves de API produtivas e configurar a comunicação com as lojas.

## 1. No Dashboard do RevenueCat
1. Faça login no [RevenueCat](https://app.revenuecat.com/).
2. Selecione o seu **Projeto**.
3. Vá em **Project Settings** > **API Keys**.

## 2. Public API Keys (SDK)
As chaves públicas são usadas para inicializar o SDK no app.
- **iOS:** Gerada ao adicionar o app iOS em *Apps*.
- **Android:** Gerada ao adicionar o app Android em *Apps*.

> [!NOTE]
> A mesma **Public API Key** funciona para Sandbox e Produção. O RevenueCat detecta o ambiente automaticamente.

## 3. Configuração de Credenciais da Loja
Para vendas em produção, o RevenueCat precisa de permissão para validar recibos.

### iOS (App Store Connect API)
1. No [App Store Connect](https://appstoreconnect.apple.com/), vá em **Usuários e Acesso** > **Integrações** > **API do App Store Connect**.
2. Gere uma chave, baixe o arquivo `.p8`.
3. No RevenueCat: **Apps** > [Seu App iOS] > **App Store Connect API**.
4. Faça o upload do `.p8` e insira o *Issuer ID* e *Key ID*.

### Android (Google Service Account)
1. Crie uma **Service Account** no Google Cloud Console com acesso ao Google Play Console.
2. Gere um arquivo **JSON**.
3. No RevenueCat: **Apps** > [Seu App Android] > **Google Service Account**.
4. Faça o upload do JSON.

## 4. Variáveis de Ambiente (.env)
Adicione as chaves ao seu arquivo `.env` para facilitar o acesso:

```env
REVENUECAT_IOS_KEY=sua_chave_aqui
REVENUECAT_ANDROID_KEY=sua_chave_aqui
```
