# Letting PowerShell decide
$Thing1 = 5
$Thing2 = 12
$Result = $Thing1 + $Thing2

# Forcing a string type
[String]$Thing1 = 5
[String]$Thing2 = 12
$Result = $Thing1 + $Thing2

# Forcing a larger integer type
[int64]$Thing1 = 2147483649
[int64]$Thing2 = 11
$Result = $Thing1 + $Thing2

# Showing max value for a given integer type
[int]::MaxValue # same as Int32
[int32]::MaxValue
[int]::MaxValue

# Asking PowerShell for a data type
$Thing1.GetType()