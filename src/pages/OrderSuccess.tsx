import React from 'react';
import { useNavigate } from 'react-router-dom';

function OrderSuccess() {
  const navigate = useNavigate();

  return (
    <div className="min-h-[60vh] flex flex-col items-center justify-center text-center">
      <div className="animate-bounce mb-8">
        <span className="text-8xl text-pink-500">☺</span>
      </div>
      <h1 className="text-4xl font-bold text-gray-800 mb-4">
        Adoption Request Submitted!
      </h1>
      <p className="text-gray-600 mb-8 max-w-md">
        Thank you for choosing to adopt! We'll review your request and contact you soon to schedule a meet-and-greet with your potential new furry family member.
      </p>
      <button
        onClick={() => navigate('/')}
        className="bg-pink-500 text-white px-8 py-3 rounded-lg hover:bg-pink-600 transition-colors"
      >
        Meet More Dogs
      </button>
    </div>
  );
}

export default OrderSuccess;