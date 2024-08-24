document.getElementById('invoiceForm').addEventListener('submit', function(event) {
  event.preventDefault();
  
  const token = document.getElementById('token').value;
  const invoiceData = JSON.parse(document.getElementById('invoiceData').value);

  chrome.runtime.sendMessage({
    action: 'postInvoice',
    token: token,
    invoiceData: invoiceData
  }, function(response) {
    const responseDiv = document.getElementById('response');
    if (response.status === 'success') {
      responseDiv.textContent = 'Invoice sent successfully!';
    } else {
      responseDiv.textContent = 'Error sending invoice: ' + response.error;
    }
  });
});
