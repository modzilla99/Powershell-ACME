#Setting the variables
param
(
  [Parameter(Mandatory=$true)]
  [String]$SubscriptionID

  [Parameter(Mandatory=$true)]
  [String]$TenantID

  [Parameter(Mandatory=$true)]
  [String]$AppID

  [Parameter(Mandatory=$true)]
  [String]$Password
)  

$azParams = @{ 
  AZSubscriptionId = $SubscriptionID
  AZTenantId = $TenantID
  AZAppUsername = $AppID
  AZAppPasswordInsecure = $Password
 
} 


#Managing prerequisites
New-Item -Path C:\Certificates -ItemType Directory -Force
Install-Module -Name Posh-ACME -Scope AllUsers -force

#Obtaining certificates
New-PACertificate *.sre.mustertenant.de -AcceptTOS -DnsPlugin Azure -PluginArgs $azParams 

#Getting path of the certs
$Path = (Get-PACertificate).CertFile  
$Path = $Path.Substring(0,$Path.Length - 9) 
$Path = "$Path\*.*" 

#Copying the certificates to the previously created directory
Copy-Item -Path $Path -Destination C:\Certificates -Recurse
