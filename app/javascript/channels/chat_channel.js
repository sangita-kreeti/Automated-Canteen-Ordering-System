import consumer from "./consumer"

document.addEventListener("turbolinks:load", () => {
  const chatContainer = document.querySelector(".chat-container");
  const channelID = chatContainer.getAttribute("data-channel-id");

  consumer.subscriptions.create({ channel: "ChatChannel", id: channelID }, {
    connected() {
      
    },

    speak(data) {
      this.perform('send_message', data);
    },

    received(data) {
      this.appendReceivedMessage(data);
    },

    appendReceivedMessage(data) {
      const messagesContainer = document.getElementById("messages");
      const messageContainer = document.createElement("div");
      messageContainer.classList.add("message");
      messageContainer.classList.add("received");
  
      const messageContentElement = document.createElement("div");
      messageContentElement.classList.add("message-content");
      messageContentElement.textContent = data.message_content;
  
      const senderInfoElement = document.createElement("div");
      senderInfoElement.classList.add("sender-info");
      senderInfoElement.textContent = `${data.sender_name} - ${new Date().toLocaleString("en-US", {
        hour: "numeric",
        minute: "numeric",
        hour12: true,
        month: "2-digit",
        day: "2-digit",
        year: "numeric",
      })}`;
  
      messageContainer.appendChild(messageContentElement);
      messageContainer.appendChild(senderInfoElement);
  
      const formContainer = document.getElementById("message_form");
      const previousSibling = formContainer.previousElementSibling;
  
      if (previousSibling && previousSibling.classList.contains("message")) {
        messagesContainer.insertBefore(messageContainer, previousSibling);
      } else {
        messagesContainer.appendChild(messageContainer);
      }
  
      clearInputField();
    }
  });

  function clearInputField() {
    const inputField = document.getElementById("message_content");
    inputField.value = "";
  }
});
