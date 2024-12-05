const express = require('express');
const cors = require('cors'); // Importar o CORS
const app = express();
const PORT = 3000;

app.use(cors()); // Ativar o middleware CORS

let temperatureCycle = [];
let currentTemperature = null;

function generateTemperature() {
  const temp = Math.floor(Math.random() * 50); // Temperaturas de 0 a 49
  temperatureCycle.push(temp);

  // Garantir que uma temperatura seja maior que 45 a cada ciclo de 3 valores
  if (temperatureCycle.length === 3 && !temperatureCycle.some(t => t > 45)) {
    const randomIndex = Math.floor(Math.random() * 3);
    temperatureCycle[randomIndex] = Math.floor(Math.random() * 6) + 45; // Temperatura entre 45 e 50
  }

  if (temperatureCycle.length > 3) {
    temperatureCycle.shift(); // Manter o ciclo com no máximo 3 valores
  }

  currentTemperature = temp; // Atualizar a temperatura atual
}

// Atualizar a temperatura a cada 30 segundos
setInterval(generateTemperature, 30000);

// Inicializar com a primeira temperatura
generateTemperature();

app.get('/temperature', (req, res) => {
  res.json({ temperature: currentTemperature, cycle: temperatureCycle });
});

app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
