# flask_web/app.py

from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Yo, we have Flask in an Azure Container Instance!'


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

