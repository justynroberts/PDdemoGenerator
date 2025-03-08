/* 
  PagerDuty Schedules (see users.tf)
  Ref: https://www.terraform.io/docs/providers/pagerduty/r/schedule.html
*/

/* 
  Support: 24x5 Rota (Level 1) - 2 layers
*/
resource "pagerduty_schedule" "support_level_1" {
  name      = "Support All-Week Schedule (L1)"
  time_zone = "Europe/London"
  layer {
    name                         = "Workday Rotation"
    start                        = "2020-06-21T00:00:00+00:00"
    rotation_virtual_start       = "2020-06-21T07:00:00+00:00"
    rotation_turn_length_seconds = 86400
    users                        = [
                                    pagerduty_user.noah_cooper.id,
                                  ]
    restriction {
      type              = "weekly_restriction"
      start_day_of_week = 1
      start_time_of_day = "09:00:00"
      duration_seconds  = 28800
    }
    restriction {
      type              = "weekly_restriction"
      start_day_of_week = 2
      start_time_of_day = "09:00:00"
      duration_seconds  = 28800
    }
    restriction {
      type              = "weekly_restriction"
      start_day_of_week = 3
      start_time_of_day = "09:00:00"
      duration_seconds  = 28800
    }
    restriction {
      type              = "weekly_restriction"
      start_day_of_week = 4
      start_time_of_day = "09:00:00"
      duration_seconds  = 28800
    }
    restriction {
      type              = "weekly_restriction"
      start_day_of_week = 5
      start_time_of_day = "09:00:00"
      duration_seconds  = 28800
    }
  }
  layer {
    name                         = "Nightshift Rotation"
    start                        = "2020-06-21T00:00:00+00:00"
    rotation_virtual_start       = "2020-06-21T07:00:00+00:00"
    rotation_turn_length_seconds = 86400
    users                        = [
                                    pagerduty_user.paul_miller.id,
                                  ]
    restriction {
      type              = "weekly_restriction"
      start_day_of_week = 1
      start_time_of_day = "17:00:00"
      duration_seconds  = 57600
    }
    restriction {
      type              = "weekly_restriction"
      start_day_of_week = 2
      start_time_of_day = "17:00:00"
      duration_seconds  = 57600
    }
    restriction {
      type              = "weekly_restriction"
      start_day_of_week = 3
      start_time_of_day = "17:00:00"
      duration_seconds  = 57600
    }
    restriction {
      type              = "weekly_restriction"
      start_day_of_week = 4
      start_time_of_day = "17:00:00"
      duration_seconds  = 57600
    }
    restriction {
      type              = "weekly_restriction"
      start_day_of_week = 5
      start_time_of_day = "17:00:00"
      duration_seconds  = 57600
    }
  }  
}

/* 
  Support: 8x7 Rota (Level 2)
*/
resource "pagerduty_schedule" "support_level_2" {
  name      = "Support All-Week Schedule (L2)"
  time_zone = "Europe/London"
  layer {
    name                         = "Daily Rotation"
    start                        = "2020-06-21T00:00:00+00:00"
    rotation_virtual_start       = "2020-06-21T07:00:00+00:00"
    rotation_turn_length_seconds = 86400
    users                        = [
                                    pagerduty_user.noah_cooper.id
                                
                                  ]
    restriction {
      type              = "daily_restriction"
      start_time_of_day = "09:00:00"
      duration_seconds  = 28800
    }
  }
}

/* 
  Operations: 24x7
*/
resource "pagerduty_schedule" "operations_level_1" {
  name      = "Operations Schedule (L1)"
  time_zone = "Europe/London"
  layer {
    name                         = "Weekly Rotation"
    start                        = "2020-06-21T00:00:00+00:00"
    rotation_virtual_start       = "2020-06-21T07:00:00+01:00"
    rotation_turn_length_seconds = 604800
    users                        = [
                                    pagerduty_user.paul_miller.id,
                                  ]
  }
}

resource "pagerduty_schedule" "operations_level_2" {
  name      = "Operations Schedule (L2)"
  time_zone = "Europe/London"
  layer {
    name                         = "Weekly Rotation"
    start                        = "2020-06-21T00:00:00+00:00"
    rotation_virtual_start       = "2020-06-21T07:00:00+01:00"
    rotation_turn_length_seconds = 604800
    users                        = [
                                    pagerduty_user.ronald_green.id,
                                  ]
  }
}

/* 
  IT Management: 24x7
*/
resource "pagerduty_schedule" "it_management" {
  name      = "IT Management Schedule"
  time_zone = "Europe/London"
  layer {
    name                         = "Daily Rotation"
    start                        = "2020-06-21T00:00:00+00:00"
    rotation_virtual_start       = "2020-06-21T07:00:00+01:00"
    rotation_turn_length_seconds = 86400
    users                        = [
                                    pagerduty_user.ronald_green.id,
                                    pagerduty_user.paul_miller.id
                                  ]
  }
}