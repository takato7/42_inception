from flask import Flask, render_template
from werkzeug.middleware.proxy_fix import ProxyFix

app = Flask(__name__)

# if this app is behind a proxy server, the app needs to set these values
# https://flask.palletsprojects.com/en/stable/deploying/proxy_fix/
app.wsgi_app = ProxyFix(
    app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1
)

@app.route("/")
def hello_world():
	return render_template("index.html")
