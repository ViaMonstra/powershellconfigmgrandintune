$jsonBase = @{}
$array = @{}
$data = @{"Name"="Andrew";"FavoriteFood"="Steak";}
$array.Add("Person",$data)
$jsonBase.Add("Data",$array)
$jsonBase | ConvertTo-Json -Depth 10 | Out-File "C:\Temp\FavoriteFood.json"