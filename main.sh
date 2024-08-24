#!/bin/bash

# Create main directory
mkdir -p aenzbi-extension

# Navigate into the directory
cd aenzbi-extension

# Create manifest.json
cat > manifest.json <<EOL
{
  "manifest_version": 3,
  "name": "Aenzbi Retail and Restaurant Management",
  "description": "Integrate with EBMS Burundi for real-time invoices and stock movements.",
  "version": "1.0",
  "permissions": [
    "storage",
    "activeTab",
    "scripting"
  ],
  "background": {
    "service_worker": "background.js"
  },
  "action": {
    "default_popup": "popup.html",
    "default_icon": {
      "16": "images/icon16.png",
      "48": "images/icon48.png",
      "128": "images/icon128.png"
    }
  },
  "options_page": "options.html",
  "icons": {
    "16": "images/icon16.png",
    "48": "images/icon48.png",
    "128": "images/icon128.png"
  }
}
EOL

# Create background.js
cat > background.js <<EOL
chrome.runtime.onInstalled.addListener(() => {
  console.log('Aenzbi Extension Installed');
});

chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'postInvoice') {
    fetch('https://ebms.obr.gov.bi:9443/ebms_api/getInvoice', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': \`Bearer \${request.token}\`
      },
      body: JSON.stringify(request.invoiceData)
    })
    .then(response => response.json())
    .then(data => sendResponse({ status: 'success', data: data }))
    .catch(error => sendResponse({ status: 'error', error: error }));
    return true;
  }
});
EOL

# Create popup.html
cat > popup.html <<EOL
<!DOCTYPE html>
<html>
<head>
  <title>Aenzbi Management</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <h1>Aenzbi Management</h1>
  <form id="invoiceForm">
    <label for="token">EBMS Token:</label><br>
    <input type="text" id="token" name="token" required><br><br>
    <label for="invoiceData">Invoice Data (JSON):</label><br>
    <textarea id="invoiceData" name="invoiceData" rows="10" cols="30" required></textarea><br><br>
    <input type="submit" value="Send Invoice">
  </form>
  <div id="response"></div>
  <script src="popup.js"></script>
</body>
</html>
EOL

# Create popup.js
cat > popup.js <<EOL
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
EOL

# Create options.html
cat > options.html <<EOL
<!DOCTYPE html>
<html>
<head>
  <title>Aenzbi Extension Options</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <h1>Options</h1>
  <form id="optionsForm">
    <label for="defaultToken">Default EBMS Token:</label><br>
    <input type="text" id="defaultToken" name="defaultToken" required><br><br>
    <input type="submit" value="Save">
  </form>
  <script src="options.js"></script>
</body>
</html>
EOL

# Create options.js
cat > options.js <<EOL
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
EOL

# Create styles.css
cat > styles.css <<EOL
body {
  font-family: Arial, sans-serif;
  margin: 20px;
}

h1 {
  font-size: 18px;
}

label {
  font-weight: bold;
}

input[type="text"], textarea {
  width: 100%;
  padding: 8px;
  margin: 5px 0;
  box-sizing: border-box;
}

input[type="submit"] {
  background-color: #4CAF50;
  color: white;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

input[type="submit"]:hover {
  background-color: #45a049;
}
EOL

# Create images directory and placeholders for icons
mkdir -p images
touch images/icon16.png images/icon48.png images/icon128.png

echo "Setup completed! Your extension files have been created in the aenzbi-extension directory."