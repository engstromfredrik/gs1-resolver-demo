import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { ProductResolver } from './pages/ProductResolver';
import { NotFound } from './pages/NotFound';
import { Admin } from './pages/Admin';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/01/:gtin/10/:batch" element={<ProductResolver />} />
        <Route path="/admin" element={<Admin />} />
        <Route path="/not-found" element={<NotFound />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
