import json

import requests
from database_module import connect_to_db, insert_cve

def fetch_and_populate_cve_data(browser_name):
    db = connect_to_db()
    if db is None:
        print("Failed to connect to the database.")
        return

    # Fetch CVE data from the NIST API
    url = "https://services.nvd.nist.gov/rest/json/cves/2.0?keywordSearch=" + browser_name
    response = requests.get(url)

    if response.status_code != 200:
        print(f"Error fetching data: {response.status_code}")
        return

    try:
        json_input = response.json()  # Assuming the data is in JSON format
    except ValueError as e:
        print(f"Error decoding JSON: {e}")
        print("Response content:", response.text)  # Log the raw response content
        return

    cve_records = json_input.__getitem__("vulnerabilities")

    # Check the structure of the returned data
    if not isinstance(cve_records, list):
        print("Expected a list of CVE records.")
        print("Response content:", cve_records)  # Log the unexpected response
        return

    for cve in cve_records:
        # Traverse the JSON
        record = cve["cve"]
        metrics = record["metrics"]
        cvs2 = metrics['cvssMetricV2']
        cvsList = cvs2[0]
        cvss_data = cvsList["cvssData"]

        descript = record["descriptions"]
        try:
            # Set the values for the record from the JSON
            cve_id = record['id']
            description = descript[0].__getitem__("value")
            severity = cvss_data['baseScore']

            # Insert each CVE record into the database
            insert_cve(db, cve_id, description, severity, browser_name)
        except KeyError as e:
            print(f"Missing expected field in record: {e}")
            print("Record content:", record)  # Log the problematic record

    db.close()
