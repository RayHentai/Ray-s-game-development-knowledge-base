# 03 Unity中的坐标系

**所属模块**：[[00 Unity 基础阶段总览]]
**关联**：[[14 Transform 位移旋转缩放]] | [[15 Input 输入]] | [[16 Screen 屏幕]] | [[17 Camera 摄像机]]  
**查阅次数**：1

---

## 坐标系

---

### 世界坐标系

**原点：** 世界的中心点（0, 0, 0）

![[世界坐标系原点.png|263]]

**轴向：** 世界坐标系的三个轴向是固定的

![[世界坐标系轴向.png]]

```csharp
//相对世界坐标系
transform.position
transform.rotation
transform.eulerAngles
transform.lossyScale
```

---

### 物体坐标系

**原点：** 物体的中心点（建模时决定）

**轴向：** 
- 物体右方为x轴正方向
- 物体上方为y轴正方向
- 物体前方为z轴正方向

![[物体坐标系.png|172]]

```csharp
//相对父对象物体坐标系
transform.localPosition
transform.localRotation
transform.localEulerAngles
transform.localScale
```

---

### 屏幕坐标系

**原点：** 屏幕左下角

**轴向：** 
- 向右为x轴正方向
- 向上为y轴正方向

![[屏幕坐标系.png|213]]

**最大宽高：**
- Screen.width
- Screen.height

```csharp
Input.MousePosition
Screen.width
Screen.height
```

---

### 视口坐标系

**原点：** 屏幕左下角

**轴向：** 
- 向右为x轴正方向
- 向上为y轴正方向

![[屏幕坐标系.png|213]]

**特点：和屏幕坐标系类似 将坐标单位化**
- 左下角为（0, 0）
- 右上角为（1, 1）

摄像机上的视口范围
![[视口坐标系.png|319]]

---

## 坐标转换

```csharp
//世界转本地
transform.InverseTransformDirection
transform.InverseTransformPoint
transform.InverseTransformVector
//本地转世界
transform.formDirection
transform.TransformPoint
transform.TransformVector

//世界转屏幕
Camera.main.WorldToScreenPoint
//屏幕转世界
Camera.main.ScreenToWorldPoint

//世界转视口
Camera.main.WorldToViewportPoint
//视口转世界
Camera.main.ViewportToWorldPoint

//视口转屏幕
Camera.main.ViewportToScreenPoint
//屏幕转视口
Camera.main.ScreenToViewportPoint
```

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 

---

## 我的踩坑记录

> ⭐ 这里最有价值！把自己犯过的错误写下来，写上日期

- 如果直接在`Camera.main.ScreenToWorldPoint()` 中传入`Input.MousePos ` 此时转换过来的世界坐标是基于`Input.MousePos `的坐标计算的，`Input.MousePos ` 的z默认是0，所以计算之后的结果永远是靠近摄像机视口的那个点，所以要先记录`Input.MousePos `得到的Vector3，改变z值，再转换成屏幕坐标

---

## 延伸阅读

> 这个知识点延伸出去的方向，学完后可以探索

- [[]]相关知识点
- 

---

*最后更新：*
