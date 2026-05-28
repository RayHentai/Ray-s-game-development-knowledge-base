# 27 Video Player 视频播放器

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

Video Player顾名思义是视频播放器的意思，它是Unity提供给我们**用于播放视频的组件**
该视频播放器组件，可以在游戏中播放导入的视频剪辑文件

**可以通过Video Player来控制视频播放相关设置**
**其中比较重要的参数有**
1. 渲染模式
2. 播放暂停相关API

视频播放时，需要有短暂的准备时间才会开始播放
我们可以通过Prepare函数来启动准备，准备完毕后再正式开始播放

**导入Video Player插件**
- 方法一：在Hierarchy窗口点击加号，选择Video > Video Player
- 方法二：选择场景上任何一个对象，为其添加Video Player组件
- 方法三：直接将视频文件拖入到Hierarchy窗口中

---

## 窗口参数

![[Video Player 参数.png]]

---

## 代码

**注意：使用VideoPlayer组件需要引用命名空间UnityEngine.Video**

```csharp
public RenderTexture texture;
public VideoClip clip;
VideoPlayer videoPlayer;
private bool isOver = false;

//1.将一个 VideoPlayer 附加到主摄像机
//  将 VideoPlayer 添加到摄像机对象时，
//  它会自动瞄准摄像机背板，无需更改 videoPlayer.targetCamera
GameObject camera = GameObject.Find("Main Camera");
videoPlayer = camera.AddComponent<VideoPlayer>();

//2.参数相关设置
//  是否自动播放
videoPlayer.playOnAwake = false;
//  渲染模式
videoPlayer.renderMode = VideoRenderMode.CameraFarPlane;
//设置目标 渲染贴图
videoPlayer.targetTexture = texture;
//设置目标摄像机
videoPlayer.targetCamera
//  透明度
videoPlayer.targetCameraAlpha = 0.5f;
videoPlayer.targetCamera3DLayout = Video3DLayout.OverUnder3D;
//  视频源
videoPlayer.source = VideoSource.VideoClip;
videoPlayer.clip = clip;
videoPlayer.source = VideoSource.Url;
videoPlayer.url = Application.streamingAssetsPath + "/Video.mp4";
//  是否循环
videoPlayer.isLooping = false;
//  视频总时长
print(videoPlayer.length);//单位为s
//  当前时长,播放了多久
print(videoPlayer.time);//单位为s
//  总帧数
print(videoPlayer.frameCount);
//  当前帧
print(videoPlayer.frame);

//3.方法相关
//  播放、停止、暂停
void Update()
{
    if(Input.GetKeyDown(KeyCode.Space) && isOver)
    {
        //视频播放
        videoPlayer.Play();
    }
    if (Input.GetKeyDown(KeyCode.S) && isOver)
    {
        //视频停止
        videoPlayer.Stop();
    }
    if (Input.GetKeyDown(KeyCode.P) && isOver)
    {
        //视频暂停
        videoPlayer.Pause();
    }
}
//  准备函数
videoPlayer.Prepare();//为视频播放准备数据，第一次播放视频就不会卡顿一下

//4.事件相关
//  准备完成事件
videoPlayer.prepareCompleted += (v) =>
{
    print("准备完成");
    isOver = true;
};

//  开始事件
videoPlayer.started += (v) =>
{
    print("当执行player播放方法后 会调用的事件");
};

//  结尾时调用事件
videoPlayer.loopPointReached += (v) =>
{
    print("视频播放到结尾处时会调用的事件");
};
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

> 1. 请结合UGU，制作一个视频播放的进度条，我们可以通过进度条控制视频播放时间

```csharp
public class VideoPlay : MonoBehaviour
{
    public Slider slider;
    public VideoPlayer videoPlayer;
    void Start()
    {
        slider.interactable = false; //让滚动条不能滑动
        slider.onValueChanged.AddListener((value) => 
        {
            videoPlayer.time = videoPlayer.length * value; 
        });
        videoPlayer.Prepare();
        videoPlayer.prepareCompleted += (v) => 
        {
            videoPlayer.Play();
            slider.interactable = true;//开始播放视频时 让滚动条可以滑动
        };
    }
    private void Update()
    {
        if (slider.interactable)
            slider.value = (float)(videoPlayer.time / videoPlayer.length);//更新滚动条
    }
}
```

---

## API速查


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
