# Use the official Python image from Docker Hub
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Python script into the container
COPY first_coffee_app.py .

# Set the default command to run the app
CMD ["python", "first_coffee_app.py"]

