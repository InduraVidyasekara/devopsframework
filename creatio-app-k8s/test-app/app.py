#!/usr/bin/env python3

from flask import Flask, request, jsonify
import redis
import pika
import pymongo
from bson.objectid import ObjectId


# Configuration
REDIS_HOST = '10.233.14.66'  # Change to your Redis host
REDIS_PORT = 6379               # Default Redis port
# REDIS_USER = 'default'      # Redis user
# REDIS_PASSWORD = 'CreatioRedis'  # If Redis requires a password

# Initialize Flask app
app = Flask(__name__)

RABBITMQ_HOST = '10.233.3.108'
QUEUE_NAME = 'test-gs-q'
VHOST= 'globalSearchVh'
USER='rabbitmq'
PASSWORD='rabbitmq'

MONGO_URI = "mongodb://192.168.102.25:27017/"  # Replace with your MongoDB URI if different
MONGO_DB = "testdb"
MONGO_COLLECTION = "messages"

def get_mongo_collection():
    client = pymongo.MongoClient(MONGO_URI)
    db = client[MONGO_DB]
    collection = db[MONGO_COLLECTION]
    return collection

# Connect to RabbitMQ
def get_rabbitmq_connection():
    credentials = pika.PlainCredentials(USER,PASSWORD)
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(
            host=RABBITMQ_HOST,
            virtual_host=VHOST,
            credentials=credentials
            )
    )
    return connection


@app.route('/rabbit-send', methods=['GET'])
def send_message():
    try:
        # Get message from query parameters
        message = request.args.get('message', 'Hello, RabbitMQ!')

        connection = get_rabbitmq_connection()
        channel = connection.channel()

        # Declare a queue
        channel.queue_declare(queue=QUEUE_NAME)

        # Publish the message to the queue
        channel.basic_publish(exchange='', routing_key=QUEUE_NAME, body=message)

        connection.close()

        return jsonify({'message': f'Sent: {message}'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/rabbit-receive', methods=['GET'])
def receive_message():
    try:
        connection = get_rabbitmq_connection()
        channel = connection.channel()

        # Declare a queue
        channel.queue_declare(queue=QUEUE_NAME)

        # Get a message from the queue
        method_frame, header_frame, body = channel.basic_get(queue=QUEUE_NAME)

        if method_frame:
            # Acknowledge that the message has been received
            channel.basic_ack(method_frame.delivery_tag)
            connection.close()
            return jsonify({'message': body.decode('utf-8')}), 200
        else:
            connection.close()
            return jsonify({'message': 'No messages in the queue'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Redis test connection endpoint
@app.route('/test-redis', methods=['GET'])
def test_redis_connection():
    # Get 'key' and 'value' from query parameters
    key = request.args.get('key')
    value = request.args.get('value')

    if not key or not value:
        return jsonify({
            "status": "error",
            "message": "Both 'key' and 'value' query parameters are required."
        }), 400

    try:
        # Connect to Redis
        r = redis.StrictRedis(
            host=REDIS_HOST,
            port=REDIS_PORT,
            # username=REDIS_USER,
            # password=REDIS_PASSWORD,
            decode_responses=True
        )

        # Write the key-value pair to Redis
        r.set(key, value)

        # Retrieve the value from Redis
        retrieved_value = r.get(key)

        # Verify if the value is correct
        if retrieved_value == value:
            return jsonify({
                "status": "success",
                "message": f"Redis connection successful. Retrieved value: {retrieved_value}",
                "key": key,
                "value": retrieved_value
            }), 200
        else:
             return jsonify({
                "status": "error",
                "message": f"Value mismatch: retrieved {retrieved_value} does not match {value}"
            }), 500

    except redis.ConnectionError as e:
        return jsonify({
            "status": "error",
            "message": f"Connection failed: {e}"
        }), 500
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": f"Error: {e}"
        }), 500

# MongoDB write endpoint
@app.route('/mongo-write', methods=['POST'])
def mongo_write():
    try:
        # Get the message from the POST request body (JSON)
        data = request.get_json()
        message = data.get('message', 'Hello, MongoDB!')

        # Insert message into MongoDB
        collection = get_mongo_collection()
        insert_result = collection.insert_one({'message': message})

        return jsonify({'inserted_id': str(insert_result.inserted_id), 'message': message}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# MongoDB read endpoint
@app.route('/mongo-read/<id>', methods=['GET'])
def mongo_read(id):
    try:
        collection = get_mongo_collection()

        # Find the message by ObjectId
        message = collection.find_one({'_id': ObjectId(id)})

        if message:
            return jsonify({'_id': str(message['_id']), 'message': message['message']}), 200
        else:
            return jsonify({'error': 'Message not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# Health check endpoint
@app.route('/healthz', methods=['GET'])
def health_check():
    return jsonify({
        "status": "healthy",
        "message": "API is running"
    }), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
