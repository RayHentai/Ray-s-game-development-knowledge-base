# 项目 Json 数据管理器

**所属阶段**：[[00 Json 总览]]
**综合知识点**：[[]] | [[]] | [[]]
**完成状态**：🔄 进行中 / ✅ 已完成
**查阅次数**：0

---

## 需求分析

提供一个存储和读取方法供外部使用的数据管理类
可以选择是用 JsonUtility 还是 LitJson

---

## 功能拆解

> 把整个项目拆成独立的功能模块，每个功能是一个可以单独实现的单元

- [ ] 功能一：
- [ ] 功能二：
- [ ] 功能三：
- [ ] 功能四：

---

## 架构设计

> 框架先行：先列出来怎么拆分，再填实现细节

```
项目结构：
├── 场景管理
│   ├── 开始场景
│   ├── 游戏场景
│   └── 结束场景
├── 核心逻辑
│   ├── 
│   └── 
└── 工具/辅助
    ├── 
    └── 
```

---

## UML类图

---
## 核心设计思路 / 理论分析

> 用伪代码或文字描述最关键的逻辑，写代码之前先想清楚

**关键逻辑一**：

```
// 伪代码描述思路
```

**关键逻辑二**：

```
// 伪代码描述思路
```

---

## 完整工程

```csharp
public enum E_JsonType
{
    JsonUtility,
    LitJson,
}
public class JsonMgr
{
    private static JsonMgr instance = new JsonMgr();
    public static JsonMgr Instance => instance;
    private JsonMgr() { }
    public void SaveData(object data, string fileName, E_JsonType type = E_JsonType.LitJson) 
    {
        string path = Application.persistentDataPath + "/" + fileName + ".Json";
        string jsonStr = "";
        switch (type)
        {
            case E_JsonType.JsonUtility:
                jsonStr = JsonUtility.ToJson(data);
                break;
            case E_JsonType.LitJson:
                jsonStr = JsonMapper.ToJson(data);
                break;
        }
        File.WriteAllText(path, jsonStr);
    }
    public T LoadData<T>(string fileName, E_JsonType type = E_JsonType.LitJson) where T : new()
    {
        string path = Application.streamingAssetsPath + "/" + fileName + ".Json";
        if (!File.Exists(path))
            path = Application.persistentDataPath + "/" + fileName + ".Json";
        if (!File.Exists(path))
            return new T();
        string jsonStr = File.ReadAllText(path);
        T data = default(T);
        switch (type)
        {
            case E_JsonType.JsonUtility:
                data = JsonUtility.FromJson<T>(jsonStr);
                break;
            case E_JsonType.LitJson:
                data = JsonMapper.ToObject<T>(jsonStr);
                break;
        }
        return data;
    }
}
```

---
## 关键代码片段

> 只记重要的、有代表性的代码，加注释说明为什么这样写

### 场景切换

```csharp
// 说明：为什么用这种方式切换场景

```

### 核心逻辑

```csharp
// 说明：

```

### 数据处理

```csharp
// 说明：

```

---

## 遇到的问题 & 解决方案

| 问题描述 | 原因分析 | 解决方案 |
|----------|----------|----------|
| | | |
| | | |
| | | |

---

## Bug 记录

| 发现时间 | Bug 描述 | 状态 | 解决方法 |
|----------|----------|------|----------|
| | | 🔴 未修复 | |
| | | ✅ 已修复 | |

---

## 代码复用记录

> 哪些代码是从之前项目复用/改进来的，哪些是新写的

- 复用自：
- 改进了：
- 新增了：

---

## 完成后的感悟

> 做这个项目学到了什么新东西？有没有对某个知识点有了新的理解？

**新学到的东西**：

**对某个知识点的新理解**：

**下次可以改进的地方**：

---

## 扩展想法

> 如果要继续优化这个项目，可以做哪些功能？

- 
- 

---

**完成时间**：
**耗时**：
