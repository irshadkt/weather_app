String _getErrorMessage(String error) {
    final errorLower = error.toLowerCase();
    
    // City not found errors
    if (errorLower.contains('404') || 
        errorLower.contains('not found') ||
        errorLower.contains('city not found')) {
      return '❌ City not found. Please check the spelling and try again.';
    } 
    // No internet / connection errors
    else if (errorLower.contains('socketexception') ||
        errorLower.contains('no internet') ||
        errorLower.contains('no host') ||
        errorLower.contains('failed host lookup') ||
        errorLower.contains('connection refused') ||
        errorLower.contains('check your connection')) {
      return '⚠️ No internet connection. Please check your internet and try again.';
    } 
    // Timeout errors
    else if (errorLower.contains('timeout')) {
      return '⏱️ Request timeout. The server took too long to respond. Please try again.';
    } 
    // Invalid input errors
    else if (errorLower.contains('invalid') || 
        errorLower.contains('malformed') ||
        errorLower.contains('unexpected')) {
      return '❌ Invalid city name. Please try again with a different name.';
    } 
    // Rate limiting
    else if (errorLower.contains('rate limit') || 
        errorLower.contains('too many requests')) {
      return '⚠️ Too many requests. Please wait a moment and try again.';
    } 
    // Server errors
    else if (errorLower.contains('status: 5') || errorLower.contains('internal error')) {
      return '⚠️ Server error. Please try again later.';
    }
    // Generic error with truncation for very long errors
    else {
      String displayError = error;
      if (error.length > 80) {
        displayError = '${error.substring(0, 80)}...';
      }
      return '❌ Error: $displayError';
    }
  }
