# 09 Resources 同步加载

**所属模块**：[[00 Unity 基础阶段总览]]
**关联**：[[08 Unity中特殊文件夹]] | [[07 预设体与资源包]]
**查阅次数**：0

---

## Resources 文件夹相关相关

**常用资源类型:**
1. 预设体对象 - GameObject
2. 音效文件 - Audioclip
3. 文本文件 - TextAsset
4. 图片文件 - Texture
5. 其它类型 - 需要什么用什么类型

**注意：**
- 预设体对象加载需要实例化
- 其他资源一般直接用
- 一个工程中可以有多个 `Resources` 文件夹，不在 `Assets` 根目录下也可以，打包时会整合所有 `Resources` 文件夹

---

## 资源同步加载

**作用：**
- 通过代码动态加载 `Resources` 文件夹下指定路径资源
- 避免繁琐的拖曳操作

**注意：**
- 重复加载同一个资源不会造成内存浪费，只会存在性能浪费
- 第一次加载时会将这个资源存放在内存中作为缓存
- 每次加载时都会先在缓存区去找，如果找到这个资源，会直接取出来使用，所以不会浪费内存，但是查找的行为会存在性能浪费

---

### 普通方法

```csharp
//普通方法不如泛型方法方便
//1 预设体对象 想要创建在场景上 记住实例化
// 1.1 加载预设体的资源文件（本质上就是 在内存中 加载配置数据）
Object obj = Resources.Load("预设体名");
// 1.2 实例化
Instantiate(obj);

//2 音效资源
public AudioSource;
// 2.1 加载数据
Object obj1 = Resources.Load("文件夹路径/文件名");
// 2.2 把数据赋值到脚本上
AudioSource.clip = obj1 as AudioClip;

//3 文本资源 
//支持格式 .txt .xml .bytes .json .html .csv ......
private TextAsset text;
text = Resources.Load("文件夹路径/文件名") as TextAsset;
text.text //文本内容
text.bytes //字节数据组

//4 图片资源
private Texture tex;
tex = Resources.Load("文件夹路径/文件名") as Texture;
private void OnGUI // 绘制
{
	GUI.DrawTexture(new Rect(0, 0, 100, 100), tex);
}

//5 其他类型 需要什么类型用什么类型就行

//6 资源同名怎么办
//可以使用另外的API
// 6.1 加载指定类型的资源
Resources.Load("文件夹路径/文件名", Type);
tex = Resources.Load("文件夹路径/文件名", typeof(Texture)) as Texture;//加载同名图片
text = Resources.Load("文件夹路径/文件名", typeof(TextAsset)) as TextAsset;//加载同名文本

// 6.2 加载指定名字的所有资源 性能消耗大 很少使用
Object[] objs = Resources.LoadAll("文件夹路径/文件名");
foreach (Object item in objs)
{
	if (item is Texture) { }
	else if (item is TextAsset) { }
}
```

### 泛型方法

```csharp
//泛型类型更加常用
Texture text = Resources.Load<Texture>("文件夹路径\文件名");
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

## 练习

> 1. 请把之前四元数练习题中，发射散弹等相关逻辑改为动态加载资源并创建

```csharp
//[[05 Quaternion四元数#^60d844]]
//只需在 Start 生命周期函数中加一句代码
private void Start()
{
    bullet = Resources.Load("Bullet") as GameObject; //方法1 普通方法
    bullet = Resources.Load<GameObject>("Bullet"); // 方法2 泛型方法
}
```

---

## API 速查
- Resources.Load （方法 加载资源）存在泛型重载
- Resources.LoadAll （方法 加载所有资源）
- TextAsset.text （成员属性 得到资源文本）
- TextAsset.bytes （成员属性 得到资源字节数据组）

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
