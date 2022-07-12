const { Router } = require("express");
const { Op, Character, Role } = require("../db");
const router = Router();

module.exports = router;

router.post("/", async (req, res) => {
  const { code, name, hp, mana, age, date_added, race } = req.body;
  if (!code || !name || !hp || !mana) {
    return res.status(404).send("Falta enviar datos obligatorios");
  }
  try {
    const newCharacter = await Character.create({
      code,
      name,
      hp,
      mana,
      age,
      date_added,
      race,
    });
    res.status(201).json(newCharacter);
  } catch (error) {
    res.status(404).send("Error en alguno de los datos provistos");
  }
});

router.get("/young", async (req, res) => {
  const characters = await Character.findAll({
    where: { age: { [Op.lt]: 25 } },
  });
  res.json(characters);
});

router.get("/:code", async (req, res) => {
  const { code } = req.params;
  const character = await Character.findByPk(code);
  if (character) {
    res.json(character);
  } else {
    res
      .status(404)
      .send(`El código ${code} no corresponde a un personaje existente`);
  }
});

router.get("/", async (req, res) => {
  const { name, hp, age, race } = req.query;
  const condition = {};

  if (race && race !== "true") condition.race = race;
  if (age && age !== "true") condition.age = age;
  if (name && name !== "true") condition.name = name;
  if (hp && hp !== "true") condition.hp = hp;

  var character;
  if (name === "true" || hp === "true" || age === "true" || race === "true") {
    let atributosMostrados = [];
    if (name === "true") atributosMostrados.push("name");
    if (hp === "true") atributosMostrados.push("hp");
    if (age === "true") atributosMostrados.push("age");
    if (race === "true") atributosMostrados.push("race");
    characters = await Character.findAll({
      where: condition,
      attributes: atributosMostrados,
    });
  } else {
    characters = await Character.findAll({ where: condition });
  }
  res.json(characters.length ? characters : "No players found");
});

router.put("/addAbilities", async (req, res) => {
  const { abilities, codeCharacter } = req.body;
  const selectedcharacter = await Character.findByPk(codeCharacter);
  let arrayAbilities = abilities.map((a) => selectedcharacter.createAbility(a));

  await Promise.all(arrayAbilities);
  res.json(selectedcharacter);
});

router.put("/:attribute", async (req, res) => {
  const { attribute } = req.params;
  const { value } = req.query;

  await Character.update(
    { [attribute]: value },
    {
      where: { [attribute]: { [Op.is]: null } },
    }
  );
  res.send("Personajes actualizados");
});

router.get("/roles/:code", async (req, res) => {
  const { code } = req.params;
  const Data = await Character.findByPk(code, {
    include: [
      {
        model: Role,
        attributes: ["id", "name", "description"],
        through: {
          attributes: [],
        },
      },
    ],
  });
  res.json(Data);
});
