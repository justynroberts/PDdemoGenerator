/* 
  PagerDuty Escalation Policies (see users.tf and schedules.tf)
  Ref: https://www.terraform.io/docs/providers/pagerduty/r/escalation_policy.html
*/

/* 
  Support: 3 level escalation path
*/
resource "pagerduty_escalation_policy" "support" {
  name      = "Support (EP)"
  num_loops = 3
  rule {
    escalation_delay_in_minutes = 5
    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.support_level_1.id
    }
  }
  rule {
    escalation_delay_in_minutes = 15
    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.support_level_2.id
    }
  }
  rule {
    escalation_delay_in_minutes = 30
    target {
      id   = pagerduty_user.ronald_green.id
    }
    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.it_management.id
    }
  }
}

/* 
  Operations: 3 level escalation path
*/
resource "pagerduty_escalation_policy" "operations" {
  name      = "Operations (EP)"
  num_loops = 3
  rule {
    escalation_delay_in_minutes = 15
    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.operations_level_1.id
    }
  }
  rule {
    escalation_delay_in_minutes = 30
    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.operations_level_2.id
    }
  }
  rule {
    escalation_delay_in_minutes = 60
    target {
      id   = pagerduty_user.ronald_green.id
    }
    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.it_management.id
    }
  }
}

/* 
  IT Management: Singular escalation path
*/
resource "pagerduty_escalation_policy" "it_management" {
  name      = "IT Management (EP)"
  rule {
    escalation_delay_in_minutes = 15
    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.it_management.id
    }
  }
}