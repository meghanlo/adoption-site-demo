import React, { useEffect, useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Link, useNavigate } from 'react-router-dom';
import { ShoppingCart, User, Heart } from 'lucide-react';
import { supabase } from './lib/supabase';
import { setRumUser } from './lib/datadog';
import Checkout from './pages/Checkout';
import OrderSuccess from './pages/OrderSuccess';
import SignIn from './pages/SignIn';
import Toast from './components/Toast';

interface Dog {
  id: string;
  name: string;
  description: string;
  price: number;
  image_url: string;
}

interface AdoptionRequest extends Dog {
  quantity: number;
}

interface ToastState {
  message: string;
  type: 'success' | 'error';
}

function App() {
  const [dogs, setDogs] = useState<Dog[]>([]);
  const [adoptionRequests, setAdoptionRequests] = useState<AdoptionRequest[]>([]);
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [toast, setToast] = useState<ToastState | null>(null);

  useEffect(() => {
    fetchDogs();
    checkUser();

    const { data: authListener } = supabase.auth.onAuthStateChange((_event, session) => {
      const currentUser = session?.user ?? null;
      setUser(currentUser);
      // Update RUM user on auth state change
      setRumUser(currentUser ? {
        id: currentUser.id,
        email: currentUser.email || '',
      } : null);
    });

    // Listen for toast events from child components
    const handleToast = (event: CustomEvent<ToastState>) => {
      showToast(event.detail.message, event.detail.type);
    };

    window.addEventListener('showToast', handleToast as EventListener);

    return () => {
      authListener.subscription.unsubscribe();
      window.removeEventListener('showToast', handleToast as EventListener);
    };
  }, []);

  const checkUser = async () => {
    const { data: { user } } = await supabase.auth.getUser();
    setUser(user);
    // Set initial RUM user
    if (!user) {
      // This throws an error that isn't caught anywhere
      Promise.reject(new Error("User data unexpectedly missing"));
    }
    if (user) {
      setRumUser({
        id: user.id,
        email: user.email || '',
      });
    }
    setLoading(false);
  };

  const fetchDogs = async () => {
    try {
      const { data, error } = await supabase
        .from('products')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      if (data) setDogs(data);
    } catch (error) {
      console.error('Error fetching dogs:', error);
      showToast('Failed to fetch dogs', 'error');
    }
  };

  const handleSignOut = async () => {
    await supabase.auth.signOut();
    setRumUser(null); // Clear RUM user data on sign out
  };

  const showToast = (message: string, type: 'success' | 'error') => {
    setToast({ message, type });
  };

  const addToAdoptionRequests = (dog: Dog) => {
    try {
      const existingRequest = adoptionRequests.find(request => request.id === dog.id);
      
      if (existingRequest) {
        const error = new Error(`${dog.name} is already in your adoption list. You can only adopt each dog once.`);
        console.error(error);
        showToast(error.message, 'error');
        return;
      }

      setAdoptionRequests(current => [...current, { ...dog, quantity: 1 }]);
      showToast(`${dog.name} added to your adoption list!`, 'success');
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Failed to add dog to adoption list';
      console.error('Error adding dog to adoption list:', error);
      showToast(errorMessage, 'error');
    }
  };

  if (loading) {
    return <div>Loading...</div>;
  }

  return (
    <Router>
      <div className="min-h-screen bg-gray-100">
        {toast && (
          <Toast
            message={toast.message}
            type={toast.type}
            onClose={() => setToast(null)}
          />
        )}

        <nav className="bg-white shadow-lg">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex justify-between h-16">
              <div className="flex items-center">
                <Heart className="h-6 w-6 text-pink-500 mr-2" />
                <Link to="/" className="text-xl font-bold">Pawsome Adoptions</Link>
              </div>
              <div className="flex items-center space-x-4">
                <Link to="/checkout" className="relative">
                  <ShoppingCart className="h-6 w-6" />
                  {adoptionRequests.length > 0 && (
                    <span className="absolute -top-2 -right-2 bg-pink-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs">
                      {adoptionRequests.reduce((sum, request) => sum + request.quantity, 0)}
                    </span>
                  )}
                </Link>
                {user ? (
                  <div className="flex items-center space-x-3">
                    <User className="h-6 w-6" />
                    <button
                      onClick={handleSignOut}
                      className="text-sm text-gray-700 hover:text-gray-900"
                    >
                      Sign Out
                    </button>
                  </div>
                ) : (
                  <Link
                    to="/signin"
                    className="bg-pink-500 text-white px-4 py-2 rounded hover:bg-pink-600 transition-colors"
                  >
                    Sign In
                  </Link>
                )}
              </div>
            </div>
          </div>
        </nav>

        <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <Routes>
            <Route path="/signin" element={<SignIn />} />
            <Route path="/checkout" element={<Checkout cart={adoptionRequests} setCart={setAdoptionRequests} user={user} />} />
            <Route path="/order-success" element={<OrderSuccess />} />
            <Route path="/" element={
              <div>
                <h1 className="text-3xl font-bold text-gray-900 mb-8 text-center">Find Your Perfect Furry Friend</h1>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                  {dogs.map(dog => (
                    <div key={dog.id} className="bg-white rounded-xl shadow-lg overflow-hidden transform transition-transform hover:scale-[1.02]">
                      <div className="relative h-72 overflow-hidden">
                        <img
                          src={dog.image_url || 'https://media.giphy.com/media/3o7TKSha51ATTx9KzC/giphy.gif'}
                          alt={dog.name}
                          className="w-full h-full object-cover transform hover:scale-110 transition-transform duration-500"
                        />
                      </div>
                      <div className="p-6">
                        <h2 className="text-2xl font-bold text-gray-800 mb-2">{dog.name}</h2>
                        <p className="text-gray-600 text-lg mb-4 min-h-[3rem]">{dog.description}</p>
                        <div className="flex justify-between items-center">
                          <span className="text-xl font-bold text-pink-600">
                            Adoption Fee: ${(dog.price / 100).toFixed(2)}
                          </span>
                          <button
                            onClick={() => addToAdoptionRequests(dog)}
                            className="bg-pink-500 text-white px-6 py-3 rounded-lg hover:bg-pink-600 transform transition-transform hover:scale-105 active:scale-95"
                          >
                            Start Adoption
                          </button>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            } />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;