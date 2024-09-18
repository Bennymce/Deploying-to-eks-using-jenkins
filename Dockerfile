# Use Node.js as base image
FROM node:16

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json ./
RUN npm install

# Copy source code and build
COPY . .
RUN npm run build

# Expose application port (optional)
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
