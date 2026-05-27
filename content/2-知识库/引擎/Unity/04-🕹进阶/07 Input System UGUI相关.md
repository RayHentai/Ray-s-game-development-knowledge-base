# 07 Input System UGUI相关

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[01 六大基础组件]] | [[]]
**查阅次数**：0

---

## Input System 对 UI的支持

- 新输入系统InputSystem不支持IMGUI（GUI）注意：编辑器代码不受影响
	- 如果当前激活的是InputSystem，那么OnGUI中的输入判断相关内容不会被触发
	- 你必须要选择Both或者只激活老输入系统InputManager才能让OnGUI中内容有用

- 新输入系统支持UGUI，但是需要使用新输入系统输入模块（Input System UI Input Module）

**启用新输入系统**
EventSystem 对象 -> 点击 Replace with InputSystemUllnputModule -> 转换新输入系统

---

## 窗口参数

**注意：一般情况下无需自己修改**

![[Input System UGUI 新输入系统参数.png]]

---

## 其他注意事项

---

### VR

如果想在VR项目中使用新输入系统配合UGUI使用
需要在Canvas对象上添加Tracked Device Raycaster组件

---

### 多人游戏使用多套UI

如果同一设备上的多人游戏，每个人想要使用自己的一套独立UI
**需要将Event System中的Event System组件替换为Multiplayer Event System组件**

与EventSystem组件不同，可以在场景中同时激活多个 MultiplayerEventSystem。
这样，可以有多个玩家，每个玩家都有自己的 InputSystemUIInputModule和MultiplayerEventSystem组件
每个玩家都可以有自己的一组操作来驱动自己的UI实例

**如果正在使用Player Input组件，还可以设置Player Input以自动配置玩家的InputSystemUIInputModule以使用玩家的操作**

MultilayerEventSystem组件的属性与事件系统中的属性相同

此外，MultiplayerEventSystem组件还添加了一个playerRoot属性，您可以将其设置为一个游戏对象
该游戏对象包含此事件系统应在其层次结构中处理的所有UI可选择项

---

### 更多内容

**可查看官方文档了解更多新输入系统和UI配合使用的相关内容**
https://docs.unity3d.com/Packages/com.unity.inputsystem@1.2/manual/UISupport.html

---

## On-Screen组件

**On-Screen可以模拟UI和用户操作的交互**
1. On-Screen Button：按钮交互
2. On-Screen Stick：摇杆交互

只需要在控件中添加对应脚本，绑定好按键，就可以模拟对应按键输入
比如：给按钮添加 On-Screen Button 脚本，绑定 Keyboard W，点击按钮，就相当于按了键盘的 W

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
