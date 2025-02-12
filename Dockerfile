FROM node:20.18.0

WORKDIR /app

# Copiar arquivos de dependências
COPY package.json pnpm-lock.yaml ./

RUN corepack enable
ENV COREPACK_DEFAULT_TO_LATEST=0
RUN corepack install
RUN pnpm install

# Instalar pnpm e wrangler
RUN pnpm setup
RUN pnpm install -g wrangler

# Instalar dependências
# RUN pnpm install

# Copiar código  fonte e scripts
COPY . .

# Garantir que o bindings.sh tem permissões de execução e formato correto
RUN tr -d '\r' < bindings.sh > bindings.tmp && \
    mv bindings.tmp bindings.sh && \
    chmod +x bindings.sh

# ENV GENERATE_SOURCEMAP=false
ENV NODE_OPTIONS=--max_old_space_size=3072

# Build da aplicação
RUN pnpm run build

# Expor porta
EXPOSE 5173

# Configurar variáveis de ambiente
ENV NODE_ENV=production \
    RUNNING_IN_DOCKER=true

# Comando para iniciar usando o script dockerstart
CMD ["pnpm", "run", "dockerstart"]