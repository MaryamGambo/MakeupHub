document.addEventListener("DOMContentLoaded", function() {
  var flashMessages = document.querySelectorAll(".flash-message");

  if (flashMessages) {
    flashMessages.forEach(function(flashMessage) {
      setTimeout(function() {
        flashMessage.style.display = "none";
      }, 5000); // 5 seconds in milliseconds
    });
  }
});
