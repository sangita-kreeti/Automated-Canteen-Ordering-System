import consumer from "./consumer"

function updateNotificationCount(count) {
  const notificationCount = document.getElementById('notification-count');
  if (notificationCount) {
    notificationCount.textContent = count;
  }
}

document.addEventListener('turbolinks:load', function() {
  const notificationCount = document.getElementById('notification-count');
  const notificationList = document.getElementById('notification-list');
  
  if (notificationCount && notificationList) {
    const currentUserID = notificationCount.dataset.currentUserId;

    const notificationChannel = consumer.subscriptions.create({
      channel: "NotificationChannel",
      current_user_id: currentUserID
    }, {
      connected() {},
      disconnected() {},
      received(data) {
        const count = parseInt(notificationCount.textContent);
        const newCount = count + 1;
        updateNotificationCount(newCount);
        const noNotificationsMessage = notificationList.querySelector('.no-notifications-message');
        if (noNotificationsMessage) {
          noNotificationsMessage.remove();
        }
        const newNotification = document.createElement('div');
        newNotification.className = 'alert alert-dismissible fade show mb-2';
        newNotification.setAttribute('role', 'alert');
        newNotification.innerHTML = `
          <i class="bi bi-check-circle-fill me-2 text-success"></i>
          <span class="notification-text">${data.message}</span>
        `;
        notificationList.insertBefore(newNotification, notificationList.firstChild);
      },
    });
        const markAllAsReadButton = document.getElementById('mark-all-as-read-button');
    if (markAllAsReadButton) {
      markAllAsReadButton.addEventListener('click', function() {
        fetch('/mark_all_notifications_read', {
          method: 'POST',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          }
        })
        .then(response => response.json())
        .then(() => {

          muteAllNotifications(notificationList);
          updateNotificationCount(0);
        });
      });
    }
  }
});

function muteAllNotifications(notificationList) {
  const notifications = notificationList.querySelectorAll('.alert');
  notifications.forEach(notification => {
    const notificationText = notification.querySelector('.notification-text');
    notificationText.style.color = '#6c757d'; 
  });
}
