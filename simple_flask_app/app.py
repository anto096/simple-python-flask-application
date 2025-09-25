from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Flask + Nexus packaging demo!"

if __name__ == "__main__":
    # Bind to all interfaces, port 5000
    app.run(host="0.0.0.0", port=5000, debug=True)
