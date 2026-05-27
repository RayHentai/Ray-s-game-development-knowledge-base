# 06 Tilemap 瓦片地图

**所属模块**：[[00 Unity 核心阶段总览]]
**关联**：[[03 Sprite 精灵图片]] | [[04 2D 物理]]
**查阅次数**：0

---

## 核心理解

> Tilemap是瓦片地图或者平铺地图
> 是unity2017中新增的功能
> 主要用于快速编辑2D游戏中的场景，通过复用资源的形式提升地图多样性

工作原理就是用一张张的小图排列组合为一张大地图

**和spriteShape的异同**

**共同点**
- 都是用于制作2D游戏的场景或地图的
**不同点**
- SpriteShape可以让地形有弧度，TileMap不行
- Ti1eMap可以快捷制作有伪“z”轴的地图，riteShape不行


---

## 瓦片资源

**在 Package Manager 引入Tilemap包**

**创建瓦片资源**
- 方法一：Assets -> create -> Tile
- 方法二：在Tile Palette 瓦片调色窗口创建 window -> 2D -> Tile Palette
	- 新建一个瓦片地图编辑文件 create New Palette 
	- 将资源拖入窗口选择要保存的路径

**窗口：**
![[瓦片资源.png]]

---

## 瓦片调色板

**窗口：**
![[瓦片调色版创建窗口.png]]

![[瓦片调色板窗口工具.png]]

---

### 编辑瓦片地图

方法一：通过瓦片调色板文件创建
方法二：直接在场景中进行创建

矩形瓦片地图用于做横版游戏地图
六边形弯片地图用于做策略游戏地图
等距瓦片地图用于做有"Z"轴的2D游戏

**注意：在编辑等距瓦片地图时**
1. 需要修改工程的自定义轴排序以Y轴决定渲染顺序
   （1）Project Settings -> Graphics -> Transparency Sort Mode -> Custom Axis -> 0, 0, -0.26
   （2）Tilemap Renderer脚本 -> Mode -> Individual
2. 如果地图存在前后关系需要修改TileRenderer的渲染模式
3. 可以通过z轴偏移来控制绘制单个瓦片时的高度
4. 精灵纹理的中心点会影响最终的显示效果

**重点知识运用**
1. 等距瓦片地图的两项重要设置
2. 两种等距瓦片地图的区别
3. 等距瓦片地图的排序问题
	轴心点排序
	排序层排序(推荐)
4. 等距瓦片地图角色**不使用重力**
5. 等距瓦片地图边缘碰撞器建议使用格子形状，墙壁使用基于轮廓
6. 等距瓦片地图上跳跃问题

---

## 关键脚本

**窗口参数：**
![[grid.png]]

![[Tilemap 和 Tilemap Renderer.png]]

**代码控制：**

```csharp
public Tilemap map;
public Grid grid;
public TileBase tileBase;

//1 清空所有瓦片
map.ClearAllTiles();
//2 获取指定坐标格子
TileBase tmp = map.GetTile(new Vector3Int(0, 0, 0));
//3 设置删除瓦片
map.SetTile(new Vector3Int(0, 2, 0), tileBase);
map.SetTile(new Vector3Int(1, 0, 0), null);
//4 替换瓦片
map.SwapTile(tmp, tileBase);
//5 世界坐标转格子坐标
grid.WorldToCell(世界坐标);
```

---

## 碰撞器

为挂载TilemapRenerer脚本的对象添加Tilemap Collider2D脚本，会自动添加碰撞器

**注意：想要生成碰撞器的瓦片ColliderType类型要进行设置**

---

### 练习

> 1. 请用TileMap制作一个横版通关的地图,让一个角色可以在其中移动

![[瓦片地图 练习1.png]]

> 2. 请用TileMap制作一个有伪Z轴的地图让一个角色可以在其中移动

![[瓦片地图 练习2.png]]

---

## 官方资源包相关

> 拓展包为Tilemap添加新的瓦片类型和笔刷类型
> 帮助我们更加方便的编辑2D场景

**下载地址：**
https://github.com/Unity-Technologies/2d-extras

---

### 新增瓦片类型

1. **规则瓦片 RuleTile**
   定义不同方向是否存在连接图片的规则
   让我们更加快捷的进行地图编辑
   ![[规则瓦片.png]]

2. 动画瓦片 AnimatedTile
   可以指定序列帧
   产生可以播放序列帧动画的瓦片
   ![[动画瓦片.png]]


3. 管道瓦片 PipelineTile
   根据自己相邻瓦片的数量更换显示的图片
   ![[管道瓦片.png]]


4. 随机瓦片 RandomTile
   根据你设置的图片，随机从中选一个进行绘制
   ![[随机瓦片.png]]

5. 地形瓦片 TerrainTile
   有点类似规则瓦，只不过地形瓦片是帮助你定好的规则
   ![[地形瓦片.png]]


6. 权重随机瓦片 WeightedRandomTile
   可以不平均随机选择图片的瓦片


7. （高级)规则覆盖瓦片(Advanced）Rule Override Tile
   在规则瓦片的基础上改变图片或者指定启用的规则

---

### 新增笔刷类型

**创建笔刷：Create -> 2D Extras -> Brushes -> Orefab Brush**
1. 预设体笔刷一用于快捷刷出想要创建的精灵
2. 预设体随机笔刷一用于快捷随机刷出想要创建的精灵
3. 随机笔刷一可以指定瓦片进行关联，随机刷出对应瓦片

**拓展笔刷**
1. Coordinate Brush 坐标笔刷—可以实时看到格子坐标
2. GameObjectBrush 游戏对象笔刷—可以在场景中选择和擦除游戏对象仅限于选定的游戏对象的子级
3. GroupBrush组合笔刷—可以设参数当点击一个瓦片样式时会自动取出一个范围内的瓦片
4. LineBrush线性笔刷—决定起点和终点画一条线出来
5. Random Brush随机笔刷一和之前的白定义随机画笔类似，可以随机画出瓦片
6. Tint Brush着笔刷一可以给瓦着瓦的颜色锁要开启（Inspector窗口切换Debug模式
7. TintBrush(Smooth）光滑着色笔刷—可以给瓦片进行渐变着色，需要按要求改变材质

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

- Tilemap（类 管理瓦片地图的组件）
- TileBase（类 瓦片资源对象基类）
- Grid（类 格子位置信息）

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
