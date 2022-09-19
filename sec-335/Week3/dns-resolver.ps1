#Script to search through an IP range using a DNS server to return the hosts and the IP addresses related to these hosts

$serv = Read-Host -Prompt "Enter DNS Server"
$range = Read-Host -Prompt "Enter IP Subnet"

for($num = 1; $num -le 254; $num++)
{
	Resolve-DnsName -Name "$range.$num" -Server $serv -ErrorAction Ignore | Select NameHost, Name
}