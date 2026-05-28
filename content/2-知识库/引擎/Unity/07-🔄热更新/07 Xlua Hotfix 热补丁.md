# 07 Xlua Hotfix 热补丁

**所属模块**：[[00 热更新 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心要点

**1. 解决的问题：通过Hotfix，可以替换类中成员（函数、属性、索引器等）的逻辑，让脚本不执行C#逻辑，而是执行Lua逻辑，实现热更新。**

**2. 必须要做的事情**
- 想要被打补丁的类，前面要加上Hotfix特性
- 如果是第一次进行热补丁开发，需要加宏 Edit → Project Settings → Player → Other Settings → Script Compilation → Scripting Define Symbols添加 `HOTFIX_ENABLE` 如果添加成功 窗口Xlua选项下 会多一个选项
- Xlua/Generate Code 生成代码
- hotfix inject in editor 注入热补丁

**3. 如果修改了热补丁的C#代码 ，一定要重新注入，如果我们为打了Hotfix特性的C#类新加了函数内容，必须要先生成代码再注入，不然注入会报错**

**4. 单函数固定写法：`xlua.hotfix(类, "函数名", lua函数)`**

**5. 多函数固定写法：`xlua.hotfix(类, {函数名 = 函数, 函数名 = 函数....})`**
- 构造函数固定写法 `[".ctor"]= 函数`
- 析构函数固定写法 `Finalize = 函数`
- 构造和析构不是替换，而是先执行C#的逻辑 再执行Lua的逻辑 和其它的函数不同

**6. 协程函数：整体规则和普通函数替换是一样的，区别在函数内部 是需要返回一个 `xlua.util.cs_generator(函数)`的返回值**

**7. 索引器和属性：**
- 属性重定向固定写法
	- set_属性名——因为是成员函数 第一个参数默认写self 第二个参数 相当于传入的值
	- get_属性名——因为是成员函数 第一个参数默认写self
- 索引器重定向固定写法
	- set_Item——因为是成员函数 第一个参数默认写self 第二个参数是索引 第三个参数是值
	- get_Item——因为是成员函数 第一个参数默认写self 第二个参数是索引

**8. 事件：add_事件名、remove_事件名**
- 如果要重定向事件加减到Lua中来
- 一定不要使用C#的事件加减 self:myEvent("+/-", 传入函数) 
- 因为会造成死循环 
- 如果想重定向 一定是把传入的函数 存到lua里的容器中

**9. 泛型类：替换规则和之前一样区别是：类名后括号加泛型的类型**
- 因为泛型时可变的，所以要指定某一个类型来进行替换 
- 想替换几个类型，就写几个补丁

---

## 代码演示

lua当中 热补丁固定写法
`xlua.hotfix(类, "函数名", lua函数)`

成员方法第一个参数需要传入self 静态方法不用

直接写好代码运行是会报错的，必须做4个非常重要的操作
1. 加特性 `[Hotfix]`
2. 加宏 `HOTFIX_ENABLE` 
	- Edit → Project Settings → Player → Other Settings → Script Compilation → Scripting Define Symbols
3. 生成代码
4. hotfix注入 要把Xlua工程文件夹中的tools复制到项目根目录 并且项目名不能有空格

**热补丁的缺点：每次修改代码都需要执行第四步**

```lua
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("08-Hotfix")
```

---

### 函数替换

```csharp
[Hotfix]
public class HotfixMain : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        Debug.Log(Add(10, 20));
        Speak("打热补丁成功");
    }
    public int Add(int a, int b)
    {
        return 0;
    }
    public static void Speak(string str)
    {
        Debug.Log("哈哈哈哈哈哈哈");
    }
```

```lua
xlua.hotfix(CS.HotfixMain, "Add", function(self, a, b)
	return a + b
end)

xlua.hotfix(CS.HotfixMain, "Speak", function(a)
	print(a)
end)
```

---

### 多函数替换

```csharp
[Hotfix]
public class HotfixMain : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        Debug.Log(Add(10, 20));
        Speak("打热补丁成功");
    }
    void Update()
    {

    }
    public int Add(int a, int b)
    {
        return 0;
    }
    public static void Speak(string str)
    {
        Debug.Log("哈哈哈哈哈哈哈");
    }
}
```

```lua
--多函数替换
--xlua.hotfix(类, {函数名 = 函数, 函数名 = 函数...})
xlua.hotfix(CS.HotfixMain, {
	Update = function(self)
		--print(os.time())
	end,
	Add = function(self, a, b)
		return a + b
	end,
	Speak = function(a)
		print(a)
	end
})
```

---

### 构造函数和析构函数替换

```csharp
[Hotfix]
public class HotfixTest
{
    public HotfixTest()
    {
        Debug.Log("HotfixTest的构造函数");
    }
    public void Speak(string str)
    {
        Debug.Log("str");
    }
    ~HotfixTest() { }
}
[Hotfix]
public class HotfixMain : MonoBehaviour
{
    HotfixTest hotfixTest;
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        hotfixTest = new HotfixTest();
        hotfixTest.Speak("嘻嘻嘻嘻");
    }
}
```

```lua
--构造函数 和析构函数的替换
xlua.hotfix(CS.HotfixTest,{
	--构造函数 热补丁固定写法
	--他们和别的函数不一样 是先调用原逻辑 再调用lua逻辑 不是替换
	[".ctor"] = function()
		print("热补丁中的构造函数")
	end,
	Speak = function(self, a)
		print("热补丁说" .. a)
	end,
	--析构函数固定写法 Finalize
	--类中必须有析构函数才能打热补丁 不然会报错
	Finalize = function()
	end
})
```

---

### 协程函数替换

```csharp
[Hotfix]
public class HotfixMain : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        StartCoroutine(TestCoroutine());
    }
    IEnumerator TestCoroutine()
    {
        while (true)
        {
            yield return new WaitForSeconds(1f);
            Debug.Log("C#启动一次");
        }
}
```

```lua
--协程函数的替换
util = require("xlua.util")
xlua.hotfix(CS.HotfixMain,{
	TestCoroutine = function(self)
		--返回一个 xlua处理过的lua协程函数
		return util.cs_generator(function()
			while true do
				coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
				print("Lua打补丁后的协程函数")
			end
		end)
	end
})
```

---

### 属性和索引器的替换

```csharp
[Hotfix]
public class HotfixMain : MonoBehaviour
{
    public int[] array = new int[] { 1, 2, 3 };
    //属性
    public int Age
    {
        get 
        {
            return 0;
        }
        set 
        {
            Debug.Log(value);
        }
    }
    //索引器
    public int this[int index]
    {
        get 
        {
            if (index >= array.Length || index < 0)
            {
                return 0;
                Debug.Log("索引不正确");
            } 
            return array[index];
        }
        set 
        {
            if (index >= array.Length || index < 0)
            {
                return;
            }
            array[index] = value;
        }
    }
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        this.Age = 100;
        Debug.Log(Age);
        this[99] = 100;
        Debug.Log(this[999]);
    }
}
```

```lua
--属性和索引器的替换
xlua.hotfix(CS.HotfixMain,{
	--属性固定写法
	--set_属性名 是设置属性的方法
	--get_属性名 是得到属性的方法
	set_Age = function(self, vlaue)
		print("lua 重定向的属性" .. 10)
	end,
	get_Age = function(self)
		return 10;
	end,
	--索引器固定写法
    --set_Item 通说索引器设置
    --get_Item 通过索引器获取
    set_Item = function(self, index, v)
    	print("lua 重定向索引器，索引：" .. index .. "值" .. v)
    end,
    get_Item = function(self, index)
    	print("lua 重定向索引器")
    	 return 999
    end
})
```

---

### 事件替换

```csharp
[Hotfix]
public class HotfixMain : MonoBehaviour
{
    event UnityAction myEvent;
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        myEvent += TestFunc;
        myEvent -= TestFunc;
    }
    public void TestFunc() { }
```

```lua
--事件替换
xlua.hotfix(CS.HotfixMain,{
	--add_事件名 代表事件+操作
	--remove_事件名 代表事件-操作
	add_myEvent = function(self,del)
		print(del)
		print("添加事件函数")
		--lua使用C#的方法去添加事件是不行的
		--在事件加减的重定向函数中
		--不要把传入的委托往事件里存
		--会死循环
		--self:myEvent("+", del)
		--所以一定是把传入的函数 存到lua里的容器中
	end,
	remove_myEvent = function(self,del)
		print(del)
		print("移除事件函数")
	end
})
```

---

### 泛型类替换

```csharp
[Hotfix]
public class HotfixTest2<T>
{
    public void Test(T value)
    {
        Debug.Log(value);
    }
}
[Hotfix]
public class HotfixMain : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        HotfixTest2<string> t1 = new HotfixTest2<string>();
        t1.Test("123");
        HotfixTest2<int> t2 = new HotfixTest2<int>();
        t2.Test(999);
    }
```

```lua
--泛型类替换
--lua中的替换 要一个类型一个类型的来
xlua.hotfix(CS.HotfixTest2(CS.System.String),{
	Test = function(self, str)
		print("Lua打的补丁：" .. str)
	end
})

xlua.hotfix(CS.HotfixTest2(CS.System.Int32),{
	Test = function(self, int)
		print("Lua打的补丁：" .. int)
	end
})
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

## API速查


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
