<#
Copyright (c) Microsoft Corporation. All rights reserved.
Licensed under the MIT License. See License.txt in the project root for license information.

Provides a method to pack the repo for local usage.
#>

[CmdletBinding()]
param(
    [Parameter(HelpMessage='NuGet package version')]
    [AllowEmptyString()]
    [string]
    $PackageVersion
)

If ($PackageVersion)
{
    $nugetDirectory = ("{0}\FeatureBits\Packages" -f $env:APPDATA)
    Write-Host "Package-Nuget: building packages..."

    dotnet pack ".\src\FeatureBits.Core\FeatureBits.Core.csproj" /p:PackageVersion=$PackageVersion
    dotnet pack ".\src\FeatureBits.Data\FeatureBits.Data.csproj" /p:PackageVersion=$PackageVersion
    dotnet pack ".\src\FeatureBits.Console\FeatureBits.Console.csproj" /p:PackageVersion=$PackageVersion
	$PackageName = ("*{0}.nupkg" -f $PackageVersion)
	Write-Verbose ("Now querying for packages {0}" -f $PackageName)

	$items = Get-ChildItem -Path .\src\*\bin -Filter $PackageName -Recurse
	foreach($item in $items) {
		Copy-Item $item.FullName -Destination $nugetDirectory -Force -Verbose:$VerbosePreference
	}
}
else
{
    Write-Host "Package-Nuget: -PackageVersion not provided, skipping..." -ForegroundColor Black -BackgroundColor Yellow
}
