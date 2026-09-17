import datetime

date_string = "17/Oct/24 9:42 AM"

date_datetime = datetime.datetime.strptime(date_string, "%d/%b/%y %I:%M %p")
date_ctime = datetime.datetime.ctime(date_datetime)
print(date_string)
print(date_datetime)