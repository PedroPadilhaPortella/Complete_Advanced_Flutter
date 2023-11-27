const express = require("express");
const bodyParser = require("body-parser");
const loginResponseMock = require("../mocks/login-response.mock");

const port = 3000
const app = express();

app.use(bodyParser.json());

app.post('/customers/login', (req, res) => {
  console.log(req.body)
  return res.status(200).json(loginResponseMock);
})

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
