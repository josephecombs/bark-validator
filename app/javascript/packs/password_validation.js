document.addEventListener('DOMContentLoaded', () => {
  const passwordInput = document.getElementById('password');
  const form = document.getElementById('new_password_form');
  const passwordFeedback = document.getElementById('password-feedback');

  const validatePasswordLength = (password) => {
    return password.length >= 8;
  };

  const updateFeedback = (isValid) => {
    if (isValid) {
      passwordFeedback.textContent = '';
      passwordFeedback.classList.remove('text-danger');
      passwordFeedback.classList.add('text-success');
    } else {
      passwordFeedback.textContent = 'Password must be at least 8 characters long.';
      passwordFeedback.classList.remove('text-success');
      passwordFeedback.classList.add('text-danger');
    }
  };

  if (passwordInput) {
    passwordInput.addEventListener('input', () => {
      const isValid = validatePasswordLength(passwordInput.value);
      updateFeedback(isValid);
    });
  }

  form.addEventListener('ajax:success', (event) => {
    const [data, status, xhr] = event.detail;
    passwordFeedback.textContent = data.message || '';
    passwordFeedback.classList.add('text-success');
    passwordFeedback.classList.remove('text-danger');
  });

  form.addEventListener('ajax:error', (event) => {
    const [data, status, xhr] = event.detail;
    passwordFeedback.textContent = data.error || 'An error occurred';
    passwordFeedback.classList.add('text-danger');
    passwordFeedback.classList.remove('text-success');
    passwordInput.focus();
  });
});
