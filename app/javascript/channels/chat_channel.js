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
  messageContainer.textContent = data;

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
