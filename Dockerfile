FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source files
COPY . .

# Build the project
RUN npm run build

# Default command
CMD ["npm", "run", "build"]
