#!/bin/bash
# ============================================================
# 🚀 Script de Upload — Marcelly França Personal → GitHub
# ============================================================
# Execute este script na pasta raiz do projeto extraído
# Uso: bash upload-github.sh
# ============================================================

# ---------- COR --------
GREEN='\033[0;32m'
PINK='\033[0;35m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo -e "${PINK}╔══════════════════════════════════════════╗${NC}"
echo -e "${PINK}║   💪 Marcelly França Personal             ║${NC}"
echo -e "${PINK}║   Upload para GitHub                     ║${NC}"
echo -e "${PINK}╚══════════════════════════════════════════╝${NC}"
echo ""

# 1. Verificar se Git está instalado
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git não encontrado. Instale em: https://git-scm.com${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Git encontrado: $(git --version)${NC}"

# 2. Pedir URL do repositório
echo ""
echo -e "${YELLOW}📋 Informe a URL do seu repositório GitHub:${NC}"
echo -e "   Exemplo: https://github.com/marcellyfranca/marcelly-franca-personal"
echo -n "   URL: "
read REPO_URL

if [ -z "$REPO_URL" ]; then
    echo -e "${RED}❌ URL não informada. Saindo.${NC}"
    exit 1
fi

# Extrair usuário do GitHub da URL
GITHUB_USER=$(echo $REPO_URL | sed 's|https://github.com/||' | cut -d'/' -f1)
REPO_NAME=$(echo $REPO_URL | sed 's|https://github.com/||' | cut -d'/' -f2)

echo ""
echo -e "${GREEN}✅ Repositório: ${REPO_URL}${NC}"
echo -e "${GREEN}✅ Usuário: ${GITHUB_USER}${NC}"

# 3. Configurar git (se necessário)
GIT_NAME=$(git config --global user.name 2>/dev/null)
GIT_EMAIL=$(git config --global user.email 2>/dev/null)

if [ -z "$GIT_NAME" ]; then
    echo ""
    echo -e "${YELLOW}⚙️  Configure seu nome no Git:${NC}"
    echo -n "   Seu nome: "
    read GIT_NAME_INPUT
    git config --global user.name "$GIT_NAME_INPUT"
fi

if [ -z "$GIT_EMAIL" ]; then
    echo -e "${YELLOW}⚙️  Configure seu email no Git (mesmo do GitHub):${NC}"
    echo -n "   Seu email: "
    read GIT_EMAIL_INPUT
    git config --global user.email "$GIT_EMAIL_INPUT"
fi

echo -e "${GREEN}✅ Git configurado: $(git config --global user.name) <$(git config --global user.email)>${NC}"

# 4. Verificar/Inicializar repositório
echo ""
echo -e "${YELLOW}🔄 Preparando repositório local...${NC}"

if [ ! -d ".git" ]; then
    git init
    git checkout -b main
    echo -e "${GREEN}✅ Repositório Git inicializado${NC}"
else
    echo -e "${GREEN}✅ Repositório Git existente encontrado${NC}"
fi

# 5. Adicionar todos os arquivos
echo ""
echo -e "${YELLOW}📦 Adicionando arquivos ao commit...${NC}"
git add .
git status --short | head -20
echo ""

# 6. Criar commit (se houver mudanças)
if git diff --cached --quiet; then
    echo -e "${GREEN}✅ Nenhuma mudança nova — commit existente será usado${NC}"
else
    git commit -m "feat: Marcelly França Personal - App premium de personal training completo"
    echo -e "${GREEN}✅ Commit criado!${NC}"
fi

# 7. Configurar remote
echo ""
echo -e "${YELLOW}🔗 Configurando remote origin...${NC}"

# Remover remote existente se houver
git remote remove origin 2>/dev/null

# Adicionar novo remote
git remote add origin "$REPO_URL.git"
echo -e "${GREEN}✅ Remote configurado: $REPO_URL${NC}"

# 8. Push para GitHub
echo ""
echo -e "${YELLOW}🚀 Fazendo push para GitHub...${NC}"
echo -e "${YELLOW}   (Uma janela de autenticação pode abrir)${NC}"
echo ""

git push -u origin main --force

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${PINK}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${PINK}║   ✅ UPLOAD CONCLUÍDO COM SUCESSO!               ║${NC}"
    echo -e "${PINK}╠══════════════════════════════════════════════════╣${NC}"
    echo -e "${PINK}║   🔗 Repositório: ${REPO_URL}${NC}"
    echo -e "${PINK}║                                                  ║${NC}"
    echo -e "${PINK}║   📱 Para publicar com GitHub Pages:             ║${NC}"
    echo -e "${PINK}║   1. Acesse Settings → Pages                     ║${NC}"
    echo -e "${PINK}║   2. Source: Deploy from a branch                ║${NC}"
    echo -e "${PINK}║   3. Branch: gh-pages / root                     ║${NC}"
    echo -e "${PINK}║   4. URL: https://${GITHUB_USER}.github.io/${REPO_NAME}/     ║${NC}"
    echo -e "${PINK}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Erro no push. Tente:${NC}"
    echo -e "${YELLOW}   1. Verifique se o repositório existe no GitHub${NC}"
    echo -e "${YELLOW}   2. Confirme que você tem permissão de escrita${NC}"
    echo -e "${YELLOW}   3. Se usar autenticação de 2 fatores, use um Personal Access Token${NC}"
    echo -e "${YELLOW}      Crie em: https://github.com/settings/tokens${NC}"
    echo ""
    echo -e "${YELLOW}   Tente manualmente:${NC}"
    echo -e "   git push -u origin main --force"
fi
