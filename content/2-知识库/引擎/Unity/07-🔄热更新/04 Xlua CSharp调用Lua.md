# 04 Xlua CSharp调用Lua

**所属模块**：[[00 热更新 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心要点

**1. LuaEnv Lua解析器**
- `DoString()` 执行Lua语言
- `Tick()` GC
- `Dispose()` 销毁
- `AddLoader()` Lua文件加载重定向 
- 默认的Lua脚本放在Resources下，并且要加上`.txt`后缀 才能被执行

**2. Lua管理器**
- 初始化方法 重定向文件路径
- 属性 得到 `_G` table
- 方法 执行Lua脚本
- 方法 GC
- 方法 销毁

**3. 映射到变量**
- Global 的 Get方法 获取全局变量
- Global 的 Set方法 修改全局变量
- local 变量无法映射
- 在C#中根据Lua的具体值选择变量类型
- 值拷贝

**4. 映射到函数**
- 无参返回 自定义委托、`Action`、`UnityAction`、`LuaFunction`
- 有参有返回 自定义委托、`Func`、`LuaFunction`
- 多返回 自定义委托 `out` / `ref` 、`LuaFunction`
- 变长参数 自定义委托、`LuaFunction`
- C#声明的有参委托 需要加上 `[CSharpCallLua]` 特性，并重新生成代码

**5. 映射到List、Dictionary**
- List 一般用来映射没有自定义所以的表，Dictionary 一般用来映射有自定义索引的表
- 确定类型，指定类型即可
- 不确定类型，用object
- 值拷贝

**6. 映射到自定义类**
- 声明一个自定义类，其中的成员变量、命名要和Lua中表的自定义索引一致
- 类的成员但是它可少可多，无非就是忽略和补空
- 支持嵌套
- 值拷贝

**7. 映射到自定义接口**
- 自定义一个接口，接口中的变量都用属性去声明，遵循C#中接口的规则，其他注意事项同自定义类
- 接口前面一定要加上特性，并重新生成代码，如果接口结构改了，一定要先清除再生成
- 引用拷贝

**8. 映射到LuaTable**
- 声明一个LuaTable
- 引用拷贝
- 用完了 要Dispose
- 不建议使用用

---

## LuaMgr

```csharp
/// <summary>
/// Lua管理器
/// 提供Lua解析器
/// 保证解析器的唯一性
/// </summary>
public class LuaMgr : BaseManager<LuaMgr>
{
    private LuaMgr() { }
    private LuaEnv luaEnv;
    
    /// <summary>
    /// 得到Lua的_G表
    /// </summary>
    public LuaTable Global => luaEnv.Global;
    
    /// <summary>
    /// 初始化解析器
    /// </summary>
    public void Init()
    {
        if (luaEnv != null)
            return;
        luaEnv = new LuaEnv();
        //重定向
        luaEnv.AddLoader(MyCustomLoader);
        luaEnv.AddLoader(MyCustomABLoader);
    }

    /// <summary>
    /// 执行Lua脚本
    /// </summary>
    /// <param name="str"></param>
    public void DoString(string str)
    {
        if (luaEnv == null)
        {
            Debug.Log("解析器未初始化");
            return;
        }
        luaEnv.DoString(str);
    }
    
    /// <summary>
    /// 执行Lua脚本
    /// 只需要输入Lua脚本名
    /// </summary>
    /// <param name="fileName">脚本名</param>
    public void DoLuaFile(string fileName)
    {
        string str = string.Format("require('{0}')", fileName);
        DoString(str);
    }
    
    /// <summary>
    /// GC
    /// </summary>
    public void Tick() 
    {
        if (luaEnv == null)
        {
            Debug.Log("解析器未初始化");
            return;
        }
        luaEnv.Tick();
    }
    
    /// <summary>
    /// 销毁解析器
    /// </summary>
    public void Dispose()
    {
        if (luaEnv == null)
        {
            Debug.Log("解析器未初始化");
            return;
        }
        luaEnv.Dispose();
        luaEnv = null;
    }
    
    /// <summary>
    /// 重定向加载自定义路径下的Lua脚本
    /// Assets/Lua
    /// </summary>
    /// <param name="filePath">文件名</param>
    /// <returns></returns>
    private byte[] MyCustomLoader(ref string filePath)
    {
        Debug.Log(filePath);//传入的参数 是require执行的Lua脚本文件名
        //通过函数中的逻辑去加载Lua文件
        //拼接一个Lua文件所在路径
        string path = Application.dataPath + "/Lua/" + filePath + ".lua";
        //有路径了 就去加载文件
        if (File.Exists(path))
            return File.ReadAllBytes(path);
        else
            Debug.Log("MyCustomLoader重定向失败，文件名为" + filePath);
        return null;
    }
    
    /// <summary>
    /// 重定向加载AB包中的Lua脚本
    /// </summary>
    /// <param name="filePath"></param>
    /// <returns></returns>
    private byte[] MyCustomABLoader(ref string filePath)
    {
        //Lua文件最终会被放在AB包
        //最终会通过加载AB包再加载其中的Lua脚本资源来执行
        Debug.Log("进入AB包加载重定向函数");
        //不使用管理器 常规的加载AB包方法
        //string path = Application.streamingAssetsPath + "/lua";
        //AssetBundle ab = AssetBundle.LoadFromFile(path);
        //TextAsset tx = ab.LoadAsset<TextAsset>(filePath + ".lua");
        //return tx.bytes;
        //使用管理器
        byte[] result = null;
        ABResMgr.Instance.LoadResAsync<TextAsset>("lua", filePath + ".lua", (lua) => 
        {
            result = lua.bytes;
        }, true);
        if (result == null)
            Debug.Log("MyCustomABLoader重定向失败，文件名为：" + filePath);
        return result;
    }
}

```

---

## Lua解析器 LuaEnv

**作用：能够在Unity中执行Lua**

```lua
print("Unity激活的Lua脚本")
```

```csharp
LuaEnv env = new LuaEnv();
//执行Lua语言 env.DoString
//参数一 lua 代码
//参数二 报错时错误来自哪个脚本
//参数三 解析器
//一般情况下填一个参数就行 而且一般也不会在这直接写脚本
env.DoString("print('hello world')", "CSharpCallLua_LuaEnv");

//执行一个Lua脚本 利用多脚本执行 require
//默认寻找脚本的路径是在Resources下 
//Resources 加载文件只支持txt 所以lua文件后缀需要再加入.txt
env.DoString("require('Main')");

//清除Lua中没有手动释放的对象 GC 帧更新或者定时执行 或者切场景时执行
env.Tick();

//销毁Lua解析器
env.Dispose();
```

---

## Lua文件加载重定向 AddLoader

**作用：Lua脚本路径重定向**
**AddLoader的规则：先加载自定义规则，找不到了再去默认路径（Resources）中找**

```csharp
public class CSharpCallLua_Loader : MonoBehaviour
{
    void Start()
    {
        LuaEnv env = new LuaEnv();
        //Xlua提供的一个 路径重定向的方法
        //允许自定义 加载Lua文件的规则
        //当执行Lua语言 require时 相当于执行一个Lua脚本
        //就会执行自定义传入的这个函数
        env.AddLoader(MyCustomLoader);
        env.DoString("require('Main')");
    }

    //自动执行 通过函数中的逻辑 去加载Lua文件
    private byte[] MyCustomLoader(ref string filePath)
    {
        Debug.Log(filePath);//传入的参数 是require执行的Lua脚本文件名
        //通过函数中的逻辑去加载Lua文件
        //拼接一个Lua文件所在路径
        string path = Application.dataPath + "/Lua/" + filePath + ".lua";
        //有路径了 就去加载文件
        if (File.Exists(path))
            return File.ReadAllBytes(path);
        else
            Debug.Log("MyCustomLoader重定向失败，文件名为" + filePath);
            return null;
    }
}
```

---

## 获取全局变量 

**注意：无法通过C#得到本地局部变量 C#中会报错**

```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("Test")
```

```lua title:Test
print("Test.Lua")
testNumber = 1
testBool = true
testFloat = 1.2
testString = "123"
--无法通过C#得到本地局部变量 C#中会报错
local testLocal = 1
```

```csharp
LuaMgr.Instance.Init();
LuaMgr.Instance.DoLuaFile("Main");
//获取全局变量
Debug.Log("testNumber：" + LuaMgr.Instance.Global.Get<int>("testNumber"));
Debug.Log("testBool：" + LuaMgr.Instance.Global.Get<bool>("testBool"));
Debug.Log("testFloat：" + LuaMgr.Instance.Global.Get<float>("testFloat"));
Debug.Log("testFloat_Double：" + LuaMgr.Instance.Global.Get<double>("testFloat"));
Debug.Log("testString：" + LuaMgr.Instance.Global.Get<string>("testString"));
int i = LuaMgr.Instance.Global.Get<int>("testNumber");
Debug.Log(i); //1
//值拷贝 不会影响原来Lua中的变量值
i = 10;
int i2 = LuaMgr.Instance.Global.Get<int>("testNumber");
Debug.Log(i2); //1
LuaMgr.Instance.Global.Set("testNumber", 99);//修改Lua中变量值的方法
Debug.Log("testNumber：" + LuaMgr.Instance.Global.Get<int>("testNumber"));//99
```

---

## 获取函数

**注意：C#中声明的有参函数需要加入 `[CSharpCallLua]` 特性，不写特性直接调用Lua有返回值函数会报错，写完特性要在编辑器重新生成代码**

```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("Test")
```

```lua title:Test
testFun = function()
	print("无参无返回")
end

testFun2 = function(a)
	print("有参无返回")
	return a + 1
end

testFun3 = function(a)
	print("多返回值")
	return 1, "123", false, a, 1
end

testFun4 = function(a, ...)
	print("变长参数")
	print(a)
	arg = {...}
	for k,v in pairs(arg) do
		print(k, v)
	end
end
```

```csharp
public delegate void CustomCall();
[CSharpCallLua]//不写特性直接调用Lua有返回值函数会报错 写完特性要在编辑器重新生成代码 
public delegate int CustomCall2(int a);
[CSharpCallLua]
public delegate int CustomCall3(int a, out string b, out bool c, out int d, out int e);
[CSharpCallLua]
public delegate int CustomCall4(int a, ref string b, ref bool c, ref int d, ref int e);
[CSharpCallLua]
public delegate int CustomCall5(string a, params int[] args);//变长参数的类型是根据实际情况来定的

public class CSharpCallLua_CallFunction : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        //用委托存储函数
        //无参无返回值
        CustomCall call = LuaMgr.Instance.Global.Get<CustomCall>("testFun");
        call();
        UnityAction ua = LuaMgr.Instance.Global.Get<UnityAction>("testFun");
        ua();
        Action ac = LuaMgr.Instance.Global.Get<Action>("testFun");
        ac();
        LuaFunction lf = LuaMgr.Instance.Global.Get<LuaFunction>("testFun"); //Xlua提供的获取函数的方式 少用
        lf.Call();

        //有参有返回
        CustomCall2 call2 = LuaMgr.Instance.Global.Get<CustomCall2>("testFun2");
        Debug.Log("有参有返回值：" + call2(10));
        Func<int, int> sFun = LuaMgr.Instance.Global.Get<Func<int, int>>("testFun2");
        Debug.Log("有参有返回值：" + sFun(20));
        LuaFunction lf2 = LuaMgr.Instance.Global.Get<LuaFunction>("testFun2"); //Xlua提供的获取函数的方式 少用
        Debug.Log("有参有返回值：" + lf2.Call(30)[0]);

        //多返回值 用out和ref接收
        CustomCall3 call3 = LuaMgr.Instance.Global.Get<CustomCall3>("testFun3");
        string b;
        bool c;
        int d;
        int e;
        Debug.Log("第一个返回值：" + call3(100, out b, out c, out d, out e));
        Debug.Log($"{b}_{c}_{d}_{e}");

        CustomCall4 call4 = LuaMgr.Instance.Global.Get<CustomCall4>("testFun3");
        string b1 = "";
        bool c1 = true;
        int d1 = 0;
        int e1 = 0;
        Debug.Log("第一个返回值：" + call4(200, ref b1, ref c1, ref d1, ref e1));
        Debug.Log($"{b1}_{c1}_{d1}_{e1}");

        LuaFunction lf3 = LuaMgr.Instance.Global.Get<LuaFunction>("testFun3");
        object[] objs = lf3.Call(1000);
        for (int i = 0; i < objs.Length; i++)
        {
            Debug.Log($"第{i + 1}个返回值是：{objs[i]}");
        }

        //变长参数
        CustomCall5 call5 = LuaMgr.Instance.Global.Get<CustomCall5>("testFun4");
        call5("123", 1, 2, 3, 4, 5, 6, 7);
        LuaFunction lf4 = LuaMgr.Instance.Global.Get<LuaFunction>("testFun4");
        lf4.Call("567", 12, 312, 41, 1, 24);
    }
}
```

---

## List、Dictionary 映射 table


```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("Test")
```

```lua title:Test
--List
testList = {1, 2, 3, 4, 5, 6}
testList2 = {"123", "123", true, 1, 1.2}

--Dictionary
testDic = {
	["1"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
}

testDic2 = {
	["1"] = 1,
	[true] = 1,
	[false] = true,
	["123"] = false,
}
```

```csharp
public class CSharpCallLua_CallListDic : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        List<int> list = LuaMgr.Instance.Global.Get<List<int>>("testList");
        foreach (int item in list)
            Debug.Log(item);
        Debug.Log("****************************************************");
        //值拷贝 浅拷贝 不会改变lua中的内容
        list[0] = 100;
        list = LuaMgr.Instance.Global.Get<List<int>>("testList");
        Debug.Log(list[0]);
        List<object> list2 = LuaMgr.Instance.Global.Get<List<object>>("testList2");
        foreach (object item in list2)
            Debug.Log(item);

        Dictionary<string, int> dic = LuaMgr.Instance.Global.Get<Dictionary<string, int>>("testDic");
        foreach (var Key in dic.Keys)
            Debug.Log($"键：{Key} 值：{dic[Key]}");
        Debug.Log("****************************************************");
        //值拷贝 浅拷贝 不会改变lua中的内容
        dic["1"] = 10000;
        dic = LuaMgr.Instance.Global.Get<Dictionary<string, int>>("testDic");
        Debug.Log($"键：1 值：{dic["1"]}");

        Dictionary<object, object> dic2 = LuaMgr.Instance.Global.Get<Dictionary<object, object>>("testDic2");
        foreach (var Key in dic2.Keys)
            Debug.Log($"键：{Key} 值：{dic2[Key]}");
    }
}

```

---

## 类 映射 table


```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("Test")
```

```lua title:Test
--自定义类
testClass = {
	testInt = 2,
	testbool = true,
	testFloat = 1.2,
	testString = "字符",
	testFun = function()
		print("123123123")
	end,
	testInClass = {
		testInInt = 5
	}
}
```

```csharp
public class CallLuaClass
{
    //成员的名字一定要和Lua中的一样 
    //访问修饰符必须是public
    //自定义类中的变量 可以更多也可以更少 多了会补空 少了会忽略
    public int testInt;
    public bool testBool;
    public float testFloat;
    public string testString;
    public UnityAction testFun;
    public TestInClass testInClass;

}
//嵌套类
public class TestInClass
{
    public int testInInt;
}
public class CSharpCallLua_CallClass : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        CallLuaClass obj = LuaMgr.Instance.Global.Get<CallLuaClass>("testClass");
        Debug.Log(obj.testInt);
        Debug.Log(obj.testBool);
        Debug.Log(obj.testFloat);
        Debug.Log(obj.testString);
        obj.testFun();
        //值拷贝 改变了它不会改变Lua表里的内容
        obj.testInt = 100;
        obj = LuaMgr.Instance.Global.Get<CallLuaClass>("testClass");
        Debug.Log(obj.testInt);
        TestInClass testInClass = LuaMgr.Instance.Global.Get<CallLuaClass>("testClass").testInClass;
        Debug.Log(testInClass.testInInt);
    }
}
```

---

## 接口 映射到 table

```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("Test")
```

```lua title:Test
--自定义接口
testInterface = {
	testInt = 2,
	testBool = true,
	testFloat = 1.2,
	testString = "字符",
	testFun = function()
		print("123123123")
	end,
}
```

```csharp
//接口中是不允许有成员变量的 用属性来接受
//接口和类规则一样 其中的属性多了少了不影响结果 无非就是忽略他们
//嵌套也支持 要遵循接口的规则
[CSharpCallLua]
public interface ICSharpCallInterface
{
    int testInt
    {
        get;
        set;
    }
    bool testBool
    {
        get;
        set;
    }
    float testFloat
    {
        get;
        set;
    }
    string testString
    {
        get;
        set;
    }
    UnityAction testFun
    {
        get;
        set;
    }
}

public class CSharpCallLua_CallInterface : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        ICSharpCallInterface obj = LuaMgr.Instance.Global.Get<ICSharpCallInterface>("testInterface");
        Debug.Log(obj.testInt);
        Debug.Log(obj.testBool);
        Debug.Log(obj.testFloat);
        Debug.Log(obj.testString);
        obj.testFun();
        //接口拷贝是 引用拷贝 改了值Lua表中的值也变了
        obj.testInt = 10000;
        obj = LuaMgr.Instance.Global.Get<ICSharpCallInterface>("testInterface");
        Debug.Log(obj.testInt); //10000
    }
}
```

---

## LuaTable 映射到 table

```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("Test")
```

```lua title:Test
--自定义类
testClass = {
	testInt = 2,
	testbool = true,
	testFloat = 1.2,
	testString = "字符",
	testFun = function()
		print("123123123")
	end,
	testInClass = {
		testInInt = 5
	}
}
```

```csharp
public class CSharpCallLua_CallLuaTable : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
        //不建议使用 LuaTable 和 LuaFunction 效率低 需要手动清除
        //引用对象
        LuaTable table = LuaMgr.Instance.Global.Get<LuaTable>("testClass");
        Debug.Log(table.Get<int>("testInt"));
        Debug.Log(table.Get<bool>("testBool"));
        Debug.Log(table.Get<float>("testFloat"));
        Debug.Log(table.Get<string>("testString"));
        table.Get<LuaFunction>("testFun").Call();
        //引用拷贝 改了值Lua表中的值也变了
        table.Set("testInt", 99999);
        table = LuaMgr.Instance.Global.Get<LuaTable>("testClass");
        Debug.Log(table.Get<int>("testInt"));//99999

        table.Dispose();//手动销毁
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
