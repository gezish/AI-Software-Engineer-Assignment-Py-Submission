# Use an official, minimal and sufficient Python runtime as parent image
FROM python:3.14-slim

# Set the working directory in the container
WORKDIR /app

# Copy the dependencies file first (for better caching)
COPY requirements.txt .

# Install dependencies before runing any test
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Set the default command to run tests automatically on build
CMD ["python", "-m", "pytest", "-v"]