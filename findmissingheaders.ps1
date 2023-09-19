# Making URL parameter is mandatory
param([Parameter(Mandatory=$true)][string]$URL)

# Defining security headers to check
$sec_headers = @("X-Frame Options", "Strict-Transport-Security", "Content-Security-Policy", "X-Content-Type-Options", "Referrer-Policy", "Permissions-Policy", "Feature-Policy", "X-XSS-Protection", "Cache-Control")

# Hitting the URL
try{
	$web_headers_dict = (Invoke-WebRequest -Method Head -Uri $url).headers
}

# Handling connection errrors
catch{
	throw "[-] Error in connecting with target host"
	exit
}


# Extracting only key from the dictionary of available header and storing it into an array
$web_headers_array = @()
foreach ($element in $web_headers_dict.GetEnumerator()){
	$web_headers_array += $($element.key)
}

# Searching for implemented and missing security headers
$implemented_sec_headers = @()
$missing_headers = @()
for ($i = 0; $i -lt $sec_headers.Count; $i++){
	if ($web_headers_array.Contains($sec_headers[$i])){
		$implemented_sec_headers += $sec_headers[$i]
		continue
	}
	$missing_headers += $sec_headers[$i]
}

# Printing implemented security headers along with its values
[string]$implemented_sec_headers_string = $null
$implemented_sec_headers_string = $implemented_sec_headers -join ","
Write-Host -NoNewline "Implemented security headers are: "
Write-Host -ForegroundColor green  $implemented_sec_headers_string
for ($i = 0; $i -lt $implemented_sec_headers.Count; $i++){
	Write-Host -ForegroundColor Green -NoNewline $implemented_sec_headers[$i]: 
	$temp = $implemented_sec_headers[$i]
	Write-Host -ForegroundColor Green $web_headers_dict.$temp
}


# Printing missing security headers 
[string]$missing_headers_string = $null
$missing_headers_string = $missing_headers -join ","
Write-Host
Write-Host -NoNewline "Missing security headers are: "
Write-Host -ForegroundColor red $missing_headers_string
