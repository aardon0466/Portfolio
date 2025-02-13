def display_results(cve_data):
    # Code to present the CVE data to the user
    if not cve_data:
        print("No CVE records found.")
        return
    
    print("CVE Records:")
    for cve in cve_data:
        print(f"CVE ID: {cve[0]}, Description: {cve[1]}, Severity: {cve[2]}")
