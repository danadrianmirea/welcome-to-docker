# Use a specific Node version to ensure consistency across builds
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install dependencies (this layer will be cached unless package.json or package-lock.json changes)
RUN npm install \
    && npm install -g serve

# Copy the rest of the application files after dependencies are installed
COPY ./src ./src
COPY ./public ./public

# Build the app and remove unnecessary files (this will only run if source code changes)
RUN npm run build \
    && rm -rf node_modules

# Expose the port that the app will be served on
EXPOSE 3000

# Start the app using the 'serve' command to serve the built files
CMD [ "serve", "-s", "build" ]