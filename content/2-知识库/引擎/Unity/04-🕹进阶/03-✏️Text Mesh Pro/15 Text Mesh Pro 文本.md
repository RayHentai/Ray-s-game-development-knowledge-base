# 15 Text Mesh Pro 文本

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[05 UI事件监听接口]] | [[]]
**查阅次数**：0

---

## UI文本

---

### 创建

在层级窗口中右键UI中可以直接找到TMP文本控件并创建
它本身和老的Text控件很像，都是用来显示文本的控件

---

### 窗口参数

![[Text Mesh Pro Text(UI) 参数.png]]

---

### 代码控制

1. 需要引用TMP命名空间 TMPPro
2. TMP UI组件名为 TextMeshProUGUI

**更多API可以看官方手册查询**
[docs.unity3d.com/Packages/com.unity.textmeshpro@4.0/api/TMPro.TextMeshProUGUI.html](https://docs.unity3d.com/Packages/com.unity.textmeshpro@4.0/api/TMPro.TextMeshProUGUI.html)

```csharp
TextMeshProUGUI 
//常用属性
//1 文本内容 text
tmpUIText.text = "123123adfasdklf545454564654654646454564654132156465424";

//2 字体 font
tmpUIText.font

//3.字体大小 fontsize
tmpUIText.fontsize = 10;

//4 颜色 color
tmpUIText.color = Color.black;

//5 对齐方式 alignment
tmpUIText.alignment = TextAlignmentoptions .Center;

//6 行间距 Linespacing
tmpuIText.lineSpacing = 50;

//7 是否启用富文本 richText
tmpUIText.richText = false;

//常用方法
//1 设置文本内容，支持富文本格式
SetText("<color=blue>Hello, World!</color>");
tmpUIText.SetText("123123123123123");

//2 强制重新构建文本网格，通常在文本內容或样式更改后使用
// Prelayout 布局前调用
// Layout 布局时调用
// PostLayout 布局后调用
// PreRender 渲染前调用
// LatePreRender 渲染后调用
// MaxUpdateVaLue 最后调用
tmpUIText.Rebuild(UnityEngine.UI.CanvasUpdate.Prelayout);

//3 强制更新文本网格，运行时动态更改文本时
tmpUIText.ForceMeshUpdate();

//4 获取文本中字符数
tmpUIText.text.Length
```

### 事件监听

通过添加Event Trigger组件后,选择对应要监听的事件,并提供相应的函数即可

![[05 UI事件监听接口#^892daa]]

![[05 UI事件监听接口#^021c2f]]

---

## 3D文本

3D文本控件和UI文本控件差不多
只是它是可以当成是一个被渲染显示在场景上的3D物体
而不是一个UI

**可以在层级视图中右键后在3D Object 中找到并创建出来**

**3D文本和UI文本的区别**

| 区别项  | UI文本                         | 3D文本                |
| ---- | ---------------------------- | ------------------- |
| 组件   | TextMeshProUGUI              | TextMeshPro         |
| 用途   | 主要用于在UI中显示文字，具备UI相关的一些属性     | 主要用于在3D场景中显示文字      |
| 渲染方式 | 通过UGUI的CanVas系统渲染            | 直接渲染在场景上            |
| 交互方式 | 一般利用Ul系统的交互规则，比如EventTrigger | 一般通关添加碰撞器进行碰撞检测判断交互 |

**如何选择?**
- 文本需要与3D场景交互需要在3D场景上显示，选择3D文本 TextMeshPro，就把他当成3D物体处理即可
- 文本需要在UI系统中使用，选择 TextMeshProUGUI，把它当成UI组件使用即可


**参数和脚本控制与U文本控件差不多，具体可以去官方使用文档查看**
[Class TextMeshPro | TextMeshPro | 4.0.0-pre.2](https://docs.unity3d.com/Packages/com.unity.textmeshpro@4.0/api/TMPro.TextMeshPro.html)

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
