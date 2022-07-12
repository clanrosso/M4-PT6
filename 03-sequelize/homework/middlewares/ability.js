const { Router } = require("express");
const { Ability } = require("../db");
const router = Router();

router.post("/", async (req, res) => {
  const { name, mana_cost, description } = req.body;
  if (!name || !mana_cost) {
    return res.status(404).send("Falta enviar datos obligatorios");
  }
  try {
    const newAbility = await Ability.create({
      name,
      mana_cost,
      description,
    });
    res.status(201).json(newAbility);
  } catch (error) {
    res.status(404).send("Error en alguno de los datos provistos");
  }
});

router.put("/setCharacter", async (req, res) => {
  const { idAbility, codeCharacter } = req.body;
  const selectedAbility = await Ability.findByPk(idAbility);
  await selectedAbility.setCharacter(codeCharacter);
  res.json(selectedAbility);
});

module.exports = router;
