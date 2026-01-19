import pandas as pd
import re
import os

# 1. Load Data
# We look for emails.csv in the same folder
print("Loading emails.csv...")
if not os.path.exists("emails.csv"):
    print("Error: Could not find emails.csv. Make sure it is in this folder!")
    exit()

# Load the CSV
# Pandas reads CSVs much simpler than Spark for local files
try:
    df = pd.read_csv("emails.csv", names=["file", "message"], header=0)
except Exception as e:
    print(f"Error reading CSV: {e}")
    exit()

# 2. Define the Parser
def parse_email(message):
    parsed = {}
    if not isinstance(message, str):
        return None
    
    # Regex patterns to find email metadata
    patterns = {
        'Message-ID': r'Message-ID: <(.+)>',
        'Date': r'Date: (.+)',
        'From': r'From: (.+)',
        'To': r'To: (.+)',
        'Subject': r'Subject: (.+)',
        'X-From': r'X-From: (.+)',
        'X-To': r'X-To: (.+)'
    }
    
    for key, pattern in patterns.items():
        match = re.search(pattern, message)
        if match:
            parsed[key] = match.group(1)
            
    # Extract Body (everything after the first double newline)
    match_body = re.search(r'\n\n(.+)', message, re.DOTALL)
    if match_body:
        parsed['Body'] = match_body.group(1)
    
    return parsed

print("Parsing emails... (This might take a moment)")

# Apply the parser to the message column
parsed_data = df['message'].apply(parse_email)
# Convert the list of dictionaries into a new DataFrame
df_parsed = pd.json_normalize(parsed_data)

# Combine original file info with parsed data
df_cleaned = pd.concat([df['file'], df_parsed], axis=1)

# ==========================================
# QUESTIONS & ANSWERS (Pandas Version)
# ==========================================

print("\n--- Question 1: Mean number of emails per sender ---")
# Count total emails and unique senders
total_emails = len(df_cleaned)
unique_senders = df_cleaned['From'].nunique()

if unique_senders > 0:
    mean_emails = total_emails / unique_senders
    print(f"Mean emails per sender: {mean_emails:.2f}")
else:
    print("No unique senders found.")

print("\n--- Question 2: Top 10 Senders ---")
# Filter for valid emails and count
if 'From' in df_cleaned.columns:
    top_senders = df_cleaned['From'].value_counts().head(10)
    print(top_senders)
else:
    print("Column 'From' not found.")

print("\n--- Question 3: Internal Enron Emails ---")
# Extract domains safely
if 'From' in df_cleaned.columns and 'To' in df_cleaned.columns:
    # Helper function to get domain
    def get_domain(email):
        if isinstance(email, str) and '@' in email:
            return email.split('@')[1].strip().lower()
        return None

    df_cleaned['From_Domain'] = df_cleaned['From'].apply(get_domain)
    # Note: 'To' field often contains multiple emails, we just check the first one for simplicity here
    df_cleaned['To_Domain'] = df_cleaned['To'].apply(get_domain)

    internal_count = len(df_cleaned[
        (df_cleaned['From_Domain'] == 'enron.com') & 
        (df_cleaned['To_Domain'] == 'enron.com')
    ])
    print(f"Number of internal Enron-to-Enron emails: {internal_count}")

print("\n--- Question 4: Top Word Frequencies (Subject) ---")
try:
    # Simple stopword list to avoid needing an external file
    stopwords = {'the', 'a', 'an', 'in', 'on', 'at', 'to', 'for', 'of', 'and', 'or', 'is', 'fw', 're'}
    
    if 'Subject' in df_cleaned.columns:
        # Get all subjects, lowercase, remove non-alpha
        subjects = df_cleaned['Subject'].dropna().str.lower().str.replace(r'[^a-z\s]', '', regex=True)
        
        # Split into words and explode to a single list
        all_words = subjects.str.split().explode()
        
        # Filter out stopwords
        filtered_words = all_words[~all_words.isin(stopwords)]
        
        print("Top 20 words in Subject lines:")
        print(filtered_words.value_counts().head(20))

except Exception as e:
    print(f"Could not run Word Frequency analysis: {e}")