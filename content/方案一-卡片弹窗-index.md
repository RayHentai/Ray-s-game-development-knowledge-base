<div class="home-wrap">

  <div class="scroll-banner">
    <div class="scroll-track">
      <span>C# &nbsp;·&nbsp; Lua &nbsp;·&nbsp; C++ &nbsp;·&nbsp; Unity &nbsp;·&nbsp; 算法 &nbsp;·&nbsp; 数据结构 &nbsp;·&nbsp; 设计模式 &nbsp;·&nbsp; 计算机网络 &nbsp;·&nbsp; 图形学 &nbsp;·&nbsp; 热更新 &nbsp;·&nbsp; MVC &nbsp;·&nbsp; 框架 &nbsp;&nbsp;</span>
      <span>C# &nbsp;·&nbsp; Lua &nbsp;·&nbsp; C++ &nbsp;·&nbsp; Unity &nbsp;·&nbsp; 算法 &nbsp;·&nbsp; 数据结构 &nbsp;·&nbsp; 设计模式 &nbsp;·&nbsp; 计算机网络 &nbsp;·&nbsp; 图形学 &nbsp;·&nbsp; 热更新 &nbsp;·&nbsp; MVC &nbsp;·&nbsp; 框架 &nbsp;&nbsp;</span>
    </div>
  </div>

  <div class="hero">
    <div class="hero-title">🧠 我的知识库</div>
    <div class="hero-sub">游戏开发学习笔记 · 持续更新中</div>
  </div>

  <div class="card-grid">
    <div class="card" onclick="openModal('lang')">
      <div class="card-icon">💻</div>
      <div class="card-name">编程语言</div>
      <div class="card-hint">3 个子模块</div>
    </div>
    <div class="card" onclick="openModal('unity')">
      <div class="card-icon">🎮</div>
      <div class="card-name">Unity</div>
      <div class="card-hint">8 个子模块</div>
    </div>
    <div class="card" onclick="openModal('framework')">
      <div class="card-icon">🔲</div>
      <div class="card-name">框架</div>
      <div class="card-hint">2 个子模块</div>
    </div>
    <div class="card" onclick="openModal('theory')">
      <div class="card-icon">📚</div>
      <div class="card-name">理论基础</div>
      <div class="card-hint">8 个子模块</div>
    </div>
    <div class="card" onclick="openModal('project')">
      <div class="card-icon">🚀</div>
      <div class="card-name">项目</div>
      <div class="card-hint">StarForge · 星铸</div>
    </div>
    <div class="card" onclick="location.href='/5-AI QA/Home'">
      <div class="card-icon">🤖</div>
      <div class="card-name">AI QA</div>
      <div class="card-hint">直接跳转</div>
    </div>
  </div>

</div>

<div class="modal-overlay" id="modal-overlay" onclick="closeModal()">
  <div class="modal-box" onclick="event.stopPropagation()">
    <button class="modal-close" onclick="closeModal()">✕</button>
    <div class="modal-title" id="modal-title"></div>
    <div class="sub-grid" id="modal-body"></div>
  </div>
</div>

<script>
const DATA = {
  lang: {
    title: "💻 编程语言",
    items: [
      { icon:"🔷", name:"C#",  href:"/2-知识库/编程语言/01-🔷CSharp" },
      { icon:"⚡", name:"C++", href:"/2-知识库/编程语言/02-⚡C++" },
      { icon:"🌙", name:"Lua", href:"/2-知识库/编程语言/03-🌙Lua" },
    ]
  },
  unity: {
    title: "🎮 Unity",
    items: [
      { icon:"🎮", name:"入门",        href:"/2-知识库/引擎/Unity/01-🎮入门" },
      { icon:"🧸", name:"基础",        href:"/2-知识库/引擎/Unity/02-🧸基础" },
      { icon:"🪀", name:"核心",        href:"/2-知识库/引擎/Unity/03-🪀核心" },
      { icon:"🕹", name:"进阶",        href:"/2-知识库/引擎/Unity/04-🕹进阶" },
      { icon:"🪅", name:"UI",          href:"/2-知识库/引擎/Unity/05-🪅UI" },
      { icon:"🔢", name:"数据持久化",  href:"/2-知识库/引擎/Unity/06-🔢数据持久化" },
      { icon:"🔄", name:"热更新",      href:"/2-知识库/引擎/Unity/07-🔄热更新" },
      { icon:"🛜", name:"网络开发基础",href:"/2-知识库/引擎/Unity/08-🛜网络开发基础" },
    ]
  },
  framework: {
    title: "🔲 框架",
    items: [
      { icon:"💭", name:"MVC",         href:"/2-知识库/框架/01-💭MVC" },
      { icon:"🔲", name:"程序基础框架", href:"/2-知识库/框架/02-🔲程序基础框架" },
    ]
  },
  theory: {
    title: "📚 理论基础",
    items: [
      { icon:"🖥️", name:"计算机基础",     href:"/2-知识库/理论基础/01-🖥️计算机基础" },
      { icon:"⚙️", name:"计算机组成原理", href:"/2-知识库/理论基础/02-⚙️计算机组成原理" },
      { icon:"🗃️", name:"操作系统",       href:"/2-知识库/理论基础/03-🗃️操作系统" },
      { icon:"📐", name:"编译原理",       href:"/2-知识库/理论基础/04-📐编译原理" },
      { icon:"📊", name:"数据结构和算法", href:"/2-知识库/理论基础/05-📊数据结构和算法" },
      { icon:"🎨", name:"设计模式",       href:"/2-知识库/理论基础/06-🎨设计模式" },
      { icon:"🌐", name:"计算机网络",     href:"/2-知识库/理论基础/07-🌐计算机网络" },
      { icon:"🖼️", name:"图形学",         href:"/2-知识库/理论基础/08-🖼️图形学" },
    ]
  },
  project: {
    title: "🚀 项目",
    items: [
      { icon:"⭐", name:"StarForge · 星铸", href:"/1-项目/StarForge · 星铸/00-概览" },
    ]
  }
};

function openModal(key) {
  const d = DATA[key];
  document.getElementById('modal-title').textContent = d.title;
  document.getElementById('modal-body').innerHTML = d.items.map(i =>
    `<a class="sub-card" href="${i.href}">
      <div class="sub-icon">${i.icon}</div>
      <div class="sub-name">${i.name}</div>
    </a>`
  ).join('');
  document.getElementById('modal-overlay').classList.add('active');
}
function closeModal() {
  document.getElementById('modal-overlay').classList.remove('active');
}
</script>
