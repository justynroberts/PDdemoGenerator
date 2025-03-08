terraform {
  required_version = ">= 0.13.0"
  required_providers {
    pagerduty = {
      source = "PagerDuty/pagerduty"
      version = "2.7.0"
    }
  }
}

# Configure the PagerDuty provider
provider "pagerduty" {
  token = var.PAGERDUTY_TOKEN
}


# CSV implementation for services
# The below is based on original code written by Tom Bryant from PagerDuty Professional Services
locals {
  
  default_esc_pol = pagerduty_escalation_policy.operations.id

  included_files = fileset(path.module, "/include_in_build/*.csv")

  services_data = {for file in local.included_files : substr(file, 17, length(substr(file, 17, -1))-4) => csvdecode(file("${path.module}/${file}"))}

  all_technical_services = flatten([ for file_k, file_v in local.services_data : { for service in file_v : "${file_k}-${service.ServiceID}" => {
    name = service.ServiceName
    key = "${file_k}-${service.ServiceID}"
    description = service.ServiceDescription
    escalation_policy = service.EscPol != "" ? service.EscPol : local.default_esc_pol 
    }
    if service.ServiceType == "service"
  }])

  all_business_services = flatten([ for file_k, file_v in local.services_data : { for service in file_v : "${file_k}-${service.ServiceID}" => {
    name = service.ServiceName
    key = "${file_k}-${service.ServiceID}"
    description = service.ServiceDescription
    }
    if service.ServiceType == "business_service"
  }])
  
  service_dependencies = flatten([ for file_k, file_v in local.services_data : flatten([
    for service in file_v : [
      for supp_serv in split(";", service.SupportingServices) :  {
        dependent_service = "${file_k}-${service.ServiceID}"
        dep_service_type = service.ServiceType
        supporting_service = "${file_k}-${supp_serv}"
        supp_service_type = ([for s in file_v : s.ServiceType if s.ServiceID == supp_serv][0])
        
      }
    ] 
    if service.SupportingServices != ""
  ])])
}

resource "pagerduty_service" "main" {
  for_each = merge(local.all_technical_services...)
  name = each.value.name
  description = substr((each.value.description == null ? "" : each.value.description), 0, 1024)
  escalation_policy = each.value.escalation_policy
}

resource "pagerduty_business_service" "main" {
  for_each = merge(local.all_business_services...)
  name = each.value.name
  description = substr((each.value.description == null ? "" : each.value.description), 0, 1024)
}

resource "pagerduty_service_dependency" "main" {
    for_each = {
      for service_dependency in local.service_dependencies : "${service_dependency.dependent_service}/${service_dependency.supporting_service}" => service_dependency
    }
    dependency {
        dependent_service {
            id = each.value.dep_service_type == "service" ? pagerduty_service.main[each.value.dependent_service].id : pagerduty_business_service.main[each.value.dependent_service].id
            type = each.value.dep_service_type
        }
        supporting_service {
            id = each.value.supp_service_type == "service" ? pagerduty_service.main[each.value.supporting_service].id : pagerduty_business_service.main[each.value.supporting_service].id
            type = each.value.supp_service_type
        }
    }
}
