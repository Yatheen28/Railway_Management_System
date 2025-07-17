import mysql.connector 
from flask import Flask, render_template, request, redirect, url_for, session, flash 
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'dbms-project-secret-key'

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'Yatheen@1528',  
    'database': 'dbms_project'
}

def get_db_connection():
    try:
        conn = mysql.connector.connect(**db_config)
        return conn
    except mysql.connector.Error as err:
        print(f"Database Connection Error: {err}")
        return None

@app.route('/')
def home():
    return redirect(url_for('login'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        password = request.form.get('password')
        if not name or not email or not password:
            flash('All fields are required!', 'danger')
            return redirect(url_for('register'))
        conn = get_db_connection()
        if conn is None or not conn.is_connected():
            flash('Database service unavailable. Please try again later.', 'danger')
            return redirect(url_for('register'))
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT user_id FROM users WHERE email = %s", (email,))
        existing_user = cursor.fetchone()
        if existing_user:
            flash('Email address already registered.', 'warning')
            return redirect(url_for('register'))
        
        cursor.execute("INSERT INTO users (name, email, password, role) VALUES (%s, %s, %s, %s)",
                       (name, email, password, 'user'))
        conn.commit()
        cursor.close()
        conn.close()
        flash('Registration successful! Please login.', 'success')
        return redirect(url_for('login'))
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password_candidate = request.form.get('password')
        if not email or not password_candidate:
            flash('Email and password are required!', 'danger')
            return redirect(url_for('login'))
        conn = get_db_connection()
        if conn is None or not conn.is_connected():
            flash('Database service unavailable. Please try again later.', 'danger')
            return redirect(url_for('login'))
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT user_id, name, email, password, role FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        if user and user['password']== password_candidate:
            session['loggedin'] = True
            session['user_id'] = user['user_id']
            session['name'] = user['name']
            session['role'] = user['role']
            flash('Login successful!', 'success')
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid email or password.', 'danger')
            return redirect(url_for('login'))
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out.', 'success')
    return redirect(url_for('login'))

@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        flash('Please log in to view the dashboard.', 'warning')
        return redirect(url_for('login'))
    user_id = session['user_id']
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT name, email FROM users WHERE user_id = %s", (user_id,))
    user_details = cursor.fetchone()
    cursor.execute("""
        SELECT
            b.booking_id,
            t.name AS train_name,
            s.date AS travel_date,
            dep_st.name AS departure_station_name,
            arr_st.name AS arrival_station_name,
            s.dep_time,
            s.arr_time,
            b.seat_no,
            b.status
        FROM bookings b
        JOIN schedules s ON b.schedule_id = s.schedule_id
        JOIN trains t ON s.train_id = t.train_id
        JOIN stations dep_st ON s.departure_station = dep_st.station_id
        JOIN stations arr_st ON s.arrival_station = arr_st.station_id
        WHERE b.user_id = %s
        ORDER BY s.date, s.dep_time
    """, (user_id,))
    bookings_list = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('dashboard.html', user=user_details, bookings=bookings_list)

@app.route('/search', methods=['GET', 'POST'])
def search():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT station_id, name FROM stations")
    stations = cursor.fetchall()
    if request.method == 'POST':
        departure_station_id = request.form['departure_station']
        arrival_station_id = request.form['arrival_station']

        travel_date = request.form['travel_date']
        try:
            date_obj = datetime.strptime(travel_date, '%Y-%m-%d')
            travel_date_formatted = date_obj.strftime('%Y-%m-%d')
        except ValueError:
            flash('Invalid date format. Please use YYYY-MM-DD.', 'danger')
            return render_template('search.html', stations=stations)
        cursor.execute("""
            SELECT
                s.schedule_id,
                t.train_id,
                t.name AS train_name,
                s.date AS travel_date,
                dep_st.name AS departure_station_name,
                arr_st.name AS arrival_station_name,
                s.dep_time,
                s.arr_time
            FROM schedules s
            JOIN trains t ON s.train_id = t.train_id
            JOIN stations dep_st ON s.departure_station = dep_st.station_id
            JOIN stations arr_st ON s.arrival_station = arr_st.station_id
            WHERE s.departure_station = %s
            AND s.arrival_station = %s
            AND s.date = %s
            ORDER BY s.dep_time
        """, (departure_station_id, arrival_station_id, travel_date_formatted))
        results = cursor.fetchall()
        cursor.close()
        conn.close()
        if results:
            return render_template('search_results.html', results=results, stations=stations)
        else:
            flash("No trains found for the selected route and date.", "info")
            return render_template('search.html', stations=stations)
    cursor.close()
    conn.close()
    return render_template('search.html', stations=stations)

@app.route('/book/<int:schedule_id>', methods=['GET', 'POST'])
def book(schedule_id):
    if 'user_id' not in session:
        flash('Please log in to book tickets.', 'warning')
        return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT t.name AS train_name, s.date, s.dep_time, s.arr_time
        FROM schedules s
        JOIN trains t ON s.train_id = t.train_id
        WHERE s.schedule_id = %s
    """, (schedule_id,))
    schedule = cursor.fetchone()
    cursor.execute("SELECT seat_no FROM bookings WHERE schedule_id = %s AND status = 'confirmed'", (schedule_id,))
    booked_seats = [row['seat_no'] for row in cursor.fetchall()]
    all_seats = [f"{row}{num}" for row in 'ABCD' for num in range(1, 21)]
    available_seats = [seat for seat in all_seats if seat not in booked_seats]
    if request.method == 'POST':
        seat_no = request.form['seat_no']
        user_id = session['user_id']
        cursor.execute("SELECT train_id FROM schedules WHERE schedule_id = %s", (schedule_id,))
        train = cursor.fetchone()
        train_id = train['train_id'] if train else None
        if seat_no not in available_seats:
            flash('Seat already booked or invalid seat.', 'danger')
            return render_template('book.html', schedule_id=schedule_id, available_seats=available_seats)
        cursor.execute("""
            INSERT INTO bookings (user_id, train_id, schedule_id, seat_no, status)
            VALUES (%s, %s, %s, %s, 'confirmed')
        """, (user_id, train_id, schedule_id, seat_no))
        conn.commit()
        cursor.close()
        conn.close()
        flash(f'Seat {seat_no} booked successfully!', 'success')
        return redirect(url_for('dashboard'))
    cursor.close()
    conn.close()
    return render_template('book.html', schedule_id=schedule_id, available_seats=available_seats)

if __name__ == '__main__':
    app.run(debug=True)
