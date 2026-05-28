# 01 MVC 基本概念和实例

**所属模块**：[[00 MVC思想 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

- **MVC的作用：** 主要用于软件和网页开发
- **MVC的基本概念：** 数据、界面、业务逻辑分离
- **MVC在游戏中的应用：** 非必须的UI系统开发框架

**是否使用MVC**
- 根据人来定 项目中的人是否能看懂MVC结构
- 根据项目来定 小项目还是复杂项目
- 根据团队规模来定 规模大用MVC可以提高效率

---

## MVC的基本概念

**自定前提：**
粗略的把计算机上使用的工具分为应用软件、网页、游戏

**MVC是应用软件开发、网页开发等最常用和流行的通用开发框架**

应用软件和网页基本功能都是由UI(用户界面)、Data (数据)构成的，下面是基本的使用规则
![[应用、网页的使用规则.png]]
**因为这样的使用规则所以产生了MVC框架**

**MVC 全名是 Model View Controller**
- 是模型(model) - 视图(view) - 控制器(controller)的缩写
- 是一种软件设计规范，用一种业务逻辑、数据、界面显示分离的方法组织代码
- 将业务逻辑聚集到一个部件里面，在改进和个性化定制界面及用户交互的同时，不需要重新编写业务逻辑。

**不使用MVC框架制作一个界面功能**
![[不使用MVC框架制作一个界面功能.png|593]]

**使用MVC思想实现一个界面功能**
![[使用MVC思想实现一个界面功能.png]]
**简单说就是把逻辑全部杂糅到一起写，变成分成三个部分写**

**MVC的一般流程**
![[MVC的一般流程.png|418]]

---

## Unity中的MVC思想

**注意：**
1. 它并不是必备的内容
2. 它主要用于开发游戏UI系统

**主要变化**
![[游戏开发中的MVC思想 主要变化.png]]

**好处：**
1. 各司其职，互不干涉 — 编程思路更清晰
2. 有利开发中的分工 一 多人协同开发时，同步并行
3. 有利于组件重用 — 项目换皮时，功能变化小时，提高开发效率

**缺点：**
1. 增加了程序文件的体量 — 脚本由一变三
2. 增加了结构的复杂性 — 对于不清楚MVC原理的人不友好
3. 效率相对较低 — 对象之间的相互跳转，始终伴随着一定开销（现代设备微乎其微）

---

## MVC的基本实例

**两者对比：**
![[普通做法和MVC做法对比.png|515]]

![[不使用MVC框架制作一个界面功能.png|525]]
![[使用MVC思想实现一个界面功能.png|526]]


数据：负责增删查改获取界面上需要的数据
界面：负责获取控件，更新控件信息
控制：负责业务逻辑处理

界面事件监听，触发数据更新，触发界面更新
![[MVC流程 图示.png|525]]


---

### 不使用MVC思想制作UI逻辑

---

#### MainPanel

```csharp
public class MainPanel : MonoBehaviour
{
    //1 关联控件
    public Text txtName;
    public Text txtLev;
    public Text txtMoney;
    public Text txtGem;
    public Text txtPower;
    public Button btnRole;
    private static MainPanel mainPanel;
    public static MainPanel Panel => mainPanel;

    void Start()
    {
        //2 添加事件监听
        btnRole.onClick.AddListener(() => 
        {
            RolePanel.ShowMe();
        });
    }

    //4 面板显隐
    public static void ShowMe() 
    {
        if (mainPanel == null)
        {
            GameObject panObj = Instantiate(Resources.Load<GameObject>("UI/MainPanel"));
            panObj.transform.SetParent(GameObject.Find("Canvas").transform, false);
            mainPanel = panObj.GetComponent<MainPanel>();
        }
        mainPanel.gameObject.SetActive(true);
        mainPanel.UpdateInfo();
    }
    public static void HideMe() 
    {
        if (mainPanel != null)
            mainPanel.gameObject.SetActive(false);
        
    }
    //3 更新面板
    public void UpdateInfo() 
    {
        //读取数据 用最简单的PlayerPrefs
        txtName.text = PlayerPrefs.GetString("PlayerName", "Hentai");
        txtLev.text = "LV." + PlayerPrefs.GetInt("PlayerLev", 1).ToString();
        txtMoney.text = PlayerPrefs.GetInt("PlayerMoney", 999).ToString();
        txtGem.text = PlayerPrefs.GetInt("PlayerGem", 888).ToString();
        txtPower.text = PlayerPrefs.GetInt("PlayerPower", 30).ToString();
    }
}

```

---

#### RolePanel

```csharp
public class RolePanel : MonoBehaviour
{
    public Text txtLev;
    public Text txtHp;
    public Text txtAtk;
    public Text txtDef;
    public Text txtCrit;
    public Text txtMiss;
    public Text txtLuck;
    public Button btnClose;
    public Button btnLevUp;
    private static RolePanel rolePanel;
    
    void Start()
    {
        btnClose.onClick.AddListener(() => 
        {
            HideMe();
        });
        btnLevUp.onClick.AddListener(() => 
        {
            //得数据
            int lev = PlayerPrefs.GetInt("PlayerLev", 1);
            int hp = PlayerPrefs.GetInt("PlayerHp", 100);
            int atk = PlayerPrefs.GetInt("PlayerAtk", 20);
            int def = PlayerPrefs.GetInt("PlayerDef", 10);
            int crit = PlayerPrefs.GetInt("PlayerCrit", 40);
            int miss = PlayerPrefs.GetInt("PlayerMiss", 20);
            int luck = PlayerPrefs.GetInt("PlayerLuck", 10);
            //改数据
            lev += 1;
            hp += lev;
            atk += lev;
            def += lev;
            crit += lev;
            miss += lev;
            luck += lev;
            //存数据
            PlayerPrefs.SetInt("PlayerLev", lev);
            PlayerPrefs.SetInt("PlayerHp", hp);
            PlayerPrefs.SetInt("PlayerAtk", atk);
            PlayerPrefs.SetInt("PlayerDef", def);
            PlayerPrefs.SetInt("PlayerCrit", crit);
            PlayerPrefs.SetInt("PlayerMiss", miss);
            PlayerPrefs.SetInt("PlayerLuck", luck);
            //更新面板
            rolePanel.UpdateInfo();
            MainPanel.Panel.UpdateInfo();
        });
    }
    public static void ShowMe()
    {
        if (rolePanel == null)
        {
            GameObject panObj = Instantiate(Resources.Load<GameObject>("UI/RolePanel"));
            panObj.transform.SetParent(GameObject.Find("Canvas").transform, false);
            rolePanel = panObj.GetComponent<RolePanel>();
        }
        rolePanel.gameObject.SetActive(true);
        rolePanel.UpdateInfo();
    }
    public static void HideMe()
    {
        if (rolePanel != null)
            rolePanel.gameObject.SetActive(false);
    }
    private void UpdateInfo()
    {
        txtLev.text = "Lv." + PlayerPrefs.GetInt("PlayerLev", 1).ToString();
        txtHp.text = PlayerPrefs.GetInt("PlayerHp", 100).ToString();
        txtAtk.text = PlayerPrefs.GetInt("PlayerAtk", 20).ToString();
        txtDef.text = PlayerPrefs.GetInt("PlayerDef", 10).ToString();
        txtCrit.text = PlayerPrefs.GetInt("PlayerCrit", 40).ToString();
        txtMiss.text = PlayerPrefs.GetInt("PlayerMiss", 20).ToString();
        txtLuck.text = PlayerPrefs.GetInt("PlayerLuck", 10).ToString();
    }
}
```

---

### 使用MVC思想制作UI逻辑

---

#### Model

```csharp
//作为一个唯一的数据模型一般情况要不自己是个单例模式对象
//要不自己存在在一个单例模式对象中
public class PlayerModel
{
    private static PlayerModel data = null;
    public static PlayerModel Data
    {
        get 
        {
            if (data == null)
            {
                data = new PlayerModel();
                data.Init();
            }
            return data; 
        }
    }
    //1 记录所有数据内容
    private string playerName;
    public string PlayerName => playerName;
    private int lev;
    public int Lev => lev;
    private int money;
    public int Money => money;
    private int gem;
    public int Gem => gem;
    private int power;
    public int Power => power;
    public int hp;
    public int HP => hp;
    private int atk;
    public int Atk => atk;
    private int def;
    public int Def => def;
    private int crit;
    public int Crit => crit;
    private int miss;
    public int Miss => miss;
    private int luck;
    public int Luck => luck;
    //通知外部更新的事件
    //通过它和外部建立联系 而不是直接获取外部的面板
    public UnityAction<PlayerModel> updateEvent;
    //2 初始化
    public void Init() 
    {
        playerName = PlayerPrefs.GetString("PlayerName", "Hentai");
        lev = PlayerPrefs.GetInt("PlayerLev", 1);
        money = PlayerPrefs.GetInt("PlayerMoney", 999);
        gem = PlayerPrefs.GetInt("PlayerGem", 888);
        power = PlayerPrefs.GetInt("PlayerPower", 90);
        hp = PlayerPrefs.GetInt("PlayerHp", 100);
        atk = PlayerPrefs.GetInt("PlayerAtk", 50);
        def = PlayerPrefs.GetInt("PlayerDef", 10);
        crit = PlayerPrefs.GetInt("PlayerCrit", 20);
        miss = PlayerPrefs.GetInt("PlayerMiss", 40);
        luck = PlayerPrefs.GetInt("PlayerLuck", 20);
    }
    //3 数据的更新和保存
    public void LevUp() 
    {
        lev += 1;
        hp += lev;
        atk += lev;
        def += lev;
        crit += lev;
        miss += lev;
        luck += lev;
        SaveData();
    }
    public void SaveData()
    {
        PlayerPrefs.SetString("PlayerName", playerName);
        PlayerPrefs.SetInt("PlayerLev", lev);
        PlayerPrefs.SetInt("PlayerMoney", money);
        PlayerPrefs.SetInt("PlayerGem", gem);
        PlayerPrefs.SetInt("PlayerPower", power);
        PlayerPrefs.SetInt("PlayerHp", hp);
        PlayerPrefs.SetInt("PlayerAtk", atk);
        PlayerPrefs.SetInt("PlayerDef", def);
        PlayerPrefs.SetInt("PlayerCrit", crit);
        PlayerPrefs.SetInt("PlayerMiss", miss);
        PlayerPrefs.SetInt("PlayerLuck", luck);
        updateInfo();
    }
    public void AddEventListener(UnityAction<PlayerModel> function) 
    {
        updateEvent += function;
    }
    public void RemoveEventListener(UnityAction<PlayerModel> function)
    {
        function -= function;
    }
    //4 通知外部处理事件的方法
    private void updateInfo() 
    {
        updateEvent?.Invoke(this);
    }
}

```

---

#### View

---

##### MainView

```csharp
public class MainView : MonoBehaviour
{
    //1 找控件
    public Text txtName;
    public Text txtLev;
    public Text txtMoney;
    public Text txtGem;
    public Text txtPower;
    public Button btnRole;
    //2 提供更新方法
    public void UpdateInfo(PlayerModel data)
    {
        txtName.text = data.PlayerName;
        txtLev.text = "Lv." + data.Lev;
        txtMoney.text = data.Money.ToString();
        txtGem.text = data.Gem.ToString();
        txtPower.text = data.Power.ToString();
    }
}
```

---

##### RoleView

```csharp
public class RoleView : MonoBehaviour
{
    public Text txtLev;
    public Text txtHp;
    public Text txtAtk;
    public Text txtDef;
    public Text txtCrit;
    public Text txtMiss;
    public Text txtLuck;
    public Button btnClose;
    public Button btnLevUp;
    public void UpdateInfo(PlayerModel data)
    {
        txtLev.text = "Lv." + data.Lev;
        txtHp.text = data.hp.ToString();
        txtAtk.text = data.Atk.ToString();
        txtDef.text = data.Def.ToString();
        txtCrit.text = data.Crit.ToString();
        txtMiss.text = data.Miss.ToString();
        txtLuck.text = data.Luck.ToString();
    }
}
```

---

### Controller

---

##### MainController

```csharp
public class MainController : MonoBehaviour
{
    private static MainController controller = null;
    public static MainController Controller => controller;

    //挂载在对象上的 mainView 脚本 得到View界面
    private MainView mainView;

    void Start()
    {
        mainView = GetComponent<MainView>();
        //2 数据更新
        mainView.UpdateInfo(PlayerModel.Data);
        //3 数据监听
        mainView.btnRole.onClick.AddListener(() => 
        {
            RoleController.ShowMe(); 
        });
        // 监听数据更新
        PlayerModel.Data.AddEventListener((data) => 
        {
            if (mainView != null)
                mainView.UpdateInfo(data);
        });
    }
    //依附的对象被删除时 移除添加的事件委托
    private void OnDestroy()
    {
        PlayerModel.Data.RemoveEventListener((data) =>
        {
            if (mainView != null)
                mainView.UpdateInfo(data);
        });
    }
    //1 面板显隐
    public static void ShowMe() 
    {
        if (controller == null)
        {
            GameObject panObj = Instantiate(Resources.Load<GameObject>("UI/MainPanel"));
            panObj.transform.SetParent(GameObject.Find("Canvas").transform, false);
            controller = panObj.GetComponent<MainController>();
        }
        controller.gameObject.SetActive(true);
    }
    public static void HideMe() 
    {
        if (controller != null)
            controller.gameObject.SetActive(false);
    }

}

```

---

##### RoleController

```csharp
public class RoleController : MonoBehaviour
{
    private static RoleController controller = null;
    public static RoleController Controller => controller;

    //挂载在对象上的 mainView 脚本
    private RoleView roleView;

    void Start()
    {
        roleView = GetComponent<RoleView>();
        //2 数据更新
        roleView.UpdateInfo(PlayerModel.Data);
        roleView.btnClose.onClick.AddListener(() =>
        {
            HideMe();
        });
        roleView.btnLevUp.onClick.AddListener(() =>
        {
            PlayerModel.Data.LevUp();
        });
        PlayerModel.Data.AddEventListener((data) =>
        {
            if (roleView != null)
                roleView.UpdateInfo(data);
        });
    }
    private void OnDestroy()
    {
        PlayerModel.Data.RemoveEventListener((data) =>
        {
            if (roleView != null)
                roleView.UpdateInfo(data);
        });
    }
    //1 面板显隐
    public static void ShowMe()
    {
        if (controller == null)
        {
            GameObject panObj = Instantiate(Resources.Load<GameObject>("UI/RolePanel"));
            panObj.transform.SetParent(GameObject.Find("Canvas").transform, false);
            controller = panObj.GetComponent<RoleController>();
        }
        controller.gameObject.SetActive(true);
    }
    public static void HideMe()
    {
        if (controller != null)
            controller.gameObject.SetActive(false);
    }
}

```

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 场景一：
- 场景二：
- 反例（不该用的时候）：

---

## 我的踩坑记录

> ⭐ 这里最有价值！把自己犯过的错误写下来，写上日期

- （日期）踩坑描述 → 解决方法

---

## 延伸阅读

> 这个知识点延伸出去的方向，学完后可以探索

- [[]]相关知识点
- 

---

*最后更新：*
