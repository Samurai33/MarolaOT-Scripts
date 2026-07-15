[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ProfilePath = "C:\Users\Samurai\AppData\Roaming\marolaot\marolaot\marolaot\bot\vBot_4.8"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Read-MarolaJson {
    param([Parameter(Mandatory)][string]$Path)

    $raw = [System.IO.File]::ReadAllText($Path)
    return $script:JsonSerializer.DeserializeObject($raw)
}

function Write-MarolaJson {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)]$Data
    )

    $json = $script:JsonSerializer.Serialize($Data)
    [System.IO.File]::WriteAllText($Path, $json, $script:Utf8NoBom)
}

function New-AttackEntry {
    param(
        [string]$Description,
        [string]$Creatures,
        [object[]]$Monsters,
        [int]$Mana,
        [int]$Count,
        [int]$MinHp,
        [int]$MaxHp,
        [int]$Cooldown,
        [int]$ItemId,
        [string]$Spell,
        [int]$Category,
        [int]$PatternCategory,
        [int]$Pattern,
        [bool]$OrMore = $true
    )

    return @{
        creatures       = $Creatures
        monsters        = $Monsters
        mana            = $Mana
        count           = $Count
        minHp           = $MinHp
        maxHp           = $MaxHp
        cooldown        = $Cooldown
        itemId          = $ItemId
        spell           = $Spell
        enabled         = $true
        category        = $Category
        patternCategory = $PatternCategory
        pattern         = $Pattern
        tooltip         = $Creatures
        orMore          = $OrMore
        description     = $Description
    }
}

$paths = @{
    ConfigDir    = Join-Path $ProfilePath 'vBot_configs\profile_1'
    Storage      = Join-Path $ProfilePath 'storage\profile_1.json'
    Attack       = Join-Path $ProfilePath 'vBot_configs\profile_1\AttackBot.json'
    Heal         = Join-Path $ProfilePath 'vBot_configs\profile_1\HealBot.json'
    Supplies     = Join-Path $ProfilePath 'vBot_configs\profile_1\Supplies.json'
    Target       = Join-Path $ProfilePath 'targetbot_configs\cobra.json'
    Cave         = Join-Path $ProfilePath 'cavebot_configs\[550+] Cobra Tower.cfg'
}

Write-Host "`n===== MAROLAOT COBRA TOWER MAX DPS V2 =====" -ForegroundColor Cyan

if (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'MarolaOT|otclient' }) {
    throw 'Feche completamente o MarolaOT antes de executar.'
}

foreach ($entry in $paths.GetEnumerator()) {
    if (-not (Test-Path -LiteralPath $entry.Value)) {
        throw "Caminho obrigatório não encontrado [$($entry.Key)]: $($entry.Value)"
    }
}

Add-Type -AssemblyName System.Web.Extensions
$script:JsonSerializer = [System.Web.Script.Serialization.JavaScriptSerializer]::new()
$script:JsonSerializer.MaxJsonLength = [int]::MaxValue
$script:JsonSerializer.RecursionLimit = 500
$script:Utf8NoBom = [System.Text.UTF8Encoding]::new($false)

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupDir = Join-Path $ProfilePath "backup-max-dps-v2-$stamp"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

foreach ($file in @($paths.Storage, $paths.Attack, $paths.Heal, $paths.Supplies, $paths.Target, $paths.Cave)) {
    Copy-Item -LiteralPath $file -Destination (Join-Path $backupDir (Split-Path $file -Leaf)) -Force
}

Write-Host "Backup: $backupDir" -ForegroundColor Green

$profileName = 'Cobra Tower MAX DPS v2'
$creatures = 'cobra assassin,cobra vizier,cobra scout'
$monsterNames = @('cobra assassin', 'cobra vizier', 'cobra scout')

if ($PSCmdlet.ShouldProcess($paths.Attack, 'Configurar rotação MAX DPS v2')) {
    $attackData = Read-MarolaJson -Path $paths.Attack
    $profiles = @($attackData['AttackBot'])

    if ($profiles.Count -ne 5) {
        throw "AttackBot deve possuir 5 perfis. Encontrados: $($profiles.Count)"
    }

    $attackProfile = $profiles[0]
    $attackProfile['name'] = $profileName
    $attackProfile['enabled'] = $false
    $attackProfile['ignoreMana'] = $false
    $attackProfile['Cooldown'] = $true
    $attackProfile['Visible'] = $false
    $attackProfile['Rotate'] = $true
    $attackProfile['pvpMode'] = $false
    $attackProfile['PvpSafe'] = $true
    $attackProfile['BlackListSafe'] = $false
    $attackProfile['AntiRsRange'] = 5
    $attackProfile['Kills'] = $false
    $attackProfile['KillsAmount'] = 1
    $attackProfile['Training'] = $false

    $attackProfile['attackTable'] = @(
        (New-AttackEntry -Description '[MAX DPS] 6+ Cobras HP 35%+: Rage of the Skies [40.5s]' -Creatures $creatures -Monsters $monsterNames -Mana 30 -Count 6 -MinHp 35 -MaxHp 100 -Cooldown 40500 -ItemId 0 -Spell 'exevo gran mas vis' -Category 5 -PatternCategory 4 -Pattern 5),
        (New-AttackEntry -Description '[MAX DPS] 3+ Cobras alinhadas: Energy Wave [8.25s]' -Creatures $creatures -Monsters $monsterNames -Mana 15 -Count 3 -MinHp 15 -MaxHp 100 -Cooldown 8250 -ItemId 0 -Spell 'exevo vis hur' -Category 5 -PatternCategory 4 -Pattern 2),
        (New-AttackEntry -Description '[MAX DPS] 3+ Cobras alinhadas: Great Fire Wave [4.25s]' -Creatures $creatures -Monsters $monsterNames -Mana 10 -Count 3 -MinHp 5 -MaxHp 100 -Cooldown 4250 -ItemId 0 -Spell 'exevo gran flam hur' -Category 5 -PatternCategory 4 -Pattern 11),
        (New-AttackEntry -Description '[MAX DPS] 2+ Cobras: Great Fireball Rune' -Creatures $creatures -Monsters $monsterNames -Mana 0 -Count 2 -MinHp 0 -MaxHp 100 -Cooldown 2000 -ItemId 3191 -Spell '' -Category 2 -PatternCategory 2 -Pattern 3),
        (New-AttackEntry -Description '[MAX DPS] Alvo solo HP 30%+: Ultimate Energy Strike [30.5s]' -Creatures $creatures -Monsters $monsterNames -Mana 5 -Count 1 -MinHp 30 -MaxHp 100 -Cooldown 30500 -ItemId 0 -Spell 'exori max vis' -Category 1 -PatternCategory 1 -Pattern 3),
        (New-AttackEntry -Description '[MAX DPS] Alvo restante: Sudden Death Rune' -Creatures $creatures -Monsters $monsterNames -Mana 0 -Count 1 -MinHp 0 -MaxHp 100 -Cooldown 2000 -ItemId 3155 -Spell '' -Category 3 -PatternCategory 3 -Pattern 10)
    )

    $attackData['currentBotProfile'] = 1
    Write-MarolaJson -Path $paths.Attack -Data $attackData
}

if ($PSCmdlet.ShouldProcess($paths.Supplies, 'Configurar supplies MAX DPS v2')) {
    $suppliesData = Read-MarolaJson -Path $paths.Supplies
    if ($null -eq $suppliesData['supplies']) { $suppliesData['supplies'] = @{} }

    $suppliesData['supplies']['currentProfile'] = $profileName
    $suppliesData['supplies'][$profileName] = @{
        items = @{
            '23373' = @{ min = 200; max = 700;  avg = 0 }
            '3191'  = @{ min = 700; max = 2500; avg = 0 }
            '3155'  = @{ min = 250; max = 1000; avg = 0 }
        }
        capSwitch     = $true
        capValue      = '300'
        staminaSwitch = $false
        staminaValue  = '850'
        SoftBoots     = $false
        imbues        = $false
    }

    Write-MarolaJson -Path $paths.Supplies -Data $suppliesData
}

if ($PSCmdlet.ShouldProcess($paths.Heal, 'Configurar HealBot MAX DPS v2')) {
    $healData = Read-MarolaJson -Path $paths.Heal
    $healProfiles = @($healData['healbot'])
    if ($healProfiles.Count -lt 1) { throw 'HealBot não possui perfil 1.' }

    $healProfile = $healProfiles[0]
    $healProfile['name'] = $profileName
    $healProfile['enabled'] = $false
    $healProfile['Cooldown'] = $true
    $healProfile['Interval'] = $true
    $healProfile['Conditions'] = $true
    $healProfile['Delay'] = $true
    $healProfile['Visible'] = $true
    $healProfile['spellTable'] = @(
        @{ index = 1; spell = 'exura vita'; sign = '<'; origin = 'HP%'; cost = 160; value = 75; enabled = $true },
        @{ index = 2; spell = 'exura gran'; sign = '<'; origin = 'HP%'; cost = 70; value = 92; enabled = $true }
    )
    $healProfile['itemTable'] = @(
        @{ index = 1; item = 23373; sign = '<'; origin = 'MP%'; value = 60; enabled = $true; subType = 0 }
    )
    $healData['currentHealBotProfile'] = 1
    Write-MarolaJson -Path $paths.Heal -Data $healData
}

if ($PSCmdlet.ShouldProcess($paths.Target, 'Configurar targeting e lootbag')) {
    $targetData = Read-MarolaJson -Path $paths.Target
    foreach ($targetEntry in @($targetData['targeting'])) {
        $name = [string]$targetEntry['name']
        $targetEntry['lureCavebot'] = $true
        $targetEntry['lureCount'] = 6
        $targetEntry['keepDistance'] = $false
        $targetEntry['maxDistance'] = 10
        $targetEntry['dontLoot'] = $true

        if ($name -match 'Vizier') {
            $targetEntry['priority'] = 4
            $targetEntry['danger'] = 4
        } elseif ($name -match 'Assassin') {
            $targetEntry['priority'] = 3
            $targetEntry['danger'] = 3
        } else {
            $targetEntry['priority'] = 2
            $targetEntry['danger'] = 2
        }
    }

    if ($null -eq $targetData['looting']) { $targetData['looting'] = @{} }
    $targetData['looting']['items'] = @()
    $targetData['looting']['containers'] = @()
    $targetData['looting']['everyItem'] = $false
    $targetData['looting']['minCapacity'] = 0
    Write-MarolaJson -Path $paths.Target -Data $targetData
}

if ($PSCmdlet.ShouldProcess($paths.Cave, 'Validar NPCs de refill')) {
    $caveRaw = [System.IO.File]::ReadAllText($paths.Cave)
    $caveRaw = [regex]::Replace($caveRaw, '(?im)^buysupplies:Menkesh\s*,\s*199\s*$', 'buysupplies:Mehkesh, 199')

    if ($caveRaw -notmatch '(?im)^buysupplies:Mehkesh\s*,\s*199\s*$') { throw 'Refill no Mehkesh ausente.' }
    if ($caveRaw -notmatch '(?im)^buysupplies:Fenech\s*,\s*199\s*$') { throw 'Refill no Fenech ausente.' }

    [System.IO.File]::WriteAllText($paths.Cave, $caveRaw, $script:Utf8NoBom)
}

if ($PSCmdlet.ShouldProcess($paths.Storage, 'Manter CaveBot e TargetBot desligados')) {
    $storageData = Read-MarolaJson -Path $paths.Storage
    $configs = $storageData['_configs']
    if ($null -eq $configs) { throw 'Seção _configs ausente no storage.' }

    $configs['cavebot_configs']['selected'] = '[550+] Cobra Tower'
    $configs['cavebot_configs']['enabled'] = $false
    $configs['targetbot_configs']['selected'] = 'cobra'
    $configs['targetbot_configs']['enabled'] = $false
    Write-MarolaJson -Path $paths.Storage -Data $storageData
}

$attackCheck = Read-MarolaJson -Path $paths.Attack
$finalProfile = $attackCheck['AttackBot'][0]

if (@($finalProfile['attackTable']).Count -ne 6) { throw 'Validação falhou: quantidade de ataques diferente de 6.' }
if ($finalProfile['attackTable'][0]['cooldown'] -ne 40500) { throw 'Validação falhou: cooldown da UE incorreto.' }
if ($finalProfile['enabled'] -ne $false) { throw 'Validação falhou: AttackBot deveria permanecer desligado.' }

$finalProfile['attackTable'] | ForEach-Object {
    [PSCustomObject]@{
        Descricao  = $_['description']
        ItemId     = $_['itemId']
        Spell      = $_['spell']
        Count      = $_['count']
        CooldownMs = $_['cooldown']
    }
} | Format-Table -AutoSize -Wrap

Write-Host "`nConfiguração concluída. Todos os módulos permanecem desligados." -ForegroundColor Green
Write-Host "Backup: $backupDir" -ForegroundColor Yellow
