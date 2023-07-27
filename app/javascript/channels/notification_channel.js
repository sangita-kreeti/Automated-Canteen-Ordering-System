// app/javascript/channels/notification_channel.js

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
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        
        const count = parseInt(notificationCount.textContent);
        const newCount = count + 1; // Increment the count
        updateNotificationCount(newCount);

        // Rest of the code for handling notifications...
      },
    });
  }
});
