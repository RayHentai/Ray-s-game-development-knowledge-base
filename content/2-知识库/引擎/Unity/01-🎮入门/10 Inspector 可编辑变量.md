# 🔧 10 Inspector 可编辑变量

**所属模块**：[[00 Unity入门阶段总览]]
**关联**：[[21 特性]]
**查阅次数**：0

---

## 哪些变量会显示在 Inspector 中

- **public 变量**：默认显示在 Inspector 面板中
- **private / protected 变量**：默认不显示

---

## 控制显示的特性

**大部分变量类型都能显示编辑**
- 字典、自定义类不支持（自定义类、结构体）

```csharp
// 让公共成员不在 Inspector 面板上显示
[HideInInspector]
public int hiddenValue;

// 让私有或保护成员可以在 Inspector 面板上显示（序列化）
// 序列化就是把一个对象保存到一个文件或数据库字段中去
[SerializeField]
private int visibleValue;

//让自定义类型可以被访问 加上自定义类前面加上序列化特性
[System.Serializable]
class c;
```

**一些辅助特性**

```csharp
//分组说明特性Header 为成员分组 [[分组说明特性Header.png]]
[Header("分组说明")]

//悬停注释Tooltip 为变量添加说明 [[悬停注释Tooltip.png]]
[Tooltip("说明内容")]

//间隔特性Space() 让两个字段出现间隔 [[间隔特性Space().png]]
[Space()]

// 修饰数值的滑条范围Range(参数, 参数) [[滑条范围Range.png]]
[Range(最大值, 最小值)]

//多行显示字符串Multiline(参数) 默认不写参数显示3行 [[多行显示字符串Multiline.png]]
[Multiline(参数)]

//滚动条字符串TextArea(参数, 参数) 默认不写参数就是超过3行显示滚动条[[滚动条字符串TextArea.png]]
[TextArea(最小值,最大值)]

//为变量添加快捷方法ContextMenuItem 方法一定是无参无返回值的 [[添加快捷方法ContextMenuItem.png]]
[ContextMenuItem("显示按钮名", "方法名")]

//为方法添加特性能够在Inspector中执行 ContextMenu [[方法能在Inspector中执行 ContextMenu.png]]
[ContextMenu("字符串")]
```

---

## 原理

> Unity 通过反射得到脚本字段信息，在 Inspector 窗口显示。
> Unity 内部通过反射得到字段的特性，当具有一些特殊特性时，便会做特定处理。

---

## 注意事项

- **拖拽脚本到 GameObject 后，再改变脚本中变量的默认值，Inspector 面板上不会自动更新**（已序列化的值不会跟着代码改变）
- 如果想更新，需要手动在 Inspector 中修改，或者在 Reset 组件 可以拷贝 => 粘贴值 实现修改

| 图示  | [[Copy Compone.png]] | [[Paste Compone.png]] |
| --- | ----------------------------------- | ----------------------------------- |

---

## 练习

> 1. 如何让公共成员不在 Inspector 面板上设置？如何让私有或保护成员可以在 Inspector 面板上设置？

```csharp
// ① 公共成员隐藏：加上 [HideInInspector] 特性
[HideInInspector]
public int hiddenValue;

// ② 私有成员显示：加上 [SerializeField] 特性
[SerializeField]
private int visibleValue;
```

> 2. 为什么加不同的特性，在 Inspector 窗口上会有不同的效果？

```csharp
//特性（Attribute）附加了额外的元数据。
//Unity 通过反射得到字段信息，然后在 Inspector 窗口显示字段。
//Unity 内部通过反射得到字段的特性，当具有一些特殊特性时，便会做特定处理：
[HideInInspector] //→ 隐藏该公共字段
[SerializeField]  //→ 序列化该私有字段，使其显示
```

---

## 我的踩坑记录

-

---

*最后更新：*
