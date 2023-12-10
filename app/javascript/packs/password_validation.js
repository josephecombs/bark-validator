document.addEventListener('DOMContentLoaded', () => {
  const passwordInput = document.getElementById('password');
  const passwordFeedback = document.getElementById('password-feedback');

  const validatePasswordLength = (password) => {
    return password.length >= 8;
  };

  const updateFeedback = (isValid) => {
    if (isValid) {
      passwordFeedback.textContent = 'Password length is sufficient.';
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
});
