'use client';

import { useChat } from 'ai/react';
import { useState, useRef, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import ReactMarkdown from 'react-markdown';

export default function ChatBox() {
  const [isOpen, setIsOpen] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const { messages, input, handleInputChange, handleSubmit, isLoading, stop } = useChat({
    api: '/api/chat',
  });

  // Auto scroll to bottom
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  return (
    <>
      {/* Chat toggle button */}
      <motion.button
        onClick={() => setIsOpen(!isOpen)}
        className="fixed bottom-6 right-6 z-50 w-14 h-14 rounded-full bg-gradient-to-r from-kirameku-primary to-kirameku-secondary text-white shadow-lg hover:shadow-kirameku-primary/30 transition-all duration-300 flex items-center justify-center group"
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
        animate={isOpen ? { rotate: 90 } : { rotate: 0 }}
      >
        <span className="text-xl">{isOpen ? '✕' : '💬'}</span>
        {/* Glow effect */}
        <span className="absolute inset-0 rounded-full bg-gradient-to-r from-kirameku-primary to-kirameku-secondary opacity-0 group-hover:opacity-50 blur-lg transition-opacity duration-300" />
      </motion.button>

      {/* Chat panel */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: 20, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 20, scale: 0.95 }}
            transition={{ type: 'spring', damping: 25, stiffness: 300 }}
            className="fixed bottom-24 right-6 z-40 w-[380px] md:w-[420px] h-[520px] rounded-2xl overflow-hidden border border-white/20 shadow-2xl shadow-kirameku-primary/10"
            style={{
              background: 'rgba(26, 26, 46, 0.85)',
              backdropFilter: 'blur(24px)',
            }}
          >
            {/* Header */}
            <div className="p-4 bg-gradient-to-r from-kirameku-primary/80 to-kirameku-secondary/80 border-b border-white/10">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center">
                  <span className="text-lg">✨</span>
                </div>
                <div>
                  <h3 className="font-display font-semibold text-white">AI 小助手</h3>
                  <p className="text-xs text-white/60">随时为你解答</p>
                </div>
              </div>
            </div>

            {/* Messages */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4" style={{ height: 'calc(100% - 140px)' }}>
              {messages.length === 0 && (
                <div className="h-full flex items-center justify-center">
                  <div className="text-center text-white/40">
                    <p className="text-2xl mb-2">👋</p>
                    <p className="text-sm">你好！我是博客 AI 助手</p>
                    <p className="text-xs mt-1">可以问我任何关于博客的问题</p>
                  </div>
                </div>
              )}

              {messages.map((m) => (
                <motion.div
                  key={m.id}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  className={`flex ${m.role === 'user' ? 'justify-end' : 'justify-start'}`}
                >
                  <div
                    className={`max-w-[85%] p-3 rounded-2xl text-sm ${
                      m.role === 'user'
                        ? 'bg-gradient-to-r from-kirameku-primary to-kirameku-secondary text-white rounded-br-md'
                        : 'bg-white/10 text-white/90 rounded-bl-md'
                    }`}
                  >
                    {m.role === 'user' ? (
                      m.content
                    ) : (
                      <div className="prose prose-sm prose-invert max-w-none">
                        {m.content}
                      </div>
                    )}
                  </div>
                </motion.div>
              ))}

              {isLoading && (
                <motion.div
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  className="flex justify-start"
                >
                  <div className="bg-white/10 p-3 rounded-2xl rounded-bl-md">
                    <div className="flex gap-1">
                      <span className="w-2 h-2 bg-white/50 rounded-full animate-typing" style={{ animationDelay: '0ms' }} />
                      <span className="w-2 h-2 bg-white/50 rounded-full animate-typing" style={{ animationDelay: '200ms' }} />
                      <span className="w-2 h-2 bg-white/50 rounded-full animate-typing" style={{ animationDelay: '400ms' }} />
                    </div>
                  </div>
                </motion.div>
              )}

              <div ref={messagesEndRef} />
            </div>

            {/* Input */}
            <form onSubmit={handleSubmit} className="p-4 border-t border-white/10">
              <div className="flex gap-2">
                <input
                  value={input}
                  onChange={handleInputChange}
                  placeholder="问我任何关于博客的问题..."
                  className="flex-1 px-4 py-2.5 rounded-xl bg-white/5 border border-white/10 text-white text-sm
                           focus:border-kirameku-primary/50 focus:bg-white/10 focus:outline-none
                           transition-all duration-300 placeholder-white/30"
                  disabled={isLoading}
                />
                <button
                  type="submit"
                  disabled={isLoading || !input.trim()}
                  className="px-4 py-2.5 bg-gradient-to-r from-kirameku-primary to-kirameku-secondary 
                           text-white rounded-xl hover:shadow-lg hover:shadow-kirameku-primary/20 
                           disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-300
                           active:scale-95 text-sm"
                >
                  {isLoading ? '✋' : '发送'}
                </button>
              </div>
            </form>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
}
