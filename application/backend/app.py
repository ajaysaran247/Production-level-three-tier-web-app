from flask import Flask, jsonify
from database import get_connection

app = Flask(__name__)

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
            # ✅ FIX: Added backticks around `current_time`
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
    # Note: If your Docker run command uses "-p 80:80", change port to 80 below.
    # If your Docker run command uses "-p 80:5000", leave it as 5000!
    app.run(host="0.0.0.0", port=5000)