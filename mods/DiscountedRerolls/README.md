# BrotatoMod-DiscountedRerolls

面向 Brotato 1.2.0.1 和 ModLoader 6.2.0。

商店刷新和升级选择界面的刷新都使用游戏 `ItemService.get_reroll_price()` 计算价格，并将最终刷新价格降低 60%（按原价的 40% 收费）。价格向下取整，最低为 0。

Mod ID：`BrotatoMod-DiscountedRerolls`。

请不要同时启用 `BrotatoMod-FreeShopRefresh`：免费刷新 Mod 的升级界面扩展会把升级刷新重新设为 0。
