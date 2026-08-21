from flask import Flask, jsonify
from flask_cors import CORS
from database import get_connection

app = Flask(__name__)

CORS(app)

@app.route("/")
def home():
    return jsonify({
        "message": "Production Three Tier Application",
        "status": "Running"
    })

@app.route("/health")
def health():
    return jsonify({
        "status": "Healthy"
    })

@app.route("/database")
def database():
    try:
        connection = get_connection()

        with connection.cursor() as cursor:
            cursor.execute("SELECT NOW() AS `current_time`")
            result = cursor.fetchone()

        connection.close()

        return jsonify({
            "database": "Connected",
            "time": str(result["current_time"])
        })

    except Exception as e:
        return jsonify({
            "database": "Connection Failed",
            "error": str(e)
        }), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
