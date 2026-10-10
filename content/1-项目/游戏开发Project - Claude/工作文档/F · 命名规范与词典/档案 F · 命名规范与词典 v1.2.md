# 档案 F · 命名规范与词典 v1.1

>版本：1.1 → 1.2 | 最后更新：*2026/10/10* · UI 模块复刻收尾
>本版变更：
>- 新增：命名规范表加两行——Try 方法（成功返回 true）、ThrowIf… 方法
>- 新增：第六部分「撞名时怎么起名」（按两者的区别命名，不用缩写区分）
>- 新增：整理说明第 13、14 条

（1.0 新建时的变更：把用户此前的命名笔记整理成五部分；新增基类、扩展方法所在类、静态工具类、bool 四条规则；修正 10 处，见文末「五、整理说明」。）

> 用途：写代码前查名字；Claude 给命名建议时按本档案执行。进公司后以团队规范为准，关键是全项目统一。

---

## 一、命名规范（成员类型 → 写法）

| 成员类型               | 规范                                                       | 例子                                             |
| ------------------ | -------------------------------------------------------- | ---------------------------------------------- |
| public 字段          | 小驼峰 camelCase（跟 Unity API 风格一致）                          | `panel`（同 Unity 的 `transform.position`）        |
| public 属性          | 大驼峰 PascalCase                                           | `Instance`                                     |
| private 字段         | 小驼峰，加 `_` 前缀                                             | `_updateEvent`、`_panelsDic`                    |
| private static 字段  | 小驼峰，加 `s_` 前缀                                            | `s_ignoredNames`                               |
| 常量                 | 大驼峰（.NET 规范）或全大写加下划线，全项目统一一种                             | `CanvasPath` / `CANVAS_PATH`                   |
| 方法                 | 大驼峰，**动词开头**，动词 + 名词构词                                   | `AddUpdateListener`、`InitPanel`                |
| Try 方法             | `Try` + 动作，返回 bool：**成功返回 true**，结果用 `out` 带出；失败时不抛异常    | `TryGetPanel`、`TryValidatePanelPrefab`         |
| 条件成立就抛异常的方法        | `ThrowIf` + 条件，不返回值                                      | `ThrowIfPanelDestroyedExternally`              |
| 响应方法（事件处理）         | 大驼峰，`On` + 事件名                                           | `OnClick`、`OnToggleValueChanged`               |
| event              | 大驼峰，名词或 `On` + 事件名                                       | `UpdateEvent`                                  |
| 参数 / 局部变量          | 小驼峰                                                      | `callback`、`eventType`                         |
| bool（字段 / 属性 / 参数） | `is` / `has` / `can` / `should` 开头，读起来是一个是非问题            | `isHideRequested`、`shouldDestroy`              |
| 类 / 接口             | 大驼峰；接口加 `I` 前缀                                           | `UIManager`、`IPanelInfo`                       |
| 基类（本项目风格）          | 被继承的那一类东西 + `Base` 结尾                                    | `PanelBase`、`SingletonBase`、`PanelInfoBase`    |
| 扩展方法所在的静态类         | 被扩展的类型 + `Extensions`                                    | `UIBehaviourExtensions`                        |
| 静态工具类              | 用途 + `Utility` / `Helper`                                | `UIEventUtility`                               |
| 枚举类型 / 枚举值         | 大驼峰；普通枚举用单数名词，按位组合的 Flags 枚举用复数；两个字母的缩写全大写（`UI`）；前缀见下方说明 | `E_UILayer.Top`、`E_PendingHideType.Deactivate` |
| 泛型参数               | 只有一个时用 `T`；多个时用 `T` + 描述                                 | `T` / `TPanel`                                 |
**说明**

- **枚举前缀**：.NET 规范不加前缀；`E_` 是教材和不少国内 Unity 项目的习惯。**本项目当前统一用 `E_`**（`E_UILayer`、`E_EventType`、`E_PendingHideType`）。要改就所有枚举一起改。
- **缩写**：.NET 规范不鼓励缩写（`Manager` 优于 `Mgr`）。**本项目统一用 `Manager`**（`MonoMgr`、`PoolMgr` 改为 `MonoManager`、`PoolManager`）。
- **团队优先**：进了公司，以团队规范为准，关键是全项目统一。

---

## 二、构词方式

动词 + 名词，拼起来。“加帧更新监听者” = `Add`（加）+ `Update`（帧更新）+ `Listener`（监听者）= **`AddUpdateListener`**。中文拆出来的几个字，一个词对一个词拼上去就是标准名。

bool 同理，先把它说成一个是非问题再拼：“要不要销毁？” = `should` + `Destroy` = **`shouldDestroy`**。

---

## 三、高频命名词典

### 3.1 动作（动词）

|中文意图|英文|说明 / 例子|
|---|---|---|
|添加 / 加|`Add`|加监听、加元素，跟 `Remove` 成对|
|移除 / 删|`Remove`||
|获取|`Get`|取值|
|设置|`Set`|存值|
|创建|`Create`|跟 `Destroy` 成对|
|销毁|`Destroy`||
|初始化|`Init`（Initialize）|`InitPanel`|
|清空|`Clear`||
|查找|`Find`|`FindChildControls`|
|加载|`Load` / `LoadAsync`|同步 / 异步，跟 `Unload` 成对|
|显示 / 隐藏|`Show` / `Hide`|面板显隐|
|打开 / 关闭|`Open` / `Close`|面板也常用，跟 `Show` / `Hide` 二选一，全项目统一|
|激活 / 失活|`Activate` / `Deactivate`|`E_PendingHideType.Deactivate`|
|开始 / 停止|`Start` / `Stop`|开协程 / 停协程|
|触发|`Trigger`|事件中心 `EventTrigger`|
|预热|`Prewarm` / `WarmUp`|提前生成、提前加载|
|延迟|`Delay`||

### 3.2 生命周期

|中文意图|英文|说明|
|---|---|---|
|帧更新|`Update`|就是生命周期那个词|
|物理帧更新|`FixedUpdate`||
|延迟帧更新|`LateUpdate`||

### 3.3 名词（系统 / 游戏对象）

| 中文         | 英文                  | 说明 / 例子                    |
| ---------- | ------------------- | -------------------------- |
| 面板         | `Panel`             | `ShowPanel`                |
| 控件         | `Control`           | `GetControl`               |
| 层级         | `Layer`             | `E_UILayer`                |
| 根物体        | `Root`              | `GetLayerRoot`             |
| 信息         | `Info`              | `PanelInfo`                |
| 管理器        | `Manager`           | 本项目统一用全称；`Mgr` 是常见缩写，本项目不用 |
| 单例实例       | `Instance`          |                            |
| 池 / 对象池    | `Pool`              | 对象池模块                      |
| 事件         | `Event`             |                            |
| 监听者 / 监听方法 | `Listener`          | 加在后面，如 `UpdateListener`    |
| 回调         | `Callback`          | 参数名常用 `callback`           |
| 协程         | `Coroutine` / `Cor` | 全称或缩写                      |
| 路径         | `Path`              | `CanvasPath`               |
| 预设体        | `Prefab`            | 也叫“预制体”                    |
| 艺术资源       | `ArtRes`            | 常用作资源文件夹名                  |
| 目标         | `Target`            |                            |
| 子弹         | `Bullet`            |                            |
| 奖励         | `Reward`            |                            |
| 武器         | `Weapon`            |                            |

### 3.4 数学 / 几何

| 中文  | 英文                         | 说明                                    |
| --- | -------------------------- | ------------------------------------- |
| 距离  | `Distance`                 |                                       |
| 角度  | `Angle`                    |                                       |
| 方向  | `Direction`（缩写 `Dir`）      | ⚠ `Dir` 也常指 `Directory`（目录），含义可能混淆时写全 |
| 半径  | `Radius`                   |                                       |
| 差值  | `Difference`（缩写 `Diff`）    | 两个量相减的结果                              |
| 变化量 | `Delta`                    | 前后两次之间的变化，如 `deltaTime`               |
| 和   | `Sum`                      |                                       |
| 当前的 | `Current`                  |                                       |
| 顶点  | `Vertices`（单数 `Vertex`）    |                                       |
| 三角形 | `Triangles`（单数 `Triangle`） |                                       |

### 3.5 音频

|缩写|全称|中文|
|---|---|---|
|`SFX`|Sound Effects|音效|
|`BGM`|Background Music|背景音乐|

### 3.6 修饰 / 状态词

| 中文意图       | 英文         | 例子                      |
| ---------- | ---------- | ----------------------- |
| 是不是        | `is…`      | `isLoading`             |
| 有没有        | `has…`     | `hasReward`             |
| 能不能        | `can…`     | `canDrag`               |
| 要不要        | `should…`  | `shouldDestroy`         |
| 待处理的 / 挂起的 | `pending…` | `pendingHide`（待处理的隐藏请求） |
| 被忽略的       | `ignored…` | `s_ignoredNames`        |

---

## 四、成对词（起名时成对使用，别混搭）

| 成对                                         | 典型用途                                          |
| ------------------------------------------ | --------------------------------------------- |
| `Add` / `Remove`                           | 容器加删元素、加删监听                                   |
| `Insert` / `Delete`                        | 在指定位置插入 / 删除                                  |
| `Create` / `Destroy`                       | 对象的生命周期                                       |
| `Load` / `Unload`                          | 资源加载 / 卸载                                     |
| `Show` / `Hide`                            | 面板显隐                                          |
| `Open` / `Close`                           | 打开 / 关闭                                       |
| `Activate` / `Deactivate`                  | 激活 / 失活                                       |
| `Enable` / `Disable`                       | 启用 / 禁用                                       |
| `Start` / `Stop`                           | 开始 / 停止（协程、计时）                                |
| `Begin` / `End`                            | 一段过程的开始 / 结束                                  |
| `Register` / `Unregister`                  | 注册 / 注销（事件、服务）                                |
| `Subscribe` / `Unsubscribe`                | 订阅 / 取消订阅                                     |
| `Get` / `Release`                          | 从池里取 / 还回池里（Unity 官方 `ObjectPool<T>` 用的就是这一对） |
| `Push` / `Pop`                             | 栈语义：压入 / 弹出                                   |
| `Put` / `Get`                              | 存 / 取                                         |
| `Send` / `Receive`                         | 发送 / 接收                                       |
| `Lock` / `Unlock`                          | 加锁 / 解锁                                       |
| `Increment` / `Decrement`                  | 加一 / 减一                                       |
| `First` / `Last`                           | 第一个 / 最后一个                                    |
| `Next` / `Previous`（缩写 `Prev`）             | 下一个 / 上一个                                     |
| `Min` / `Max`                              | 最小 / 最大                                       |
| `Old` / `New`                              | 旧 / 新                                         |
| `Up` / `Down`                              | 上 / 下                                         |
| `Source` / `Target`                        | 源 / 目标                                        |
| `Source` / `Destination`（缩写 `src` / `dst`） | 源 / 目的地（拷贝、移动）                                |
| `Copy` / `Paste`、`Cut` / `Paste`           | 复制 / 剪切 / 粘贴                                  |

**本项目对象池统一用 `Get` / `Release`**（借出 / 归还；`Release` 是还回池里，不是销毁）。原先沿用教材的 `PushObj` / `GetObj` 是两组配对混搭（Push 本该配 Pop，Get 本该配 Release），已决定改掉。

---

## 五、整理说明（相对原笔记修正了什么）

| #   | 原笔记                      | 改为                                                      | 原因                                                           |
| --- | ------------------------ | ------------------------------------------------------- | ------------------------------------------------------------ |
| 1   | 命名规范表里“枚举”出现两行，前缀说法不一致   | 合并成一行，写明本项目统一用 `E_`                                     | 去重；本项目代码实际一直在用 `E_`                                          |
| 2   | 存 `Push` 取 `Get`         | 拆成三组标准配对：`Get` / `Release`、`Push` / `Pop`、`Put` / `Get` | `Push` 和 `Get` 不是一对                                          |
| 3   | 预热 `Warm`                | `Prewarm` / `WarmUp`                                    | Unity 自己的写法：粒子系统的 prewarm、`ShaderVariantCollection.WarmUp()` |
| 4   | `pending…` 待定            | 待处理的 / 挂起的                                              | `pendingHide` 指“等着被处理的隐藏请求”，不是“还没决定”                         |
| 5   | `add` / `delete`         | 删掉，改用 `Add` / `Remove` 或 `Insert` / `Delete`            | 不是常用配对                                                       |
| 6   | `Dir` 方向                 | `Direction`，注明缩写 `Dir` 的歧义                              | `Dir` 也常指 `Directory`                                        |
| 7   | `diff` 差                 | 区分 `Difference`（差值）和 `Delta`（变化量）                       | 两者语义不同，`deltaTime` 用的是后者                                     |
| 8   | `vertices`、`triangles`   | 补上单数 `Vertex`、`Triangle`                                | 单个对象用单数                                                      |
| 9   | 类名例子 `MonoMgr`           | 例子改为 `UIManager`，另加“缩写”说明                               | 本项目 `Mgr` 和 `Manager` 混用，需要统一                                |
| 10  | 无                        | 新增基类、扩展方法类、静态工具类、bool 四条规则                              | UI 模块里实际用到、讨论过的命名                                            |
| 11  | `Mgr` / `Manager` 混用     | 本项目统一用 `Manager`（1.1）                                   | 用户拍板                                                         |
| 12  | 对象池 `PushObj` / `GetObj` | 本项目统一用 `Get` / `Release`（1.1）                           | 用户拍板                                                         |
| 13  | 无                        | 新增 Try 方法、`ThrowIf…` 方法两条规则（1.2）                        | UI 模块里用到；名字和规则是 Claude 给的                                    |
| 14  | 无                        | 新增第六部分「撞名时怎么起名」（1.2）                                    | 用户提问"嵌套时临时变量撞名有没有统一格式"，原则和例子是 Claude 给的                      |

---

## 六、撞名时怎么起名（同一作用域里有两个同类的变量）

**原则：按"两者的区别"起名，不靠缩写区分。** 缩写（`info`、`ctrl`）只是把字变短，看不出两个变量差在哪；名字要说出"这一个和那一个哪里不一样"。

| 两者的区别 | 写法 | 例子 |
|---|---|---|
| 一个是基类类型，一个是转换后的子类 | 基类那个加 `Base` | `PanelInfoBase panelInfoBase` → `PanelInfo<T> panelInfo` |
| 一个已经存在，一个是新建的 | `existing…` / `new…` | `existingEntry` / `newEntry` |
| 一个是查找出来的 | `matched…` / `found…` | `matchedEntry = trigger.triggers.Find(...)` |
| 改之前 / 改之后 | `old…` / `new…` | `oldState` / `newState` |
| 当前的 / 上一次的 | `current…` / `previous…` | `currentPanel` / `previousPanel` |
| 源 / 目标 | `source…` / `target…` | `sourceList` / `targetList` |

⚠ 本节是按 UI 模块收尾时 Claude 给的同一原则重写的（当时那张表在更早的对话里，原文已经取不回来）；例子取自本项目代码。