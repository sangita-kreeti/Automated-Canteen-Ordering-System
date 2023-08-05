import consumer from "./consumer"

function updateNotificationCount(count) {
  const notificationCount = document.getElementById('notification-count');
  if (notificationCount) {
    notificationCount.textContent = count;
  }
}

document.addEventListener('turbolinks:load', function() {
  const notificationCount = document.getElementById('notification-count');
  if (notificationCount) {
    const currentUserID = notificationCount.dataset.currentUserId;
    
    consumer.subscriptions.create({ channel: "NotificationChannel", current_user_id: currentUserID }, {
      connected() {
        
      },

      disconnected() {
        
      },

      received(data) {
        
        const count = parseInt(notificationCount.textContent);
        const newCount = count + 1;
        updateNotificationCount(newCount);

      },
    });
  }
});
