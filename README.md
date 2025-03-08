# 🌟 Service Graph Generator

This tool generates PagerDuty service graphs from CSV files using Terraform. Based on original code by James Pickles (https://github.com/pdt-jpickles), enhanced to include a Python service architecture generator with OpenAI. 

## 🎯 Prerequisites

- Python 3.x
- Terraform (>= 0.13.0)
- PagerDuty account with admin access
- PagerDuty API token
- OpenAI API token

## 🚀 Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Install Python dependencies:
```bash
pip install -r requirements.txt
```

3. Generate a PagerDuty API token:
   - Go to PagerDuty → Configuration → API Access
   - Create a new API key with full access
   - Save the token securely

4. Generate a OpenAI API token:
   - Create a new API key with 
   - Save in the generator.py 

## 🔨 Usage

### 1. Generate Service Architecture 🤖

To generate a new service architecture CSV:

1. Edit `generate.py` to set your organization name:
```python
organization = "your-org-name"
```

2. Run the generator:
```bash
python generate.py
```

This will create a CSV file in the `service_maps` directory.

### 2. Deploy to PagerDuty ⚡

1. Copy your generated CSV from `service_maps` to the Terraform directory:
```bash
cp service_maps/your-org-name.csv terraform-servicegraph-main/include_in_build/
```

2. Initialize Terraform:
```bash
cd terraform-servicegraph-main
terraform init
```

3. Deploy the service graph:
```bash
terraform apply -parallelism=1 -var="PAGERDUTY_TOKEN=your-token-here"
```

Alternatively, set the token as an environment variable:
```bash
export TF_VAR_PAGERDUTY_TOKEN=your-token-here
terraform apply -parallelism=1
```

4. Review the proposed changes and type `yes` to proceed.

## 📚 Understanding the CSV Structure

The Terraform code expects CSV files with the following columns:
- `ServiceName`: Name of your service
- `ServiceDescription`: Optional description
- `ServiceID`: Unique identifier within the CSV (used for dependencies)
- `ServiceType`: Either `business_service` or `service`
- `SupportingServices`: Semi-colon separated list of ServiceIDs (e.g., "1;2;3")
- `EscPol`: Optional escalation policy ID (leave blank for default)

Example:
```csv
ServiceName,ServiceDescription,ServiceID,ServiceType,SupportingServices,EscPol
Payment Gateway,Processes payments,1,service,2;3,
```

## 🎨 Using Existing Templates

Pre-made industry templates are available in `terraform-servicegraph-main/available_templates/`:
- 🛍️ ecommerce_services.csv
- 🍔 uber_eats.csv
- 💳 paypal.csv

To use a template:
```bash
cp terraform-servicegraph-main/available_templates/ecommerce_services.csv terraform-servicegraph-main/include_in_build/
```

## 🧹 Clean Up

To remove all resources from PagerDuty:
```bash
terraform destroy -var="PAGERDUTY_TOKEN=your-token-here"
```

## 📝 Important Notes

- The `-parallelism=1` flag prevents PagerDuty API rate limiting
- Multiple CSV files can be processed simultaneously from `include_in_build`
- The Terraform code will:
  - Create technical services with default Operations (EP) escalation policy
  - Create business services
  - Establish service dependencies based on the SupportingServices column
  - Set up users, schedules, and escalation policies
- Service dependencies are unidirectional and should not create circular references
