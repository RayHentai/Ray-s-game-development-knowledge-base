# ⚖️ MV+X 模式横向对比

> 一页搞清楚五种模式的区别，选型直接查这里。
> **记住：不要拘泥于框架，找到适合自己项目的稳定实现方式才是目标。**

---

## 一句话定位

| 模式          | 全称                     | 一句话                                      |
| ----------- | ---------------------- | ---------------------------------------- |
| **MVC**     | Model-View-Controller  | 最基础的分层，M和V之间还有耦合                         |
| **MVP**     | Model-View-Presenter   | 切断M和V的直接联系，全部走Presenter                  |
| **MVVM**    | Model-View-ViewModel   | MVP升级版，V和VM双向数据绑定，Unity中不太适合             |
| **MVE**     | Model-View-EventCenter | 用事件中心做解耦，观察者模式的直接应用                      |
| **PureMVC** | —                      | 基于MVC的第三方框架，有完整的Proxy/Mediator/Command体系 |

---

## 核心对比表

| 对比项 | MVC | MVP | MVVM | MVE | PureMVC |
|--------|-----|-----|------|-----|---------|
| **M和V是否直接联系** | ✅ 有 | ❌ 全走Presenter | ❌ 全走ViewModel | ❌ 全走EventCenter | ❌ 全走Facade |
| **通信方式** | Controller调用 | Presenter双向 | 数据绑定（双向） | 事件分发（单向） | Notification通知 |
| **代码复杂度** | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **解耦程度** | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Unity适配度** | ✅ 好 | ✅ 好 | ⚠️ 水土不服 | ✅ 好 | ✅ 好（需导入） |
| **是否第三方** | 思想，无依赖 | 思想，无依赖 | 思想，无依赖 | 思想，无依赖 | ✅ 需导入dll |
| **团队协作友好度** | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## 各层职责对比

### Model 层（所有模式相同）
- 记录数据
- 初始化数据（从PlayerPrefs/文件读取）
- 提供数据修改方法
- 通知外部数据更新（通过事件/通知）

### 中间层（X 的差异所在）

| 模式 | 中间层名称 | 核心职责 | 与M的关系 | 与V的关系 |
|------|-----------|---------|----------|----------|
| MVC | Controller | 处理业务逻辑 | 直接调用 | 直接调用 |
| MVP | Presenter | 处理业务逻辑 + 持有V的引用 | 直接调用 | 直接调用 |
| MVVM | ViewModel | 处理业务逻辑 + 数据绑定 | 直接调用 | **数据绑定（双向）** |
| MVE | EventCenter | 只负责分发事件，不含逻辑 | 监听事件 | 监听事件 |
| PureMVC | Command+Facade | Command处理逻辑，Facade统管全局 | 通过Proxy | 通过Mediator |

### View 层差异

| 模式 | View 能直接访问 Model 吗 | View 主动获取数据吗 | View 怎么更新 |
|------|------------------------|-------------------|-------------|
| MVC | ✅ 可以 | ✅ 主动读取 | 自己从M读 |
| MVP | ❌ 不能 | ❌ 被动 | Presenter推送 |
| MVVM | ❌ 不能 | ❌ 被动 | 数据绑定自动更新 |
| MVE | ❌ 不能 | 第一次主动，之后被动 | 监听事件被动更新 |
| PureMVC | ❌ 不能 | ❌ 被动 | Mediator收到Notification后推送 |

---

## PureMVC 结构详解

PureMVC 是这几种里唯一的第三方框架，有自己的一套完整术语体系：

| PureMVC 组件 | 对应 MVC 层 | 职责 |
|-------------|-----------|------|
| **Proxy（代理）** | Model | 封装数据和数据操作，一个数据类对应一个Proxy |
| **Mediator（中介）** | View | 封装UI面板，监听通知并更新界面 |
| **Command（命令）** | Controller | 处理业务逻辑，响应通知 |
| **Facade（外观）** | 统管全局 | 注册和获取Proxy/Mediator/Command，发送通知 |
| **Notification（通知）** | 消息 | 在各组件之间传递信息的载体 |

```
操作触发 → Mediator 发送 Notification
         → Facade 路由到对应 Command
         → Command 处理逻辑，操作 Proxy 数据
         → Proxy 数据变化，发送 Notification
         → Facade 路由到对应 Mediator
         → Mediator 更新 View
```

---

## 数据流对比（以"升级"操作为例）

**MVC：**
```
Button点击 → Controller.LevUp()
           → PlayerModel.LevUp()（数据更新）
           → View.UpdateInfo()（界面刷新）
```

**MVP：**
```
Button点击 → Presenter.LevUp()
           → PlayerModel.LevUp()（数据更新）
           → Presenter 持有View引用 → View.UpdateInfo()
```

**MVE：**
```
Button点击 → PlayerModel.LevUp()（数据更新）
           → EventCenter.EventTrigger("UpdatePlayerInfo", data)
           → View 监听到事件 → 自动更新界面
```

**PureMVC：**
```
Button点击 → Mediator.SendNotification("levUp")
           → Facade 路由 → LevUpCommand.Execute()
           → PlayerProxy.LevUp()（数据更新）
           → SendNotification("updatePlayerInfo")
           → MainViewMediator 收到 → 更新界面
```

---

## 选型建议

**个人项目 / 小团队：**
- 简单UI → **MVC**（够用就好，别过度设计）
- 需要解耦 → **MVE**（利用已有的EventCenter，改动最小）

**中大型项目 / 多人协作：**
- 追求清晰职责划分 → **MVP**
- 已有PureMVC经验的团队 → **PureMVC**

**不建议在Unity中用MVVM**，除非使用专门的第三方框架（Loxodon/uMVVM），手写成本远大于收益。

---

## 关联

[[01 MVC 基本概念和实例]] | [[02 MV + X 概述]] | [[03 MVP 基本概念和实例]] | [[04 MVVM 基本概念和实例]] | [[05 MVE 基本概念和实例]] | [[06 PureMVC 基本概念和实例]]

---

*最后更新：*
