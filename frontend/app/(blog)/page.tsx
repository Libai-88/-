import ChatBox from '@/components/ai-chat/ChatBox';

export default function Home() {
  return (
    <main className="min-h-screen relative">
      {/* Background effects */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-kirameku-primary/5 rounded-full blur-3xl animate-float" />
        <div className="absolute bottom-1/4 right-1/4 w-80 h-80 bg-kirameku-secondary/5 rounded-full blur-3xl animate-float" style={{ animationDelay: '-3s' }} />
        <div className="absolute top-1/2 left-1/2 w-64 h-64 bg-kirameku-accent/5 rounded-full blur-3xl animate-float" style={{ animationDelay: '-1.5s' }} />
      </div>

      {/* Main content */}
      <div className="relative z-10 max-w-6xl mx-auto px-6 py-20">
        {/* Hero section */}
        <div className="text-center mb-20">
          <h1 className="font-display text-6xl md:text-8xl font-bold mb-6">
            <span className="text-gradient">Kirameku</span>
          </h1>
          <p className="text-white/60 text-xl md:text-2xl font-light max-w-2xl mx-auto">
            一个带有 AI 助手的高颜值博客
          </p>
          <p className="text-white/40 mt-4 text-sm">
            点击右下角的 AI 按钮，与博客助手对话
          </p>
        </div>

        {/* Blog posts placeholder */}
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[1, 2, 3].map((i) => (
            <article key={i} className="card-glass group cursor-pointer">
              <div className="aspect-video rounded-xl bg-gradient-to-br from-kirameku-primary/20 to-kirameku-secondary/20 mb-4 overflow-hidden">
                <div className="w-full h-full flex items-center justify-center text-white/20 text-4xl font-display font-bold group-hover:scale-105 transition-transform duration-500">
                  {i}
                </div>
              </div>
              <h3 className="font-display text-xl font-semibold mb-2 group-hover:text-kirameku-primary transition-colors">
                示例文章 {i}
              </h3>
              <p className="text-white/50 text-sm line-clamp-2">
                这是一篇示例文章的摘要，展示了文章的主要内容概述...
              </p>
              <div className="flex items-center justify-between mt-4 text-xs text-white/30">
                <span>2024-01-{String(i).padStart(2, '0')}</span>
                <span>#博客 #技术</span>
              </div>
            </article>
          ))}
        </div>
      </div>

      {/* AI Chat Component */}
      <ChatBox />
    </main>
  );
}
