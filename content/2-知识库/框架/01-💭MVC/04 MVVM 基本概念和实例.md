# 04 MVVM 基本概念和实例

**所属模块**：[[00 MVC思想 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

MVVM全称为模型(Model)一视图(View)一视图模型(ViewModel)
Model提供数据，View负责界面，ViewModel负责逻辑的处理
MVVM的由来是 **MVP（Model-View-Presenter）模式与 WPF 结合应用时发展演变过来的一种新型框架**

**MVP 和 MVVM 对比**
![[MVP 和 MVVM 对比.png]]

**数据绑定：将一个用户界面元素（控件）的属性绑定到一个类型（对象）实例上的某个属性的方法**
- 如果开发者有一个 MainViewMode 类型的实例，那么他就可以把 MainViewMode 的“Lev”属性绑定到一个UI中Text的“Text”属性上。
- "绑定”了这2个属性之后，对Text的Text属性的更改将“传播”到 MainViewMode 的Lev属性，而对 MainViewMode 的 Lev 属性的更改同样会“传播”至到Text的Text属性
![[数据绑定 图示.png]]

**MVVW与Unity是有一些水土不服的：**
1. View对象始终由我们来书写，并没有UI配置文件（如WPF中的XAML）的存在
2. 硬要在Unity中实现MVVM，需要写三模块，并且还要对V和VM进行数据绑定，工作量大，好处也不够明显

**Unity中的第三方MVVW框架**（为了实现MVVW框架而实现MVVW框架， 意义不大）
- Loxodon FrameWork
  https://github.com/vovgou/loxodon-framework
- uMVVM
  https://github.com/MEyes/uMVVM

**MVVW的粗暴变式MP**
MVVM中的关键是V和VM的数据双向绑定，即改变V或者VM对方的属性，对方也会随之变化，一切对外的的处理都通过VM来处理了，V只负责更新和显示
尝试将他们合二为一，并且达到将界面和逻辑某种意义上的解耦即可
![[MVVW的粗暴变式MP 图示.png]]

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

### View + ViewMode

---

#### MainPanel

```csharp
public class MP_MainPanel : BasePanel
{
    void Start()
    {
        UpdateInfo(PlayerModel.Data);//第一次执行更新
        PlayerModel.Data.AddEventListener(UpdateInfo);//添加监听
    }
    private void OnDestroy()
    {
        PlayerModel.Data.RemoveEventListener(UpdateInfo);//移除监听
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
        PlayerModel.Data.AddEventListener(UpdateInfo);
    }
    private void OnDestroy()
    {
        PlayerModel.Data.RemoveEventListener(UpdateInfo);
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
