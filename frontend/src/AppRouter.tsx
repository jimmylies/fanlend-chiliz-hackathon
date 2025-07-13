import { Navigate, Route, BrowserRouter as Router, Routes } from 'react-router';

import History from './pages/History';

import Home from '@/pages/Home/Home';
import Header from '@/components/Header/Header';
import { Toaster } from '@/components/ui/sonner';
import Footer from './components/Footer/Footer';

function AppRouter() {
  return (
    <main className="flex min-h-screen flex-col">
      <Router>
        <Header />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/history" element={<History />} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
        <Footer />
        <Toaster position="top-right" />
      </Router>
    </main>
  );
}

export default AppRouter;
