# Start from the official Node.js image 
FROM node:23

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json from the current directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code from the current directory
COPY . .

# Expose the port the app runs on
EXPOSE 3700

# Define the command to start the app
CMD ["npm", "start"]
