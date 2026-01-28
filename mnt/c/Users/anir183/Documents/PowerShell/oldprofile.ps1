Invoke-Expression (& { (zoxide init powershell --cmd chd | Out-String) })

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

# Alias Functions
function ezaa { eza -a $args }
function ezala { eza -la $args }
function fvmflutter { fvm flutter $args }
function fvmdart { fvm dart $args }

# Custom Aliases
Set-Alias -Name el -Value ezaa
Set-Alias -Name ell -Value ezala
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim
Set-Alias -Name notepad -Value notepads
Set-Alias -Name flutter -Value fvmflutter
Set-Alias -Name dart -Value fvmdart

$Env:FVM_CACHE_PATH = "D:\sdks\flutter\cache"
$Env:CHROME_EXECUTABLE = "C:\Users\anir183\AppData\Local\Chromium\Application\chrome.exe"
$Env:FLUTTER_SDK_PATH_183 = "D:\sdks\flutter\cache\versions\stable"

# Refresh Environment Variables
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# SIG # Begin signature block
# MIIFvwYJKoZIhvcNAQcCoIIFsDCCBawCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA6TKc//0fN2Il9
# QvfVojq3K/WrgeJ0xqZRYlnZI6JZgaCCAyYwggMiMIICCqADAgECAhAmLbTj2Qgg
# p0k3i2pwgT2HMA0GCSqGSIb3DQEBBQUAMCkxJzAlBgNVBAMMHlBvd2VyU2hlbGwg
# UHJvZmlsZSBDZXJ0aWZpY2F0ZTAeFw0yNTEyMjcwNzA2MTFaFw0yNjEyMjcwNzI2
# MTFaMCkxJzAlBgNVBAMMHlBvd2VyU2hlbGwgUHJvZmlsZSBDZXJ0aWZpY2F0ZTCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMhWt6+UKKTfjKS19E2YFkgQ
# 0HZMdccWXx+C4wlNYXELitHChjifnnCb7soAiynRMcUW1gDycot3lkL5DgudOwzw
# Pe5EhgL16H4rWhXY5iXvXD+Hk2WulThK09qfbn/viW4N2AUrLUP805nMbgQaZtub
# SqKqqOJILONzp5+IN3EjmGEcF6QwvUkNObTJYRR2bRNcl77Mt16wHkHTOzhz55Y1
# VKSO/J62jmpd4uTt6weiC4UrbF+g49mnzPeKdR10PQNnyqKThaamA0gS/AuW7bp3
# uKJEqremx5/8T6y8634yXbwJbfGooGKHv9DL4sMgazO9fX3AEvsdAfKHG2i6fdkC
# AwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0G
# A1UdDgQWBBSamf8nLkxcOpxyaHG0VGaPMJ6zADANBgkqhkiG9w0BAQUFAAOCAQEA
# LW4ns+vY0jgf/qgztAnSY27M6yrlUC5QCCBf3rEKHvXK8xMNaJpzfubGxrIcL3jk
# sETOEBkd43JE3fBEOl6GlYW18UXC+NLO7r39NkLlEby9wQSLCwOdj+VRA1MpCejn
# CkjIpGbFWPwyPqGXFQHCvBDx/I3vp2r0kG/kj+z0fYnY0KxlgL9UH/eierw4+5OZ
# xMugl9/hLgv+N36t/ML/P5IDxApBAUDPCiEhQaU23m8SMJ4cfHUCxCllzAt8VRKX
# AyNypODd/UzUIP2GagkJhiC083L2iK7RJM7wEpBZxfq9ej8lQuqr+5jEpXNLz9sM
# HTV0pQl2h6NvtfbK7IYh7DGCAe8wggHrAgEBMD0wKTEnMCUGA1UEAwweUG93ZXJT
# aGVsbCBQcm9maWxlIENlcnRpZmljYXRlAhAmLbTj2Qggp0k3i2pwgT2HMA0GCWCG
# SAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcN
# AQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUw
# LwYJKoZIhvcNAQkEMSIEIAdl3uJPyetHuv4urVOvc6RJVL8qclKpHkCkrvKyNg3P
# MA0GCSqGSIb3DQEBAQUABIIBAItv7SO1OVL/I4pJnNq9Yii2AbeYmMuzhma1Jfmf
# UJLjz3dGP/EgNvk6QE6dr2VYXSHzo/iqvwxT3DqKiDPxbkFqUsr4DIVR6BbaCAjf
# fEHRNYChM65ilweXWA5vyOUG8LEYEoGGurC/Qqt5wkOz+8VFuJvy7DPlChRqMyOq
# CZXs0zPyhgux+Vn3hCnEza+mxsGmBxmoBSPfShE4xqI24Gi4xsAGU74gDFmFaf1y
# +sGqtFygiaQaZ5DBQDMsFPkDHXGV4gDPni+PoJjq6BXxUhYUlvhB6s6QVbdSR1KE
# 8xRe3RF7bXBSKF7VVKdv2hNpD6qVBYDEjvIK3y47xwXyVpU=
# SIG # End signature block
