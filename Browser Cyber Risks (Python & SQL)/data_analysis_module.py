from database_module import connect_to_db

def calculate_weighted_average(severity_scores):
    if not severity_scores:
        return 0
    return sum(severity_scores) / len(severity_scores)

def compare_browsers(browser_name, db):
    # Code to analyze the CVE data and calculate the aggregated cyber risk score
    cursor = db.cursor()

    # Retrieve severity scores from the database
    query = "SELECT Severity FROM CVE WHERE BrowserName = %s"
    cursor.execute(query, (browser_name, ))
    severity_scores = [row[0] for row in cursor.fetchall()]  # Extract severity scores

    # Calculate the aggregated cyber risk score
    risk_score = calculate_weighted_average(severity_scores)
    
    # Scale score from 0 to 10
    risk_score = min(max(risk_score, 0), 10)  # Ensure score is within bounds
    
    cursor.close()
    return risk_score
