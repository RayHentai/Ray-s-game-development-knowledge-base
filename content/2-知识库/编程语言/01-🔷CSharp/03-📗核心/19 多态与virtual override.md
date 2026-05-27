# 🎭 19 多态与 virtual override

**所属模块**：[[00 CSharp 核心阶段总览]]
**关联**：[[14 继承基本规则]] | [[20 抽象类与抽象方法]]
**查阅次数**：0

---

## 核心理解

> 字面意思：多种状态。同样行为的不同表现，儿子继承父亲的基因，但是有不同表现。

**解决的问题：** 让继承同一父类的子类们，在执行相同方法时有不同的表现（状态）。

> **让同一个对象有唯一行为的特征**——父类装的子类对象可以执行子类自己的方法。

---

## VOB 三个关键字

**virtual（虚函数）：** 可以被子类重写

```csharp
class Animal
{
    public virtual void Speak() // 加 virtual 表示可以被重写
    {
        Console.WriteLine("动物发出声音");
    }
}
```

**override（重写）：** 重写虚函数

```csharp
class Dog : Animal
{
    public override void Speak() // override 重写父类虚方法
    {
        Console.WriteLine("汪汪");
    }
}
// 多态的体现：父类容器装子类，调用的是子类的方法
Animal a = new Dog();
a.Speak();  // 汪汪（调用 Dog 的版本，不是 Animal 的）
```

**base（父类）**：保留父类行为

```csharp
class Dog : Animal
{
    public override void Speak() 
    {
		//base 保留父类行为
	    base.Speak();
        Console.WriteLine("汪汪");
    }
}
a.Speak(); // 动物发出声音 汪汪（保留父类脚本逻辑，并加上子类重写逻辑）

```

---

## 练习

> 1. 真的鸭子嘎嘎叫，木头鸭子吱吱叫，橡皮鸭子唧唧叫

```csharp
class Duck 
{ 
	public virtual void Jiao()  
	{ 
		Console.WriteLine("嘎嘎"); 
	} 
}
class MTDuck : Duck 
{ 
	public override void Jiao() 
	{ 
		Console.WriteLine("吱吱"); 
	} 
}
class XJDuck : Duck 
{ 
	public override void Jiao() 
	{ 
		Console.WriteLine("唧唧"); 
	} 
}

Duck d  = new Duck(); 
d.Jiao();
Duck d2 = new MTDuck(); 
d2.Jiao();
Duck d3 = new XJDuck(); 
d3.Jiao();
```

> 2. 所有员工9点打卡，但经理11点打卡，程序员不打卡

```csharp
class Worker 
{ 
	public virtual void DaKa()  
	{ 
		Console.WriteLine("9点打卡"); 
	} 
}
class JingLi : Worker 
{ 
	public override void DaKa() 
	{ 
		Console.WriteLine("11点打卡"); 
	} 
}
class Programer : Worker 
{ 
	public override void DaKa() 
	{ 
		Console.WriteLine("不打卡"); 
	} 
}

Worker w  = new Worker();    w.DaKa();
Worker w2 = new JingLi();   w2.DaKa();
Worker w3 = new Programer(); w3.DaKa();
```

> 3. 创建一个图形类，有求面积和周长两个方法；创建矩形类、正方形类、圆形类继承图形类；实例化矩形、正方形、圆形对象求面积和周长

```csharp
class TuXing
{
    public virtual float MianJi() 
    { 
	    return 0; 
    }
    public virtual float ZhouChang() 
    { 
	    return 0; 
    }
}

class JvXing : TuXing
{
    float w, h;
    public JvXing(float w, float h)   
    { 
	    this.w = w; 
	    this.h = h; 
    }
    public override float MianJi()    
    { 
	    return w * h; 
    }
    public override float ZhouChang() 
    { 
	    return (w + h) * 2; 
    }
}

class ZhengFangXing : TuXing
{
    float w;
    public ZhengFangXing(float w)
	{ 
		this.w = w; 
	}
    public override float MianJi()
    { 
	    return w * w; 
    }
    public override float ZhouChang() 
    { 
	    return w * 4; 
    }
}

class YuanXing : TuXing
{
    float r;
    public YuanXing(float r) 
    { 
	    this.r = r; 
    }
    public override float MianJi()
    { 
	    return 3.14f * r * r; 
    }
    public override float ZhouChang() 
    { 
	    return 2 * 3.14f * r; 
    }
}

TuXing t = new JvXing(3, 4);       Console.WriteLine(t.MianJi() + " " + t.ZhouChang());
TuXing t2 = new ZhengFangXing(3);   Console.WriteLine(t2.MianJi() + " " + t2.ZhouChang());
TuXing t3 = new YuanXing(2);        Console.WriteLine(t3.MianJi() + " " + t3.ZhouChang());
```

---

## 我的踩坑记录

- 父类方法没加 virtual，子类的 override 会报编译错误

---

*最后更新：*
