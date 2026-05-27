# 11 Resources 资源卸载

**所属模块**：[[00 Unity 基础阶段总览]]
**关联**：[[09 Resources 同步加载]] | [[10 Resources 异步加载]] | [[06 垃圾回收机制GC]]
**查阅次数**：0

---

## 语法 / 用法

**注意：UnloadAsset方法**
- 不能释放GameObject对象（即使是没有实例化的），因为它会用于实例化对象
- 它只能用于一些不需要实例化的内容，比如图片、音效、文本等等一般情况下，很少单独使用它

```csharp
//1 卸载指定资源(不包括GameObject)
// 它只能用于一些不需要实例化的内容 比如 图片、音效、文本等等
Resources.UnloadAsset(资源对象);
资源对象 = null;
Resources.UnloadAsset(已经加载过的GameObject对象);//❌ 报错

//2 卸载所有未使用资源 一般在过场景时和 GC 一起使用
Resources.UnloadUnusedAssets();
GC.Collect();
```

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- UnloadAsset方法不能释放GameObject对象
- 

---

## API 速查

- Resources.UnloadAsset （方法 卸载指定对象）
- Resources.UnloadUnusedAssets （方法 卸载所有未使用资源）

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
