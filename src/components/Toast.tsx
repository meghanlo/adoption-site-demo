import React, { useEffect } from 'react';
import { CheckCircle, XCircle, X } from 'lucide-react';

interface ToastProps {
  message: string;
  type: 'success' | 'error';
  onClose: () => void;
}

const Toast: React.FC<ToastProps> = ({ message, type, onClose }) => {
  useEffect(() => {
    const timer = setTimeout(() => {
      onClose();
    }, 3000);

    return () => clearTimeout(timer);
  }, [onClose]);

  return (
    <div 
      className={`
        fixed top-4 left-1/2 -translate-x-1/2 
        flex items-center gap-2 
        bg-white border rounded-lg shadow-xl p-4 
        min-w-[300px] max-w-[90vw]
        animate-[slideIn_0.3s_ease-out]
        z-50
      `}
    >
      {type === 'success' ? (
        <CheckCircle className="w-6 h-6 text-green-500 flex-shrink-0" />
      ) : (
        <XCircle className="w-6 h-6 text-red-500 flex-shrink-0" />
      )}
      <span className="text-gray-700 flex-grow">{message}</span>
      <button
        onClick={onClose}
        className="ml-2 text-gray-400 hover:text-gray-600 p-1 hover:bg-gray-100 rounded-full transition-colors"
      >
        <X className="w-4 h-4" />
      </button>
    </div>
  );
};

export default Toast;