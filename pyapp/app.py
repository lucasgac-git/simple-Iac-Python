from flask import Flask, render_template, request, redirect
from flask_mysqldb import MySQL

app = Flask(__name__)

# MySQL Configuration
app.config['MYSQL_HOST'] = '192.168.0.168'
app.config['MYSQL_USER'] = 'pycon'
app.config['MYSQL_PASSWORD'] = 'Pycon123!'
app.config['MYSQL_DB'] = 'users'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/add_user', methods=['POST'])
def add_user():
    if request.method == 'POST':
        name = request.form['name']
        age = request.form['age']
        email = request.form['email']

        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO clients (name, age, email) VALUES (%s, %s, %s)", (name, age, email))
        mysql.connection.commit()
        cur.close()

        return redirect('/users')

@app.route('/users')
def users():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM clients")
    users = cur.fetchall()
    cur.close()

    return render_template('users.html', users=users)

if __name__ == '__main__':
    app.run(host='192.168.0.38', port=5000, debug=True)