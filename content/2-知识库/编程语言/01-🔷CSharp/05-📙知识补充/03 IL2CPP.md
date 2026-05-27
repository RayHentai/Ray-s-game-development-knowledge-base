# 03 IL2CPP

**所属模块**：[[00 CSharp 知识补充总览]]
**关联**：[[01 跨平台的基本原理]] | [[02 Mono]]
**查阅次数**：0

---

## 核心理解

**IL2CPP是在Unity4.6.1 p5之后的版本中加入的脚本后处理方式**
可以简单理解为是继Mono之后的一种跨平台解决方案
顾名思义就是把IL中间代码转译为CPP代码（C++）

由于IL2CPP的运行效率有很大优势
**所以建议在实际开发中直接使用IL2CPP模式进行打包**

**设置位置**
ProjectSetting -> Player -> OtherSetting -> Configuration -> ScripingBackend -> Mono 或 IL2CPP

**Unity IL2CPP打包工具的安装**
Unity Hub -> 安装 -> 管理 -> 添加模块

---

## IL2CPP跨平台原理

通过IL2CPP我们可以将编译好的IL中间代码转译成C++代码
再利用各平台优化过的编译器编译为对应平台的目标代码
![[IL2CPP跨平台原理.png|416]]

IL2CPP和Mono的区别就在于
当生成了IL中间代码后，Mono是直接通过虚拟机转译运行
而IL2CPP的步骤多了一些
会将IL中间代码转译为C++代码
再通过各平台的C++编译器直接编译为可执行的原生汇编代码
![[IL2CPP跨平台原理 2.png|398]]
**需要注意的是**
虽然中间代码变为了C++
但是内存管理还是遵循C#中GC的方式这也是为什么有一个IL2CPPVM（虚拟机）存在的原因，它主要是用来完成
GC管理，线程创建等服务工作的

---

## Mono 和 IL2CPP的区别

**Mono**
1. 构建（最终打包时）速度快
2. Mono编译机制是JIT即时编译，所以支持更多类库
3. 必须将代码发布为托管程序集（.dIl文件）
4. MonoVM虚拟机平台维护麻烦，且部分平台不支持(WebGL)
5. 由于Mono版本授权原因，C#很多新特性无法使用
6. IOS支持Mono，但不在允许32位的Mono应用提交到应用商店

**IL2CPP**
1. 相对Mono构建（最终打包时）速度慢
2. 只支持AOT提前编译
3. 可以启用引擎代码剥离来减少代码的大小
4. 程序的运行效率比Mono高，运行速度快
5. 多平台移植更加方便

**Mono和IL2CPP的最大区别就是**
**IL2CPP不能在运行时动态生成代码和类型**
所以必须在编译时就完全确定需要用到的类型

举例：`List<A>`和`List<B>`中A和B是我们自定义的类，必须在代码中显示的调用过，IL2CPP才能保留`List<A>`和`List<B>`两个类型。如果在热更新时我们调用`List<C>`，但是它之前并没有在代码中显示调用过，那么这时就会出现报错等问题。主要就是因为JIT和AOT两个编译模式的不同造成的
 
---

## IL2CPP可能存在的问题处理

---

### 类型裁剪

IL2CPP在打包时会自动对Unity工程的DLL进行裁剪，将代码中没有引用到的类型裁剪掉，
以达到减小发布后包的尺寸的目的。
然而在实际使用过程中，很多类型有可能会被意外剪裁掉，
造成运行时抛出找不到某个类型的异常。
特别是通过反射等方式在编译时无法得知的函数调用，在运行时都很有可能遇到问题

**解决方案：**

**1.IL2CPP处理模式时，将PlayerSetting->Other Setting->Managed Stripping Level(代码剥离)设置为Low**
- Disable:Mono模式下才能设置为不删除任何代码
- Low:默认低级别，保守的删除代码，删除大多数无法访问的代码，同时也最大程度减少剥离实际使用的代码的可能性
- Medium:中等级别，不如低级别剥离谨慎，也不会达到高级别的极端
- Hight:高级别，尽可能多的删除无法访问的代码，有限优化尺寸减小。如果选择该模式一般需要配合link.xml使用

**2.通过Unity提供的link.xml方式来告诉Unity引擎，哪些类型是不能够被剪裁掉的**
- 在Unity工程的Assets目录中（或其任何子目录中）建立一个叫link.xml的XML文件
- 推荐处理方式：代码剥离设置为hight，打包，看看哪些地方报错，通过测试在link中进行配置

```xml
<?xml version="1.0" encoding="UTF-8"?>

  <!--保存整个程序集-->
  <assembly fullname="UnityEngine" preserve="all"/>
  <!--没有“preserve”属性，也没有指定类型意味着保留所有-->
  <assembly fullname="UnityEngine"/>

  <!--完全限定程序集名称-->
  <assembly fullname="Assembly-CSharp, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null">
    <type fullname="Assembly-CSharp.Foo" preserve="all"/>
  </assembly>

  <!--在程序集中保留类型和成员 最常用-->
  <assembly fullname="Assembly-CSharp">
    <!--保留整个类型-->
    <type fullname="MyGame.A" preserve="all"/>
    <!--没有“保留”属性，也没有指定成员 意味着保留所有成员-->
    <type fullname="MyGame.B"/>
    <!--保留命名空间中的所有内容-->
    <type fullname="MyGame"/>
    <!--保留类型上的所有字段-->
    <type fullname="MyGame.C" preserve="fields"/>
    <!--保留类型上的所有方法-->
    <type fullname="MyGame.D" preserve="methods"/>
    <!--只保留类型-->
    <type fullname="MyGame.E" preserve="nothing"/>
    <!--仅保留类型的特定成员-->
    <type fullname="MyGame.F">
      <!--类型和名称保留-->
      <field signature="System.Int32 field1" />
      <!--按名称而不是签名保留字段-->
      <field name="field2" />
      <!--方法-->
      <method signature="System.Void Method1()" />
      <!--保留带有参数的方法-->
      <method signature="System.Void Method2(System.Int32,System.String)" />
      <!--按名称保留方法-->
      <method name="Method3" />

      <!--属性-->
      <!--保留属性-->
      <property signature="System.Int32 Property1" />
      <property signature="System.Int32 Property2" accessors="all" />
      <!--保留属性、其支持字段（如果存在）和getter方法-->
      <property signature="System.Int32 Property3" accessors="get" />
      <!--保留属性、其支持字段（如果存在）和setter方法-->
      <property signature="System.Int32 Property4" accessors="set" />
      <!--按名称保留属性-->
      <property name="Property5" />

      <!--事件-->
      <!--保存事件及其支持字段（如果存在），添加和删除方法-->
      <event signature="System.EventHandler Event1" />
      <!--根据名字保留事件-->
      <event name="Event2" />
    </type>

    <!--泛型相关保留-->
    <type fullname="MyGame.G`1">
      <!--保留带有泛型的字段-->
      <field signature="System.Collections.Generic.List`1&lt;System.Int32&gt; field1" />
      <field signature="System.Collections.Generic.List`1&lt;T&gt; field2" />

      <!--保留带有泛型的方法-->
      <method signature="System.Void Method1(System.Collections.Generic.List`1&lt;System.Int32&gt;)" />
      <!--保留带有泛型的事件-->
      <event signature="System.EventHandler`1&lt;System.EventArgs&gt; Event1" />
    </type>


    <!--如果使用类型，则保留该类型的所有字段。如果类型不是用过的话会被移除-->
    <type fullname="MyGame.I" preserve="fields" required="0"/>

    <!--如果使用某个类型，则保留该类型的所有方法。如果未使用该类型，则会将其删除-->
    <type fullname="MyGame.J" preserve="methods" required="0"/>

    <!--保留命名空间中的所有类型-->
    <type fullname="MyGame.SomeNamespace*" />

    <!--保留名称中带有公共前缀的所有类型-->
    <type fullname="Prefix*" />

  </assembly>
  
</linker>
```

---

### 泛型问题

IL2CPP和Mono最大的区别是 不能在运行时动态生成代码和类型
就是说 泛型相关的内容，如果你在打包生成前没有把之后想要使用的泛型类型显示使用一次
那么之后如果使用没有被编译的类型，就会出现找不到类型的报错

**解决方案：**
泛型类：声明一个类，然后在这个类中声明一些public的泛型类变量
泛型方法：随便写一个静态方法，在将这个泛型方法在其中调用一下。这个静态方法无需被调用
这样做的目的其实就是在预言编译之前让IL2CPP知道我们需要使用这个内容

```csharp
public class IL2CPP_Info
{
    public List<A> list;
    public List<B> list2;
    public List<C> list3;

    public Dictionary<int, string> dic = new Dictionary<int, string>();

    public void Test<T>(T info)
    {

    }

    public static void Test()
    {
        IL2CPP_Info info = new IL2CPP_Info();
        info.Test<int>(1);
        info.Test<float>(1);
        info.Test<bool>(true);
    }

}
```

---

## 总结

**1. IL2CPP是Unity4.6.1版本之后加入的新的一种跨平台解决方案**

**2. Mono跨平台回顾**
C#代码 -> MonoC#编译器 -> IL中间代码 -> MonoVM -> 操作系统的原生代码

**3. IL2CPP跨平台原理**
C#代码 -> MonoC#编译器 -> IL中间代码 -> IL2CPP>C++ -> C++编译器 -> 原生汇编代码 -> IL2CPPVM

**4. Mono和IL2CPP的区别**
IL2CPP效率高于Mono，跨平台也更好维护。Mono是JIT即时编译，IL2CPP是AOT提前编译

**5. Mono和IL2CPP两种方式的使用建议建议使用效率更高的IL2CPP**

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

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
