# 04 Sprite 精灵图片

**所属模块**：[[00 Unity 核心阶段总览]]
**关联**：[[02 图片设置]] | [[05 Tilemap 瓦片地图]]
**查阅次数**：0

---

## Sprite Editor

> SpriteEditor就是精灵图编辑器，它主要用于编辑2D游戏开发中使用的sprite精灵图片，它可以用于编辑图集中提取元素，设置精灵边框，设置九宫格，设置轴心（中心）点等等功能

**安装2D Sprite包（3D工程）**
Window -> Package Manager -> 搜索2D -> 2D Sprite -> 安装

---

### 功能 和 参数

single图编辑主要讲解的就是在设置图时，将精灵图模式（SprteMode）设置为single的精灵图在SpriteEditor窗口中如何编辑

**1.Sprite Editor**
基础图片设置 （右下角窗口）
主要用于设置单张图片的基础属性
![[Sprite Editor.png]]

**2.Custom Outline（决定渲染区域）**
自定义边缘线设置，可以自定义精灵网格的轮廓形状
默认情况下不修改都是在矩形网格上渲染，边缘外部透明区域会被渲染，浪费性能使用自定义轮廓，可以调小透明区域，提高性能
![[Custom Outline.png|601]]

**3.Custom Physics Shape(决定碰撞判断区域)**
自定义精灵图片的物理形状，主要用于设置需要物理碰撞判断的2D图形它决定了之后产生碰撞检测的区域
和上面一致

**4.Secondary Textures(为图添加特殊效果）**
次要纹理设置，可以将其它纹理和该精灵图片关联
着色器可以得到这些辅助纹理然后用于做一些效果处理，让精灵应用其它效果

---

### Multiple 图集元素分割

> 当我们的图片资源是图集时，我们需要在设置时将模式设置为Multiple，这时我们可以使用SpriteEditor自带的功能进行图集元素分割

![[Automatic.png]]
![[Grid By Cell Size.png]]
![[Grid By Cell Count.png]]
![[Trim.png]]

---

### Polygon 多边形编辑

>如果我们使用的资源时多边形资源，我们可以在设置时将模式设置为Polygon，然后可以在Sprite Editor中进行快捷设置
>但是一般这种模式在实际开发中使用较少


![[Sprite Polygon Mode Editor.png]]

---

## Sprite Renderer

> SpriteRenderer是精灵渲染器，所有2D游戏中游戏资源（除UI外）都是通过SpriteRenderer让我们看到的，它是2D游戏开发中的一个极为重要的组件

**2D对象的创建：图片类型转为Sprite后**
- 直接拖入
- 右键创建
- 空物体添加脚本

---

### 参数

![[Sprite Renderer.png]]
![[Draw Mode.png]]
![[Mask Interaction.png]]

---

### 代码设置

```csharp
GameObject obj = new GameObject();
SpriteRenderer sr = obj.AddComponent<SpriteRenderer>();
//动态改变图片
sr.sprite = Resources.Load<sprite>("路径/文件名");
//动态添加图集中的图
Sprite[] sprs = Resources.LoadAll<sprite>("路径/图集文件名");
sr.sprite = sprs[10];
```

---

### 练习

> 1. 写一个工具类，让我们可以更加方便的加载Multiple类型的图集资源

```csharp
public class Sprite_Multiple
{
    private static Sprite_Multiple instance = new Sprite_Multiple();
    public static Sprite_Multiple Instance => instance;
    private Dictionary<string, Dictionary<string, Sprite>> dic = new Dictionary<string, Dictionary<string, Sprite>>();

    public Sprite Load(string multipleName, string spriteName)
    {
        //有没有加载过大图
        if (dic.ContainsKey(multipleName))
        {
            //大图里面有没有小图
            if (dic[multipleName].ContainsKey(spriteName))
                return dic[multipleName][spriteName];
        }
        else
        {
            //获取所有小图
            Dictionary<string, Sprite> tempDic = new Dictionary<string, Sprite>();
            Sprite[] sprs = Resources.LoadAll<Sprite>(multipleName);
            for (int i = 0; i < sprs.Length; i++)
                tempDic.Add(sprs[i].name, sprs[i]);
            dic.Add(multipleName, tempDic);
            //如果找到对应的小图
            if (tempDic.ContainsKey(spriteName))
                return tempDic[spriteName];
        }
        return null;
    }
    public void Clear()
    {
        //清除数据
        dic.Clear();
        //卸载资源
        Resources.UnloadUnusedAssets();
    }
}
public class Sprite_Test : MonoBehaviour
{
    private void Start()
    {
        GameObject obj = new GameObject();
        SpriteRenderer spr =  obj.AddComponent<SpriteRenderer>();
        spr.sprite = Sprite_Multiple.Instance.Load("Test", "RobotBoyDeath09");
    }
}
```

> 2. 用提供的角色资源，制作一个通过wasd键控制其上下左右移动的功能

```csharp
public class Sprite_Move : MonoBehaviour
{
    private float h;
    private SpriteRenderer sr;

    private void Start()
    {
        sr = GetComponent<SpriteRenderer>();
    }
    void Update()
    {
        h = Input.GetAxis("Horizontal");
        transform.Translate(Vector3.right * 20 * h * Time.deltaTime);
        if (h < 0)
            sr.flipX = true;
        else if (h > 0)
            sr.flipX = false;

        transform.Translate(Vector3.up * 20 * Input.GetAxis("Vertical") * Time.deltaTime);
    }
}
```

---

## Sprite Creator

> Sprite Creator是精灵创造者
> 我们可以利用spriteEditor的多边形工具创造出各种多边形
> Unity也为我们提供了现成的一些多边形

它的主要作用是2D游戏的替代资源
在等待美术出资源时我们可以用他们作为替代品
有点类似unity提供的自带几何体

本质上就是创建了一个多边形资源的四边形，通过Sprite Editor设置对应的边

---

### 练习

> 1. 使用菱形替代资源，制作一个按空格键让角色发射菱形子弹的功能

```csharp
public class Sprite_Shoot : MonoBehaviour
{
    private float h;
    private SpriteRenderer sr;

    private void Start()
    {
        sr = GetComponent<SpriteRenderer>();
    }
    void Update()
    {
        h = Input.GetAxis("Horizontal");
        transform.Translate(Vector3.right * 20 * h * Time.deltaTime);
        if (h < 0)
            sr.flipX = true;
        else if (h > 0)
            sr.flipX = false;

        transform.Translate(Vector3.up * 20 * Input.GetAxis("Vertical") * Time.deltaTime);
        if (Input.GetKeyDown(KeyCode.Space))
        {
            GameObject obj = Instantiate(Resources.Load<GameObject>("Bullet"), transform.position + new Vector3(sr.flipX ? -0.3f : 0.3f, 0.4f, 0), transform.rotation);
            obj.GetComponent<Sprite_bullet>().ChangeDir(sr.flipX ? Vector3.left : Vector3.right);
        }
    }
}

public class Sprite_bullet : MonoBehaviour
{
    private Vector3 nowDir; 
    private void Start()
    {
        Destroy(gameObject, 3);
    }
    void Update()
    {
        transform.Translate(nowDir * 10 * Time.deltaTime);
    }
    public void ChangeDir(Vector3 dir)
    {
        nowDir = dir;
    }
}
```

---

## Sprite Mask

>SpriteMask是精灵遮罩的意思
>它的主要作用就是对精灵图片产生遮罩
>制作一些特殊的功能，比如只显示图片的一部分让玩家看到

**参数**
![[Sprite Mask.png]]

---

### 练习

> 1. 用提供的资源，制作一个类似放大镜的功能

![[精灵遮罩练习.png]]

给放大镜添加一个精灵遮罩
把大图的Mask Interaction 设置成 Visible Inside Mask
调整层级 小图1 大图2 放大镜3

---

## Sorting Group

>SortingGroup是排序分组的意思
>它的主要作用就是对多个精灵图片进行分组排序
>Unity会将同一个排序组中的精灵图片一起排序，就好像他们是单个游戏对象一样


**注意：**
1. 子排序组，先排子对象再按父对象和别人一起排（同层和同层比）
2. 多个加载排序分组组件的预设体之间通过修改排序索引号来决定前后顺序

---

## Sprite Atlas

**为什么要打图集？**
- 打图集的目的就是减少DrawCall提高性能
- 在2D游戏开发，以及UI开发中是会频繁使用的功能

**打开自带的打图集功能**
在工程设置面板中打开功能
Edit->Project Setting->Editor
![[精灵包装器.png]]

**创建图集和添加图片**
Create -> 2D -> Sprtie Atles
直接拖动图片文件，也可以直接拖入文件夹到 Objects for Packing

**观察DrawCall数量（判断是否打包成功）：**
拖入在图集中的图片到场景
如果启动之后 `Batches` 显示1 就说明打包成功
**注意：** 如果两张图片处于一个图集，在这两张图片中间层级穿插一个其他图集的图片，DrawCall会从1次变成3次
![[观察DrawCall.png]]

---

### 参数

**打图集面板参数**
![[主图集参数.png]]
![[变体类型的图集.png]]
![[图集 Default.png]]

---

### 代码控制

```csharp
GameObject obj = new GameObject();
SpriteRenderer sr = obj.AddComponent<SpriteRenerer>();
//加载图集资源
SpriteAtlas spriteAtlas = Resources.Load("图集名");
//加载图集中的一张小图
sr.sprite = spriteAtlas.GetSprite("图片名");
```

---

### 练习

> 1. 将我提供给大家的资源制作成图集，并且通过代码加载图集中的一张图片来使用

```csharp
public class Sprite_Atlas : MonoBehaviour
{
    private void Start()
    {
        GameObject obj = new GameObject();
        SpriteRenderer sr = obj.AddComponent<SpriteRenderer>();
        SpriteAtlas spriteAtlas = Resources.Load<SpriteAtlas>("MyAtlas");
        sr.sprite = spriteAtlas.GetSprite("dead2");
    }
}
```


> 2. 在场景中有3张图片，3张图片叠在一起放，最底层和最上层的图片在一个图集中，中间的图片和他们两不在一个图集中，请告诉我当前的DrawCall数量是多少?

3

---

## Sprite Shape

>SpriteShape是精灵形状的意思
>主要是方便我们以节约美术资源为前提，制作2D游戏场景地形或者背景的

**导入 Sprite Shape 工具**
- 在 Package Manager 中导入相关工具
- 可以选择性导入实例和拓展资源

**参数**
![[Sprite Shape.png]]

---

## 脚本

**窗口：**
![[Sprite Shape Renderer 和 Sprite Shape Renderer.png]]
![[Sprite Shape Controller 编辑模式.png]]

**添加碰撞器**
1. 边界碰撞器，会自动匹配精灵形状的边
2. 多边形碰撞器配合复合碰撞器

---

## API 速查

- SpriteRenderer （类 精灵渲染器）
- Sprite （类 精灵图）
- SpriteMask（类 精灵遮罩）
- SpriteAtlas （类 图集）
	- SpriteAtlas.GetSprite （成员方法 获取图集中指定名字的图片）

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- Sliced 切片模式 用一个个很小的图片资源 渲染很大的图片场景

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

学会了 
- 使用代码动态挂载一个精灵渲染器脚本，并用代码设置脚本上的参数（绑定的图片等）
- 2D中人物的移动和转向逻辑
- 2D中配合人物转向发射子弹逻辑
- 动态创建图集中的指定图片
