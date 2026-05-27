# 12 Nav Mesh 导航寻路系统

**所属模块**：[[00 Unity 核心阶段总览]]
**关联**：[[11 Character Controller 角色控制器]] | [[12 委托]]
**查阅次数**：0

---

## 核心理解

>Unity中的导航寻路系统是能够游戏世界当中，让角色能够从一个起点准确的到达另一个终点，并且能够自动避开两个点之间的障碍物选择最近最合理的路径进行前往

Unity中的导航寻路系统的本质，就是在A星寻路算法的基础上进行了拓展和优化

---

## 导航网格生成 NavMesh

> 导航网格（NavMesh）的生成一要想角色能够在场景中自动寻路产生行进路径，那么必须得先有场景地形数据，导航网格生成就是生成用于寻路地地形数据

**准备地形**
在进行导航寻路网格生成时，第一步是需要有地形地形，由美术同学制作模型

**打开导航网格窗口**
Window -> Package Manager -> AI Navigation
Window -> AI -> Navigation(Obsolete)

**参数**
1. 对象页签
   ![[对象页签.png]]

2. 导航数据烘焙页签
   ![[导航数据烘焙页签.png]]

3. 导航地区页签
   ![[导航地区页签.png]]

4. 代理页签
   和对象页签基本一致，用于配置寻路代理信息 

---

## 导航网格寻路组件 Nav Mesh Agent

>寻路组件的作用就是让角色可以在地形上准确的移动起来
>寻路组件的本质就是根据烘焙出的寻路网格信息
>通过基于A星寻路的算法计算出行进路径让我们在该路径上移动起来

**窗口参数**
![[Nav Mesh Agent.png]]


**代码**

```csharp
using UnityEngine.AI;
private NavMeshAgent agent;
agent = GetComponent<NavMeshAgent>();
//常用
//1 设置目标点
agent.SetDestination(position);
//2 停止、开始寻路
agent.isStopped = true;
agent.isStopped = false;

//不常用
//1 面板参数相关 速度 加速度 旋转速度等等
agent.speed
agent.acceleration
agent.angularSpeed

//2 其他重要属性
// 2.1 当前是否有路径
if (agent.hasPath)
// 2.2 代理目标点 可以设置 可以得到
agent.destination
// 2.3 是否停止
agent.isStopped
// 2.4 当前路径 相关信息
agent.path
// 2.5 路径是否还在计算中
if (agent.pathPending)
// 2.6 路径状态
agent.pathStatus
// 2.7 是否更新位置
agent.updatePosition = true;
// 2.8 是否更新角度
agent.updateRotation = true;
// 2.9 代理速度
agent.velocity

//方法
//手动寻路
//1 计算生成路径
NavMeshPath path = null;
agent.CalculatePath(目标位置, 信息)
if (agent.CalculatePath(Vector3.zero, path))
//2 设置新路径
if (agent.SetPath(path))
//3 清除路径
agent.ResetPath();
//4 调整到指定点位置
agent.Warp(位置);
```

### 练习

> 1. 自己拼凑一个场景并进行网格烘焙，加入一个角色，可以通过鼠标右键点击控制场景上角色的移动，要切换动画

```csharp
public class NavMeshAgent_Move : MonoBehaviour
{
    private NavMeshAgent agent;
    private Animator animator;
    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        animator = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            RaycastHit hit;
            if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit)) 
            {
                agent.SetDestination(hit.point);
            }
        }
        if (agent.velocity == Vector3.zero)
            animator.SetInteger("Speed", 0);
        else
            animator.SetInteger("Speed", 1);
    }
}
```

---

## 网格外连接组件 Off Mesh Link

>如果我们只希望两个未连接的平面之间只有有限条连接路径可以跳跃过去
>并且运行时可以动态添加，就可以使用网格外连接组件，达到“指哪打哪”的效果

**窗口参数**
![[OffMeshLink.png]]

**使用：**
1. 使用两个对象作为两个平面之间的连接点 （起点和终点）
2. 添加offMeshLink脚本进行关联
3. 设置参数


---

## 导航网格动态障碍物组件 Nav Mesh Obstacle

>导航网格动态障碍物组件（NavMeshObstacle）：地形中可能存在的可以移动或动态销毁的障碍物需要挂载的组件

**在游戏中常常会有这样的一个功能**
- 场景中有一道门，如果这道门没有被破坏是不能自动导航到门后场景的
- 只有当这道门被破坏了，才可以通过此处前往下一场景，
- 而类似这样的物体本身是不需要进行寻路的
- 所以没有必要为它添加NavMeshAgent脚本，这时就会使用动态障碍组件实现该功能

**窗口参数**
![[NavMeshObstacle.png]]

**注意：如果不勾选雕刻功能，玩家的路径被障碍物挡住会一直尝试移动，勾选就不会**

**使用：**
1. 为需要进行动态阻挡的对象添加NavMeshobstacle组件
2. 设置相关参数
3. 代码逻辑控制其的移动或者显隐


### 练习

> 1. 在上一个练习题的基础上，在场景上加入一个阻碍玩家前进的动态障碍物，玩家摧毁它才可以前往下一个区域

```csharp
public class NavMeshObstacle_Move : MonoBehaviour
{
    private NavMeshAgent agent;
    private Animator animator;
    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        animator = GetComponent<Animator>();
    }
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            RaycastHit hit;
            if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit))
                agent.SetDestination(hit.point);
        }
        if (Input.GetMouseButtonDown(1)) 
        {
            RaycastHit hit;
            if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 1 << LayerMask.NameToLayer("Cube") ))
                hit.collider.gameObject.SetActive(false);
        }
        if (agent.velocity == Vector3.zero)
            animator.SetInteger("Speed", 0);
        else
            animator.SetInteger("Speed", 1);
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
