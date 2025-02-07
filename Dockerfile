FROM node:20.18.0

WORKDIR /app

# Install specific version of pnpm and wrangler
RUN npm install -g pnpm@8.15.1 && \
    npm install -g wrangler

# Copy dependency files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install

# Copy source code and scripts
COPY . .

# Ensure bindings.sh has correct permissions and format
RUN tr -d '\r' < bindings.sh > bindings.tmp && \
    mv bindings.tmp bindings.sh && \
    chmod +x bindings.sh

# Build the application
RUN pnpm run build

# Expose port
EXPOSE 5173

# Set environment variables
ENV NODE_ENV=production \
    RUNNING_IN_DOCKER=true

# Start command
CMD ["pnpm", "run", "dockerstart"]