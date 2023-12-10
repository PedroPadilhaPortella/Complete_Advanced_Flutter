const express = require("express");
const bodyParser = require("body-parser");

const loginResponseMock = require("../mocks/login-response.mock");
const registerResponseMock = require("../mocks/register-response.mock");
const forgotPasswordResponseMock = require("../mocks/forgot-password-response.mock");
const homeResponseMock = require("../mocks/home-response.mock");
const storeDetailsResponseMock = require("../mocks/store-details-response.mock");

const port = 3000
const app = express();

app.use(bodyParser.json());

app.post('/customers/login', (req, res) => {
  console.log(req.body)
  return res.status(200).json(loginResponseMock);
});

app.post('/customers/register', (req, res) => {
  console.log(req.body)
  return res.status(200).json(registerResponseMock);
});

app.post('/customers/forgotPassword', (req, res) => {
  console.log(req.body)
  return res.status(200).json(forgotPasswordResponseMock);
});

app.get('/home', (req, res) => {
  return res.status(200).json(homeResponseMock);
});

app.get('/storeDetails/:id', (req, res) => {
  const id = req.params.id
  console.log(id)
  return res.status(200).json(storeDetailsResponseMock[id - 1]);
});

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
