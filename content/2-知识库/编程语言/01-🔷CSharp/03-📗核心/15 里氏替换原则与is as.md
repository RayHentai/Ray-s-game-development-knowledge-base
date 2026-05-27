# 🔄 15 里氏替换原则与 is as

**所属模块**：[[00 CSharp 核心阶段总览]]
**关联**：[[14 继承基本规则]] | [[17 万物之父object与装箱拆箱]]
**查阅次数**：0

---

## 里氏替换原则（七大原则之一）

> **定义：** 任何父类出现的地方，子类都可以替代。
> **父类容器装子类对象**——因为子类对象包含了父类的所有内容。

**作用：** 方便进行对象存储和管理。

---

## 语法

**关键字：`is` 和 `as`**

|     | is                      | as                  |
| --- | ----------------------- | ------------------- |
| 作用  | 判断一个对象是否是指定类对象          | 将一个对象转换为指定类对象       |
| 返回值 | bool（是为 true，不是为 false） | 成功返回指定类对象，失败返回 null |

```csharp
class GameObject { }
class Player : GameObject 
{ 
	public void Atk(){ }
}
class Monster : GameObject { }
class Boss : GameObject { }

// 父类容器装子类对象（里氏替换）
GameObject[] objects = new GameObject[]{ new Player(), new Monster(), new Boss() };

// 注意：用父类容器装了子类对象后，是无法点出子类对象的方法的
GameObject p = new Player();
p.Atk(); //❌ 报错

// 需要用 is 和 as 解决
if (p is Player)
	(p as Player).Atk();

// 不能用子类去装父类对象
Player p2 = new Object(); // ❌ 报错
```

---

## 练习

> 1. is 和 as 的区别是什么？

**is：**
- 判断一个对象是否是指定类，返回一个 bool 值（是为 true，不是为 false）
**as：**
- 将一个对象改成指定类，成功返回指定类对象，失败返回 null


> 2. 写个 Monster 类，派生出 Boss 和 Goblin 两个类，Boss 有技能，Goblin 有攻击；随机生成10个怪，装载到数组中，遍历数组调用他们的方法，如果是 Boss 就释放技能

```csharp
class Monster { public string name; }

class Boss : Monster
{
    public void Skill() 
    { 
	    Console.WriteLine("boss释放了技能"); 
    }
}

class Goblin : Monster
{
    public void Atk() 
    { 
	    Console.WriteLine("怪物发动了攻击"); 
    }
}

Random r = new Random();
Monster[] monsters = new Monster[10];
for (int i = 0; i < 10; i++)
{
    int random = r.Next(0, 2);
    if (random == 0) monsters[i] = new Boss();
    else monsters[i] = new Goblin();
}

for (int i = 0; i < monsters.Length; i++)
{
    if (monsters[i] is Boss) 
	    (monsters[i] as Boss).Skill();
    else 
	    (monsters[i] as Goblin).Atk();
}
```

> 3. FPS 游戏模拟：写一个玩家类，玩家可以拥有各种武器，现有冲锋枪/散弹枪/手枪/匕首四种武器，玩家默认拥有匕首，请在玩家类中写一个方法，可以拾取不同的武器替换自己拥有的枪械

```csharp
class Weapon { }
class BiShou : Weapon { }
class ChongFengQiang : Weapon { }
class XianDanQiang : Weapon { }
class ShouQiang : Weapon { }

class Player
{
    public Weapon weapon = new BiShou(); // 默认匕首

    public void PickUp(Weapon w)
    {
        weapon = w;
        Console.WriteLine("拾取了武器：" + w.GetType().Name);
    }
}

Player p = new Player();
Weapon w = new XianDanQiang();
p.PickUp(w);
```

---

## 我的踩坑记录

- as 转换失败返回 null，调用 null 的方法会报空引用异常，记得判空

---

*最后更新：*
