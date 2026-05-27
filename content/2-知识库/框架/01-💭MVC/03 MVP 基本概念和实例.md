# 03 MVP 基本概念和实例

**所属模块**：[[00 MVC思想 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

MVP全称为：模型(Model)一视图(View)一主持人(Presenter)
Model提供数据，View负责界面，Presenter负责逻辑的处理
**它是MVC的一种变式，是针对MVC中M和V存在耦合的优化**

**MVP与MVC有着一个重大的区别：**
- 在MVC中 View 会直接从 Model 中读取数据而不是通过 Controller
- 而在MVP中 View 并不直接使用 Model ，它们之间的通信是通过 Presenter 来进行的，所有的交互都发生在Presenter内部。

MVP中的Presenter（主持人）将完全断绝 View 和 Model 的来往主要程序逻辑都在 Presenter 中实现
![[MVP 图示.png]]

---

## 基本实例

---

### Model
 
**不变**

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

### View

**不再通过View更新面板**

---

##### MainView

```csharp
public class MVP_MainView : MonoBehaviour
{
    //1 找控件
    public Text txtName;
    public Text txtLev;
    public Text txtMoney;
    public Text txtGem;
    public Text txtPower;
    public Button btnRole;

    //2 提供更新方法 因为是通过Presenter管理的 可写可不写
    //public void UpdateInfo(string name, int lev, int money, int gem, int power)
    //{
    //    txtName.text = name;
    //    txtLev.text = "Lv." + lev;
    //    txtMoney.text = money.ToString();
    //    txtGem.text = gem.ToString();
    //    txtPower.text = power.ToString();
    //}
}

```

---

##### RoleView

```csharp
public class MVP_RoleView : MonoBehaviour
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
}
```

---

### Presenter

**在Presenter的更新面板方法中，处理View的数据更新逻辑**

---

##### MainPresenter

```csharp
public class MainPresenter : MonoBehaviour
{
    private static MainPresenter presenter = null;
    public static MainPresenter Presenter => presenter;

    //挂载在对象上的 mainView 脚本
    private MVP_MainView mainView;

    void Start()
    {
        mainView = GetComponent<MVP_MainView>();
        //2 数据更新
        //mainView.UpdateInfo(PlayerModel.Data);
        UpdateInfo(PlayerModel.Data);
        //3 数据监听
        mainView.btnRole.onClick.AddListener(() =>
        {
            RolePresenter.ShowMe();
        });
        // 监听数据更新
        PlayerModel.Data.AddEventListener((data) =>
        {
            if (mainView != null)
            {
                //和MVP的主要区别在于更新逻辑 直接由Presenter处理了
                //mainView.UpdateInfo(data);
                UpdateInfo(data);
            }
        });
    }
    //依附的对象被删除时 移除添加的事件委托
    private void OnDestroy()
    {
        PlayerModel.Data.RemoveEventListener((data) =>
        {
            if (mainView != null)
                //mainView.UpdateInfo(data);
                UpdateInfo(data);
        });
    }
    //1 面板显隐
    public static void ShowMe()
    {
        if (presenter == null)
        {
            GameObject panObj = Instantiate(Resources.Load<GameObject>("UI/MainPanel"));
            panObj.transform.SetParent(GameObject.Find("Canvas").transform, false);
            presenter = panObj.GetComponent<MainPresenter>();
        }
        presenter.gameObject.SetActive(true);
    }
    public static void HideMe()
    {
        if (presenter != null)
            presenter.gameObject.SetActive(false);
    }
    //更新面板的方法
    private void UpdateInfo(PlayerModel data) 
    {
        mainView.txtName.text = data.PlayerName;
        mainView.txtLev.text = "Lv." + data.Lev;
        mainView.txtMoney.text = data.Money.ToString();
        mainView.txtGem.text = data.Gem.ToString();
        mainView.txtPower.text = data.Power.ToString();
    }
}

```

---

##### RolePresenter

```csharp
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RolePresenter : MonoBehaviour
{
    private static RolePresenter presenter = null;
    public static RolePresenter Presenter => presenter;

    //挂载在对象上的 mainView 脚本
    private MVP_RoleView roleView;

    void Start()
    {
        roleView = GetComponent<MVP_RoleView>();
        //2 数据更新
        //roleView.UpdateInfo(PlayerModel.Data);
        UpdateInfo(PlayerModel.Data);
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
                //roleView.UpdateInfo(data);
                UpdateInfo(data);
        });
    }
    private void OnDestroy()
    {
        PlayerModel.Data.RemoveEventListener((data) =>
        {
            if (roleView != null)
                //roleView.UpdateInfo(data);
                UpdateInfo(data);
        });
    }
    //1 面板显隐
    public static void ShowMe()
    {
        if (presenter == null)
        {
            GameObject panObj = Instantiate(Resources.Load<GameObject>("UI/RolePanel"));
            panObj.transform.SetParent(GameObject.Find("Canvas").transform, false);
            presenter = panObj.GetComponent<RolePresenter>();
        }
        presenter.gameObject.SetActive(true);
    }
    public static void HideMe()
    {
        if (presenter != null)
            presenter.gameObject.SetActive(false);
    }

    //更新面板的方法
    private void UpdateInfo(PlayerModel data)
    {
        roleView.txtLev.text = "Lv." + data.Lev;
        roleView.txtHp.text = data.hp.ToString();
        roleView.txtAtk.text = data.Atk.ToString();
        roleView.txtDef.text = data.Def.ToString();
        roleView.txtCrit.text = data.Crit.ToString();
        roleView.txtMiss.text = data.Miss.ToString();
        roleView.txtLuck.text = data.Luck.ToString();
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

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

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
