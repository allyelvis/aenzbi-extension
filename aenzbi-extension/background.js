chrome.runtime.onInstalled.addListener(() => {
  console.log('Aenzbi Extension Installed');
});

chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'postInvoice') {
    fetch('https://ebms.obr.gov.bi:9443/ebms_api/getInvoice', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${request.token}`
      },
      body: JSON.stringify(request.invoiceData)
    })
    .then(response => response.json())
    .then(data => sendResponse({ status: 'success', data: data }))
    .catch(error => sendResponse({ status: 'error', error: error }));
    return true;
  }
});
