# 13 Scriptable Object 应用

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[02 JsonUtility 读取存储]] | [[]]
**查阅次数**：0

---

## 配置文件

**Scriptable Object 作为配置文件的优势**
1. 配置文件的数据在游戏发布之前定规则
2. 配置文件的数据在游戏运行时只会读出来使用，不会改变内容
3. 在Unity的Inspector窗口进行配置更加的方便

只用不改，并且经常会进行配置的数据
非常适合使用ScriptableObject

**可以利用ScriptableObject数据文件 来制作编辑器相关功能**
比如：Unity内置的技能编辑器、关卡编辑器等等
- 不需要把编辑器生成的数据生成别的数据文件，而是直接通过ScriptableObject进行存储
- 因为内置编辑器只会在编辑模式下运行，编辑模式下ScriptableObject具备数据持久化的特性

**使用Scriptable Object 制作配置文件**

**进阶阶段项目中配置的数据**
![[13 项目-丧尸围城#^571584]]

**用Scriptable Object 配置**
```csharp
[CreateAssetMenu(fileName ="RoleInfo", menuName = "ScriptableObject/角色信息")]
public class RoleInfo : SingleScriptableObject<RoleInfo>
{
    [System.Serializable]//Insperctor 显示自定义类 必须加这个特性 不然不会显示
    public class RoleData
    {
        public int id;
        public string res;
        public int atk;
        public string tips;
        public int lockMoney;
        public int type;
        public string hitEff;
    }
    public List<RoleData> roleList;
}
```

---

## 复用数据

**对于只用不变的数据，以面向对象的思想去声明对象类是可能存在内存浪费的问题的**
**可以使用Scriptable Object来节约内存**

**以子弹对象为例**
子弹作为预设体被实例化出来后，有几个子弹，就会有几个子弹挂载的脚本，内存空间就会被分配几次

**如果子弹的数据是不变的，利用Scriptable Object 数据对象 更加节约内存，它们都是共享同一个内存空间中的数据**
更改 Scriptable Object 配置文件的参数，会影响所有运用这个数据的对象

```csharp
[CreateAssetMenu()]
public class BulletInfo : ScriptableObject
{
    public float speed;
    public int atk;
}

public class Bullet : MonoBehaviour
{
    public BulletInfo info;
    void Update()
    {
        this.transform.Translate(Vector3.forward * info.speed * Time.deltaTime);
    }
}
```

---

## 数据带来的多态行为

某些行为的变化是因为数据的不同带来的
可以利用面向对象的特性和原则，以及设计模式相关知识点
结合 Scriptable Object 做出更加方便的功能

**比如随机音效，物品拾取，AI等等等**
1. 随机音效（里氏替换原则和依赖倒转原则）
  播放音乐时，可能会随机播放多个音效当中的一种
```csharp
public abstract class AudioPlayBase : ScriptableObject
{
    public abstract void Play(AudioSource source);
}

[CreateAssetMenu()]
public class PlayerAudio : AuidoPlayBase //只想播放一个音乐的配置
{
    public AudioClip clip;
    public override void Play(AudioSource source)
    {
        source.clip = clip;
        source.Play();
    }
}

[CreateAssetMenu()]
public class RandomPlayAudio : AudioPlayBase //随机播放音乐的配置
{
    //希望随机播放的音效文件
    public List<AudioClip> clips;
    public override void Play(AudioSource source)
    {
        if (clips.Count == 0)
            return;
        //设置音效切片文件
        source.clip = clips[Random.Range(0, clips.Count)];
        source.Play();
    }
}

public AuidoPlayBase audioPlay;//在外部拖入子类 实现不同的数据逻辑
audioPlay.Play(this.GetComponent<AudioSource>());//此时播放的是RandomPlayAudio子类中配置好的切片
```

2. 物品拾取（里氏替换原则和依赖倒转原则）
  比如拾取一个物品，物品给玩家带来不同的效果
```csharp
public abstract class ItemEffect : ScriptableObject
{
    public abstract void AddEffect(GameObject obj);
}

[CreateAssetMenu]
public class AddHealthItemEffect : ItemEffect //玩家拾取物品加血
{
    public int num;
    public override void AddEffect(GameObject obj) 
    {
        //通过获取到的对象 让其加血了 加num的值
    }
}

[CreateAssetMenu]
public class AddAtkItemEffect : ItemEffect //玩家拾取物品加攻击力
{
    public int atk;
    public override void AddEffect(GameObject obj)
    {
       //具体加多少攻击力的逻辑
    }
}

public class ItemObj : MonoBehaviour
{
    public ItemEffect eff; //具体想实现什么效果 拖动不同的配置文件即可
    private void OnTriggerEnter(Collider other)
    {
        //为和物品产生碰撞的对象加效果
        eff.AddEffect(other.gameObject);
    }
}
```

3. AI，不同数据带来的不同行为模式

这些例子中的功能就算不用Scriptable Object，也是能够用面向对象的思想 结合配置文件来完成的
**但是ScriptableObject具备自己的几个优点**
1. 更方便的配置
2. 共享数据节约内存
在实现某些功能的时候，使用ScriptableObject会更加方便使用

---

## 单例模式化的获取数据

对于只用不变并且要复用的数据，比如配置文件中的数据
往往需要在很多地方获取他们

如果直接通过在脚本中 public关联 或者 动态加载
如果在多处使用，会存在很多重复代码，效率较低

**如果我们将此类数据通过单例模式化的去获取，可以提升效率，减少代码量**

可以实现一个**Scriptable Object数据单例模式基类**
只需要让子类继承该基类
就可以直接获取到数据
而不再需要去通过 public关联 和 资源动态加载

```csharp
public class SingleScriptableObject<T> :ScriptableObject where T:ScriptableObject
{
    private static T instance;
    public static T Instance
    {
        get
        {
            //如果为空 首先应该去资源路劲下加载 对应的 数据资源文件
            if (instance == null)
                //我们定两个规则
                //1.所有的 数据资源文件都放在 Resources文件夹下的ScriptableObject中
                //2.需要复用的 唯一的数据资源文件名 我们定一个规则：和类名是一样的
                instance = Resources.Load<T>("ScriptableObject/" + typeof(T).Name);
            //如果没有这个文件 为了安全起见 我们可以在这直接创建一个数据
            if(instance==null)
                instance = CreateInstance<T>();
            //甚至可以在这里 从json当中读取数据，但是我不建议用ScriptableObject来做数据持久化
            return instance;
        }
    }
}

public class Lesson8 : MonoBehaviour //直接获取数据 无需手动关联数据对象
{
    void Start()
    {
        print(RoleInfo.Instance.roleList[0].id);
        print(RoleInfo.Instance.roleList[1].tips);
    }
}
```

**这种基类比较适合 配置数据 的管理和获取**
当数据是 只用不变，并且是唯一的时候，可以使用该方式提高我们的开发效率

在此基础上也可以根据自己的需求进行变形
比如添加数据持久化的功能，将数据从json中读取，并提供保存数据的方法
但是不建议大家用ScriptableObject来制作数据持久化功能，除非你有这方面的特殊需求

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

# API速查


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
