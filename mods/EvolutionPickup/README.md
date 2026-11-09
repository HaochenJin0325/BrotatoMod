# Local-EvolutionPickup

此 Mod 基于 Steam 创意工坊项目 **Local-EvolutionPickup**（Workshop ID `3832998906`），将下载的 `1.0.2` 包整理进本项目，脚本和 manifest 保持原样。

## 效果

- 机械或异变进化值的绝对值达到 `3` 后，对应路线的进化果实可以触发吸附。
- 果实掉落时，会按游戏原有的 `instant_gold_attracting` 属性概率立即吸附；进入材料吸附范围后，符合路线条件的果实也会被吸引。
- 波次结束时，符合路线条件的剩余果实会自动吸附；在波次切换前仍未到达的目标果实会直接拾取。
- 对应果实指机械果实和异变果实（`consumable_meca_fruit` / `consumable_mutant_fruit`），不是敌人掉落的机械零件或变异果实。

## 包

- 项目源码：`package-root/mods-unpacked/Local-EvolutionPickup/`
- ZIP：`builds/Local-EvolutionPickup-1.0.2.zip`
- 原下载包备份：`archive/Local-EvolutionPickup-workshop-3832998906-1.0.2.zip`

原 Mod ID 保留为 `Local-EvolutionPickup`。若将项目 ZIP 安装到游戏中，请停用原来下载的同 ID Mod，避免重复加载。
