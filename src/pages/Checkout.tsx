import React from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '../lib/supabase';

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

interface CheckoutProps {
  cart: AdoptionRequest[];
  setCart: React.Dispatch<React.SetStateAction<AdoptionRequest[]>>;
  user: any;
}

function Checkout({ cart, setCart, user }: CheckoutProps) {
  const navigate = useNavigate();

  const simulateRandomFailure = () => {
    // 30% chance of failure
    return Math.random() < 0.3;
  };

  const submitAdoptionRequest = async () => {
    try {
      // Simulate a random failure
      if (simulateRandomFailure()) {
        throw new Error("We're experiencing high volume of adoption requests. Please try again in a few moments.");
      }

      const total = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
      
      // Insert the order
      const { data: order, error: orderError } = await supabase
        .from('orders')
        .insert([{
          user_id: user?.id || '00000000-0000-0000-0000-000000000000',
          total,
          status: 'pending',
          is_guest: !user
        }])
        .select()
        .single();

      if (orderError) throw orderError;

      // Insert the order items
      const { error: itemsError } = await supabase
        .from('order_items')
        .insert(
          cart.map(item => ({
            order_id: order.id,
            product_id: item.id,
            quantity: item.quantity,
            price: item.price
          }))
        );

      if (itemsError) throw itemsError;

      setCart([]);
      navigate('/order-success');
    } catch (error) {
      console.error('Error submitting adoption request:', error);
      // Find the parent App component's showToast function
      const event = new CustomEvent('showToast', {
        detail: {
          message: error instanceof Error ? error.message : 'Failed to submit adoption request. Please try again.',
          type: 'error'
        }
      });
      window.dispatchEvent(event);
    }
  };

  if (cart.length === 0) {
    return (
      <div className="text-center py-12">
        <h2 className="text-2xl font-bold mb-4">No adoption requests yet</h2>
        <button
          onClick={() => navigate('/')}
          className="bg-pink-500 text-white px-6 py-2 rounded hover:bg-pink-600"
        >
          Find Your Perfect Dog
        </button>
      </div>
    );
  }

  return (
    <div className="bg-white p-6 rounded-lg shadow-md">
      <h2 className="text-2xl font-bold mb-6">Review Adoption Requests</h2>
      {cart.map(item => (
        <div key={item.id} className="flex justify-between items-center py-4 border-b">
          <div className="flex items-center">
            <img
              src={item.image_url}
              alt={item.name}
              className="w-16 h-16 object-cover rounded"
            />
            <div className="ml-4">
              <h3 className="font-semibold">{item.name}</h3>
              <p className="text-gray-600">Adoption Fee: ${(item.price / 100).toFixed(2)}</p>
            </div>
          </div>
        </div>
      ))}
      <div className="mt-6 flex justify-between items-center">
        <span className="text-xl font-bold">
          Total Fees: ${(cart.reduce((sum, item) => sum + (item.price * item.quantity), 0) / 100).toFixed(2)}
        </span>
        <button
          onClick={submitAdoptionRequest}
          className="bg-pink-500 text-white px-8 py-3 rounded-lg hover:bg-pink-600 transition-colors"
        >
          Submit Adoption Request
        </button>
      </div>
    </div>
  );
}

export default Checkout;