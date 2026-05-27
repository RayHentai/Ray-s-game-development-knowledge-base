# 📦 01 ArrayList

**所属模块**：[[00 CSharp 进阶阶段总览]]
**关联**：[[07 List]]
**查阅次数**：0

---

## 核心理解

> ArrayList = C# 封装好的类，本质是 object[] 数组，帮助我们实现了增删查改方法。

- **注意：** 不需要指定长度，但存值类型会发生装箱拆箱，性能不如泛型 List，后续会被 List 取代。

---

## 声明

```csharp
using System.Collections;  // 需要引用此命名空间
ArrayList array = new ArrayList();
```

---

## 增删查改

```csharp
// 增（可以存入任何类型）
array.Add(值); // 末尾添加
array.AddRange(另一个list); // 批量添加（把另一个集合的内容全加进来）
array.Insert(下标, 值); // 插入到指定位置

// 删
array.Remove(对象); // 移除指定元素
array.RemoveAt(下标); // 移除指定位置
array.Clear(); // 清空

// 查
object val = array[下标]; // 按下标访问
array.Contains(值); // 是否包含，返回 bool
array.IndexOf(值); // 正向查找索引，没有返回 -1
array.LastIndexOf(值); // 反向查找索引，没有返回 -1

// 改
array[下标] = 值;
```

---

## 遍历

```csharp
// for 循环（用 Count 而不是 Length）
for (int i = 0; i < array.Count; i++)
    Console.WriteLine(array[i]);

// foreach（迭代器遍历）
foreach (object item in array)
    Console.WriteLine(item);

// Capacity：当前分配的容量（自动扩容，每次×2）
Console.WriteLine(array.Capacity);
```

---

## 装箱拆箱

```csharp
// 存值类型时会发生装箱（性能损耗），取出时需要强转（拆箱）
array.Add(1); // 装箱：int → object
int val = (int)array[0]; // 拆箱：object → int
```

> 尽量少用，后面会学习更好的泛型容器（List）。

---

## ArrayList 与数组的区别

| 对比 | ArrayList | 数组 |
|------|-----------|------|
| 长度 | 动态，用 Count | 固定，用 Length |
| 类型 | 默认 object，存任意类型 | 指定类型 |
| 增删 | 封装好的 API | 需要自己实现 |
| 装箱拆箱 | 存值类型时有 | 非 object 数组无 |

---

## 练习

> 1. 请简述 ArrayList 和数组的区别

- ArrayList 本质上是一个 object 数组的封装：
- ArrayList 可以不用一开始就定长，数组默认是定长的
- ArrayList 默认为 object 类型，数组可以存储指定类型
- ArrayList 封装了方便的 API 供我们增删查改，数组需要自己实现
- ArrayList 使用时可能存在装箱拆箱，数组只要不是 object 数组就不存在这个问题
- ArrayList 的长度为 Count，数组的长度为 Length

> 2. 创建一个背包管理类，使用 ArrayList 存储物品，实现购买物品、卖出物品、显示物品的功能，购买与卖出物品会导致金钱变化

```csharp
class Backpack
{
    private ArrayList items;
    private int money;

    public Backpack() 
    { 
	    items = new ArrayList(); 
	    money = 9999; 
    }

    public void BuyItem(Item item)
    {
        int sumMoney = item.num * item.money;
        if (item.num <= 0 || item.money < 0)
        {
            Console.WriteLine("不好意思，请传入正确的物品信息");
            return;
        }
        if (money < sumMoney) 
        { 
	        Console.WriteLine("不好意思，您的余额不足"); 
	        return; 
        }
        money -= sumMoney;
        Console.WriteLine("你购买了{0}个{1}，一共花费{2}元，剩余{3}元",
            item.num, item.name, sumMoney, money);
        for (int i = 0; i < items.Count; i++)
        {
            if ((items[i] as Item).id == item.id)
            {
                (items[i] as Item).num += item.num;
                return;
            }
        }
        items.Add(item);
    }

    public void SellItem(Item item)
    {
        for (int i = 0; i < items.Count; i++)
        {
            if ((items[i] as Item).id == item.id)
            {
                string name  = (items[i] as Item).name;
                int price = (items[i] as Item).money;
                int num;
                if ((items[i] as Item).num > item.num) 
	                num = item.num; (items[i] as Item).num -= num; 
                else                                   
                { 
	                num = (items[i] as Item).num; 
	                items.RemoveAt(i); 
                }
                int sum = (int)((price * num) * 0.8f);
                this.money += sum;
                Console.WriteLine("你卖出了{0}个{1}，一共卖出{2}元，剩余{3}元", num, name, sum, this.money);
                return;
            }
        }
    }

    public void SellItem(int id, int num = 1)
    {
        Item item = new Item(); 
        item.id = id; 
        item.num = num; 
        SellItem(item);
    }

    public void ShowItem(Item item)
    {
        for (int i = 0; i < items.Count; i++)
        {
            if ((items[i] as Item).id == item.id)
            {
                Console.WriteLine("你拥有{0}{1}个", (items[i] as Item).name, (items[i] as Item).num);
                return;
            }
            else 
            { 
	            Console.WriteLine("你没有该物品"); 
	            return; 
            }
        }
    }
}

class Item
{
    public string name; public int id, money, num;
    public Item() { }
    public Item(string name, int id, int money, int num)
    { 
	    this.name = name; 
	    this.id = id; 
	    this.money = money; 
	    this.num = num; 
    }
}

Backpack bag = new Backpack();
Item i1 = new Item("R键", 0, 99999, 1);
Item i2 = new Item("圣心", 1, 99, 10);
Item i3 = new Item("果汁", 2, 9, 100);
bag.BuyItem(i1); bag.BuyItem(i2); bag.BuyItem(i3);
bag.SellItem(2, 50);
bag.ShowItem(i3);
```

---

## 我的踩坑记录

- 忘记 `using System.Collections`，找不到 ArrayList

---

*最后更新：*
