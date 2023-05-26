const { faker } = require('@faker-js/faker');
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

const os = require('os');
const hostname = os.hostname();

const name = process.env.name || faker.person.firstName()

app.get('*', function(req, res) {
  res.send(`${name}` + ` (${hostname})`);
});

app.listen(port, () => console.log(`Listening on port ${port}!`));

// This causes the process to respond to "docker stop" faster
process.on('SIGTERM', function() {
  console.log('Received SIGTERM, shutting down');
  app.close();
});
