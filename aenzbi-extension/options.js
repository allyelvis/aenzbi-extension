document.getElementById('optionsForm').addEventListener('submit', function(event) {
  event.preventDefault();
  
  const defaultToken = document.getElementById('defaultToken').value;
  chrome.storage.sync.set({ defaultToken: defaultToken }, function() {
    alert('Options saved.');
  });
});

document.addEventListener('DOMContentLoaded', function() {
  chrome.storage.sync.get('defaultToken', function(data) {
    if (data.defaultToken) {
      document.getElementById('defaultToken').value = data.defaultToken;
    }
  });
});
