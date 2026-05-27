# 07 Animator Controller 状态机动画系统

**所属模块**：[[00 Unity 核心阶段总览]]
**关联**：[[06 Animation 老动画系统]] | [[08 2D 动画]] | [[10 3D 动画]]
**查阅次数**：0

---

## 有限状态机

>有限状态机(Finite- state machine，FSM)，又称有限状态自动机，简称状态机
>是表示有限个状态以及在这些状态之间的转移和动作等行为的数学模型

**有限：** 表示有限度的不是无限的
**状态：** 指所拥有的所有状态

**举例说明：**
- 假设我们人会做很多个动作，也就是有很多种状态
- 这些状态包括站立、走路、跑步、攻击、防守、睡觉等等
- 我们每天都会在这些状态中切换，而且这些状态虽然多但是是有限的
- 当达到某种条件时，我们就会在这些状态中进行切换，而且这种切换时随时可能发生的

**有限状态机的意义**
- 游戏开发中有很多功能系统都是有限状态机
- 最典型的状态机系统
- 动作系统一当满足某个条件切换一个动作，且动作是有限的
- AI（人工智能）系统一当满足某个条件切换一个状态，且状态时有限的

**所以状态机是游戏开发中一个必不可少的概念**

**最简单的有限状态机实现**

```csharp
//假设有一个值控制当前玩家状态
string animName = "idle"
switch (animName)
{
	case "idle"
		//待机动作逻辑
		break;
	case "move"
		//移动动作逻辑
		break;
	case "run"
		//跑步动作逻辑
		break;
	case "atk"
		//攻击动作逻辑
		break;
}
```

---

### Animator Controller

**创建：**
1. 通过为场景中物体创建动画时自动创建
2. 手动创建动画状态机文件

**窗口参数：**
![[Animator Controller.png]]
**注意：权重才是影响动画层级的**

**添加动画：**
1. 自动添加一为对象创建动画后会自动将动画添加到状态机中
2. 手动添加1一将动画文件拖入到状态机中（注意：老动画拖入会有警告）
3. 手动添加2一右键创建状态，再关联动画

**添加切换连线：**
右键矩形 -> Make Transition -> 选择要连接到的矩形

**添加切换条件：**
- 在左侧面板点击参数页签，可以在这里添加4中类型的切换条件
- 在 Inspector 下 Conditions 添加条件 （多个条件 && 判断）

**Animator窗口参数**
![[Animator.png]]

**代码控制状态机切换：**
- 用代码控制状态机切换主要使用的就是Animator提供的API
- —共有四种切换条件int float bool trigger，所以对应的API也是和这四种类型有关系的
- Has Exit Time 取消勾选 可以马上切换动作

```csharp
private Animator = animator;
animator = GetCompenont<Animator>();
//1 通过状态机条件切换动画
//设置条件值
animator.SetFloat("条件名", 1.2f);
animator.SetInteger("条件名", 5);
animator.SetBool("条件名", true);
animator.SetTrigger("条件名");
//获取条件值
animator.GetFloat("条件名");
animator.GetInteger("条件名");
animator.GetBool("条件名");
animator.GetTrigger("条件名");

//2 直接切换动画 除非特殊情况不然一般不使用
animator.Play("状态名");

runtimeAnimatorController//Animator中的状态机
```

---

## 状态机行为脚本

>状态机行为脚本时一类特殊的脚本，继承指定的基类
>它主要用于关联到状态机中的状态矩形上，可以按照一定规则编写脚本
>当进入、退出、保持在某一个特定状态时我们可以进行一些逻辑处理

简单解释就是为AnimatorController状态机窗口中的某个状态添加个脚本

**利用这个脚本我们可以做一些特殊功能，比如**
1. 进入或退出某一状态时播放声音
2. 仅在某些状态下检测一些逻辑，比如是否接触地面等等
3. 激活和控制某些状态相关的特效

---

### 使用

**注意：**
- 状态机行为脚本相对动画事件来说更准确
- 但是使用起来稍微麻烦一些
- 根据实际需求选择使用

```csharp
//1.新建一个脚本继承stateMachineBehaviour基类
//2.实现其中的特定方法进行状态行为监听
OnStateEnter 进入状态时，第一个Update中调用
OnStateExit 退出状态时，最后一个update中调用
OnStateIK OnAnimatorIk 后调用
OnStateMove OnAnimatorMove后调用
OnStateUpdate 除第一帧和最后一帧，每个Update上调用
OnStateMachineEnter 子状态机进入时调用，第一个update中调用
OnStateMachineExit 子状态机退出时调用，最后一个Update中调用
//3.处理对应逻辑
```

---

## 状态机复用

**游戏开发时经常遇到这样的情况**
- 有n个玩家和n个怪物，他们的动画状态机行为都是一致的，只是对应的动作不同而已
- 这时如果为他们每一个对象都创建一个状态机进行状态设置和过渡设置无疑是浪费时间的，所以状态机复用就是解决这一问题的方案

**主要用于为不同对象使用共同的状态机行为，减少工作量提升开发效率**

**复用状态机**
1. Project窗口右键 -> Create -> Animation Override Controller
2. 在Animation Override Controller窗口关联基础的 Animation Controller文件
3. 关联需要的动画


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

## 练习

> 1. 使用Animator相关知识，请自己用Unity自带几何体拼凑一个机器人，有手有脚为它制作两个动作，一个待机动作（站立不动），一个走路动作我们可以通过键盘控制它移动切换动作

```csharp
public class AnimationController_New : MonoBehaviour
{
    private Animator animator;
    void Start()
    {
        animator = GetComponent<Animator>();
    }
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.W))
            animator.SetBool("Change", true);
        else if (Input.GetKeyUp(KeyCode.W))
            animator.SetBool("Change", false);
        if (animator.GetBool("Change"))
            transform.Translate(Vector3.forward * 5 * Time.deltaTime);
    }
}
```

---

## API 速查

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
