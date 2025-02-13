from database_module import connect_to_db
from data_retrieval_module import search_cves
from data_analysis_module import compare_browsers
from ui_module import display_results
from data_integration_module import fetch_and_populate_cve_data

def main():

    # Initialize database connection
    db_conn = connect_to_db()

    # Retrieve user input (browser name and version)
    browser_name = input("Enter browser name (e.g., Chrome, Firefox): ")

    # Fetch CVE data and display results
    fetch_and_populate_cve_data(browser_name)
    cve_data = search_cves(browser_name, db_conn)
    display_results(cve_data)

    # Analyze and compare browser security
    risk_score = compare_browsers(browser_name, db_conn)
    print(f"Aggregated cyber risk score for {browser_name}: {risk_score:.2f}")

    # Close the database connection
    db_conn.close()

if __name__ == "__main__":
    main()
