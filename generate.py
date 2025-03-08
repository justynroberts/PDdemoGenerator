organization = "ORGANIZATION"      # Replace with your organization name
api_key = 'ADD YOUR KEY HERE'      # Replace with your OpenAI API key


from openai import OpenAI
import uuid
import os

# Initialize variables

output_directory = "./service_maps/"  # Directory to save the files

# Generate a unique session identifier
session_uuid = str(uuid.uuid4())

# Initialize the OpenAI client
client = OpenAI(api_key=api_key)

def query_openai_api(prompt_text):
    """Query the OpenAI Chat API and return the extracted content."""
    try:
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=[{"role": "user", "content": prompt_text}],
            temperature=1,
            max_tokens=4096
        )
        if response.choices and len(response.choices) > 0:
            content = response.choices[0].message.content
            return content
        else:
            print("No content was extracted from the response.")
            return None
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return None

def write_output_to_file(directory, filename, content):
    """Write the given content to a file in the specified directory."""
    # Ensure the output directory exists
    if not os.path.exists(directory):
        os.makedirs(directory)
    filepath = os.path.join(directory, filename)
    with open(filepath, 'w', encoding='utf-8') as file:
        file.write(content)
    print(f"Output written to {filepath}")

# Construct the prompt text
prompt_text="""
You are a fictitious company like """+organization+""", operating a Service-Oriented Architecture (SOA) with 25 realistic technical services and 4 top-level business services.

Instructions:
1. Generate 28 unique technical services with realistic, specific names such as Application Web, Core Database, and Authentication. Avoid generic names like Network or DevOps.
2. Generate 4 unique business services, categorized under business_service. These should be top-level services that rely on underlying technical services.
3. Define dependencies among services using Service IDs (1-30), separated by ; (semicolon). Avoid circular dependencies but allow multi-level dependencies.
4. Ensure accurate service flow, from customer-facing services to backend systems.
5. Pay attention to how data and services might be connected in a real architecture

Format the output strictly as CSV:
   - Header row:
     ServiceName,ServiceDescription,ServiceID,ServiceType,SupportingServices,EscPol
   - Data rows: Each service should be represented as follows:
     Recommendation Service,Offers personalized recommendations to users,23,service,3;5,
   - The last four entries should have business_service as their ServiceType.
   - Maintain exactly 32 rows of service data (excluding the header).
   - The EscPol column should be empty but included to maintain CSV integrity.End with a ,
   - Avoid circular dependencies

Output Format (Strict CSV Requirements):
- Do not include quotes (") around any values.
- Do not include row numbers.
- Do not prepend triple backticks (``` ) or any extraneous formatting.
- Ensure a valid CSV with the correct number of columns in each row.
- Ensure the same number of fields for each row.
Sample Output: Name of Technical Service 1,Description for the Technical Service,2,service,3;4,

ensure file integrity.

"""
print( "🟨 Starting................")

# Query the OpenAI API
content = query_openai_api(prompt_text)

if content:
    # Define the file name dynamically based on the organization
    filename = f"{organization}.csv"
    # Write the API response to the file
    write_output_to_file(output_directory, filename, content)
print( "🟩 Done................")