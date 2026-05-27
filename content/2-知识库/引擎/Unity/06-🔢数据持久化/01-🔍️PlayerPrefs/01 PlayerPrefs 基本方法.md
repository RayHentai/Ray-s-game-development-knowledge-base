# 💾 01 PlayerPrefs 基本方法

**所属模块**：[[00 PlayerPrefs 总览]]
**关联**：
**查阅次数**：0

---

## 定义

> Unity 提供的可以用于存储读取玩家数据的公共类。
> 数据存储类似于**键值对**，一个键对应一个值。
> 只支持三种数据类型：**int、float、string**。

**我的理解：**
- 把游戏数据存到电脑硬盘
- 把硬盘数据读取到游戏中


---

## 存储相关

### 注意事项

- 直接调用 `Set` 相关方法，**只会把数据存到内存里**
- **当游戏正常结束时**，`Unity` 会自动把数据存到硬盘中
- 如果游戏不是正常关闭（闪退/崩溃），数据会**丢失**
- 如果不同类型用同一键名存储，**会进行覆盖**

### API

```csharp
// 存储（只写入内存）
PlayerPrefs.SetInt("键", 100);
PlayerPrefs.SetFloat("键", 3.14f);
PlayerPrefs.SetString("键", "值");

// 立即写入硬盘（关键操作后调用，防止丢失）
PlayerPrefs.Save();
```

---

## 读取相关

### 注意事项

- 运行时只要 Set 了对应的键值对，即使没有马上 `Save`，也能**马上读取**出信息
- 如果键不存在，则会返回**默认值**（第二个参数可以指定默认值）
- **第二个参数的作用：** 在得到没有的数据时，可以用它来进行**基础数据的初始化**

### API

```csharp
// 读取（键不存在时返回类型默认值）
int i = PlayerPrefs.GetInt("键");
float f = PlayerPrefs.GetFloat("键");
string s = PlayerPrefs.GetString("键");

// 读取（键不存在时返回指定默认值）
int i = PlayerPrefs.GetInt("键", 100); // 默认 100
float f = PlayerPrefs.GetFloat("键", 1.0f); // 默认 1.0
string s = PlayerPrefs.GetString("键", "未命名"); // 默认 "未命名"

// 判断键是否存在
bool exists = PlayerPrefs.HasKey("键");
```

---

## 删除数据

```csharp
PlayerPrefs.DeleteKey("键"); // 删除指定键值对
PlayerPrefs.DeleteAll(); // 删除所有存储的数据（慎用）
```

---

## 练习

> 1. 现在有玩家信息类，有名字、年龄、攻击力、防御力等成员，请为其封装两个方法，一个用来存储数据，一个用来读取数据

```csharp
public class PlayerInfo
{
    public string name;
    public int age;
    public int atk;
    public int def;

    public void Save()
    {
        PlayerPrefs.SetString("name", name);
        PlayerPrefs.SetInt("age", age);
        PlayerPrefs.SetInt("atk", atk);
        PlayerPrefs.SetInt("def", def);
        PlayerPrefs.Save();
    }
    
    public void Load()
    {
        name = PlayerPrefs.GetString("name", "未命名");
        age = PlayerPrefs.GetInt("age", 24);
        atk = PlayerPrefs.GetInt("atk", 999);
        def = PlayerPrefs.GetInt("def", 200);
    }
}
public class Mgr : MonoBehaviour
{
    private void Start()
    {
        PlayerInfo p = new PlayerInfo();
        p.Load();
        print(p.name);
        print(p.age);
        print(p.atk);
        print(p.def);
    }
}
```

^caaaa0

> 2. 现在有装备信息类，装备类中有 id、数量两个成员。上一题的玩家类中包含一个 List 存储了拥有的所有装备信息。请在上一题的基础上，把装备信息的存储和读取加上

```csharp
public class Item
{
    public int id;
    public int num;
}
public class Player
{
    public List<Item> items;
    public void Save()
    {
        PlayerPrefs.SetInt("itemNum1", items.Count);
        for (int i = 0; i < items.Count; i++) 
        {
            PlayerPrefs.SetInt("id1" + i, items[i].id);
            PlayerPrefs.SetInt("num1" + i, items[i].num);
        }
        PlayerPrefs.Save();
    }
    public void Load()
    {
	    //最开始数量肯定没有 所以初始化一个0
        int num = PlayerPrefs.GetInt("itemNum1", 0);
        items = new List<Item>(); //读取的时候 new 一个新对象 然后一个一个存
        Item item;
        for (int i = 0; i < num; i++)
        {
            item = new Item();
            item.id = PlayerPrefs.GetInt("id1" + i);
            item.num = PlayerPrefs.GetInt("num1" + i);
            items.Add(item);
        }
    }
}
public class ReTest : MonoBehaviour
{
    void Start()
    {
        Player p = new Player();
        p.Load();
        print("数量为" + p.items.Count);
        for (int i = 0; i < p.items.Count; i++)
        {
            print("ID为" + p.items[i].id);
            print("数量为" + p.items[i].num);
        }
        
        Item item1 = new Item();
        item1.id = 1;
        item1.num = 1;
        p.items.Add(item1);
		
        Item item2 = new Item();
        item2.id = 2;
        item2.num = 2;
        p.items.Add(item2);
        p.Save();
    }
}
```

---

## 我的踩坑记录

- 不调用 `Save()` 直接退出游戏数据不会写入硬盘，重新启动后数据丢失
- 存储 List 时，一定要先存数量，读取时才能知道循环次数

---

*最后更新：*
