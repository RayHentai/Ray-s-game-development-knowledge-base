# 06 Xlua 特性重要内容

**所属模块**：[[00 热更新 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心要点

`[CSharpCallLua]` 
- C#中声明的有参委托必须加上这个特性，不然调用映射了Lua函数之后的该委托时会报错
- C#中声明的接口同理

`[LuaCallCSharp]`
- Lua调用C#拓展方法时需要在拓展方法类名前加上这个特性
- 该特性建议每个被Lua调用的类都加，提升性能

这两个特性添加完都需要在编辑器重新生成代码

**有一个问题：如果系统类或者第三方库代码因报错需要添加这两个特性，这些类无法修改，这显然是做不到的，Xlua提供了一个解决方法**

这种写法同时也可以把自定义类也

---

## 语法 / 用法

```csharp
public static class XluaAttribute
{
	[CSharpCallLua]
	public static List<Type> cSharpCallLuaList = new List<Type>() {
		typeof(UnityAction<float>),
		...//继续添加即可
	}
	
	[LuaCallCSharp]
	public static List<Type> luaCallCSharpList = new List<Type>() {
		typeof(GameObject),
		typeof(Rigebody),
		...//继续添加即可
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
