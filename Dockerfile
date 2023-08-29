# Use a base image with Python pre-installed
FROM python:3.9

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt /app/

# Update package list and install libpq-dev
RUN apt update && apt install -y libpq-dev
RUN apt update && apt install -y wget


# Update pip
RUN pip install --upgrade pip

# Install the required Python packages
RUN pip install --no-cache-dir -r requirements.txt

# install celery
COPY run.sh /app/run.sh
RUN chmod +x ./run.sh
RUN ./run.sh

# Copy the project files into the container
COPY ./backend/. /app/

# Expose the port that Django runs on
EXPOSE 8000

# Start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
