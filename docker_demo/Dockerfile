# Use an official Python runtime as a base image
FROM python:3.9-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
#RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME Docker

# Run app.py when the container launches
CMD ["python", "hello.py"]


#FROM python:3.9-slim: Specifies the base image to use. In this case, it uses an official Python 3.9 image with a slim (smaller) variant.
#
#WORKDIR /app: Sets the working directory inside the container to /app.
#
#COPY . /app: Copies the contents of the current directory (your application code) into the /app directory of the container.
#
#RUN pip install --no-cache-dir -r requirements.txt: Installs the dependencies specified in the requirements.txt file. This assumes you have a requirements.txt file with your Python dependencies.
#
#EXPOSE 80: Informs Docker that the container will listen on the specified network ports at runtime. This doesn't actually publish the port; it's more of a documentation feature.
#
#ENV NAME World: Sets an environment variable inside the container.
#
#CMD ["python", "app.py"]: Specifies the default command to run when the container starts. In this example, it runs the app.py script using Python.