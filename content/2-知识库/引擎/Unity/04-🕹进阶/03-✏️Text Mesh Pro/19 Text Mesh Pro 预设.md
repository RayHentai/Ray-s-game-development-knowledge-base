# 19 Text Mesh Pro 样式表

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 样式表

**创建和使用样式表**
1. 右键 -> Create -> TextMeshPro -> Style Sheet 即可创建样式表
2. 样式表一般移动到 TextMesh Pro/Resources/Style Sheets 下
3. 把需要用到的样式表拖入TMP组件下 Extra Settings -> Style Sheet Asset 即可使用样式表
4. 在 TMP组件下 Text Style 选择自己设置的标签即可应用
5. 通过`<style=样式名></style>`也可以直接指定特定区域的文本应用该样式
   可以看得出，样式其实是对富文本标签的封装和复用

---

## 窗口参数

![[Style Sheets 参数.png]]

---

## 颜色预设

**创建和使用颜色预设**
1. 右键 -> Create -> TextMeshPro ->Color Gradient 并配置
2. 把需要用到的样式表拖入TMP组件下 Main Settings -> Color Gradient -> Color Preset 即可

**当有多个文本需要同一种渐变的时候，这样可以大大提示我们的开发效率**

---

## 图文混排

**创建图集资源**
1. 准备好图集并生成图集资源，切片好
2. 右键图集 -> Create -> TextMeshPro -> Sprite Asset
3. 图集一般移动到 TextMesh Pro/Resources/Sprite Assets 下
4. 把需要用到的图集拖入TMP组件下 Extra Settings -> Sprite Asset 即可使用图集

**使用**

```json
//直接在TMP文本控件中输入sprite相关的富文本标签便可以使用
//1 默认资源中获取图片
<sprite index=图片ID color=#RGBA的16进制(可选)>
<sprite name="图片名" color=#RGBA的16进制(可选)>
<sprite=图片ID color=#RGBA的16进制(可选)>

//2 指定资源中获取图片
<sprite="资源名" index=图片ID color=#RGBA的16进制(可选)>
<sprite="资源名" name="图片名" color=#RGBA的16进制(可选)>
```

**有时候可能会显示为空报错，这个时候把原始图集重复为Default 之后Apply，再重设为Sprite之后Apply，再生成一个图集资源就好了**

**调整图集资源**
1. 进入到图集资源的字形表中
2. 主要调整BX、BY（分别是左上角相对于基线的X，Y方向偏移）
3. 因为图集切割的大小差不多，所以可以在下面给全局设置相同的偏移值，保证所有的表情都显示在合理的位置

---

## 总结

1. 样式表其实就是封装了一次的富文本
2. 颜色预设是一个配置文件，可以帮助我们提前设置好渐变颜色并复用到多个文本上
3. 精灵图片资源可以实现图文混排，但是有时候可能位置有所偏移，这个时候需要去精灵图片资源的字形表中进行调整

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
