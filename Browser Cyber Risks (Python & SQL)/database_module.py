import mysql.connector

def connect_to_db():
    # Code to establish a connection to the MySQL database
    try:
        db = mysql.connector.connect(
            host="localhost",
            user=" ",  # Replace with your MySQL username
            password=" ",  # Replace with your MySQL password
            database="BrowserSecurity"  # Ensure your database is created
        )
        return db
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None

def insert_cve(db, cve_id, description, severity, browser_name):
    # Code to insert a new CVE record into the database
    cursor = db.cursor()
    sql = "INSERT INTO CVE (ID, Description, Severity, BrowserName) VALUES (%s, %s, %s, %s)"
    val = (cve_id, description, severity, browser_name)
    cursor.execute(sql, val)
    db.commit()
    return cursor.rowcount

def get_cve_by_id(db, cve_id):
    # Code to retrieve a CVE record by its ID
    cursor = db.cursor()
    cursor.execute("SELECT * FROM CVE WHERE ID = %s", (cve_id,))
    result = cursor.fetchone()
    cursor.close()
    return result
