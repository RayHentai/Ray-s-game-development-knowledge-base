# 开发日志 · Day 1
**日期：** 2026-05-07  
**实际开发时长：** 约 4 小时  
**里程碑：** M1 完成 · M2 进行中

---

## 今日完成

### 环境搭建
- [x] 安装 Unity 6 LTS (URP 模板)
- [x] 安装 Cursor IDE，配置 AI 辅助编码工作流
- [x] 创建 GitHub 仓库（RayHentai/StarForge），完成第一次推送
- [x] 用 ProjectSetup.cs 一键生成项目文件夹结构

### 代码实现
- [x] ResourceManager v1 → v3（资源管理单例，完成地球篇19种资源注册）
- [x] BuildingManager（建筑建造·费用·计数，整合电力污染）
- [x] PowerManager（电力发电·用电·短路判定，无线电网MVP）
- [x] FuelManager（燃料热值·燃烧消耗逻辑）
- [x] PollutionManager（全局污染值·双阈值惩罚事件）
- [x] BuildingData ScriptableObject（支持电力·燃料·污染配置字段）
- [x] ClickCollector（点击采集·缩放动效）
- [x] ResourceUI（动态版，自动遍历所有资源）
- [x] BuildingShopUI（建筑商店，动态生成按钮）

### 设计决策
- [x] 战斗系统选定：类吸血鬼幸存者（v2.0再做俯视角）
- [x] 游戏命名：StarForge · 星铸
- [x] 资源框架确立：自然资源 vs 加工产物 分离
- [x] 地球资源系统定稿（19种自然资源）
- [x] 能源系统设计：电力 + 燃料 + 污染三系统
- [x] GDD v0.3 更新

### 原型验证
- [x] 点击星球表面 → 资源+1 → UI显示 ✅
- [x] 建造采集器 → 消耗资源 → 自动每秒产出 ✅
- [x] BuildingData ScriptableObject 在 Inspector 正常配置 ✅

---

## 今日踩坑记录

| 坑                  | 原因                                   | 解决方案                                             |
| ------------------ | ------------------------------------ | ------------------------------------------------ |
| ResourceUI不更新      | 硬编码`"ore"`与新ID`"raw_a"`不匹配           | 升级为动态遍历，不再硬编码ID                                  |
| UI文字堆叠在一点          | 动态生成子物体缺少布局组件                        | 给容器加 Vertical Layout Group + Content Size Fitter |
| git push 失败 403    | 凭据管理器存了旧账号RayHentai                  | 清除Windows凭据，重新授权正确账号                             |
| git push失败 refspec | 从未commit过，分支不存在                      | 先 git add . && git commit 再 push                 |
| .gitignore不生效      | 文件名被Windows加了前缀变成StarForge.gitignore | 重命名为 .gitignore                                  |
| 点"放弃所有更改"删文件       | 未commit时放弃 = 永久删除                    | 文件从回收站还原，建立commit习惯                              |

---

## 学到的概念

**Unity 相关**
- `ScriptableObject`：数据与逻辑分离，Inspector里填配置不改代码
- `[SerializeField]`：私有字段暴露到Inspector，改配置不改代码
- `Vertical Layout Group` + `Content Size Fitter`：动态UI自动排列
- `Canvas Scaler`：Scale With Screen Size，UI适配不同分辨率
- `Editor` 文件夹：只在编辑器运行的脚本放这里，不打包进游戏

**架构模式**
- 单例（Singleton）：全局唯一，任何地方 `Manager.Instance.Method()` 直接调用
- 观察者模式（Event）：数据变化时广播，UI订阅响应，不每帧轮询
- 单一数据源：每类数据只有一个Manager管，不出现数据不同步问题
- 数据驱动UI：UI不关心有哪些资源，只显示Manager告诉它的内容

**Git 相关**
- 正确的新项目流程：空仓库→放.gitignore→git init→commit→push
- Conventional Commits：feat/fix/refactor/docs 前缀规范
- 凭据管理器：Windows存储Git登录信息的地方，账号冲突时在这里清除

---

## 明日计划
- [ ] 讨论并设计自动化加工链（加工产物完整设计）
- [ ] 讨论科技树框架
- [ ] 实现第一台加工建筑（粉碎机：矿石→矿物粉末）
- [ ] 把今日新增3个Manager挂到场景GameManager对象上并验证

---

## 当前技术债
- FuelManager 的默认燃料预设仍使用占位ID（`raw_a`/`raw_b`），
  需要在本文件更新后同步替换为地球篇真实资源ID（`ore_coal`/`res_wood`等）
- BuildingShopUI 的按钮预制体层级需与代码中查找的子物体名称保持一致

---

*下次开发前先看"明日计划"和"当前技术债"*
