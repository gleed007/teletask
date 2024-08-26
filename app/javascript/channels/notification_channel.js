import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    console.log('connected');
  },

  received(data) {
    const notificationContainer = document.getElementById('toast-success');
    notificationContainer.innerHTML = '';
    if (!notificationContainer.classList.contains('d-none')) {
      notificationContainer.classList.add('d-none')
    }

    if (data.message) {
      notificationContainer.classList.remove('d-none')

      const textContent = document.createElement('div');
      textContent.className = 'ml-3 text-sm font-normal';
      textContent.id = 'message-content';
      textContent.innerText = data.message;
  
      notificationContainer.appendChild(textContent);


      if (data.type === 'success_notification') {
        notificationContainer.style.backgroundColor = '#2ecc71';
      } else {
        notificationContainer.style.backgroundColor = '#FF0000';
      }

      setTimeout(() => {
        notificationContainer.classList.add('d-none');
      }, 3000);
    }
  }
});
