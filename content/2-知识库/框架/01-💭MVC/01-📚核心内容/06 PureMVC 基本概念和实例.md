# 06 PureMVC 基本概念和实例

**所属模块**：[[00 MVC思想 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

1. PureMVC是 基于MVC思想的第三方开源框架
2. PureMVC获取 http://puremvc.org/
3. PureMVC的基本结构 MVC+Proxy+Mediator+Command+Facade

---

## 基本原理

基于MVC思想和一些基础设计模式建立的一个轻量级的应用框架
是一个免费开源框架
它最初是执行的ActionScript 3语言使用的
现在已经移植到几乎所有主流平台

**获取：官方网址** 
http://puremvc.org/
单核版：只有一个Facade
多核版：允许有多个Facade

**PureMVC 的基本结构**
- **Model（数据模型）：** 关联Proxy(代理）对象，负责处理数据
- **View（界面）: ** 关联Mediator(中介）对象，负责处理界面
- **Controller（业务控制）：** 管理Command(命令）对象，负责处理业务逻辑
- **Facade（外观）：** 是MVC三者的经纪人，统管全局可以获取代理、中介、命令
- **Notification（箭头）:** 通知，负责传递信息
![[PureMVC 基本结构.png]]

---

## 导入

**方法一：通过Visual Studio 获取dll库文件**
- 用Visual Studio打开根目录的sln文件
![[PureMVC 导入 方法一 1.png|514]]
- 右键生成
 ![[PureMVC 导入 方法一 2.png|521]]
- 找到dll文件 直接拖入Unity
![[PureMVC 导入 方法一 3.png|540]]

**方法二：直接拖入Unity**
- 把这三个核心文件夹拖入Unity即可
![[PureMVC 导入 方法二.png|563]]

---

## 基本实现

**关键步骤：**
Facade：
1. 继承PureMVC中Facade脚本
2. 为了方便我们使用Facade需要自己写一个单例模式的属性4个引用
3. 初始化控制层相关的内容
4. 一定是有一个启动函数的

**Proxy：**
1. 继承Proxy父类
2. 写构造函数
3. 重要点
	- 代理的名字！！！
	- 代理相关的数据！！

**Mediator**
1. 继承PureMVC中的Mediator脚本
2. 写构造函数
3. 重写监听通知的方法
4. 重写处理通知的方法
5. 可选：重写注册时的方法

**Command：**
1. 继承Command相关的脚本
2. 重写里面的执行函数
3. 执行函数中的参数 INotification对象里面包含两个重要的参数
	- 通知名我们根据这个名字来做对应的处理
	- 通知包含的信息

先数据、后界面、再用命令做串联、Facade判断、注册和获取

---

### Other

---

#### PureNotification（通知名）

```csharp
/// <summary>
/// 这个是pureMVc中的通知名类
/// 主要是用来申明各个通知的名字
/// 方便使用和管理
/// </summary>
public class PureNotification
{
    public const string SHOW_PANEL = "showPanel";
    public const string HIDE_PANEL = "hidePanel";
    public const string UPDATE_PLAYER_INFO = "updatePlayerInfo";
    public const string START_UP = "startUp";
    public const string LEV_UP = "levUp";
}

```

---

#### Main

```csharp
public class PureMVCMain : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        GameFacade.Instance.StartUp();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
            GameFacade.Instance.SendNotification(PureNotification.SHOW_PANEL,"MainPanel");
        if (Input.GetKeyDown(KeyCode.Q))
            GameFacade.Instance.SendNotification(PureNotification.HIDE_PANEL, GameFacade.Instance.RetrieveMediator(NewMainViewMediator.NAME));
    }
}

```

---

### Model 和 Proxy （数据和数据代理）

---

#### PlayerDataObj

```csharp
/// <summary>
/// 玩家数据结构
/// </summary>
public class PlayerDataObj
{
    public string playerName;
    public int lev;
    public int money;
    public int gem;
    public int power;
    public int hp;
    public int atk;
    public int def;
    public int crit;
    public int miss;
    public int luck;
}

```

---

#### PlayerProxy

```csharp
/// <summary>
/// 玩家数据代理对象
/// </summary>
public class PlayerProxy : Proxy
{
    public new const string NAME = "PlayerProxy"; //声明该代理的名字 避免填写参数时写错
    //1 继承 Proxy父类
    //2 写构造函数
    public PlayerProxy() : base(NAME)
    {
        //可以传入DataObj进行初始化 在base中传入DataObj即可 适合有多个Proxy的情况
        //也可以在外部赋值 适合proxy 和 Model 一对一的情况
        //1 初始化数据
        PlayerDataObj data = new PlayerDataObj();
        //初始化
        data.playerName = PlayerPrefs.GetString("PlayerName", "Hentai");
        data.lev = PlayerPrefs.GetInt("PlayerLev", 1);
        data.money = PlayerPrefs.GetInt("PlayerMoney", 999);
        data.gem = PlayerPrefs.GetInt("PlayerGem", 888);
        data.power = PlayerPrefs.GetInt("PlayerPower", 90);
        data.hp = PlayerPrefs.GetInt("PlayerHp", 100);
        data.atk = PlayerPrefs.GetInt("PlayerAtk", 50);
        data.def = PlayerPrefs.GetInt("PlayerDef", 10);
        data.crit = PlayerPrefs.GetInt("PlayerCrit", 20);
        data.miss = PlayerPrefs.GetInt("PlayerMiss", 40);
        data.luck = PlayerPrefs.GetInt("PlayerLuck", 20);
        Data = data; //赋值给自己的Data
    }
    /// <summary>
    /// 升级的方法
    /// </summary>
    public void LevUp()
    {
        PlayerDataObj data = Data as PlayerDataObj;
        data.lev += 1;
        data.hp += data.lev;
        data.atk += data.lev;
        data.def += data.lev;
        data.crit += data.lev;
        data.miss += data.lev;
        data.luck += data.lev;
    }
    /// <summary>
    /// 保存数据的方法
    /// </summary>
    public void SaveData()
    {
        PlayerDataObj data = Data as PlayerDataObj;
        PlayerPrefs.SetString("PlayerName", data.playerName);
        PlayerPrefs.SetInt("PlayerLev", data.lev);
        PlayerPrefs.SetInt("PlayerMoney", data.money);
        PlayerPrefs.SetInt("PlayerGem", data.gem);
        PlayerPrefs.SetInt("PlayerPower", data.power);
        PlayerPrefs.SetInt("PlayerHp", data.hp);
        PlayerPrefs.SetInt("PlayerAtk", data.atk);
        PlayerPrefs.SetInt("PlayerDef", data.def);
        PlayerPrefs.SetInt("PlayerCrit", data.crit);
        PlayerPrefs.SetInt("PlayerMiss", data.miss);
        PlayerPrefs.SetInt("PlayerLuck", data.luck);
    }
}

```

---

### View 和 Mediator （窗口和窗口代理）

---

#### MainView

```csharp
public class NewMainView : MonoBehaviour
{
    //1 找控件
    public Text txtName;
    public Text txtLev;
    public Text txtMoney;
    public Text txtGem;
    public Text txtPower;
    public Button btnRole;

    //按照MVC的思想可以直接在这里提供
    //如果是用MVP的思想 则不用
    //2 提供更新方法
    public void UpdateInfo(PlayerDataObj data)
    {
        txtName.text = data.playerName;
        txtLev.text = "Lv." + data.lev;
        txtMoney.text = data.money.ToString();
        txtGem.text = data.gem.ToString();
        txtPower.text = data.power.ToString();
    }
}

```

---

#### MainViewMediator

```csharp
public class NewMainViewMediator : Mediator
{
    //1 继承PureMVc中的Mediator脚本
    public new const string NAME = "NewMainViewMediator";
    //2 写构造函数
    public NewMainViewMediator() : base(NAME)
    {
        //这里面可以去创建界面预设体等等的逻辑
        //但是界面显示应该是触发的控制的（按钮、拖动条等）
        //而且创建界面的代码重复性比较高
    }
    //3 重写监听通知的方法
    public override string[] ListNotificationInterests()
    {
        //这是一个PureMVc的规则
        //就是需要监听哪些通知那就在这里把通知们 通过字符串数组的形式返回出去
        //PureMVc就会监听这些通知
        //类似于通过事件名注册事件监听
        return new string[]{
            PureNotification.UPDATE_PLAYER_INFO,
        };
    }
    //4 重写处理通知的方法
    public override void HandleNotification(INotification notification)
    {
        //INotification对象里面包含两个重要的参数
        //1 通知名 我们根据这个名字 来做对应的处理
        //2 通知包含的信息
        switch (notification.Name)
        {
            case PureNotification.UPDATE_PLAYER_INFO:
                if (ViewComponent != null) //如果角色面板被移除 不能正常更新数据 所以要判空
                    (ViewComponent as NewMainView).UpdateInfo(notification.Body as PlayerDataObj);
                break;
        }
    }
    //5 可选：重写注册时的方法
    public override void OnRegister()
    {
        base.OnRegister();
        //初始化一些内容
    }
    public void SetView(NewMainView view) //初始化面板和监听事件
    {
        ViewComponent = view; //关联 ViewComponent
        view.btnRole.onClick.AddListener(() => //监听事件
        {
            SendNotification(PureNotification.SHOW_PANEL, "RolePanel");
        });
    }
}

```

---

#### RoleView

```csharp
public class NewRoleView : MonoBehaviour
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

    public void UpdateInfo(PlayerDataObj data)
    {
        txtLev.text = "Lv." + data.lev;
        txtHp.text = data.hp.ToString();
        txtAtk.text = data.atk.ToString();
        txtDef.text = data.def.ToString();
        txtCrit.text = data.crit.ToString();
        txtMiss.text = data.miss.ToString();
        txtLuck.text = data.luck.ToString();
    }
}

```

---

#### RoleViewMediator

```csharp
public class NewRoleViewMediator : Mediator
{
    //1 继承PureMVc中的Mediator脚本
    public new const string NAME = "NewRoleViewMediator";
    //2 写构造函数
    public NewRoleViewMediator() : base(NAME)
    {

    }
    //3 重写监听通知的方法
    public override string[] ListNotificationInterests()
    {

        return new string[]{
            PureNotification.UPDATE_PLAYER_INFO,
        };
    }
    //4 重写处理通知的方法
    public override void HandleNotification(INotification notification)
    {
        //INotification对象里面包含两个重要的参数
        //1 通知名 我们根据这个名字 来做对应的处理
        //2 通知包含的信息
        switch (notification.Name)
        {
            case PureNotification.UPDATE_PLAYER_INFO:
                if (ViewComponent != null) //如果角色面板被移除 不能正常更新数据 所以要判空
                    (ViewComponent as NewRoleView).UpdateInfo(notification.Body as PlayerDataObj);
                break;
        }
    }
    //5 可选：重写注册时的方法
    public override void OnRegister()
    {
        base.OnRegister();
        //初始化一些内容
    }
    public void SetView(NewRoleView view) //初始化面板
    {
        ViewComponent = view; //关联 ViewComponent
        view.btnClose.onClick.AddListener(() => //监听事件
        {
            //隐藏自己
            GameFacade.Instance.SendNotification(PureNotification.HIDE_PANEL, this);
        });
        view.btnLevUp.onClick.AddListener(() => //监听事件
        {
            SendNotification(PureNotification.LEV_UP);
        });
    }
}

```

---


### Facade 和 Command （代理人和任务）

---

#### GameFacade

```csharp
public class GameFacade : Facade
{
    //1 继承PureMVC中Facade脚本
    //2 为了方便使用Facade需要自己写一个单例模式
    public static GameFacade Instance
    {
        get
        {
            if (instance == null)
                instance = new GameFacade();
            return instance as GameFacade;
        }
    }
    //3 初始化控制层相关的内容
    protected override void InitializeController()
    {
        base.InitializeController();
        //写一些 命令和通知的绑定逻辑
        RegisterCommand(PureNotification.START_UP, () =>
        {
            return new StartUPCommand();
        });
        RegisterCommand(PureNotification.SHOW_PANEL, () =>
        {
            return new ShowPanelCommand();
        });
        RegisterCommand(PureNotification.HIDE_PANEL, () =>
        {
            return new HidePanelCommand();
        });
        RegisterCommand(PureNotification.LEV_UP, () =>
        {
            return new LevUpCommand();
        });
    }
    //4 一定要有一个启动函数
    public void StartUp() 
    {
        //发送通知
        //就会执行上面初始化过的命令
        //就会new一个Command对象 并执行其中的执行函数
        SendNotification(PureNotification.START_UP);
    }
}

```

---

#### StartUPCommand

```csharp
public class StartUPCommand : SimpleCommand
{
    //1.继承Command相关的脚本
    //2.重写里面的执行函数
    public override void Execute(INotification notification)
    {
        base.Execute(notification);
        //当命令被执行时就会调用该方法
        //注册proxy
        if (!Facade.HasProxy(PlayerProxy.NAME)) //没有数据代理才会注册
            Facade.RegisterProxy(new PlayerProxy());
    }
}

```

---

#### ShowPanelCommand

```csharp
public class ShowPanelCommand : SimpleCommand
{
    public override void Execute(INotification notification)
    {
        base.Execute(notification);
        //写创建面板的逻辑
        string panelName = notification.Body.ToString();
        switch (panelName)
        {
            case "MainPanel":
                //如果要使用Mediator 一定也要在Facade中去注册
                //command、proxy都是一样的要用 就要注册
                //注册Mediator
                if (!Facade.HasMediator(NewMainViewMediator.NAME)) //如果没有Mediator 就创建
                    Facade.RegisterMediator(new NewMainViewMediator());
                //得到Mediator
                NewMainViewMediator mm = Facade.RetrieveMediator(NewMainViewMediator.NAME) as NewMainViewMediator;
                if (mm.ViewComponent == null) //没有界面才创建界面
                {
                    //创建界面
                    GameObject obj = GameObject.Instantiate(Resources.Load<GameObject>("UI/MainPanel"));
                    obj.transform.SetParent(GameObject.Find("Canvas").transform, false);
                    mm.SetView(obj.GetComponent<NewMainView>());//得到View脚本 并关联到ViewMediator 并监听事件;
                }
                //界面创建完成后 更新界面
                SendNotification(PureNotification.UPDATE_PLAYER_INFO, Facade.RetrieveProxy(PlayerProxy.NAME).Data); //发通知 传数据
                break;
            case "RolePanel":
                if (!Facade.HasMediator(NewRoleViewMediator.NAME)) //如果没有Mediator 就创建
                    Facade.RegisterMediator(new NewRoleViewMediator());
                //得到Mediator
                NewRoleViewMediator rm = Facade.RetrieveMediator(NewRoleViewMediator.NAME) as NewRoleViewMediator;
                if (rm.ViewComponent == null) //没有界面才创建界面
                {
                    //创建界面
                    GameObject obj = GameObject.Instantiate(Resources.Load<GameObject>("UI/RolePanel"));
                    obj.transform.SetParent(GameObject.Find("Canvas").transform, false);
                    rm.SetView(obj.GetComponent<NewRoleView>());//得到View脚本 并关联到ViewMediator
                }
                SendNotification(PureNotification.UPDATE_PLAYER_INFO, Facade.RetrieveProxy(PlayerProxy.NAME).Data); //发通知 传数据
                break;
        }
    }
}

```

---

#### HidePanelCommand

```csharp
public class HidePanelCommand : SimpleCommand
{
    public override void Execute(INotification notification)
    {
        base.Execute(notification);
        //写隐藏面板的逻辑
        //得到mediator再得到mediator中的view 然后去要不删除要不设置显隐
        //得到传入的mediator
        Mediator m = notification.Body as Mediator;
        if (m != null && m.ViewComponent != null) 
        {
            GameObject.Destroy((m.ViewComponent as MonoBehaviour).gameObject);//直接移除
            m.ViewComponent = null;//置空 不然以后无法创建这个面板
        }
    }
}

```

---

#### LevUpCommand

```csharp
public class LevUpCommand : SimpleCommand
{
    public override void Execute(INotification notification)
    {
        base.Execute(notification);
        PlayerProxy playerProxy = Facade.RetrieveProxy(PlayerProxy.NAME) as PlayerProxy; //得到数据代理
        if (playerProxy != null) 
        {
            playerProxy.LevUp();//升级
            playerProxy.SaveData();//保存
            SendNotification(PureNotification.UPDATE_PLAYER_INFO, playerProxy.Data);//更新数据
        }
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
