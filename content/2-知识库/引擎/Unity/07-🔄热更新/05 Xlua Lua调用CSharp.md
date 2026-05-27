# 05 Xlua Lua调用CSharp

**所属模块**：[[00 热更新 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心要点

**1. 类**
- `CS.命名空间.类名` 调用
- `CS.命名空间.类名()` 实例化 
- `CS.命名空间.类名.方法或者变量` 静态方法和变量
- `实例化的对象.变量名` 成员变量
- `实例化的对象:方法名` 成员方法
- 使用对象中的成员方法需要:调用！！！
- 可以取别名 `别名 = CS.命名空间.类名` 优化技巧 方便使用 节约性能
- xlua不支持无参泛型函数，要使用 `AddCompoent（Type）` 
- xlua提供了一个 `typeof` 方法 可以得到对象的 `Type`
- 通过C#进入（启动）Lua

**2. 枚举**
- `CS.命名空间.枚举名.枚举成员` 得到枚举
- `枚举.__CastFrom(数字或者字符串)` 转枚举

**3. 数组、List和Dictionary**
- `数组`、`List`、`Dictionary` 使用在Lua中都遵循C#的规则
- 实例化数组 需要引用 `Array` 类 并调用 静态方法`CreateInstance(类型, 长度)` 实例化
- lua中不支持 `[,]` `[][]`访问二维数组 所以要使用 `Arrays` 类中的 `GetValue` 成员方法
- 实例化List有两种方法 新版 需要先实例化该List的泛型类 再实例化得到的这个对象
- Dictionary的实例化同List
- 在Lua中 只能通过`set_Item(键, 值)`  `get_Item(键)` 改或得元素

**4.函数**
- 拓展方法
	- Lua可以使用C#的拓展方法，需要在拓展方法类中得对应静态类之前加上`[LuaCallCSharp]`特性并重新生成代码
- 参数为ref 和 out的函数
	- `ref` 和 `out` 使用上非常相似，如果Lua使用C#中带有 `ref` 和 `out` 的函数，都是以多返回值的形式使用的
	- 在传参时：`ref` 需要用值占位，`out` 忽略不传 
	- 在返回时：如果函数默认有返回值，第一个返回值就是函数的返回值 之后的多返回值，从函数参数从左往右看，有 `ref` 或者 `out` 就多一个返回值，对应的就是该参数在函数内部额赋值
- 函数重载
	- Lua支持调用C#的重载函数，但是调用时存在调用时存在精度分不清的问题（float类型）
	- 通过 `Type` 得到C#函数，通过 `xlua.tofunction` 转为lua函数 然后使用 可以解决精度问题
	- 默认情况下 只支持调用 有约束有参数的泛型函数
- 泛型函数
	- 默认情况下只支持调用有约束有参数的泛型函数
	- 其他的泛型函数能被调用，必须要指定泛型的类型，这种方法使用在不同的代码打包方式下支持情况不同，要谨慎使用

**5. 委托和事件**
- Lua中使用委托第一次加函数不能直接加，要先等 之后的再加
- lua中不支持复合运算符+=和-=
- `对象:事件名（"+/-", 函数变量）` 事件添加函数的方法
- 事件的清空和调用都要在C#处去包裹 然后在Lua来调用成员方法

**6. 协程**
- Lua中用C#协程开启和关闭规则和C#中一样
- C#的`yield return` 相当于Lua中的 `coroutine.yield(返回值)`
- 开启协程时 传入的函数必须先`xlua.util.cs_generator(函数)` 再传入
- `util` 表 必须先 `require("xlua.util")`

**7. null和nil**
- Lua中C#的 `null` 没办法和 `nil` 比较 不是相等的
- 方法一：`对象:Equals(nil)` 但这种方法 前提是对象是一个 `object`
- 方法二：在Lua中封装一个全局方法 保险判断
- 方法三：在C#中为 `Object` 写一个拓展判空方法

---

## Lua使用C#类 

```csharp
//Lua无法直接调用C#脚本
//所以通过一个C#脚本启动Lua 主脚本
//再在Lua主脚本中写逻辑
public class Main : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
    }
}
```

```csharp
public class Test1
{
    public void Speak(string str)
    {
        Debug.Log("Test1" + str);
    }
}
namespace TestNamespace
{
    public class Test2
    {
        public void Speak(string str)
        {
            Debug.Log("Test2" + str);
        }
        
    }
}
public class LuaCallCSharp : MonoBehaviour {  }
```

```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("01-LuaCallClass")
```

```lua title:01-LuaCallClass.Lua
print("01-LuaCallClass.Lua")
--Lua使用C#类
--CS.命名空间.类名
--Lua没有new ()相当于执行无参构造函数
local obj1 = CS.UnityEngine.GameObject()
local obj2 = CS.UnityEngine.GameObject("通过Lua实例化的空对象")

--优化 为了方便和节约性能 可以定义全局变量存储C#中的类
--Lua 就不会每次执行都会去搜索命名空间和类
GameObject = CS.UnityEngine.GameObject
local obj3 = GameObject("通过Lua实例化的第二个空对象")

--类中的静态对象 可以直接.调用
local obj4 = GameObject.Find("通过Lua实例化的空对象")

--类中的成员变量 直接对象.即可
print(obj4.transform.position)
Debug = CS.UnityEngine.Debug
Debug.Log(obj4.transform.position)

--如果使用对象中的成员方法 一定要加:!!!!
Vector3 = CS.UnityEngine.Vector3
obj4.transform:Translate(Vector3.right);
Debug.Log(obj4.transform.position)

--调用自定义类
local t = CS.Test1()
t:Speak("说话")
local t2 = CS.TestNamespace.Test2()
t2:Speak("说话")

--继承了Mono的类
--xlua提供了一个重要方法 typeof 可以得到类的type
--lua不支持无参泛型函数 所以需要使用Type的重载
local obj5 = GameObject("加脚本测试")
obj5:AddComponent(typeof(CS.LuaCallCSharp))
```
---

## Lua使用C#枚举

```csharp
//Lua无法直接调用C#脚本
//所以通过一个C#脚本启动Lua 主脚本
//再在Lua主脚本中写逻辑
public class Main : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
    }
}
```

```csharp
public enum E_MyEnum
{ 
    Idle,
    Move,
    Atk,
}
```

```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("02-LuaCallEnum")
```

```lua title:02-LuaCallEnum.Lua
print("02-LuaCallEnum.Lua")
--枚举调用
--调用Unity当中的枚举
--枚举的调用规则和类的调用规则是一样的
--CS.命名空间.枚举名.枚举成员
--也支持取别名
PrimitiveType = CS.UnityEngine.PrimitiveType
GameObject = CS.UnityEngine.GameObject
local obj1 = GameObject.CreatePrimitive(PrimitiveType.Cube)

--自定义枚举 使用方法一样 注意命名空间即可
E_MyEnum = CS.E_MyEnum
local a = E_MyEnum.Idle
print(a)

--枚举转换
--数值转枚举
local b = E_MyEnum.__CastFrom(1);
print(b)
--字符串转枚举
local c = E_MyEnum.__CastFrom("Atk")
print(c)
```

---

## Lua使用C#数组、List、Dictionary

```csharp
//Lua无法直接调用C#脚本
//所以通过一个C#脚本启动Lua 主脚本
//再在Lua主脚本中写逻辑
public class Main : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
    }
}
```

```csharp
public class ListArrayDictionary
{
    public int[] array = new int[5] { 1, 2, 3, 4, 5 };
    public int[,] arrays = new int[2, 3] { { 1, 2, 3 }, { 4, 5, 6 } };
    public List<int> list = new List<int>();
    public Dictionary<int, string> dic = new Dictionary<int, string>();
}
```

```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("03-LuaCallArray")
```

```lua title:03-LuaCallArray.Lua
print("03-LuaCallArray.Lua")
--C#使用数组
--长度 
--从C#中读取过来的数据为 userdata类型 保留了数据原本的结构
--所以不能用#获取长度 C#中如何使用 就如何使用
local obj = CS.ListArrayDictionary()
print(obj.array.Length) --5

--访问元素
print(obj.array[0]) --1

--遍历 索引为0 遵循C#规则
for i=0,obj.array.Length-1 do
	print(obj.array[i])
end

--创建一个C#数组
--数组的本质是一个Array类
--Array类中有一个CreateInstance 静态方法
--使用这个静态方法创建即可
local array2 = CS.System.Array.CreateInstance(typeof(CS.System.Int32), 10)
print(array2.Length) --10
print(array2[0]) --0
print(array2[1]) --0

--二维数组
--长度
print("行：" .. obj.arrays:GetLength(0)) --2
print("列：" .. obj.arrays:GetLength(1)) --3

--访问元素
--不能通过[0][0] 或者[0,0] 访问元素 会报错
--解决方案 使用Arrays类中的GetValue成员方法
print(obj.arrays:GetValue(0,0))
print(obj.arrays:GetValue(1,0))

--遍历
for i=0,obj.arrays:GetLength(0)-1 do
	for j=0,obj.arrays:GetLength(1)-1 do
		print(obj.arrays:GetValue(i,j))
	end
end

--C#使用List
--增
obj.list:Add(1)
obj.list:Add(2)
obj.list:Add(3)
print(obj.list.Count)

--遍历
for i=0,obj.list.Count-1 do
	print(obj.list[i])
end

--创建一个List对象
--老版本
local list2 = CS.System.Collections.Generic["List`1[System.String]"]()
list2:Add("123")
print(list2[0]) --123

--新版本 >v2.1.12
--先得到一个List<string>的一个类 别名 需要再实例化
local list_String = CS.System.Collections.Generic.List(CS.System.String)
local list3 = list_String()
list3:Add("5555")
print(list3[0]) --5555

--C#使用Dictionary
--增
obj.dic:Add(1, "123")
print(obj.dic[1])

--遍历
for k,v in pairs(obj.dic) do
	print(k,v)
end

--创建一个List对象
--老版本 过于麻烦
--新版本
--先得到一个Dictionary<string, Vector3>的一个类 别名 需要再实例化
local dic_String_Vector3 = CS.System.Collections.Generic.Dictionary(CS.System.String, CS.UnityEngine.Vector3)
local dic2 = dic_String_Vector3()
dic2:Add("1", CS.UnityEngine.Vector3.forward)
for k,v in pairs(dic2) do
	print(k,v)
end
--这样得在Lua中创建的字典 直接通过键中括号得 得不到 是nil
print(dic2["1"]) --nil
print(dic2:TryGetValue("1")) --true 001 这样是可以得的 有两个返回值
--如果要通过键取得值 需要通过固定方法 改同
print(dic2:get_Item("1"))
dic2:set_Item("1",nil)
print(dic2:get_Item("1"))
```
---

## Lua使用C#函数

```csharp
//Lua无法直接调用C#脚本
//所以通过一个C#脚本启动Lua 主脚本
//再在Lua主脚本中写逻辑
public class Main : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
    }
}
```

```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("04-LuaCallFunction")
```

---

### Lua使用C#拓展方法


```csharp
public class LuaExtensionMethods
{
    public string name = "Hentai";
    public void Speak(string str)
    {
        Debug.Log(str);
    }
    public static void Eat()
    {
        Debug.Log("吃东西");
    }
}
//如果要在Lua中使用拓展方法 一定要在工具类前面加上特性
//建议Lua中要使用的类都加上该特性 可以提升性能
//如果不加 出了拓展方法对应的类 其他类的使用都不会报错
//但是Lua是通过反射的机制去调用C#的类 效率较低
//而添加了特性就会自动生成对应的C#代码去提升访问性能
[LuaCallCSharp]
public static class Tools
{
    public static void Move(this LuaExtensionMethods obj)
    {
        Debug.Log(obj.name + "移动");
    }
}
```

```lua title:04-LuaCallFunction
--Lua调用C#拓展方法
LuaExtensionMethods = CS.LuaExtensionMethods
--调用静态方法 CS.命名空间.类名.静态方法名
LuaExtensionMethods.Eat()

--成员方法 实例化出来使用
local obj = LuaExtensionMethods()
obj:Speak("说话")

--使用拓展方法 和使用成员方法一样
--如果想在Lua中用拓展方法 需要在拓展工具类前面加上特性 [LuaCallCSharp]
obj:Move();
```

---

### Lua使用C#ref、out函数

```csharp
public class RefOut
{
    public int RefFun(int a, ref int b, ref int c, int d)
    {
        b = a + d;
        c = a - d;
        return 100;
    }
    public int OutFun(int a, out int b, out int c, int d)
    {
        b = a;
        c = d;
        return 200;
    }
    public int RefOutFun(int a, out int b, ref int c)
    {
        b = a * 10;
        c = a * 20;
        return 300;
    }
}
```

```lua title:04-LuaCallFunction
--Lua调用C#ref和out方法
--ref参数 会以多返回值的形式返回给lua
--如果函数存在返回值 第一个值就是返回值
--之后的返回值 就是 ref的结果 从左到右一一对应
--ref参数需要用一个默认值占位 不传值进入也不会报错 但是可能出问题 
RefOut = CS.RefOut
local obj = RefOut()
local a,b,c = obj:RefFun(1, 0, 0, 1)
print(a)
print(b)
print(c)

--out参数 会以多返回值的形式返回给lua
--如果函数存在返回值 第一个值就是返回值
--之后的返回值 就是 out的结果 从左到右一一对应
--out参数不需要占位
local a,b,c = obj:OutFun(20, 30)
print(a)
print(b)
print(c)

--ref 和 out 参数 混合使用时综合上面的规则
--ref 需占位 out 不用传
--第一个是函数的返回值
--之后从左到右依次对应 ref 或者 out
local a,b,c = obj:RefOutFun(80, 1)
print(a)
print(b)
print(c)
```

---

### Lua使用C#泛型函数

```csharp
//Lua无法直接调用C#脚本
//所以通过一个C#脚本启动Lua 主脚本
//再在Lua主脚本中写逻辑
public class Main : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
    }
}
```

```csharp
public class LuaGenericsFun
{
    public interface ITest { }
    public class TestFather { }
    public class TestChild : TestFather, ITest { }

    public void TestFun1<T>(T a, T b) where T : TestFather 
    {
        Debug.Log("有参数，有约束的泛型方法");
    }
    public void TestFun2<T>(T a) 
    {
        Debug.Log("有参数，没有约束的泛型方法");
    }
    public void TestFun3<T>() where T : TestFather
    {
        Debug.Log("没有参数，有约束的泛型方法");
    }
    public void TestFun4<T>(T a) where T : ITest
    {
        Debug.Log("有参数，有约束，但约束不是类的泛型方法");
    }
}
```

```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("04-LuaCallFunction")
```

```lua title:04-LuaCallFunction
--泛型函数
local obj = CS.LuaGenericsFun()
local child = CS.LuaGenericsFun.TestChild()
local father = CS.LuaGenericsFun.TestFather()

--支持有约束有参数的泛型函数
obj:TestFun1(child, father)
obj:TestFun1(father, child)

--不支持没有约束的泛型函数
--obj:TestFun2(child)

--不支持有约束 没有参数的泛型函数
--obj:TestFun3()

--不支持非class的约束
--obj:TestFun4(child)

--有一定使用限制
--Mono打包 这种方式支持使用
--IL2CPP打包 如果泛型参数是值类型 除非C#那边已经调用过 同类型的泛型参数 Luau中才能被使用
--让上面不支持使用的泛型函数 变得能用
--得到通用函数
--设置泛型类再使用
--xlua.get_generic_method(类, 函数名)
local testFun2 = xlua.get_generic_method(CS.LuaGenericsFun, "TestFun2")
local testFun2_R = testFun2(CS.System.Int32)
--调用
--成员方法 第一个参数 传调用函数的对象
--静态方法 不用传参数
testFun2_R(obj, 1)
```

---

## Lua使用C#重载函数

```csharp
public class LuaFunctionOverloading
{
    public int Calc()
    {
        return 100;
    }
    public int Calc(int a, int b)
    {
        return a + b;
    }
    public int Calc(int a)
    {
        return a;
    }
    public float Calc(float a)
    {
        return a;
    }
}
```


```lua title:04-LuaCallFunction
--重载函数
LuaFunctionOverloading = CS.LuaFunctionOverloading
local obj = LuaFunctionOverloading()
--虽然Lua自己不支持函数重载
--但是Lua支持调用C#中的重载函数
print(obj:Calc()) --100
print(obj:Calc(15, 1)) --16

--Lua虽然支持调用C#中的重载函数
--但是Lua中的数值类型只有Number
--对C#中多精度的重载函数支持不好 在使用时 可能会出现意想不到的问题
print(obj:Calc(10)) --10
print(obj:Calc(10.2)) --0

--解决重载函数含糊的问题
--xlua提供了解决办法 利用反射机制
--这种方法只做了解 尽量别用
local m1 = typeof(LuaFunctionOverloading):GetMethod("Calc", {typeof(CS.System.Int32)})
local m2 = typeof(LuaFunctionOverloading):GetMethod("Calc", {typeof(CS.System.Single)})
--通过xlua提供的方法 把它转成lua函数使用
--一般只转一次 重复使用
local f1 = xlua.tofunction(m1);
local f2 = xlua.tofunction(m2);
--成员方法 第一个参数传对象
--静态方法 不用传对象
print(f1(obj, 10)) --10
print(f2(obj, 10.2)) --0
```

---

## Lua使用C#委托、事件

```csharp
//Lua无法直接调用C#脚本
//所以通过一个C#脚本启动Lua 主脚本
//再在Lua主脚本中写逻辑
public class Main : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
    }
}
```

```csharp
public class LuaDelegateEvent
{
    public UnityAction del;
    public event UnityAction eventAction;
    public void DoEvent()
    {
        eventAction?.Invoke();
    }
    public void ClearEvent()
    {
        eventAction = null;
    }
}
```

```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("05-LuaCallDelegate")
```

```lua title:05-LuaCallDelegate
--Lua使用C#委托事件
--委托
--委托是用来装函数的
--使用C#中的委托就是用来装lua函数的
LuaDelegateEvent = CS.LuaDelegateEvent
local obj = LuaDelegateEvent()
local fun = function()
	print("Lua函数Fun")
end

--Lua中没有复合运算符 不能+=
--如果是第一次往委托中加函数 因为是nil 
--所以第一次直接赋值 后面再+
obj.del = fun
obj.del = obj.del + fun
--不建议这样写 最好还是先声明函数再+ 因为这样不好减
obj.del = obj.del + function (  )
	print("直接+一个Lua函数也可以")
end
obj.del()
---函数
obj.del = obj.del - fun
obj.del = obj.del - fun

obj.del()
--置空委托
obj.del = nil
obj.del = fun
obj.del()

--事件
--事件加减函数和委托非常不一样
local fun2 = function(  )
	print("事件加的函数")
end
obj:eventAction("+", fun2);
obj:eventAction("+", function(  )
	print("事件加的匿名函数")
end);
obj:DoEvent()
obj:eventAction("-", fun2);
obj:DoEvent()

--置空事件
--事件不能直接置空 会报错
--但是可以在C#中写一个置空事件的方法 在Lua中调用
--obj.eventAction = nil
obj:ClearEvent()
obj:DoEvent()
```

---

## Lua中 null 和 nil比较

```csharp
//Lua无法直接调用C#脚本
//所以通过一个C#脚本启动Lua 主脚本
//再在Lua主脚本中写逻辑
public class Main : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
    }
}
```

```csharp
public static class Tools
{
    public static bool IsNull(this Object obj)
    {
        return obj == null;
    }
}
```

```lua title:Main
print("主Lua脚本启动")
function IsNull(obj)
	if obj == nil or obj:Equals(nil) then
		return true
	end
	return false
end
require("06-LuaNilAndNull")

```

```lua title:
--问题复现
--往场景对象添加一个脚本 并进行判空操作
GameObject = CS.UnityEngine.GameObject
Rigidbody = CS.UnityEngine.Rigidbody
local obj = GameObject("测试加脚本");
local rig = obj:GetComponent(typeof(Rigidbody))
if rig == nil then
	print("进入if语句块")
	rig = obj:AddComponent(typeof(Rigidbody))
end
print(rig) --nil
--添加脚本失败 并且并没有进入判空的if语句块
--原因是nil 和 null是不能进行==比较的

--解决方案 
--方法一 利用万物之父的Equals方法比较
--但是这种方法有风险 如果对象本来就是nil 则会报错
if rig:Equals(nil) then
	print("进入if语句块")
	rig = obj:AddComponent(typeof(Rigidbody))
end
print(rig) --成功打印

--方法二 可以在Main中写一个全局的判空函数
if IsNull(rig) then
	print("进入if语句块")
	rig = obj:AddComponent(typeof(Rigidbody))
end
print(rig) --成功打印

--方法三 在C#为Object写一个判空的拓展方法
if rig:IsNull() then
	print("进入if语句块")
	rig = obj:AddComponent(typeof(Rigidbody))
end
print(rig) --成功打印
```

---

## Lua使用C#协程

```csharp
//Lua无法直接调用C#脚本
//所以通过一个C#脚本启动Lua 主脚本
//再在Lua主脚本中写逻辑
public class Main : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
    }
}
```

```csharp
public class LuaCallCSharp : MonoBehaviour {  }
```

```lua title:Main
print("主Lua脚本启动")
--所有的关联Lua脚本都在这调用
require("07-Coroutine")
```

```lua title:
--xlua提供的一个工具类
--一定要通过require调用之后才能用
util = require("xlua.util")
--协程
--C#中协程启动都是通过继承了Mono的类 通过里面的启动函数StartCoroutine
GameObject = CS.UnityEngine.GameObject
WaitForSeconds = CS.UnityEngine.WaitForSeconds
local obj = GameObject("Coroutine")
--添加一个继承了Mono的脚本
local mono = obj:AddComponent(typeof(CS.LuaCallCSharp))
fun = function()
	local a = 1
	while true do
		--Lua中并没有yield return 所以只能通过Lua的coroutine开启协程
		coroutine.yield(WaitForSeconds(1))
		print(a)
		a = a + 1
		if a > 10 then
			--停止协程
			mono:StopCoroutine(b)
		end
	end
end
--注意！！！ 不能像这样把函数传给开启协程 会报错
--mono:StartCoroutine(fun)
--如果想把Lua函数当作协程函数传入
--必须先调用xlua.util中的cs_generator(Lua函数)
b = mono:StartCoroutine(util.cs_generator(fun))

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

## 优先级 / 执行顺序

> 如果涉及优先级、执行顺序、作用域等，在这里说明

---

## 练习

> 1. 练习题描述

```csharp
// 答案
```

> 2. 练习题描述

```csharp
// 答案
```

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
