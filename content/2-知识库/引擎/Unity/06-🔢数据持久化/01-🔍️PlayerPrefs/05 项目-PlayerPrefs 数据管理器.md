# 🎮 05 项目-PlayerPrefs 数据管理器

**所属阶段**：[[00 PlayerPrefs 总览]]
**关联**：[[20 反射]] | [[07 List]] | [[08 Dictionary]] | [[03 反射知识补充]]
**完成状态**：🔄 进行中
**查阅次数**：0

---

## 需求分析

> 利用反射实现一个通用的数据存储管理器，支持自动存储和读取任意类型的数据（包括自定义类、List、Dictionary 等），不需要为每个类手动写 Save/Load 方法。

- 让复杂数据类型List、Dictionary、Class可以直接调用封装好的方法，用一句代码实现数据的读取和存储

---
## 功能拆解

> 把整个项目拆成独立的功能模块，每个功能是一个可以单独实现的单元

- 反射存储数据——常用成员（int/float/string/bool）
- 反射存储数据——List 成员
- 反射存储数据——Dictionary 成员
- 反射存储数据——自定义类成员
- 反射读取数据——常用成员
- 反射读取数据——List 成员
- 反射读取数据——Dictionary 成员
- 反射读取数据——自定义类成员

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

>数据管理类

```csharp
public class PlayerPrefsDataMgr
{
    //1.这是一个管理类 首先把它设置为一个单例模式 [[单例模式]]
    /// <summary>
    /// PlayerPrefs数据管理类 统一管理数据的存储和读取
    /// </summary>
    private static PlayerPrefsDataMgr instance = new PlayerPrefsDataMgr();
    public static PlayerPrefsDataMgr Instance => instance;
    private PlayerPrefsDataMgr() { }

    //2.声明存储和读取的方法
    /// <summary>
    /// 存储数据
    /// </summary>
    /// <param name="data">数据对象</param>
    /// <param name="keyName">数据对象唯一的Key 自己控制</param>
    //由于这个方法可以存储任何的数据 所以用万物之父来装传入的对象
    public void SaveData(object data, string keyName)
    {
        //2.1 通过 Type 得到传入数据对象的所有字段 自定义keyName规则
        //    然后结合PlayerPrefs进行存储

        //2.1.1 得到传入数据对象的所有字段
        //得到Type
        Type dataType = data.GetType();
        //得到所有字段信息
        FieldInfo[] infos = dataType.GetFields();//反射关联知识 完全忘了


        //2.1.3 遍历字段并存储
        //声明一个临时变量 这就是每一个数据的唯一ID 在for循环里面进行拼接
        string saveKeyName = "";
        FieldInfo info;
        //遍历字段
        for (int i = 0; i < infos.Length; i++)
        {
            //2.1.2 自定义keyName规则 
            //这是为了确保数据的唯一性 规则至少要做到所有的键都是唯一的
            //字段类型 info.FieldType.Name
            //字段名字 info.Name
            //keyName_数据类型_字段类型_字段名
            //Player1_Player_Int32_age
            info = infos[i];
            saveKeyName = keyName + "_" + dataType.Name + "_" +
			              info.FieldType.Name + "_" + info.Name;
            //存储
            //info.GetValue(data);//这个也忘了 得到 传入数据 第几个字段 的 值
            //有Key了，有值了 就可以进行存储了
            //封装一个方法用来存储值
            //调用方法 传入 键 和 值
            SaveValue(info.GetValue(data), saveKeyName);
        }
        PlayerPrefs.Save();
    }
    //通过这个方法存储值
    private void SaveValue(object value, string keyName)
    {
        //根据数据类型不同 来决定使用哪个API进行存储 用if判断
        //得到值类型
        Type fieldType = value.GetType();
        //2.1.3.1 存储常用数据类型
        if (fieldType == typeof(int))
        {
            PlayerPrefs.SetInt(keyName, (int)value);
        }
        else if (fieldType == typeof(float))
        {
            PlayerPrefs.SetFloat(keyName, (float)value);
        }
        else if (fieldType == typeof(string))
        {
            PlayerPrefs.SetString(keyName, value.ToString());
        }
        else if (fieldType == typeof(bool))
        {
            //bool类型特殊处理 1表示true 0表示false
            PlayerPrefs.SetInt(keyName, (bool)value ? 1 : 0);
        }
        //2.1.3.2 存储List
        //这里的逻辑是
        //List存在泛型 泛型有各种不同的类型 如何让所有的泛型传入进来都可以正确存储数据？
        //找到一个可以存储所有List泛型的父类——IList
        //然后通过IsAssignableFrom 判断传入进来这个对象的类型是否能被自己的父类ILst存
        //如果可以 那就说明传进来这个对象的类型就是List
        //继续处理接下来的逻辑
        else if (typeof(IList).IsAssignableFrom(fieldType))
        {
            //父类装子类 把List转换成IList
            IList list = value as IList;
            //存数量
            PlayerPrefs.SetInt(keyName, list.Count);
            //这个index是为了确保键的唯一性
            int index = 0;
            //存值
            foreach (object obj in list)
            {
                //每一次遍历 Key后面都会加上一个index 每次都不一样
                //递归
                //List里面的每一个值都会重新执行一次 SaveValue
                //并且每一次keyName都会不一样 
                //我的理解是 无论List里嵌套了多少层自定义类型的值 就会一直不断的去执行这个过程
                //直到只剩下常用值int、float.... 就不会继续进入foreach循环了 
                SaveValue(obj, keyName + index);
                ++index;
            }
        }
        //2.1.3.2 存储Dictionary
        //和List的套路是一样的
        else if (typeof(IDictionary).IsAssignableFrom(fieldType))
        {
            IDictionary dictionary = value as IDictionary;
            PlayerPrefs.SetInt(keyName, dictionary.Count);
            int index = 0;
            foreach (object key in dictionary.Keys)
            {
                SaveValue(key, keyName + "_key" + index);
                SaveValue(dictionary[key], keyName + "_value" + index);
                ++index;
            }
        }
        //剩下的就是自定义类
        else
        {
            //我的理解 递归的作用有共同点
            //进到这里的一定是一个自定义类 无法通过遍历得到 具体值
            //这里递归的目的 不是 存储对象中的每一个值 不是执行 SaveValue
            //而是重新的去得到它每一个字段的具体值 所以让它 执行 SaveData
            //这里的keyName已经是经历过一轮 SaveData的 Key已经改变
            //继续执行 SaveData key会一直拼接 依然是唯一的 
            SaveData(value, keyName);
        }
    }
    /// <summary>
    /// 读取数据
    /// </summary>
    /// <param name="type">想要读取的数据的 数据类型</param>
    /// <param name="keyName">数据对象的唯一Key</param>
    /// <returns></returns>
    public object LoadData(Type type, string keyName)
    {

        //不传入object的原因 是 在外部节约一行代码
        //如果传入object 必须在外面new一个object再传入
        //传入Type的话 只需要typeof(type)得到类型
        //然后利用反射动态实例化出一个对象传出去就行了
        //相当于把new新对象的过程也封装到函数中
        //存储的地方 不这样修改 是因为 存储需要存储一个具体数据 而不是类型

        //2.2 根据传入的 Type 和 keyName创建一个对象
        //    依据自定义的 keyName拼接规则 得到数据 进行赋值 返回出去

        //这里一定要确保传进来的类型有一个无参构造 不然无法实例化
        object data = Activator.CreateInstance(type);//忘了 通过反射new 新对象
        //往new出的对象里面 填充数据 返回出去
        //这里与存储的规则一样
        //先得到所有字段
        FieldInfo[] fields = type.GetFields();
        FieldInfo info;
        string loadKeyName = "";
        //遍历所有字段
        for (int i = 0; i < fields.Length; i++)
        {
            //字段信息
            info = fields[i];
            loadKeyName = keyName + "_" + type.Name + "_" + 
			              info.FieldType.Name + "_" + info.Name;
            //得到Key 读取数据
            //给前面实例化的obj对象 data 赋 Key 对应的值
            info.SetValue(data, LoadValue(info.FieldType, loadKeyName));//忘了 通过反射给对象赋值
        }
        //填充数据到data中
        return data;
    }
    //通过这个方法得到值
    public object LoadValue(Type fieldType, string keyName)
    {
        //根据字段 判断使用哪个PlayerPrefs的API获取
        if (fieldType == typeof(int))
        {
            return PlayerPrefs.GetInt(keyName, 0);
        }
        else if (fieldType == typeof(float))
        {
            return PlayerPrefs.GetFloat(keyName, 0);
        }
        else if (fieldType == typeof(string))
        {
            return PlayerPrefs.GetString(keyName, "");
        }
        else if (fieldType == typeof(bool))
        {
            return PlayerPrefs.GetInt(keyName, 0) == 1 ? true : false;
        }
        else if (typeof(IList).IsAssignableFrom(fieldType))
        {
            //得到长度
            int count = PlayerPrefs.GetInt(keyName, 0);
            //实例化一个List对象 来赋值
            //Activator.CreateInstance 实例化出来的对象是object 需要as转换
            IList list = Activator.CreateInstance(fieldType) as IList;
            for (int i = 0;i< count;i++)
            {
                list.Add(LoadValue(fieldType.GetGenericArguments()[0],
		                 keyName + i));//忘了 通过反射得到泛型中的类型
            }
            return list;
        }
        else if (typeof(IDictionary).IsAssignableFrom(fieldType))
        {
            int count = PlayerPrefs.GetInt(keyName, 0);
            IDictionary dictionary = Activator.CreateInstance(fieldType) as
            IDictionary;
            Type[] kvType = fieldType.GetGenericArguments();
            for (int i = 0; i < count; i++)
            {
                dictionary.Add(LoadValue(kvType[0], keyName + "_key" + i),
                LoadValue(kvType[1], keyName + "_value" + i));
            }
            return dictionary;
        }
        else
        {
            return LoadData(fieldType, keyName);
        }
    }
}
```

^6e2d0c

>测试代码

```csharp
public class Player
{
    public int age;
    public string name;
    public float height;
    public bool sex;

    public List<int> list;
    public Dictionary<int, string> dic;
    public Item item;
    public List<Item> items;
    public Dictionary<int, Item> itemDic;
}
public class Item
{
    public int id;
    public int num;
    public Item() { }

    public Item(int id, int num)
    {
        this.id = id;
        this.num = num;
    }
}
public class Test_PlayerPrefs : MonoBehaviour
{
    void Start()
    {
        //传入类型,键 => 返回object => 转化成自己的类型
        Player player1 = PlayerPrefsDataMgr.Instance.LoadData(typeof(Player), "player1") as Player;
        
        player1.name = "Test";
        player1.age = 1;
        player1.height = 1.1f;
        player1.sex = true;
        player1.list.Add(1);
        player1.dic.Add(23451, "2");
        player1.item.id = 445;
        player1.item.num = 123;
        player1.items.Add(new Item(123,244));
        player1.items.Add(new Item(52,32));
        player1.itemDic.Add(214131,new Item(233,123));
        PlayerPrefsDataMgr.Instance.SaveData(player1, "player1");
    }
}

```

---

## 生成资源包

> 把项目打成 `.unitypackage` 文件，方便在其他项目中复用。
> Assets 右键 → Export Package → 选择 DataManager 相关文件 → Export

---

## 遇到的问题 & 解决方案

| 问题描述 | 解决方案 |
|----------|----------|
| | |

---

## 完成后的感悟

> 做这个项目学到了什么新东西？有没有对某个知识点有了新的理解？

**新学到的东西**：

**对某个知识点的新理解**：

**下次可以改进的地方**：

---

## 扩展想法

> 如果要继续优化这个项目，可以做哪些功能？

- 如果需要添加可支持的数据类型，在LoadValue和SaveValue里继续添加else if 条件判断就行

---

**完成时间**：26/4/10
**耗时**：1.5h（大概把，计时计忘了）