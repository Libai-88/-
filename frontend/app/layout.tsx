import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Kirameku - AI Blog',
  description: 'A beautiful blog with AI assistant',
  icons: {
    icon: '/favicon.ico',
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="zh-CN">
      <body className="min-h-screen">
        {children}
      </body>
    </html>
  );
}
