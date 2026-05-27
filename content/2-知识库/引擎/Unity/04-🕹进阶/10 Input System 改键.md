# 10 Input System 改键

**所属阶段**：[[00 Unity 进阶阶段总览]]
**综合知识点**：[[25 string常用方法]] | [[]] | [[]]
**完成状态**：🔄 进行中 / ✅ 已完成
**查阅次数**：0

---

## 方案

1. 获取输入配置的Json信息（设备和按键信息）
2. 修改Json数据
3. 生成InputActionAsset对象
4. 赋值给PlayerInput达到改建目的

**注意：**
- 改建的做法不止这一种，随着我们学习的知识增多，还可以使用别的方式来制作改建
- 目前使用的方式只是基于现有知识点来进行制作的

**需求实现**
1. 编辑输入配置文件，并转存到文本文件中
2. 创建改键信息数据结构类
3. 编辑文本文件中的可变字符串（设置一个替换符）
4. 制作改键UI相关逻辑
5. 实现改键
6. 数据持久化

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

---

### Manager

```csharp title:数据管理器
/// <summary>
/// 数据管理类
/// </summary>
public class DataManager
{
    private static DataManager instance = new DataManager();
    public static DataManager Instance => instance;
    private KeyInfo keyInfo;
    private string jsonStr;
    public KeyInfo KeyInfo => keyInfo;
    
    private DataManager() 
    {
        keyInfo = JsonMgr.Instance.LoadData<KeyInfo>("TestFile");
        jsonStr = Resources.Load<TextAsset>("Test").text;//加载有通配符的配置文件
    }
    /// <summary>
    /// 得到修改后的配置文件
    /// </summary>
    /// <returns></returns>
    public InputActionAsset GetActionAsset()
    {
        string str = jsonStr.Replace("<Up>", keyInfo.up);
        str = str.Replace("<Down>", keyInfo.down);
        str = str.Replace("<Left>", keyInfo.left);
        str = str.Replace("<Right>", keyInfo.right);
        str = str.Replace("<Fire>", keyInfo.fire);
        str = str.Replace("<Jump>", keyInfo.jump);
        return InputActionAsset.FromJson(str);
    }

}
```

---

### UI

```csharp title:改键面板
public enum E_KeyType
{
    UP,
    DOWN,
    LEFT,
    RIGHT,
    FIRE,
    JUMP
}
public class ChangeKeyPanel : MonoBehaviour
{

    public Text txtUpKey;
    public Text txtDownKey;
    public Text txtLeftKey;
    public Text txtRightKey;
    public Text txtFire;
    public Text txtJump;

    public Button btnUp;
    public Button btnDown;
    public Button btnLeft;
    public Button btnRight;
    public Button btnFire;
    public Button btnJump;

    private KeyInfo keyInfo;
    private E_KeyType nowKey;
    public PlayerObj playerObj;
    void Start()
    {
        keyInfo = DataManager.Instance.KeyInfo;//获取键位信息
        UpdateInfo();
        btnUp.onClick.AddListener(() => { ChangeKey(E_KeyType.UP); });
        btnDown.onClick.AddListener(() => { ChangeKey(E_KeyType.DOWN); });
        btnLeft.onClick.AddListener(() => { ChangeKey(E_KeyType.LEFT); });
        btnRight.onClick.AddListener(() => { ChangeKey(E_KeyType.RIGHT); });
        btnFire.onClick.AddListener(() => { ChangeKey(E_KeyType.FIRE); });
        btnJump.onClick.AddListener(() => { ChangeKey(E_KeyType.JUMP); });
    }
    private void ChangeKey(E_KeyType type)
    {
        nowKey = type;
        InputSystem.onAnyButtonPress.CallOnce(ChangeKeyReally);
    }
    public void ChangeKeyReally(InputControl control)
    {

        string[] strs = control.path.Split('/');
        string path = "<" + strs[1] + ">/" + strs[2];
        switch (nowKey)
        {
            case E_KeyType.UP:
                keyInfo.up = path;
                break;
            case E_KeyType.DOWN:
                keyInfo.down = path;
                break;
            case E_KeyType.LEFT:
                keyInfo.left = path;
                break;
            case E_KeyType.RIGHT:
                keyInfo.right = path;
                break;
            case E_KeyType.FIRE:
                keyInfo.fire = path;
                break;
            case E_KeyType.JUMP:
                keyInfo.jump = path;
                break;
        }
        JsonMgr.Instance.SaveData(keyInfo, "TestFile");
        playerObj.ChangeKey();//让玩家改键
        UpdateInfo();
    }
    public void UpdateInfo()
    {
        txtUpKey.text = keyInfo.up;
        txtDownKey.text = keyInfo.down;
        txtLeftKey.text = keyInfo.left;
        txtRightKey.text = keyInfo.right;
        txtFire.text = keyInfo.fire;
        txtJump.text = keyInfo.jump;
    }
}
```

---

### Data

```json title:json文本
//只贴出关键部分
{
    //...
            "bindings": [
                {
                    "path": "<Fire>",
                    "action": "Fire",
                },
                {
                    "path": "<Jump>",
                    "action": "Jump",
                },
                {
                    "name": "up",
                    "path": "<Up>",
                    "action": "Move",
                },
                {
                    "name": "down",
                    "path": "<Down>",
                    "action": "Move",
                },
                {
                    "name": "left",
                    "path": "<Left>",
                    "action": "Move",
                },
                {
                    "name": "right",
                    "path": "<Right>",
                    "action": "Move",
                }
}
```

```csharp title:数据结构类
public class KeyInfo
{
    public string fire = "<Mouse>/leftButton";
    public string jump = "<Keyboard>/space";
    public string up = "<Keyboard>/w";
    public string down = "<Keyboard>/a";
    public string left = "<Keyboard>/s";
    public string right = "<Keyboard>/d";
}
```

---

### GameObject

```csharp title:玩家
public class PlayerObj : MonoBehaviour
{
    private PlayerInput input;
    void Start()
    {
        input = GetComponent<PlayerInput>();
        input.actions = DataManager.Instance.GetActionAsset();
        input.actions.Enable();//改完键之后需重新激活
        input.onActionTriggered += (context) =>
        {
            if (context.phase == InputActionPhase.Performed)
            {
                switch (context.action.name)
                {
                    case "Move":
                        print("移动");
                        break;
                    case "Fire":
                        print("开火");
                        break;
                    case "Jump":
                        print("跳跃");
                        break;
                }
            }
        };
    }
    /// <summary>
    /// 让玩家改键
    /// </summary>
    public void ChangeKey()
    {
        input.actions = DataManager.Instance.GetActionAsset();
        input.actions.Enable();
    }
}
```

---

## 完成后的感悟

> 做这个项目学到了什么新东西？有没有对某个知识点有了新的理解？

**新学到的东西**：
- 如果想要改变某些配置文件中的内容，可以根据配置文件Copy一份一模一样的文本
- 将需要改的地方设置一个自定义的通配符
- 执行逻辑的时候，先读取文本，将通配符改成想要的文本，再将修改后的文本读取到配置文件中

**对某个知识点的新理解**：string 方法的用法

**下次可以改进的地方**：

---

## 扩展想法

> 如果要继续优化这个项目，可以做哪些功能？

- 
- 

---

**完成时间**：
**耗时**：
