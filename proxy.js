// const { createProxyMiddleware } = require('http-proxy-middleware');
// const express = require('express');
// const app = express();
// const PORT = 3000;

// app.use('/api', createProxyMiddleware({
//   target: 'https://country.io',
//   changeOrigin: true,
//   pathRewrite: {
//     '^/api': '',
//   },
// }));

// app.listen(PORT, () => {
//   console.log(`Proxy server is running on http://localhost:${PORT}`);
// });

//========================================================
// const express = require('express');
// const { createProxyMiddleware } = require('http-proxy-middleware');
// const cors = require('cors');

// const app = express();
// const PORT = 3000;

// app.use(cors());
// app.use('/api', createProxyMiddleware({
//   target: 'https://country.io',
//   changeOrigin: true,
//   pathRewrite: {
//     '^/api': '',
//   },
// }));

// app.listen(PORT, () => {
//   console.log(`Proxy server is running on http://localhost:${PORT}`);
// });

//========================================================
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const cors = require('cors');
const axios = require('axios');

const app = express();
const PORT = 3000;
const TARGET_URL = 'https://country.io';

app.use(cors());
app.use('/api', createProxyMiddleware({
  target: TARGET_URL,
  changeOrigin: true,
  pathRewrite: {
    '^/api': '',
  },
}));

// Initial check to see if the target URL is reachable
axios.get(`${TARGET_URL}/phone.json`)
  .then(response => {
    console.log('External API is reachable:', response.status);
  })
  .catch(error => {
    console.error('Error reaching external API:', error.message);
  });

app.listen(PORT, () => {
  console.log(`Proxy server is running on http://localhost:${PORT}`);
});
