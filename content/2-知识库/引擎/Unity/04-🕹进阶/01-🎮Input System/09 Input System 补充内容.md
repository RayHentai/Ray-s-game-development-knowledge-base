# 09 Input System 补充内容

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 获取任意键输入的方法

```csharp
public InputAction input;
//1.键盘任意键按下 无法获取具体的键
input.Enable();
input.performed += (context) =>
{
    print("123");
    print(context.control.name);// anyKey
    print(context.control.path);// /Keyboard/anyKey
};
//2.键盘任意键按下字符 无法获取特殊按键 Enter、Space等
Keyboard.current.onTextInput += (c) =>
{
    print(c);//打印按下的字符
};

//3.InputSystem中专门于任意键按下的方案
//如果用Call 按键盘会报错 但是也能正常执行
//用CallOnce 只会执行一次 但是不会报错
InputSystem.onAnyButtonPress.CallOnce((control) =>
{
    print(control.path);
    print(control.name);
});
```

---

## 通过Json数据加载配置文件

Player Input中 绑定的输入配置文件是通过Json配置的，一定会存在一个数据结构类
这个数据结构类就是 PlayerInput类 下的 InputActionAsses 类

```csharp
public PlayerInput input;
string json = Resources.Load<TextAsset>("PlayerInputTest").text;
InputActionAsset asset = InputActionAsset.FromJson(json);
input.actions = asset;
input.onActionTriggered += (context) =>
{
    if(context.phase == InputActionPhase.Performed)
    {
        switch (context.action.name)
        {
            case "Move":
                print("移动");
                break;
            case "Look":
                print("看向");
                break;
            case "Fire":
                print("开火");
                break;
        }
    }
};
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
