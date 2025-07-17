A web-based Railway Management System built using Flask, HTML, CSS, and SQL.  
This project allows users to register, log in, search for trains, and book tickets.

---

## How to Run This Project Locally

Follow the steps below to set up the project on your machine:

### 1. Clone the repository
git clone https://github.com/Yatheen28/Railway_Management_System.git
cd Railway_Management_System

shell
Copy code

### 2. Create a virtual environment
python -m venv venv

graphql
Copy code

### 3. Activate the virtual environment
- On Windows:
venv\Scripts\activate

diff
Copy code
- On macOS/Linux:
source venv/bin/activate

shell
Copy code

### 4. Install the required packages
pip install -r requirements.txt

r
Copy code

If `requirements.txt` is missing, install Flask manually:
pip install flask

shell
Copy code

### 5. Run the application
python app.py

yaml
Copy code

Now open your browser and go to:  
http://127.0.0.1:5000/

---

## Project Structure

- app.py – Main Flask application
- dbms_project.sql – SQL schema for the database
- templates/ – HTML files for frontend
- static/ – CSS styles
- README.md – This file
