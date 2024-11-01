# Start from the official Node.js image (use a stable version like 18 or latest)
FROM node:18

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json from the project root
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code from the project root
COPY . .

# Expose the port the app runs on
EXPOSE 3700

# Define the command to start the app
CMD ["npm", "start"]
