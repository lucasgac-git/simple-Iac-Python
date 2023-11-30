from flask import Flask, render_template, request, redirect
from flask_mysqldb import MySQL

app = Flask(__name__)

# MySQL Configuration
app.config['MYSQL_HOST'] = 'host ip'
app.config['MYSQL_USER'] = 'mysql user'
app.config['MYSQL_PASSWORD'] = 'user password'
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
        cur.execute("INSERT INTO users (name, age, email) VALUES (%s, %s, %s)", (name, age, email))
        mysql.connection.commit()
        cur.close()

        return redirect('/users')

@app.route('/users')
def users():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users")
    users = cur.fetchall()
    cur.close()

    return render_template('users.html', users=users)

if __name__ == '__main__':
    app.run(debug=True)