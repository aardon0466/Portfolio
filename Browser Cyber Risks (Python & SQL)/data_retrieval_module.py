from database_module import connect_to_db

#def search_cves(browser_name, browser_version, db):
def search_cves(browser_name, db):
    # Code to search for CVE records based on browser name and version
    cve_data = []
    cursor = db.cursor()

    # Select all records from the database
    query = "SELECT * FROM CVE WHERE BrowserName = %s"
    val = (browser_name, )
    cursor.execute(query, (browser_name, ))
    results = cursor.fetchall()
    
    for result in results:
        cve_data.append(result)
    
    cursor.close()
    return cve_data
