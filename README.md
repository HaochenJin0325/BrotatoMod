# BrotatoMod

独立的 Brotato Mod 项目集合。每个 Mod 使用自己的源码目录和 ZIP 包，适用于 **Brotato 1.2.0.1** 与 **ModLoader 6.2.0**。

## Mods

| 项目目录 | Mod ID | 当前包 | 功能 |
| --- | --- | --- | --- |
| `mods/AllStartingWeapons/` | `BrotatoMod-AllStartingWeapons` | 1.1.0 | 在开局武器选择界面显示所有当前可用等级的武器，包括已启用 DLC 中的武器。仍遵守角色的近战/远程限制和内容可用性。 |
| `mods/DiscountedRerolls/` | `BrotatoMod-DiscountedRerolls` | 1.0.0 | 商店刷新和升级刷新均按原价的 40% 收费（降低 60%），整数向上取整且最低为 1。 |
| `mods/FreeShopRefresh/` | `BrotatoMod-FreeShopRefresh` | 1.0.1 | 商店刷新和升级刷新免费。 |

`DiscountedRerolls` 与 `FreeShopRefresh` 不要同时启用：免费刷新 Mod 会将升级刷新价格设为 0。

## 安装

1. 从对应 Mod 的 `builds/` 目录中选择 README 所列版本的 ZIP。
2. 将 ZIP 放进 ModLoader 实际扫描的本地 Mod 目录，并在游戏的 Mod 配置中启用对应 Mod。扫描目录因安装方式和 Workshop 订阅状态而异。
3. 每个 ZIP 都是独立 Mod 包；不要把多个 `mods-unpacked` 目录合并到同一个 ZIP。

## 项目结构

```text
mods/<Mod项目>/
├── package-root/mods-unpacked/<namespace-modname>/  # ModLoader 包内容
├── builds/                                           # 可安装 ZIP
├── archive/                                          # 本地旧包和回滚资料
└── README.md
```

## 打包

在仓库根目录用 PowerShell 执行，例如：

```powershell
$modPath = Join-Path (Get-Location) 'mods\AllStartingWeapons'
$zipPath = Join-Path $modPath 'builds\BrotatoMod-AllStartingWeapons-1.1.0.zip'
Compress-Archive -Path (Join-Path $modPath 'package-root\mods-unpacked') -DestinationPath $zipPath -Force
```

ZIP 根目录应直接包含 `mods-unpacked/<namespace-modname>/manifest.json`、`mod_main.gd` 和扩展脚本。

各 Mod 的兼容版本、行为细节和限制见其目录下的 README。项目维护约定见 [AGENTS.md](AGENTS.md)。
