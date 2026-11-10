# BrotatoMod 项目说明

## 项目结构

- 每个 Mod 单独放在 `mods/<项目文件夹>/`。
- `package-root/mods-unpacked/<namespace-modname>/` 是要打进 ZIP 的 Mod 内容。
- 每个 Mod 自己维护 `builds/`；旧包、尝试包和回滚源放在 `archive/`。
- 不要把多个独立 Mod 塞进同一个 `mods-unpacked` ZIP；需要组合时通过 ModLoader 依赖声明。
- 改一个 Mod 时只编辑对应子目录，不要顺手改其他 Mod。

当前 Mod：

- `mods/FreeShopRefresh/`：已存在的免费刷新 Mod。
- `mods/AllStartingWeapons/`：让角色可从所有可用等级及已启用 DLC 武器中选择起始武器。
- `mods/HeroEditor/`：选两个已解锁角色，临时合并其效果、起始内容和禁用列表。

## 当前环境

- Brotato：`1.2.0.1`
- 游戏日志报告的 Godot：`3.7.dev.custom_build`
- ModLoader：`6.2.0`
- Steam 游戏目录：以目标机器的 Steam 库设置和 ModLoader 日志为准。
- Workshop Mod 目录：先从 ModLoader 日志确认；路径通常位于 `<SteamLibrary>/steamapps/workshop/content/1942280/<Workshop 项目 ID>/`。
- Mod 配置：`%APPDATA%/Brotato/mod_user_profiles.json`
- 诊断日志：`%APPDATA%/Brotato/logs/modloader.log` 和 `godot.log`

## 新建 Mod

1. 在 `mods/` 下新建独立目录、`package-root/mods-unpacked/<namespace-modname>/` 和 `builds/`。
2. `manifest.json` 写清 `name`、`namespace`、版本、依赖，以及 `extra.godot.compatible_game_version` 和 `compatible_mod_loader_version`。
3. `mod_main.gd` 扩展 `Node`，用 `ModLoaderMod.get_unpacked_dir().plus_file(MOD_DIR_NAME)` 定位自己的 Mod 目录，并通过 `ModLoaderMod.install_script_extension()` 安装脚本扩展。
4. `MOD_DIR_NAME`、ZIP 内目录名和 `mod_user_profiles.json` 中的 Mod ID 要一致；本项目约定 ID 为 `<namespace>-<name>`。
5. 扩展脚本必须 `extends` 游戏 1.2.0.1 中真实存在的 `res://...` 脚本。改 UI 或游戏逻辑前先检查当前版本脚本；不要照抄旧版路径或字段名。
6. 把 ZIP 打在 `package-root` 中，使 ZIP 根路径从 `mods-unpacked/` 开始，不要多套一层项目目录。

PowerShell 打包范例：

```powershell
$mod = Join-Path (Get-Location) 'mods\AllStartingWeapons'
$zip = Join-Path $mod 'builds\BrotatoMod-AllStartingWeapons-1.1.0.zip'
Compress-Archive -Path (Join-Path $mod 'package-root\mods-unpacked') -DestinationPath $zip -Force
```

打包后检查 ZIP 内包含 `mods-unpacked/<namespace-modname>/manifest.json`、`mod_main.gd` 和扩展脚本。

## 本地安装与检查

1. 完全退出 Brotato。
2. 把 ZIP 复制到已确认可被 ModLoader 扫描的 Workshop Mod 目录，或使用游戏/ModLoader 支持的本地安装方式。不要把散装 `mods-unpacked` 直接丢在游戏 EXE 旁边。
3. 备份后更新 `%APPDATA%/Brotato/mod_user_profiles.json` 当前 profile 的 `mod_list`：以 Mod ID 为键，写入 `is_active: true` 和 ZIP 的 `zip_path`。保留其他已有条目，不要覆盖整个 Mod 列表。
4. 重启游戏。日志应显示 ZIP 已加载、Mod 已初始化、脚本扩展安装到预期 `res://` 路径。
5. 若 Mod 列表为空，先检查 ZIP 根目录、profile 的 ZIP 路径和 `is_active`。`Can't open unpacked mods folder res://mods-unpacked/` 在打包版中可能只是没有散装开发目录的提示，不等于 ZIP Mod 没加载。
6. 脚本报错时先看 `godot.log` 的首个 parse/runtime error；它通常指出错误的游戏脚本路径、变量名或方法签名。

当前机器用过把 ZIP 放入 Workshop 数字目录并在 profile 里登记的本地安装方式。其他机器或其他 Workshop 订阅项不要照搬数字目录；先确认 ModLoader 实际扫描路径。

## 参考版本差异

旧版 Brotato 脚本与 1.2.0.1 不一定兼容。例如升级刷新界面的当前脚本是 `res://ui/menus/ingame/upgrades_ui_player_container.gd`；应以本机当前 PCK 中脚本为准。
