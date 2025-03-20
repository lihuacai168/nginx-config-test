from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    return jsonify({
        'received_path': f'/{path}' if path else '/',
        'full_url': request.url,
        'method': request.method
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000) 