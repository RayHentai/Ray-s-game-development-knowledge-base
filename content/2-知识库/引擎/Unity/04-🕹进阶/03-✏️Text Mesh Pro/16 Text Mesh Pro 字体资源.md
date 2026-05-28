# 16 Text Mesh Pro 字体资源

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 创建字体资源

1. 可以去电脑上随便找一个字体（后缀为.tff 或.off 格式的文件），拖入到工程中
2. 一般拖进来之后，放置在 TextMesh Pro/Fonts 下
3. 选中字体，右键 -> Create -> TextMeshPro -> Font Asset 即可创建字体资源
4. 创建好的字体资源，一般移动到 TextMesh Pro/Resources/Fonts & Materials 下
5. 点击字体，在Inspector点击 Update Atlas Texture 生成字体资源
   如果需要用到的字符已经提前知道并固定了，就可以用这种，或者有的艺术字需要专门用一个资源

---

## 窗口参数

**Font Asset Creator 参数**
![[Font Asset Creator 参数.png|717]]


**Face Info参数**
![[Face Info 参数.png]]
![[文字参数 图示.png]]


**Generation Settings、Atlas & Material、Font Weights 参数**
![[Generation Settings、Atlas & Material、Font Weights 参数.png]]

**Fallback List 参数**
![[Fallback List 参数.png]]
可以创建相应文本资源的变体，从而在里面提供更多的字符
右键 -> Create -> TextMeshPro -> Font Asset Variant 即可创建文本资源的变体

**Character Table 字符表：如果有需要某个字符特殊的偏移间隔效果，可以来这里找到并给他单独设置**

**Glyph Table: 字形表：和字符表作用差不多，这里还可以设置每个字符的采样位置**
- X、Y、W、H：字符在纹理中对应的位置范围
- W、H：字形的宽高
- BX、BY：相对基线的左上角位置(X方向，Y方向)
- AD：和下一个字符间隔的宽
- Scale：缩放大小
- Atlas Index：图集索引在第几个图集中(开启了多图集时)

**Glyph Adjustment Table：字形调整表：字形调整表控制特定字符对之间的间距**
- Adjustment Pair Search:调整对搜索
- Char 左和右:想要查找的字符
- ID 左和右:唯一标识符，一般显示左右字符的ASCI十进制编码
- OX左和右:字符原点坐标X
- OY 左和右:字符原点坐标Y
- AX左和右：字符的宽度
- Add New Glyph Adjustment Record:添加新的字形调整记录


---

## 常用富文本标签

```csharp
//1 换行
  <br>
//2 文本加粗
  <b></b>
//3 文本斜体
  <i></i>
//4 加下划线
  <u></u>
//5 改变大小
  <size=数值></size>
//6 改变颜色
  <color=#RGBA 16进制></color>
//7 对齐方式
  <align=left、center、right、justified、flush></align>
//8 背景高亮
  <mark=#RGBA 16进制></mark>
//9 透明度
  <alpha=#A 16进制>
//10 全部大写
  <allcaps></allcaps>
//11 改字体和材质（可选）
  <font="字体名" material="材质名"></font>
//12 加上标(平方)
  <sup></sup>
//13 加下标(化学式)
  <sub></sub>
//14 超链接
  <link="链接"></link>
```

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
