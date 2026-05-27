# 💡 18 光源组件 Light

**所属模块**：[[00 Unity入门阶段总览]]
**关联**：[[04 Inspector 与 Console 窗口]]
**查阅次数**：0

---

## 面板参数

- **Type**  
    光源类型
    - Spot  
        聚光灯
        - Range  
            发光范围距离
        - Spot Angle  
            光锥角度
    - Directional  
        方向光（环境光）
	        方向光就是模拟太阳的 让他旋转就可以模拟日落
    - Point  
        点光源
    - Area  
        面光源
- **Color 
    颜色
- **Mode 
    光源模式
    - Realtime  
        实时光源  
        每帧实时计算 效果好 性能消耗大
    - Baked  
        烘培光源  
        事先计算好 无法动态变化
    - Mixed  
        混合光源  
        预先计算+实时运算
- **Intensity 
    光源亮度
- Indirect Multiplier  
    改变间接光的强度
    - 低于1 每次反弹会使光更暗
    - 高于1 每次反弹会使光更亮
- **Shadow Type**  
    阴影类型
    - NoShadows  
        关闭阴影
    - HardShadows  
        生硬阴影
    - Softshadows  
        柔和阴影
- RealtimeShadows  
    阴影
    - strength  
        阴影暗度0~1之间 越大越黑
    - Resolution  
        阴影须贴图渲染分辨率 越高越逼真 消耗越高
    - Bias  
        阴影推离光源的距离
    - Normal Bias  
        阴影投射面沿法线收缩距离
    - Near Panel  
        渲染阴影的近裁剪面
- **Cookie 
    投影遮罩
- Cookie Size  
    遮罩大小
- **Draw Halo**  
    球型光源开关
- **Flare 
    耀斑
    - 如果需要Game窗口显示耀斑 需要添加Flare Layer脚本
- Render Mode  
    渲染优先级
    - Auto  
        运行时确定
    - Important  
        以像素质量为单位进行渲染 效果逼真 消耗大
    - Not Important  
        以快速模式进行渲染
- **Culling Mask
    剔除遮罩层  
    决定哪些层的对象受到该光源影响

---

## 代码操作

```csharp
//light.参数 = 值;
Light lightComp = GetComponent<Light>();
lightComp.intensity = 1.5f;      // 强度
lightComp.color     = Color.red; // 颜色
lightComp.range     = 10f;       // 范围（点光源）
```

---

## 光面板相关

| 入口  | [[光面板入口.png]] |
| --- | ----------------------------------- |
- Environment  
    环境相关设置
    - **Skybox Material  
        天空盒材质  
        可以改变天空盒  
    - Sun Source  
        太阳来源  
        不设置会默认使用场景中最亮的方向光代表太阳
    - Environment Lighting
        - Source  
            环境光光源颜色
            - Skybox  
                天空和材质作为环境光颜色
            - Gradient  
                可以为天空、地平线、地面单独选择颜色和他们之间混合
        - Intensity Multiplier  
            环境光亮度
        - Ambient Mode  
            全局光照模式  
            只有启用了实时全局和全局烘焙时才有用  
            - Realtime（已弃用)
            - Baked

- OtherSettings
    - Fog  
        雾开关
        - Color  
            雾颜色
        - Mode  
            雾计算模式
            - Linear  
                随距离线性增加
                - Start  
                    离摄像机多远开始有雾
                - End  
                    离摄像机多远完全遮挡
            - Exponential  
                随距离指数增加
                - Density  
                    强度
            - Exponential Qquare  
                随距离比指数更快的增加
                - Density  
                    强度
    - Halo Texture  
        光源周围挥着光环的纹理
    - Halo Strength  
        光环可见性
    - Flare Fade Speed  
        耀斑淡出时间  
        ​最初出现之后淡出的时间
    - Flare Strength  
        耀斑可见性
    - Spot Cookie  
        聚光灯剪影纹理

---

## 练习

> 1. 通过代码结合点光源模拟一个蜡烛的光源效果

```csharp
public class Light_10 : MonoBehaviour
{
    public float pointSpeed = 0.8f;
    public float flashSpeed = 10;
    public Light lightComp;

    void Update()
    {
        // 轻微位移模拟抖动
        lightComp.transform.Translate(Vector3.right * pointSpeed * Time.deltaTime);
        if (lightComp.transform.position.x >= 1)
            pointSpeed = -pointSpeed;
        else if (lightComp.transform.position.x <= 0.8f)
            pointSpeed = -pointSpeed;

        // 强度变化模拟闪烁
        lightComp.intensity += flashSpeed * Time.deltaTime;
        if (lightComp.intensity >= 1)
            flashSpeed = -flashSpeed;
        else if (lightComp.intensity <= 0.5f)
            flashSpeed = -flashSpeed;
    }
}
```

> 2. 通过代码结合方向光模拟白天黑夜的变化

```csharp
public class DayNight : MonoBehaviour
{
    public int dirSpeed = 10;
    public Light dirLight;

    void Update()
    {
	    //方向光就是模拟太阳的 让他旋转就可以模拟日落
        dirLight.transform.Rotate(Vector3.right, dirSpeed * Time.deltaTime);
    }
}
```

---

## 我的踩坑记录

-

---

*最后更新：*
