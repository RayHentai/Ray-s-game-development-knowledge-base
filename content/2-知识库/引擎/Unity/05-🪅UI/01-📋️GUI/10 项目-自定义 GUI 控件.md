# 项目：GUI封装与预设体

**所属阶段**：[[00 GUI 总览]]
**综合知识点**：[[19 多态与virtual override]] | [[20 抽象类与抽象方法]] | [[]]
**完成状态**：🔄 进行中 / ✅ 已完成
**查阅次数**：0

---

## 补充知识点

>编辑模式下让指定代码运行

***关联知识点：*** [[21 特性]] 

```csharp
[ExecuteAlways]
class Test {}
```

---

## 需求分析

> 用自己的话描述要做什么，不要只抄题目，要写出自己的理解

- 让GUI的控件实现自适应分辨率
- 制作常用控件的预设体，封装显示控件的方法，实现即拖即用

---

## 功能拆解

> 把整个项目拆成独立的功能模块，每个功能是一个可以单独实现的单元

- 功能一：通过一个脚本控制所有控件的显示
- 功能二：控件支持 在面板修改 普通/自定义
- 功能三：自适应分辨率
- 功能四：常用控件的显示
- 功能五：控件脚本提供一个监听事件

---

## 架构设计

> 框架先行：先列出来怎么拆分，再填实现细节

```
项目结构：
├── 控件总控
│   ├── 总控类
│   └── 控件基类
├── 核心逻辑
│   └── 控件位置计算
└── 控件类
    ├── 常用控件显隐
    └── 事件监听
```

---

## UML类图

![[GUI小项目类图.png]]

---

## 核心设计思路/理论分析

> 用伪代码或文字描述最关键的逻辑，写代码之前先想清楚

**关键逻辑**：九宫格

- 九宫格就是将屏幕分成9个部分**上**、**下**、**左**、**右**、**中**、**左上**、**右上**、**左下**、**右下**
- 每一个部分都有一个**相对UI屏幕原点的原点**—是通过屏幕宽**w**和高**h**计算出来的
- **计算公式**：`转换后的控件坐标` = `相对屏幕位置` + `控件偏移位置` + `偏移位置`

```csharp
//屏幕中心的居中对齐控件坐标
Vector2.x = Screen.w / 2 + -cw / 2 + cpos.x
Vector2.y = Screen.h / 2 + -ch / 2 + cpos.y

//[[九宫格图示.png]]
//[[控件九宫格图示.png]]
```

---

## 项目完整工程

### 基类脚本

#### 控件总控类

```csharp
//通过一个父对象 统一管理所有的硬件
//编辑模式可运行特性
[ExecuteAlways]
public class CustomGUIRoot : MonoBehaviour
{
    private CustomGUIControl[] allControls;
    void Start()
    {
        allControls = GetComponentsInChildren<CustomGUIControl>();
    }
    private void OnGUI()
    {
        //优化 ： 只有在编辑状态下才会一直执行
        if (!Application.isPlayer) 
        {
            //得到子对象挂载的所有脚本
            //这句代码浪费性能 因为每次 GUI都会来获取所有的 控件对应脚本
            allControls = GetComponentsInChildren<CustomGUIControl>();
        }
        //遍历每一个控件 让其绘制
        for (int i = 0; i < allControls.Length; i++) 
        {
            allControls[i].DrawGUI();
        }
    }
}

```

^725ef5

#### 控件基类

```csharp
//自定义样式开关
public enum E_StyleOnOff
{
    on, 
    off,
}
//改为抽象函数
public abstract class CustomGUIControl : MonoBehaviour
{
    //提取GUI的共同表现
    //位置
    public CustomGUIPos guiPos;
    //内容信息
    public GUIContent content;
    //自定义样式
    public GUIStyle style;
    //自定义样式是否启用开关 默认关闭
    public E_StyleOnOff styleOnOff = E_StyleOnOff.off;

    //自定义样式开关执行不同逻辑
    //提供给外部绘制GUI的方法
    public void DrawGUI()
    {
        switch (styleOnOff)
        {
            case E_StyleOnOff.on:
                StyleOnDraw();
                break;
            case E_StyleOnOff.off:
                StyleOffDraw();
                break;
        }
    }
    //虚函数 子类可以重写规则
    //改为抽象方法
    protected abstract void StyleOnDraw();

    protected abstract void StyleOffDraw();

}

```

#### 位置基类（核心）

```csharp
//对齐方式枚举
public enum E_AlignmentType
{
    up,
    down,
    left,
    right,
    center,
    left_up,
    left_dowm,
    right_up,
    right_dowm,
}
//该类是用来表示位置 计算位置相关信息的 不需要继承mono
//特性 可以显示自定义类
[System.Serializable]
public class CustomGUIPos
{
    //用于返回给外部 用于空间绘制
    //需要用它进行计算
    private Rect rPos = new Rect(0, 0, 100, 100);

    //屏幕对齐方式
    public E_AlignmentType screenAlignmentType = E_AlignmentType.center;
    //控件对齐方式
    public E_AlignmentType controlCenterAlignmentType = E_AlignmentType.center;
    //偏移位置
    public Vector2 pos;
    //宽高
    public float width = 100;
    public float height = 50;

    //用于计算中心点的 成员变量
    private Vector2 centerPos;
    //计算中心点偏移位置
    //外部计算时 加上结果 就可以让控件的原点(0,0) 变成控件对应方向的中心点
    private void CalcCenterPos()
    {
        switch (controlCenterAlignmentType)
        {
            case E_AlignmentType.up:
                centerPos.x = -width / 2;
                centerPos.y = 0;
                break;
            case E_AlignmentType.down:
                centerPos.x = -width / 2;
                centerPos.y = -height;
                break;
            case E_AlignmentType.left:
                centerPos.x = 0;
                centerPos.y = -height / 2;
                break;
            case E_AlignmentType.right:
                centerPos.x = -width;
                centerPos.y = -height / 2;
                break;
            case E_AlignmentType.center:
                centerPos.x = -width / 2;
                centerPos.y = -height / 2;
                break;
            case E_AlignmentType.left_up:
                centerPos.x = 0;
                centerPos.y = 0;
                break;
            case E_AlignmentType.left_dowm:
                centerPos.x = 0;
                centerPos.y = -height;
                break;
            case E_AlignmentType.right_up:
                centerPos.x = -width;
                centerPos.y = 0;
                break;
            case E_AlignmentType.right_dowm:
                centerPos.x = -width;
                centerPos.y = -height;
                break;
        }
    }
    //计算控件的真实位置
    //相对屏幕位置 + 控件中心点偏移位置 + 偏移位置
    private void CalcPos()
    {
        switch (screenAlignmentType)
        {
            case E_AlignmentType.up:
                rPos.x = Screen.width / 2 + centerPos.x + pos.x;
                rPos.y = centerPos.y + pos.y;
                break;
            case E_AlignmentType.down:
                rPos.x = Screen.width / 2 + centerPos.x + pos.x;
                //因为位置坐标轴往下是正方向 所以pos.y为正数就会往下移动 想让它往上动 反转就行了
                rPos.y = Screen.height + centerPos.y - pos.y;
                break;
            case E_AlignmentType.left:
                rPos.x = centerPos.x + pos.x;
                rPos.y = Screen.height / 2 + centerPos.y + pos.y;
                break;
            case E_AlignmentType.right:
                rPos.x = Screen.width + centerPos.x - pos.x;
                rPos.y = Screen.height / 2 + centerPos.y + pos.y;
                break;
            case E_AlignmentType.center:
                rPos.x = Screen.width / 2 + centerPos.x + pos.x;
                rPos.y = Screen.height / 2 + centerPos.y + pos.y;
                break;
            case E_AlignmentType.left_up:
                rPos.x = centerPos.x + pos.x;
                rPos.y = centerPos.y + pos.y;
                break;
            case E_AlignmentType.left_dowm:
                rPos.x = centerPos.x + pos.x;
                rPos.y = Screen.height + centerPos.y + pos.y;
                break;
            case E_AlignmentType.right_up:
                rPos.x = Screen.width + centerPos.x - pos.x;
                rPos.y = centerPos.y + pos.y;
                break;
            case E_AlignmentType.right_dowm:
                rPos.x = Screen.width + centerPos.x - pos.x;
                rPos.y = Screen.height + centerPos.y - pos.y;
                break;
        }
    }
    //得到真实位置 需要进行计算
    public Rect Pos
    {
        get
        {
            //宽高等于设置的宽高
            rPos.width = width;
            rPos.height = height;
            CalcCenterPos();
            CalcPos();
            return rPos;
        }
    }
}

```

### 常用控件脚本

```csharp
//按钮
public class CustomGUIButton : CustomGUIControl
{
    //因为按钮按下会执行操作 所以这里声明一个事件 用于监听
    public event UnityAction clickEvent;
    protected override void StyleOffDraw()
    {
        if (GUI.Button(guiPos.Pos, content))
        {
            //为空不执行 不为空执行监听逻辑
            clickEvent?.Invoke();
        }
    }

    protected override void StyleOnDraw()
    {
        if (GUI.Button(guiPos.Pos, content, style))
        {
            clickEvent?.Invoke();
        }
    }
}

//输入框
public class CustomGUIInput : CustomGUIControl
{
    public event UnityAction<string> textChange;
    private string oldStr = "";
    protected override void StyleOffDraw()
    {
        content.text = GUI.TextField(guiPos.Pos, content.text);
        if (oldStr != content.text)
        {
            textChange?.Invoke(oldStr);
            oldStr = content.text;
        }
    }

    protected override void StyleOnDraw()
    {
        content.text = GUI.TextField(guiPos.Pos, content.text, style);
        if (oldStr != content.text)
        {
            textChange?.Invoke(oldStr);
            oldStr = content.text;
        }
    }
}

//文本
public class CustomGUILabel : CustomGUIControl
{
    protected override void StyleOffDraw()
    {
        GUI.Label(guiPos.Pos, content);
    }
    protected override void StyleOnDraw()
    {
        GUI.Label(guiPos.Pos, content, style);
    }
}

//单选框
public class CustomGUIToggle : CustomGUIControl
{
    public bool isSel;
    private bool isOldSel;
    //监听事件 用于响应 按钮点击的事件 [[13 事件]]
    public event UnityAction<bool> changeValue;
    
    protected override void StyleOffDraw()
    {
        isSel = GUI.Toggle(guiPos.Pos, isSel, content);
        //优化 只有变化了 才告诉外部执行函数 否则 没有必要一直告诉别人同一个值
        //避免一直执行事件 只有改变的时候才会执行
        if (isOldSel != isSel)
        {
            //执行当前bool值对应的逻辑
            changeValue?.Invoke(isSel);
            //上一个bool值等于当前bool值
            isOldSel = isSel;
        }
    }
    protected override void StyleOnDraw()
    {
        isSel = GUI.Toggle(guiPos.Pos, isSel, content, style);
        if (isOldSel != isSel)
        {
            changeValue?.Invoke(isSel);
            isOldSel = isSel;
        }
    }
}

//多选框 配合单选框使用
public class CustomGUIToggleGroup : MonoBehaviour
{
    public CustomGUIToggle[] toggles;
    private CustomGUIToggle frontTurTog;
    
    private void Start()
    {
        //toggles为空不处理
        if (toggles.Length == 0)
            return;
        for (int i = 0; i < toggles.Length; i++) 
        {
            //记录当前toggle 
            CustomGUIToggle toggle = toggles[i];
            //监听 value即为当前bool值
            toggle.changeValue += (value) => 
            {
                //如果为true 关闭其他的
                if (value) 
                {
                    for (int j = 0; j < toggles.Length; j++)
                    {
                        //这里完成了闭包 
                        if (toggle != toggles[j]) 
                        {
                            //强行设置为false
                            toggles[j].isSel = false;
                        }
                        //记录上一次为true的tog
                        frontTurTog = toggle;
                    }
                }
                //如果点击true的选项 就不能让它关闭 至少得保持一个true
                else if (frontTurTog == toggle)
                {
                    //强行让它为true
                    toggle.isSel = true;
                }
            };
        }
    }
}

//拖动条
public enum E_SliderType
{
    horizontal,
    vertical,
}
public class CustomGUISlider : CustomGUIControl
{
    //最小值、最大值、当前值
    public float minValue = 0;
    public float maxValue = 1;
    public float nowValue = 0;
    private float oldValue;
    //当前类型、水平、竖直
    public E_SliderType type = E_SliderType.horizontal;
    //Slider独有的style
    public GUIStyle StyleThumb;
    public event UnityAction<float> changeValue;
    
    protected override void StyleOffDraw()
    {
	    switch (type)
	    {
		    base E_SliderType.horizontal:
		    nowValue = GUI.HorizontalSlider(guiPos.Pos, nowValue, minValue, maxValue);
			    break;
			base E_SliderType.vertical:
			nowValue = GUI.VerticalSlider(guiPos.Pos, nowValue, minValue, maxValue);
				break;
	    }
        
        if (oldValue != nowValue)
        {
            changeValue?.Invoke(nowValue);
            oldValue = nowValue;
        }
    }
    protected override void StyleOnDraw()
    {
	    switch (type)
	    {
		    base E_SliderType.horizontal:
		    nowValue = GUI.HorizontalSlider(guiPos.Pos, nowValue, minValue, maxValue, style, StyleThumb);
			    break;
			base E_SliderType.vertical:
			nowValue = GUI.VerticalSlider(guiPos.Pos, nowValue, minValue, maxValue, style, StyleThumb);
				break;
	    }
        if (oldValue != nowValue)
        {
            changeValue?.Invoke(nowValue);
            oldValue = nowValue;
        }
    }
}

//图片
public class CustomGUITexture : CustomGUIControl
{
    //缩放模式
    public ScaleMode ScaleMode = ScaleMode.StretchToFill;
    protected override void StyleOffDraw()
    {
        GUI.DrawTexture(guiPos.Pos, content.image, ScaleMode);
    }
    protected override void StyleOnDraw()
    {
        GUI.DrawTexture(guiPos.Pos, content.image, ScaleMode);
    }
}
```
---

## 遇到的问题 & 解决方案

| 问题描述            | 原因分析 | 解决方案 |
| --------------- | ---- | ---- |
| 事件监听的逻辑不会写      |      |      |
| 写代码不连贯，不知道下一步干嘛 |      |      |
|                 |      |      |

---

## 完成后的感悟

> 做这个项目学到了什么新东西？有没有对某个知识点有了新的理解？

**新学到的东西**：

**对某个知识点的新理解**：

**下次可以改进的地方**：

---

## 扩展想法

> 如果要继续优化这个项目，可以做哪些功能？

- 加入其他控件类型，只需要写控件显示脚本就行

---

**完成时间**：26/4/10
**耗时**：2.5h
