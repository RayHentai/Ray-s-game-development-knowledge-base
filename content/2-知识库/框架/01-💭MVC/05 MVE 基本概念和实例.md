# 05 MVE 基本概念和实例

**所属模块**：[[00 MVC思想 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

**注意：**
- MVE为拓展思想，是个人性质的总结，讲解目的是拓展思路
- 全称为模型(Model)一视图(View)一事件中心(EventCenter)Model提供数据，View负责界面，EventCenter负责数据传递
- 讲解MVE的主要目的是对事件传递这种形式建立一个概念，为之后的pureMVC讲解做热身
- 观察者设计模式是解耦的一大利器

**MVE：**
1. View第一次显示获取Mode数据用于更新自己，并通知事件中心监听事件
2. 数据更新时（玩家操作或者服务器更新）通过告知事件中心触发并分发事件
3. 数据从事件中心流入View中进行更新
![[MVE 图示.png]]

**优势：**
- 利用事件中心的观察者模式
- 让M和V层的之间的关系更加灵活多变减少了目前数据层的负载
- 将数据层事件全部交由事件中心处理

---

## 基本实例

---

### Model

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
    //4 通知外部处理事件的方法
    private void updateInfo() 
    {
		EventCenter.Instance.EventTrigger<PlayerModel>("事件触发", this);
    }
}
```

---

### View + ViewMode

---

#### MainPanel

```csharp
public class MP_MainPanel : BasePanel
{
    void Start()
    {
        UpdateInfo(PlayerModel.Data);//第一次执行更新
        EventCenter.Instance.AddEventListener<PlayerModel>("事件触发", UpdateInfo);//添加监听
    }
    private void OnDestroy()
    {
        EventCenter.Instance.RemoveEventListener<PlayerModel>("事件触发", UpdateInfo);//移除监听
    }
    protected override void ClickBtn(string btnName)
    {
        base.ClickBtn(btnName);
        switch (btnName)
        {
            case "btnRole":
                UIMgr.Instance.ShowPanel<MP_RolePanel>();
                break;
        }
    }
    public void UpdateInfo(PlayerModel data)
    {
        GetControl<Text>("txtName").text = data.PlayerName;
        GetControl<Text>("txtLev").text = "Lv." + data.Lev;
        GetControl<Text>("txtMoney").text = data.Money.ToString();
        GetControl<Text>("txtGem").text = data.Gem.ToString();
        GetControl<Text>("txtPower").text = data.Power.ToString();
    }
    public override void HideMe() { }
    public override void ShowMe() { }
}

```

---

#### RolePanel

```csharp
public class MP_RolePanel : BasePanel
{
    void Start()
    {
        UpdateInfo(PlayerModel.Data);
        EventCenter.Instance.AddEventListener<PlayerModel>("事件触发", UpdateInfo);//添加监听
    }
    private void OnDestroy()
    {
        EventCenter.Instance.RemoveEventListener<PlayerModel>("事件触发", UpdateInfo);//移除监听
    }
    public void UpdateInfo(PlayerModel data) 
    {
        GetControl<Text>("txtLev").text = "Lv." + data.Lev;
        GetControl<Text>("txtHp").text = data.HP.ToString();
        GetControl<Text>("txtAtk").text = data.Atk.ToString();
        GetControl<Text>("txtDef").text = data.Def.ToString();
        GetControl<Text>("txtCrit").text = data.Crit.ToString();
        GetControl<Text>("txtMiss").text = data.Miss.ToString();
        GetControl<Text>("txtLuck").text = data.Luck.ToString();
    }
    protected override void ClickBtn(string btnName)
    {
        base.ClickBtn(btnName);
        switch (btnName)
        {
            case "btnClose":
                UIMgr.Instance.HidePanel<MP_RolePanel>();
                break;
            case "btnLevUp":
                PlayerModel.Data.LevUp();
                break;
        }
    }
    public override void HideMe() { }
    public override void ShowMe() { }
}
```

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
